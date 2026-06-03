terraform {
  required_providers {
    alicloud = {
      source  = "aliyun/alicloud"
      version = "~> 1.200.0"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.12"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "alicloud" {
  access_key = var.alicloud_access_key
  secret_key = var.alicloud_secret_key
  region     = var.alicloud_region
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}


resource "time_static" "this" {}



module "networking" {
  source = "../../modules/networking"

  vpc_cidr_block      = "172.16.0.0/16"
  vswitch_cidr_blocks = ["172.16.1.0/24"]
  availability_zone   = var.alicloud_availability_zone

  tags = {
    ApplicationOwner = "Kerwin Li"
    ApplicationName  = "devops-demo"
    Environment      = "dev"
    CreatedAt        = formatdate("YYYY-MM-DD hh:mm:ss", time_static.this.rfc3339)
  }
}

module "ack" {
  source = "../../modules/ack"

  cluster_name       = "ack-dev-devops01"
  worker_vswitch_ids = [module.networking.vswitch_id]
  pod_vswitch_ids    = [module.networking.vswitch_id]

  worker_instance_types       = ["ecs.c6.xlarge"]
  worker_system_disk_category = "cloud_ssd"
  worker_system_disk_size     = 40

  worker_number     = 2
  new_nat_gateway   = true

  tags = {
    ApplicationOwner = "Kerwin Li"
    ApplicationName  = "devops-demo"
    Environment      = "dev"
    ServerOwner      = "Kerwin Li"
  }
}

resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "nsp-d-devops01-monitoring"
  }

  depends_on = [
    module.ack
  ]
}

resource "helm_release" "prometheus_stack" {
  name       = "prometheus"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  timeout    = 600
  atomic     = true

  values = [
    <<-EOT
  prometheus:
    prometheusSpec:
      storageSpec:
        volumeClaimTemplate:
          spec:
            storageClassName: alicloud-disk-ssd
            accessModes: ["ReadWriteOnce"]
            resources:
              requests:
                storage: 50Gi
  grafana:
    persistence:
      enabled: true
      storageClassName: alicloud-disk-ssd
      accessModes:
        - ReadWriteOnce
      size: 10Gi
  alertmanager:
    alertmanagerSpec:
      replicas: 2
    config:
      global:
        resolve_timeout: 5m
      route:
        group_by: ['alertname']
        group_wait: 10s
        group_interval: 10s
        repeat_interval: 12h
        receiver: 'feishu-webhook'
      receivers:
      - name: 'feishu-webhook'
        webhook_configs:
        - url: '${var.feishu_webhook_url}'
          send_resolved: true
  EOT
  ]

  set {
    name  = "grafana.service.type"
    value = "LoadBalancer"
  }

  depends_on = [
    kubernetes_namespace.monitoring
  ]
}

resource "kubernetes_ingress_v1" "grafana" {
  metadata {
    name      = "grafana-ingress"
    namespace = kubernetes_namespace.monitoring.metadata[0].name
    annotations = {
      "nginx.ingress.kubernetes.io/rewrite-target" = "/"
      "cert-manager.io/cluster-issuer"             = "letsencrypt-prod"
    }
  }

  spec {
    ingress_class_name = "nginx"

    tls {
      hosts       = ["grafana.devops01.com"]
      secret_name = "grafana-tls"
    }

    rule {
      host = "grafana.devops01.com"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "prometheus-grafana"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }

  depends_on = [
    helm_release.prometheus_stack
  ]
}

# ACR 个人版命名空间（免费）
resource "alicloud_cr_namespace" "acr" {
  name               = "devops01-${random_string.suffix.result}"
  auto_create        = false
  default_visibility = "PRIVATE"
}

resource "random_string" "suffix" {
  length  = 6
  special = false
  upper   = false
}


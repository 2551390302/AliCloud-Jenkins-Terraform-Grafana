resource "alicloud_vpc" "this" {
  vpc_name          = "vpc-devops01"
  cidr_block        = var.vpc_cidr_block
  resource_group_id = var.resource_group_id != "" ? var.resource_group_id : null

  tags = var.tags
}

resource "alicloud_vswitch" "this" {
  vpc_id     = alicloud_vpc.this.id
  cidr_block = var.vswitch_cidr_blocks[0]
  zone_id    = var.availability_zone

  tags = var.tags
}

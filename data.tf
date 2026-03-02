data "aws_availability_zones" "available" {
  state = "available"
}

#peering
data "aws_vpc" "default" {
  default = true
}
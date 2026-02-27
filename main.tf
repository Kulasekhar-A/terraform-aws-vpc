resource "aws_vpc" "main" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"
  enable_dns_hostnames = true

  tags = local.vpc_final_tags
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id #VPC association

  tags = local.igw_final_tags
}

#public subnet

resource "aws_subnet" "public" {
    count = length(var.public_subnet_cidr)
    vpc_id     = aws_vpc.main.id
    cidr_block = var.public_subnet_cidr[count.index]
    availability_zone = local.az_names[count.index]
    map_public_ip_on_launch = true 

    tags = merge (
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-public-${local.az_names[count.index]}"
        },
        var.public_subnet_tags
    )
}

    #private subnet

    resource "aws_subnet" "main" {
        count = length(var.private_subnet_cidr)
        vpc_id     = aws_vpc.main.id
        cidr_block = var.private_subnet_cidr[count.index]
        availability_zone = local.az_names[count.index]
        map_public_ip_on_launch = false


        tags = merge (
            local.common_tags,
            {
                Name = "${var.project}-${var.environment}-private-${local.az_names[count.index]}"
            },
            var.private_subnet_tags
        )
   }  

   # database subnet

   resource "aws_subnet" "database" {
    count = length(var.database_subnet_cidr)
    vpc_id = aws_vpc.main.id
    cidr_block = var.database_subnet_cidr[count.index]
    availability_zone = local.az_names[count.index]
    map_public_ip_on_launch = false

    tags = merge (
        local.common_tags,
        {
            Name = "${var.project}-${var.environment}-database-${local.az_names[count.index]}"
        }
    )
   } 
### creating vpc ###
resource "aws_vpc" "main" {
    cidr_block = var.vpc_cidr
    instance_tenancy = "default"
    enable_dns_hostnames = var.enable_dns_hostnames

    tags = merge(
        var.common_tags,
        var.vpc_tags,
        {
            Name = local.resource_name
        }
    )

}

### igw ###
resource "aws_internet_gateway" "igw" {
    vpc_id =aws_vpc.main.id

    tags = merge (
        var.common_tags,
        var.igw_tags,
        {
            Name = local.resource_name
        }
    )
}

### public subnet ###
resource "aws_subnet" "public" {   # public[0], public [1]
    count  = length(var.public_subnet_cidrs)
    availability_zone = local.az_names[count.index]
    vpc_id = aws_vpc.main.id
    cidr_block = var.public_subnet_cidrs[count.index]
    map_public_ip_on_launch = true

    tags = merge (
        var.common_tags,
        var.public_subnet_tags,
        {
            Name = "${local.resource_name}-public-${local.az_names[count.index]}"
        }
    )
}

### private subnet ###
resource "aws_subnet" "private" {
    count = length(var.private_subnet_cidrs)
    availability_zone = local.az_names[count.index]
    vpc_id = aws_vpc.main.id
    cidr_block = var.private_subnet_cidrs[count.index]
    
    tags = merge (
        var.common_tags,
        var.private_subnet_tags,
        {
            Name = "${local.resource_name}-private-${local.az_names[count.index]}"
        }
    )
}

### database private subnet ###
resource "aws_subnet" "database" {
    count = length(var.database_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    availability_zone = local.az_names[count.index]
    cidr_block = var.database_subnet_cidrs[count.index]

    tags = merge (
        var.common_tags,
        var.database_subnet_tags,
        {
            Name = "${local.resource_name}-database-${local.az_names[count.index]}"
        }
    )
}

## db subnet group ##
resource "aws_db_subnet_group" "default" {
    name = local.resource_name
    subnet_ids = aws_subnet.database[*].id

    tags = merge (
        var.common_tags,
        var.db_subnet_group_tags,
        {
            Name = local.resource_name
        }
    )
}

#### nat gateway and elastic ip ####
## elastic ip ##
resource "aws_eip" "static_ip" {
    domain = "vpc"
}

## nat gateway ##
resource "aws_nat_gateway" "ngw" {
    allocation_id = aws_eip.static_ip.id
    subnet_id  = aws_subnet.public[0].id

    tags = merge (
        var.common_tags,
        var.nat_gw_tags,
        {
            Name = local.resource_name
        }
    )
}

#### route tables ####
### public route table ###
resource "aws_route_table" "public" {
    vpc_id = aws_vpc.main.id

    tags = merge (
        var.common_tags,
        var.public_route_tags,
        {
            Name = "${local.resource_name}-public"
        }
    )
}

### private route table ###
resource "aws_route_table" "private" {
    vpc_id = aws_vpc.main.id

    tags = merge (
        var.common_tags,
        var.private_route_tags,
        {
            Name = "${local.resource_name}-private"
        }
    )
}

### database private route table ###
resource "aws_route_table" "database" {
    vpc_id = aws_vpc.main.id

    tags = merge (
        var.common_tags,
        var.database_route_tags,
        {
            Name = "${local.resource_name}-database"
        }
    )
}

#### adding routes in public,private,database route tables ####
## public route ##
resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}

## private nat route ##
resource "aws_route" "private_nat" {
    route_table_id = aws_route_table.private.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
}

## database nat route ##
resource "aws_route" "database_nat" {
    route_table_id = aws_route_table.database.id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw.id
}


#### adding route tables to subnets ####
## public subnet route table association ##
resource "aws_route_table_association" "public" {
    count = length(var.public_subnet_cidrs)
    subnet_id = element(aws_subnet.public[*].id,count.index)
    route_table_id = aws_route_table.public.id
}

## private subnet route table association ##
resource "aws_route_table_association" "private" {
    count = length(var.private_subnet_cidrs)
    subnet_id = element(aws_subnet.private[*].id,count.index)
    route_table_id = aws_route_table.private.id
}

## database subnet route table association ##
resource "aws_route_table_association" "database" {
    count = length(var.database_subnet_cidrs)
    subnet_id = element(aws_subnet.database[*].id,count.index)
    route_table_id = aws_route_table.database.id
}
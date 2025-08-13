### creting peering ###
resource "aws_vpc_peering_connection" "expense_default" {
    count = var.is_peering_required ? 1 : 0
    vpc_id = aws_vpc.main.id  #requestor
    peer_vpc_id = var.acceptor_vpc_id == "" ? data.aws_vpc.default_vpc.id : var.acceptor_vpc_id #acceptor

    auto_accept = var.acceptor_vpc_id == "" ? true : false

    tags = merge (
        var.common_tags,
        var.peer_tags,
        {
            Name = local.resource_name
        }
    )
}

### adding routes for peering ###
## public route ##
resource "aws_route" "public_peering" {
    count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
    route_table_id = aws_route_table.public.id
    destination_cidr_block = data.aws_vpc.default_vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.expense_default[0].id
}

## private route ##
resource "aws_route" "private_peering" {
    count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
    route_table_id = aws_route_table.private.id
    destination_cidr_block = data.aws_vpc.default_vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.expense_default[0].id
}

## database route ##
resource "aws_route" "database_peering" {
    count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
    route_table_id = aws_route_table.database.id
    destination_cidr_block = data.aws_vpc.default_vpc.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.expense_default[0].id
}

## default vpc route ##
resource "aws_route" "default_peering" {
    count = var.is_peering_required && var.acceptor_vpc_id == "" ? 1 : 0
    route_table_id = data.aws_route_table.main.id
    destination_cidr_block = var.vpc_cidr
    vpc_peering_connection_id = aws_vpc_peering_connection.expense_default[0].id
}
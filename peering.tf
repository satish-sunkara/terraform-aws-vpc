resource "aws_vpc_peering_connection" "peering" {
  count = var.is_peering_required ? 1 : 0
  vpc_id        = aws_vpc.main.id
  peer_vpc_id   = var.acceptors_vpc_id == "" ? data.aws_vpc.default.id : var.acceptors_vpc_id
  auto_accept = var.acceptors_vpc_id == "" ? true : false
  tags = merge(
    var.common_tags,
    var.aws_vpc_peering_connection_tags,
    {
        Name = "${local.name}"
    }
  )
}


resource "aws_route" "accepter_route" {
  count =   var.is_peering_required && var.acceptors_vpc_id == "" ? 1 : 0
  route_table_id            = data.aws_route_table.main.id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}


resource "aws_route" "public_peering" {
  count =   var.is_peering_required && var.acceptors_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "private_peering" {
  count =   var.is_peering_required && var.acceptors_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}

resource "aws_route" "database_peering" {
  count =   var.is_peering_required && var.acceptors_vpc_id == "" ? 1 : 0
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[0].id
}
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.common_tags,
    var.aws_vpc_tags,
    {
        Name = "${local.name}-vpc"
    }
  )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.main.id}"

  tags = merge(
    var.common_tags,
    var.aws_internet_gateway_tags,
    {
        Name = "${local.name}-igw"
    }
  )
}

resource "aws_subnet" "public" {
  count = length(var.public_vpc_cidr)  
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_vpc_cidr[count.index]
  availability_zone = local.azs_names[count.index]

  tags = merge(
    var.common_tags,
    var.aws_public_subnet_tags,
    {
        Name = "${local.name}-${local.azs_names[count.index]}-public"
    }
  )
}


resource "aws_subnet" "private" {
  count = length(var.private_vpc_cidr)  
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_vpc_cidr[count.index]
  availability_zone = local.azs_names[count.index]

  tags = merge(
    var.common_tags,
    var.aws_private_subnet_tags,
    {
        Name = "${local.name}-${local.azs_names[count.index]}-private"
    }
  )
}

resource "aws_subnet" "database" {
  count = length(var.database_vpc_cidr)  
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_vpc_cidr[count.index]
  availability_zone = local.azs_names[count.index]

  tags = merge(
    var.common_tags,
    var.aws_database_subnet_tags,
    {
        Name = "${local.name}-${local.azs_names[count.index]}-database"
    }
  )
}

resource "aws_eip" "eip" {
  domain = "vpc"
}


resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id

  tags = merge(
    var.common_tags,
    var.aws_nat_gateway_tags,
    {
        Name = "${local.name}-ngwt"
    }
  )

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.gw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id



  tags = merge(
    var.common_tags,
    var.aws_public_route_table_tags,
    {
        Name = "${local.name}-public"
    }
  )
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id



  tags = merge(
    var.common_tags,
    var.aws_private_route_table_tags,
    {
        Name = "${local.name}-private"
    }
  )
}

resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id



  tags = merge(
    var.common_tags,
    var.aws_database_route_table_tags,
    {
        Name = "${local.name}-database"
    }
  )
}

resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}

resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.main.id
}


resource "aws_route_table_association" "public" {
  count = length(var.public_vpc_cidr)  
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count = length(var.private_vpc_cidr)  
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "database" {
  count = length(var.database_vpc_cidr)  
  subnet_id      = element(aws_subnet.database[*].id, count.index)
  route_table_id = aws_route_table.database.id
}
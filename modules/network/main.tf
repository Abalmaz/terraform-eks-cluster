locals {
  common_tags = { "application" = var.name,
                  "envaironment" = var.env_pref}
  az_count = length(var.azs)
}

# Create VPV
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  tags = merge(
    { "Name" = "${var.env_pref}-${var.name}-vpc" },
    local.common_tags
  )
}

# Create Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    { "Name" = "${var.env_pref}-igw" },
    local.common_tags
  )
}

# Create routes
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  tags = merge(
    { "Name" = "${var.env_pref}-${var.name}-public-rt" },
    local.common_tags
  )
}

# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.vpc.id

#   tags = merge(
#     {
#       "Name" ="${var.env_pref}-${var.name}-private-rt"
#     },
#     local.common_tags
#   )
# }

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}


# Create Subnets
resource "aws_subnet" "public_subnet" {
  count = local.az_count
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 6, count.index)
  availability_zone = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = merge(
    {
      "Name" = format(
        "${var.env_pref}-${var.name}-public-subnet-%s",
        element(var.azs, count.index),
      ),
    },
    local.common_tags
  )
}

resource "aws_subnet" "private_subnet" {
  count = local.az_count
  vpc_id = aws_vpc.vpc.id
  cidr_block = cidrsubnet(var.vpc_cidr, 6, local.az_count + count.index)
  availability_zone = element(var.azs, count.index)

  tags = merge(
    {
      "Name" = format(
        "${var.env_pref}-${var.name}-private-subnet-%s",
        element(var.azs, count.index),
      ),
    },
    local.common_tags
  )
}

# # Elastic IP
# resource "aws_eip" "nat" {
#   vpc = true
#   tags = merge(
#     {
#       "Name" = "${var.env_pref}-${var.name}-nat"
#     },
#     local.common_tags
#   )
# }

# # Create NAT Gateway
# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.nat.id
#   subnet_id = aws_subnet.public_subnet[0].id

#   tags = merge(
#     {
#       "Name" = "${var.env_pref}-${var.name}-nat-gw"
#     },
#     local.common_tags
#   )
#   depends_on = [aws_internet_gateway.igw]
# }

# resource "aws_route" "private_nat_gateway" {
#   route_table_id         = aws_route_table.private_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat_gw.id
# }

# resource "aws_route_table_association" "private_rta" {
#   count = local.az_count
#   subnet_id = element(aws_subnet.private_subnet[*].id, count.index)
#   route_table_id = aws_route_table.private_rt.id
# }

resource "aws_route_table_association" "public_rta" {
  count = local.az_count
  subnet_id  = element(aws_subnet.public_subnet[*].id, count.index)
  route_table_id = aws_route_table.public_rt.id
}
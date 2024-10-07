# Here I'm using default VPC for convenience, this is not recommended for production.
resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
}

data "aws_route_table" "rt" {
  vpc_id = aws_default_vpc.default.id
}

resource "aws_security_group" "lambda" {
  name        = "php-bref-demo-symfony-app"
  description = "Allow outbound" #Fail but requires destroy to change..
  vpc_id      = aws_default_vpc.default.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db" {
  name        = "php-bref-demo-symfony-app-db"
  description = "Allow outbound"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    protocol        = "tcp"
    from_port       = 3306
    to_port         = 3306
    security_groups = [aws_security_group.lambda.id]
  }

}

# DynamoDB endpoint for Lambda to be able to privately push cache data to DynamoDB.
resource "aws_vpc_endpoint" "dynamodb_endpoint" {
  service_name = "com.amazonaws.eu-west-1.dynamodb"
  vpc_id       = aws_default_vpc.default.id
}

resource "aws_vpc_endpoint_route_table_association" "dynamo_routing" {
  route_table_id  = data.aws_route_table.rt.id
  vpc_endpoint_id = aws_vpc_endpoint.dynamodb_endpoint.id
}
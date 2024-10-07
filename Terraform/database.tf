# An Aurora cluster to store application DB. Not strictly serverless (doesn't scale-to-zero)
resource "aws_rds_cluster" "db" {
  cluster_identifier      = "aurora-cluster-demo"
  engine                  = "aurora-mysql"
  engine_version          = "8.0.mysql_aurora.3.05.2"
  availability_zones      = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  database_name           = "mydb"
  master_username         = "foo"
  master_password         = "must_be_eight_characters"

  serverlessv2_scaling_configuration {
    max_capacity = 32
    min_capacity = 1
  }

  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
}

resource "aws_rds_cluster_instance" "db" {
  cluster_identifier = aws_rds_cluster.db.id
  engine             = "aurora-mysql"
  instance_class     = "db.serverless"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  subnet_ids = data.aws_subnets.default.ids
}
resource "aws_db_subnet_group" "this" {
  name       = "${var.env}-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags = {
    Name = "${var.env}-db-subnet-group"
  }
}

# 🔒 Fetch DB credentials from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "db_secret" {
  secret_id = "${var.env}-db-credentials"
}

# Decode JSON secret (expected format: {"username":"admin","password":"xxxx"})
locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_secret.secret_string)
}

resource "aws_db_instance" "this" {
  identifier              = "${var.env}-db"
  allocated_storage       = var.allocated_storage
  engine                  = "postgres"
  engine_version          = "13.7"
  instance_class          = var.instance_class
  name                    = var.db_name
  username                = local.db_creds.username   # 🔑 from Secrets Manager
  password                = local.db_creds.password   # 🔑 from Secrets Manager
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.this.name
  publicly_accessible     = false
  vpc_security_group_ids  = [] # optionally attach SGs

  tags = {
    Name = "${var.env}-rds"
  }
}

output "db_instance_identifier" {
  value = aws_db_instance.this.id
}

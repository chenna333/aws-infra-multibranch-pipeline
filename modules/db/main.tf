##################################################
# STEP 1 — Create DB Subnet Group
##################################################
resource "aws_db_subnet_group" "this" {
  name       = "${var.env}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.env}-db-subnet-group"
  }
}

##################################################
# STEP 2 — Create Secrets Manager Secret (if not exists)
##################################################
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# Create the secret name
resource "aws_secretsmanager_secret" "db_secret" {
  name        = "${var.env}-db-credentials"
  description = "Database credentials for ${var.env} environment"
}

# Store the username/password in the secret
resource "aws_secretsmanager_secret_version" "db_secret_value" {
  secret_id = aws_secretsmanager_secret.db_secret.id

  secret_string = jsonencode({
    username = var.db_username
    password = random_password.db_password.result
  })
}

##################################################
# STEP 3 — Fetch the secret value (to use for RDS)
##################################################
data "aws_secretsmanager_secret_version" "db_secret_data" {
  secret_id = aws_secretsmanager_secret.db_secret.id
}

locals {
  db_creds = jsondecode(data.aws_secretsmanager_secret_version.db_secret_data.secret_string)
}

##################################################
# STEP 4 — Create the RDS Instance
##################################################
resource "aws_db_instance" "this" {
  identifier              = "${var.env}-db"
  allocated_storage       = var.allocated_storage
  engine                  = "postgres"
  engine_version          = "13.7"
  instance_class          = var.instance_class
  name                    = var.db_name
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.this.name
  publicly_accessible     = false
  vpc_security_group_ids  = [] # optionally attach SGs

  tags = {
    Name = "${var.env}-rds"
  }
}

##################################################
# STEP 5 — Outputs
##################################################
output "db_instance_identifier" {
  value = aws_db_instance.this.id
}

output "db_secret_arn" {
  value = aws_secretsmanager_secret.db_secret.arn
}


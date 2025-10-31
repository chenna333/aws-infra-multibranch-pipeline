resource "aws_db_subnet_group" "this" {
  name       = "${var.env}-db-subnet-group"
  subnet_ids = var.subnet_ids
  tags = { Name = "${var.env}-db-subnet-group" }
}

resource "aws_db_instance" "this" {
  identifier = "${var.env}-db"
  allocated_storage = var.allocated_storage
  engine = "postgres"
  engine_version = "13.7"
  instance_class = var.instance_class
  name = var.db_name
  username = var.username
  password = var.password
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.this.name
  publicly_accessible = false
  vpc_security_group_ids = [] # optionally attach SGs
  tags = { Name = "${var.env}-rds" }
}

output "db_instance_identifier" {
  value = aws_db_instance.this.id
}

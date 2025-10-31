variable "env" {
  description = "Environment name (e.g., dev, qa, stg, prod)"
  type        = string
}

variable "subnet_ids" {
  description = "List of private subnet IDs for DB"
  type        = list(string)
}

variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_username" {
  description = "Database username"
  type        = string
}

variable "instance_class" {
  description = "DB instance type"
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

resource "aws_instance" "bastion" {
  ami           = "ami-0c02fb55956c7d316" # Amazon Linux 2
  instance_type = "t3.micro"
  subnet_id     = var.public_subnet_id
  key_name      = "bastion-key"

  tags = {
    Name = "${var.env}-bastion"
  }
}

output "bastion_id" {
  value = aws_instance.bastion.id
}


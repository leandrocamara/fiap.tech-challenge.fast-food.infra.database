resource "aws_security_group" "sg" {
  name        = "SG-${var.projectName}"
  description = "This group is used AWS RDS"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "All"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_db_instance" "db_instance" {
  identifier        = var.projectName
  db_name           = var.projectName
  allocated_storage = 5
  engine            = "postgres"
  engine_version    = "13.4"
  instance_class    = var.instanceClass
  username          = var.username
  password          = var.password

  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.sg.id]

  depends_on = [aws_security_group.sg]
}

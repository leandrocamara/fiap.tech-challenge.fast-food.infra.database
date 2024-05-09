resource "aws_db_instance" "db_instance" {
  identifier        = "${var.projectName}-db"
  db_name           = var.projectName
  allocated_storage = 1
  engine            = "postgres"
  engine_version    = "11.22" # aws rds describe-db-engine-versions --engine postgres --output table --region us-east-1
  instance_class    = var.instanceClass
  username          = var.username
  password          = var.password


  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.sg.id]
  skip_final_snapshot    = true

  depends_on = [aws_security_group.sg]
}

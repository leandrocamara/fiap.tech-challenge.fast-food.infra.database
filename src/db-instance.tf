resource "aws_db_instance" "db_orders_instance" {
  identifier        = "orders"
  db_name           = "orders"
  allocated_storage = 5
  engine            = "postgres"
  engine_version    = "11.22" # aws rds describe-db-engine-versions --engine postgres --output table --region us-east-1
  instance_class    = var.instanceClass
  username          = var.ordersUsername
  password          = var.ordersPassword


  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.sg.id]
  skip_final_snapshot    = true

  depends_on = [aws_security_group.sg]
}

resource "aws_db_instance" "db_payments_instance" {
  identifier        = "payments"
  db_name           = "payments"
  allocated_storage = 5
  engine            = "postgres"
  engine_version    = "11.22" # aws rds describe-db-engine-versions --engine postgres --output table --region us-east-1
  instance_class    = var.instanceClass
  username          = var.paymentsUsername
  password          = var.paymentsPassword


  publicly_accessible    = true
  vpc_security_group_ids = [aws_security_group.sg.id]
  skip_final_snapshot    = true

  depends_on = [aws_security_group.sg]
}

resource "aws_dynamodb_table" "tickes_table" {
  name           = "tickets"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "pk"
  range_key      = "sk"
  
  attribute {
    name = "pk"
    type = "S"
  }

  attribute {
    name = "sk"
    type = "S"
  }

  tags = {
    Name        = "tickes_table"
    Environment = "production"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }
}
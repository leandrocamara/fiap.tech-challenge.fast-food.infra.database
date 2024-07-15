# Criando a fila payment-updated
resource "aws_sqs_queue" "payment_updated" {
  name = "payment-updated"
}

# Criando a fila ticket-created
resource "aws_sqs_queue" "ticket_created" {
  name = "ticket-created"
}

# Criando a fila ticket-updated
resource "aws_sqs_queue" "ticket_updated" {
  name = "ticket-updated"
}
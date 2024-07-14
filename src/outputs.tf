output "ordersDbEndpoint" {
  value = aws_db_instance.db_orders_instance.endpoint
}

output "paymentsDbEndpoint" {
  value = aws_db_instance.db_payments_instance.endpoint
}

output "ticketsDbEndpoint" {
  value = aws_dynamodb_table.tickes_table.endpoint
}
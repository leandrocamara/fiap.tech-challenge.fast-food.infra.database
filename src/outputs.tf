output "ordersDbEndpoint" {
  value = aws_db_instance.db_orders_instance.endpoint
}

output "paymentsDbEndpoint" {
  value = aws_db_instance.db_payments_instance.endpoint
}
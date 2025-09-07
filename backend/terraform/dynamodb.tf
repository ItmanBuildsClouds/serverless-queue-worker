resource "aws_dynamodb_table" "order_table" {
  name           = "${var.project_name}-orders"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "orderId"

  attribute {
    name = "orderId"
    type = "S"
  }
  tags = {
    Project = var.project_name
  }
}
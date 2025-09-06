resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "${var.project_name}-orders"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "OrderID"

  attribute {
    name = "OrderID"
    type = "S"
  }
  tags = {
    Project = var.project_name
  }
}
resource "aws_sqs_queue" "orders_queue" {
    name= "${var.project_name}-orders_queue"
    tags = {
        Project = var.project_name
    }
}
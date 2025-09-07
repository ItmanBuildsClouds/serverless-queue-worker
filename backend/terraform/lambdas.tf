data "archive_file" "api_handler_zip" {
    type = "zip"
    source_file = "${path.module}/../lambda_src/api_handler.py"
    output_path = "${path.module}/../lambda_src/dist/api_handler.zip"
}
data "archive_file" "order_worker_zip" {
    type = "zip"
    source_file = "${path.module}/../lambda_src/order_worker.py"
    output_path = "${path.module}/../lambda_src/dist/order_worker.zip"
}
resource "aws_lambda_function" "api_handler" {
  filename      = "${path.module}/../lambda_src/dist/api_handler.zip"
  function_name = "${var.project_name}-api-handler"
  role = "${aws_iam_policy.api_lambda-policy.arn}"
  handler = "api_handler.lambda_handler"
  runtime = "python3.12"
  timeout = 30
  source_code_hash = data.archive_file.api_handler_zip.output_base64sha256
  environment {
    variables = {
      QUEUE_URL = aws_sqs_queue.orders_queue.id
    }
  }
}
resource "aws_lambda_function" "order_worker" {
  filename = "${path.module}/../lambda_src/dist/order_worker.zip"
  function_name = "${var.project_name}-order-worker"
  role = "${aws_iam_policy.worker_lambda-policy.arn}"
  handler = "order_worker.lambda_handler"
  runtime = "python3.12"
  timeout = 30
  source_code_hash = data.archive_file.order_worker_zip.output_base64sha256
  environment {
    variables = {
      DYNAMODB_TABLE = aws_dynamodb_table.order_table.name
    }
  }
}
resource "aws_lambda_event_source_mapping" "sqs_trigger_worker" {
  event_source_arn = aws_sqs_queue.orders_queue.arn
  function_name = aws_lambda_function.order_worker.arn
  batch_size = 1
}
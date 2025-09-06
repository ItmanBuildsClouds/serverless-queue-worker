resource "aws_iam_role" "worker_lambda-role" {
    name = "${var.project_name}-worker-lambda-role"
    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Action = "sts:AssumeRole"
            Effect = "Allow"
            Principal = {
                Service = "lambda.amazonaws.com"
            }}]
        
    })
    tags = {
    Project = var.project_name
    }
}
resource "aws_iam_policy" "worker_lambda-policy" {
    name = "${var.project_name}-worker-lambda-policy"
    description = "Policy for SQS worker Lambda"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
                Resource = "arn:aws:logs:*:*:*"
            },
            {
                Effect = "Allow"
                Action = [
                    "sqs:ReceiveMessage",
                    "sqs:DeleteMessage",
                    "sqs:GetQueueAttributes"
                ]
                Resource = aws_sqs_queue.orders_queue.arn
            },
            {
                Effect = "Allow"
                Action = [
                    "dynamodb:PutItem",
                    "dynamodb:UpdateItem"
                ]
                Resource = aws_dynamodb_table.order_table.arn
            }
        ]
    })
}
resource "aws_iam_role_policy_attachment" "worker_lambda-attachment" {
    role = aws_iam_role.worker_lambda-role.name
    policy_arn = aws_iam_policy.worker_lambda-policy.arn
}





resource "aws_iam_role" "api_lambda-role" {
    name = "${var.project_name}-api-lambda-role"
    assume_role_policy = aws_iam_role.worker_lambda-role.assume_role_policy
}
resource "aws_iam_policy" "api_lambda-policy" {
    name = "${var.project_name}-api-lambda-policy"
    description = "Policy for API Lambda"

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Effect = "Allow"
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ]
                Resource = "arn:aws:logs:*:*:*"
            },
            {
                Effect = "Allow"
                Action = [
                    "sqs:SendMessage"
                ]
                Resource = aws_sqs_queue.orders_queue.arn
            }
        ]
    })
}
resource "aws_iam_role_policy_attachment" "api_lambda-attachment" {
    role = aws_iam_role.api_lambda-role.name
    policy_arn = aws_iam_policy.api_lambda-policy.arn
}
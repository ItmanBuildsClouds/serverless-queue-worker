resource "aws_apigatewayv2_api" "orders_api" {
    name = "${var.project_name}-orders-api"
    protocol_type = "HTTP"
}
resource "aws_apigatewayv2_integration" "api_handler_integration" {
    api_id = aws_apigatewayv2_api.orders_api.id
    integration_type = "AWS_PROXY"
    integration_uri = aws_lambda_function.api_handler.invoke_arn
    payload_format_version = "2.0"
}
resource "aws_apigatewayv2_route" "api_handler_route" {
    api_id = aws_apigatewayv2_api.orders_api.id
    route_key = "POST /orders"
    target = "integrations/${aws_apigatewayv2_integration.api_handler_integration.id}"
}
resource "aws_apigatewayv2_stage" "api_stage" {
    api_id = aws_apigatewayv2_api.orders_api.id
    name = "$default"
    auto_deploy = true
}
resource "aws_lambda_permission" "api_gateway_permission" {
    statement_id = "AllowExecutionFromAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.api_handler.function_name
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_apigatewayv2_api.orders_api.execution_arn}/*/*"
}

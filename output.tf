output "lambda_function_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.my_lambda_function.arn
}

output "lambda_function_name" {
  description = "Name of the Lambda function"
  value       = aws_lambda_function.my_lambda_function.function_name
}

output "lambda_function_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.my_lambda_function.invoke_arn
}

output "request_layer_arn" {
  description = "ARN of the requests layer"
  value       = aws_lambda_layer_version.request_layer.arn
}

output "request_layer_version" {
  description = "Version of the requests layer"
  value       = aws_lambda_layer_version.request_layer.version
}
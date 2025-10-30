# Common dependencies layer
resource "aws_lambda_layer_version" "request_layer" {
  filename            = "request_layer.zip"
  layer_name          = "request_layer"
  description         = "Request dependencies layer for Lambda functions"
  compatible_runtimes = ["python3.9"]
  compatible_architectures = ["arm64"]
}

# Function using the layer
resource "aws_lambda_function" "my_lambda_function" {
  filename      = "my_lambda_function.zip"
  function_name = "example_layered_function"
  role          = aws_iam_role.test_role.arn
  handler       = "index.handler"
  runtime       = "python3.9"
  architectures = ["arm64"]
  package_type  = "Zip"
  ephemeral_storage {
    size = 512
  }
  layers = [aws_lambda_layer_version.request_layer.arn]

  environment {
    variables = {
      API_TOKEN   = "<API_TOKEN>"
      JENKINS_URL = "<JENKINS_URL>"
      USERNAME    = "<USERNAME>"
    }
  }
}

resource "aws_lambda_permission" "allow_codecommit" {
  statement_id  = "AllowExecutionFromCodeCommit"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda_function.function_name
  principal     = "codecommit.amazonaws.com"

  # Refer to the CodeCommit repository ARN
  source_arn    = aws_codecommit_repository.test_repository.arn 
}
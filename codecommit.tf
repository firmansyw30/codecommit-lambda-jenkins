resource "aws_codecommit_repository" "test_repository" {
  repository_name = "test_repository"
}

resource "aws_codecommit_trigger" "test_trigger" {
  repository_name = aws_codecommit_repository.test_repository.repository_name

  trigger {
    name            = "test-trigger"
    events          = ["all"]
    destination_arn = aws_lambda_function.my_lambda_function.arn
    branches        = ["main"]
    custom_data     = "Triggered by CodeCommit repository events"
  }
}
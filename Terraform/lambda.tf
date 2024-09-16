resource "aws_lambda_function" "sample_php_lambda_apigw" {
  function_name    = "php-bref-demo-symfony-app"
  role             =  aws_iam_role.iam_for_lambda.arn
  runtime          = "provided.al2"
  handler          = "public/index.php"
  timeout          = 28
  filename         = data.archive_file.zip_php_lambda.output_path
  source_code_hash = data.archive_file.zip_php_lambda.output_base64sha256
  publish          = false
  memory_size      = 1024
  layers = ["arn:aws:lambda:eu-west-1:534081306603:layer:php-83-fpm:31"] # See https://bref.sh/docs/runtimes/runtimes-details
  environment {
    variables = {
      APP_ENV = "dev"
      APP_DEBUG =  "1"
      APP_SECRET = "2ca64f8d83b9e89f5f19d672841d6bb8"

    }
  }
}

# Create Zip file for Lambda
data "archive_file" "zip_php_lambda" {
  type        = "zip"
  source_dir  = "../SymfonyApp"
  output_path = "app.zip"
}

# IAM Role for Lambda
resource "aws_iam_role" "iam_for_lambda" {
  name               = "php-bref-demo-symfony-app"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "lambda_one" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_two" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_three" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
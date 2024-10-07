# Lambda using the PHP-FPM Bref runtime to serve requests via APIGateway
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
      APP_ENV = "prod"
      DATABASE_URL = "mysql://${aws_rds_cluster.db.master_username}:${aws_rds_cluster.db.master_password}@${aws_rds_cluster.db.endpoint}:3306/${aws_rds_cluster.db.database_name}?serverVersion=8&charset=utf8mb4"
      APP_DEBUG =  "0"
      APP_SECRET = "2ca64f8d83b9e89f5f19d672841d6bb8" # DON'T PUT THAT IN REPOSITORY. This is only for demo. In real life use Secrets Manager or SSM Parameter Store.
      DYNAMODB_CACHE_TABLE = aws_dynamodb_table.bref_cache.name
      MESSENGER_TRANSPORT_DSN = aws_sqs_queue.queue.url
    }
  }

  vpc_config {
    security_group_ids = [aws_security_group.lambda.id]
    subnet_ids = data.aws_subnets.default.ids
  }
}

# Worker that
resource "aws_lambda_function" "worker" {
  function_name    = "php-bref-demo-symfony-app-worker"
  role             =  aws_iam_role.iam_for_lambda.arn # In real-life, have a specific role with SQS permissions (least privilege approach)
  runtime          = "provided.al2"
  handler          = "bin/consumer.php"
  timeout          = 28
  filename         = data.archive_file.zip_php_lambda.output_path
  source_code_hash = data.archive_file.zip_php_lambda.output_base64sha256
  publish          = false
  memory_size      = 1024
  layers = ["arn:aws:lambda:eu-west-1:534081306603:layer:php-83-fpm:31"] # See https://bref.sh/docs/runtimes/runtimes-details
  environment {
    variables = {
      APP_ENV = "prod"
      APP_DEBUG =  "0"
      APP_SECRET = "2ca64f8d83b9e89f5f19d672841d6bb8" # DON'T PUT THAT IN REPOSITORY. This is only for demo. In real life use Secrets Manager or SSM Parameter Store.
      MESSENGER_TRANSPORT_DSN = aws_sqs_queue.queue.url
      DATABASE_URL = "mysql://${aws_rds_cluster.db.master_username}:${aws_rds_cluster.db.master_password}@${aws_rds_cluster.db.endpoint}:3306/${aws_rds_cluster.db.database_name}?serverVersion=8&charset=utf8mb4"
      DYNAMODB_CACHE_TABLE = aws_dynamodb_table.bref_cache.name
    }
  }

  vpc_config {
    security_group_ids = [aws_security_group.lambda.id]
    subnet_ids = data.aws_subnets.default.ids
  }
}

# worker Lambda access to SQS queue
resource "aws_lambda_event_source_mapping" "worker" {
  event_source_arn = aws_sqs_queue.queue.arn
  enabled          = true
  function_name    = aws_lambda_function.worker.arn
  batch_size       = 10
}

# A Lambda exposing the PHP console. To be triggered via the AWS CLI or the AWS Console.
resource "aws_lambda_function" "console" {
  function_name    = "php-bref-demo-symfony-app-console"
  role             =  aws_iam_role.iam_for_lambda.arn
  runtime          = "provided.al2"
  handler          = "bin/console"
  timeout          = 28
  filename         = data.archive_file.zip_php_lambda.output_path
  source_code_hash = data.archive_file.zip_php_lambda.output_base64sha256
  publish          = false
  memory_size      = 1024
  layers = ["arn:aws:lambda:eu-west-1:534081306603:layer:php-83-fpm:31"] # See https://bref.sh/docs/runtimes/runtimes-details
  environment {
    variables = {
      APP_ENV = "prod"
      APP_DEBUG =  "0"
      APP_SECRET = "2ca64f8d83b9e89f5f19d672841d6bb8" # DON'T PUT THAT IN REPOSITORY. This is only for demo. In real life use Secrets Manager or SSM Parameter Store.
      MESSENGER_TRANSPORT_DSN = aws_sqs_queue.queue.url
      DATABASE_URL = "mysql://${aws_rds_cluster.db.master_username}:${aws_rds_cluster.db.master_password}@${aws_rds_cluster.db.endpoint}:3306/${aws_rds_cluster.db.database_name}?serverVersion=8&charset=utf8mb4"
      DYNAMODB_CACHE_TABLE = aws_dynamodb_table.bref_cache.name
    }
  }

  vpc_config {
    security_group_ids = [aws_security_group.lambda.id]
    subnet_ids = data.aws_subnets.default.ids
  }
}

# Create a Zip file with my Symfony app to push to Lambda
data "archive_file" "zip_php_lambda" {
  type        = "zip"
  source_dir  = "../SymfonyApp"
  excludes    = [
    "tests",
  ]
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

resource "aws_iam_role_policy_attachment" "lambda_four" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_five" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaSQSQueueExecutionRole"
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
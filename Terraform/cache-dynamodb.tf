resource "aws_dynamodb_table" "bref_cache" {
  name         = "php-bref-demo-symfony-cache"
  hash_key     = "id"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "id"
    type = "S"
  }

  ttl {
    attribute_name = "ttl"
    enabled        = true
  }
}

# Add a policy to iam_for_lambda role so it can access serverlessdemo DynamoDB
resource "aws_iam_policy" "dynamodb_for_lambda" {
  name        = "php-bref-demo-symfony-cache"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "dynamodb:*"
      ],
      "Resource": "${aws_dynamodb_table.bref_cache.arn}",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Attach policy to iam_for_lambda role
resource "aws_iam_role_policy_attachment" "dynamodb_for_lambda" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.dynamodb_for_lambda.arn
}

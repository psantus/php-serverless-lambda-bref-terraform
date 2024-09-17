resource "aws_api_gateway_rest_api" "api" {
  name        = "ServerlessExample"
  description = "Terraform Serverless Application Example"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "root" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "{proxy+}"

}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.root.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.sample_php_lambda_apigw.invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_rest_api.api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.sample_php_lambda_apigw.invoke_arn
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "v1"
}

resource "aws_lambda_permission" "allow_api_gateway_invoke_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sample_php_lambda_apigw.function_name
  principal     = "apigateway.amazonaws.com"

  # The /*/* portion grants access from any method on any resource
  # within the API Gateway "REST API".
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"
}

# Create role enabling API Gateway service to write logs
resource "aws_iam_role" "apigw_role" {
  name = "php-bref-demo-symfony-app-api-gateway"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "apigateway.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Create policy enabling API Gateway service to write logs
resource "aws_iam_policy" "apigw_policy" {
  name        = "php-bref-demo-symfony-app-apigateway"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:*"
      ],
      "Resource": "*",
      "Effect": "Allow"
    }
  ]
}
EOF
}

# Attach policy to role
resource "aws_iam_role_policy_attachment" "apigw_logs" {
  role       = aws_iam_role.apigw_role.name
  policy_arn = aws_iam_policy.apigw_policy.arn
}

# Configure role for use by API Gateway service
resource "aws_api_gateway_account" "account_level_config_for_logging_from_apigw" {
  cloudwatch_role_arn = aws_iam_role.apigw_role.arn
}

# Custom domain bref.terracloud.fr
resource "aws_api_gateway_domain_name" "api_bref" {
  domain_name     = "api.bref.terracloud.fr"
  regional_certificate_arn = aws_acm_certificate.api_bref.arn
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# Certificate for bref.terracloud.fr
resource "aws_acm_certificate" "api_bref" {
  domain_name       = "api.bref.terracloud.fr"
  validation_method = "DNS"
}

resource "aws_apigatewayv2_api_mapping" "custom_name_to_stage" {
  api_id      = aws_api_gateway_rest_api.api.id
  domain_name = aws_api_gateway_domain_name.api_bref.domain_name
  stage       = aws_api_gateway_stage.stage.stage_name
}

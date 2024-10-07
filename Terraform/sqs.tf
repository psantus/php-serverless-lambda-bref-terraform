# Replace Symfony Messenger internal queue with SQS

resource "aws_sqs_queue" "queue" {
  name = "php-bref-demo-symfony-app-queue"
}

resource "aws_sqs_queue_policy" "queue_policy" {
  policy    = data.aws_iam_policy_document.queue_policy.json
  queue_url = aws_sqs_queue.queue.url
}

data "aws_iam_policy_document" "queue_policy" {
  statement {
    sid    = "First"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.iam_for_lambda.arn]
    }

    actions   = ["sqs:*"]
    resources = [aws_sqs_queue.queue.arn]
  }
}

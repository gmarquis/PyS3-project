data "archive_file" "ListS3BucketsPy" {
  type        = "zip"
  source_file = "ListS3BucketsPy.py"
  output_path = "ListS3BucketsPy.zip"
}

data "aws_iam_policy_document" "policy" {
  statement {
    sid    = ""
    effect = "Allow"
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "iam_for_lambda" {
  name               = "ListS3BucketsRole"
  assume_role_policy = "${data.aws_iam_policy_document.policy.json}"
}

resource "aws_lambda_function" "ListS3BucketsPy" {
  function_name    = "ListS3BucketsPy"
  filename         = "${data.archive_file.ListS3BucketsPy.output_path}"
  source_code_hash = "${data.archive_file.ListS3BucketsPy.output_base64sha256}"
  role    = "arn:aws:iam::735522019233:role/service-role/PythonHelloWorld-role-3oceq5at"
  handler = "ListS3BucketsPy.lambda_handler"
  runtime = "python3.9"

  environment {
    variables = {
      greeting = "ListS3BucketsPy"
    }
  }
}

resource "aws_lambda_function_url" "ListS3BucketsPy" {
  function_name      = "ListS3BucketsPy"
  authorization_type = "NONE"
}

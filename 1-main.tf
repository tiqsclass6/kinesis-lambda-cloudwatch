resource "aws_kinesis_stream" "kinesis_stream" {
  name             = "kinesis-stream"
  shard_count      = 1
  retention_period = 24
}

# Archive a file to be used with Lambda using consistent file mode

data "archive_file" "lambda_my_function" {
  type             = "zip"
  source_file      = "${path.module}/src/app.js"
  output_file_mode = "0666"
  output_path      = "${path.module}/src/kinesis.zip"
}

resource "aws_lambda_function" "kinesis_lambda" {
  filename         = data.archive_file.lambda_my_function.output_path
  source_code_hash = data.archive_file.lambda_my_function.output_base64sha256
  function_name    = "kinesis-lambda"
  role             = aws_iam_role.lambda_role.arn
  handler          = "app.handler"
  runtime          = "nodejs16.x"
  depends_on       = [data.archive_file.lambda_my_function]
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy" "lambda_kinesis_access" {
  name = "lambda-kinesis-policy"
  role = aws_iam_role.lambda_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "kinesis:GetRecords",
          "kinesis:GetShardIterator",
          "kinesis:DescribeStream",
          "kinesis:DescribeStreamSummary",
          "kinesis:ListShards",
          "kinesis:ListStreams",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_lambda_event_source_mapping" "kinesis_mapping" {
  event_source_arn  = aws_kinesis_stream.kinesis_stream.arn
  function_name     = aws_lambda_function.kinesis_lambda.arn
  starting_position = "LATEST"
}

output "kinesis_data_stream" {
  value       = aws_kinesis_stream.kinesis_stream.arn
  description = "Kinesis data stream with shards"
}

output "consumer_function" {
  value       = aws_lambda_function.kinesis_lambda.arn
  description = "Consumer Function function name"
}
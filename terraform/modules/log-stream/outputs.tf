//--------------------------------------------------------------------------------------//
//                                        Outputs                                       //
//--------------------------------------------------------------------------------------//

output "firehose_delivery_stream_arn" {
  description = "ARN of the Firehose delivery stream"
  value       = aws_kinesis_firehose_delivery_stream.main.arn
}

output "log_stream_fallback_bucket_name" {
  description = "Name of the S3 fallback bucket"
  value       = aws_s3_bucket.fallback.id
}

output "logs_role_arn" {
  description = "ARN of the CloudWatch logs subscription role"
  value       = aws_iam_role.logs.arn
}

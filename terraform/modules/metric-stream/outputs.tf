//--------------------------------------------------------------------------------------//
//                                        Outputs                                       //
//--------------------------------------------------------------------------------------//

output "grafana_cloud_aws_resource_metadata_role_arn" {
  description = "ARN of the Grafana Cloud AWS Resource Metadata Scrape Job access role"
  value       = aws_iam_role.grafana_cloud_aws_resource_metadata.arn
}

output "metric_stream_arn" {
  description = "ARN of the CloudWatch metric stream"
  value       = aws_cloudwatch_metric_stream.metric_stream.arn
}

output "firehose_delivery_stream_arn" {
  description = "ARN of the Firehose delivery stream"
  value       = aws_kinesis_firehose_delivery_stream.stream.arn
}

output "metric_stream_fallback_bucket_name" {
  description = "Name of the S3 fallback bucket"
  value       = aws_s3_bucket.metric_stream_fallback.id
}

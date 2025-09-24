//--------------------------------------------------------------------------------------//
//                                        Outputs                                       //
//--------------------------------------------------------------------------------------//

# Log Stream Module Outputs
output "log_stream_firehose_arn" {
  description = "ARN of the log stream Firehose delivery stream"
  value       = var.enable_log_stream ? module.log_stream[0].firehose_delivery_stream_arn : null
}

output "log_stream_fallback_bucket_name" {
  description = "Name of the log stream S3 fallback bucket"
  value       = var.enable_log_stream ? module.log_stream[0].log_stream_fallback_bucket_name : null
}

output "log_stream_logs_role_arn" {
  description = "ARN of the CloudWatch logs subscription role"
  value       = var.enable_log_stream ? module.log_stream[0].logs_role_arn : null
}

# Metric Stream Module Outputs
output "metric_stream_grafana_role_arn" {
  description = "ARN of the Grafana Cloud AWS Resource Metadata Scrape Job access role"
  value       = var.enable_metric_stream ? module.metric_stream[0].grafana_cloud_aws_resource_metadata_role_arn : null
}

output "metric_stream_arn" {
  description = "ARN of the CloudWatch metric stream"
  value       = var.enable_metric_stream ? module.metric_stream[0].metric_stream_arn : null
}

output "metric_stream_firehose_arn" {
  description = "ARN of the metric stream Firehose delivery stream"
  value       = var.enable_metric_stream ? module.metric_stream[0].firehose_delivery_stream_arn : null
}

output "metric_stream_fallback_bucket_name" {
  description = "Name of the metric stream S3 fallback bucket"
  value       = var.enable_metric_stream ? module.metric_stream[0].metric_stream_fallback_bucket_name : null
}

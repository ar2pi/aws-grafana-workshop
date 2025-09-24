//--------------------------------------------------------------------------------------//
//                                      Variables                                       //
//--------------------------------------------------------------------------------------//

variable "grafana_cloud_sts_aws_account_id" {
  description = "Grafana Cloud AWS account ID used for STS by the AWS Resource Metadata Scrape Job"
  type        = string
  default     = "008923505280"
}

variable "grafana_cloud_stack_slug" {
  description = "Slug of the Grafana Cloud stack to use for the AWS Resource Metadata Scrape Job"
  type        = string
}

variable "cloud_provider_token" {
  description = "Grafana Cloud token used for creating the AWS Resource Metadata Scrape Job"
  type        = string
  sensitive   = true
}

variable "cloud_provider_url" {
  description = "URL to call Grafana Cloud's Cloud Provider API"
  type        = string
}

variable "metric_stream_fallback_bucket_name" {
  type        = string
  description = "Name of the S3 bucket where failed metric batches will be written to"
  default     = "grafana-cloud-metric-stream-fallback"
}

variable "metric_stream_name" {
  type        = string
  description = "Name of the CloudWatch metric stream"
  default     = "grafana-cloud-metric-stream"
}

variable "target_endpoint" {
  description = "Target endpoint for delivering metrics to Grafana Cloud Provider Observability. If empty, this will be computed based on the stack's Prometheus URL."
  type        = string
  default     = ""
}

variable "metrics_write_token" {
  description = "Grafana Cloud token used to write metrics to Mimir"
  type        = string
  sensitive   = true
}

variable "log_delivery_errors" {
  description = "When enabled, delivery errors will be logged in the configured log group."
  type        = bool
  default     = false
}

variable "errors_log_group_name" {
  description = "Name of the log group to use when `log_delivery_errors` is enabled."
  type        = string
  default     = "grafana_cloud_metric_stream_errors"
}

variable "errors_log_stream_name" {
  description = "Name of the log stream to write to when `log_delivery_errors` is enabled."
  type        = string
  default     = "DeliveryErrors"
}

variable "include_namespaces" {
  description = "List of AWS namespaces to include in the metric stream."
  type        = list(string)
}

variable "aws_regions" {
  description = "List of AWS regions to monitor. If empty, all available regions will be monitored."
  type        = list(string)
  default     = []
}

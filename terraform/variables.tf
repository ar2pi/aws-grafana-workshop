//--------------------------------------------------------------------------------------//
//                                   Root Variables                                     //
//--------------------------------------------------------------------------------------//

# Variables for log-stream module
variable "log_stream_fallback_bucket_name" {
  type        = string
  description = "Name of the S3 bucket where failed log batches will be written to"
}

variable "log_stream_name" {
  type        = string
  description = "Name of the AWS Firehose delivery stream"
}

variable "target_endpoint" {
  description = "Target endpoint for delivering logs to"
  type        = string
}

variable "logs_instance_id" {
  description = "Grafana Loki instance ID"
  type        = number
}

variable "logs_write_token" {
  description = "Grafana Cloud token used to write to Loki"
  type        = string
  sensitive   = true
}

# Variables for metric-stream module (with sensible defaults)
variable "grafana_cloud_sts_aws_account_id" {
  description = "Grafana Cloud AWS account ID used for STS by the AWS Resource Metadata Scrape Job"
  type        = string
  default     = "008923505280"
}

variable "grafana_cloud_stack_slug" {
  description = "Slug of the Grafana Cloud stack to use for the AWS Resource Metadata Scrape Job"
  type        = string
  default     = ""
}

variable "cloud_provider_token" {
  description = "Grafana Cloud token used for creating the AWS Resource Metadata Scrape Job"
  type        = string
  sensitive   = true
  default     = ""
}

variable "cloud_provider_url" {
  description = "URL to call Grafana Cloud's Cloud Provider API"
  type        = string
  default     = ""
}

variable "metric_stream_fallback_bucket_name" {
  type        = string
  description = "Name of the S3 bucket where failed metric batches will be written to"
  default     = ""
}

variable "metric_stream_name" {
  type        = string
  description = "Name of the CloudWatch metric stream"
  default     = ""
}

variable "metrics_write_token" {
  description = "Grafana Cloud token used to write metrics to Mimir"
  type        = string
  sensitive   = true
  default     = ""
}

variable "include_namespaces" {
  description = "List of AWS namespaces to include in the metric stream."
  type        = list(string)
  default     = [
    "AWS/ApplicationELB",
    "AWS/EBS",
    "AWS/EC2",
    "AWS/ECS",
    "AWS/Lambda",
    "AWS/NATGateway",
    "AWS/RDS",
    "AWS/S3",
    "AWS/AutoScaling",
    "AWS/EFS",
    "AWS/ElasticBeanstalk",
    "AWS/ELB",
    "AWS/ES",
    "AWS/Firehose",
    "AWS/Logs",
    "AWS/Prometheus",
    "AWS/Redshift",
    "AWS/SageMaker",
    "AWS/SageMaker/Endpoints",
    "AWS/Usage",
    "ECS/ContainerInsights",
  ]
}

# Shared variables
variable "log_delivery_errors" {
  description = "When enabled, delivery errors will be logged in the configured log group."
  type        = bool
  default     = false
}

variable "errors_log_group_name" {
  description = "Name of the log group to use when `log_delivery_errors` is enabled."
  type        = string
  default     = "grafana_aws_errors"
}

variable "errors_log_stream_name" {
  description = "Name of the log stream to write to when `log_delivery_errors` is enabled."
  type        = string
  default     = "DeliveryErrors"
}

# Feature flags to control which modules to deploy
variable "enable_log_stream" {
  description = "Whether to deploy the log stream module"
  type        = bool
  default     = true
}

variable "enable_metric_stream" {
  description = "Whether to deploy the metric stream module"
  type        = bool
  default     = true
}

variable "enable_auto_subscription" {
  description = "Enable automatic subscription to new log groups via Lambda and EventBridge"
  type        = bool
  default     = false
}

variable "aws_regions" {
  description = "List of AWS regions to monitor for metrics. If empty, all available regions will be monitored."
  type        = list(string)
  default     = []
}

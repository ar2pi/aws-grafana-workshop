//--------------------------------------------------------------------------------------//
//                                      Variables                                       //
//--------------------------------------------------------------------------------------//

variable "log_stream_fallback_bucket_name" {
  type        = string
  description = "Name of the S3 bucket where failed batches will be written to"
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
}

variable "log_delivery_errors" {
  description = "When enabled, delivery errors will be logged in the configured log group."
  type        = bool
  default     = false
}

variable "errors_log_group_name" {
  description = "Name of the log group to use when `log_delivery_errors` is enabled."
  type        = string
  default     = "grafana_aws_logs_errors"
}

variable "errors_log_stream_name" {
  description = "Name of the log stream to write to when `log_delivery_errors` is enabled."
  type        = string
  default     = "DeliveryErrors"
}

variable "enable_auto_subscription" {
  description = "Enable automatic subscription to new log groups via Lambda and EventBridge"
  type        = bool
  default     = false
}

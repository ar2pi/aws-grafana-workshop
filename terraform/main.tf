//--------------------------------------------------------------------------------------//
//                           Terraform provider configuration                           //
//--------------------------------------------------------------------------------------//

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
    grafana = {
      source  = "grafana/grafana"
      version = "~> 3.25"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.12"
    }
  }

  required_version = ">= 1.12"
}

provider "aws" {
  region = "us-east-2"

  // FILLME: local AWS profile to use
  // profile = ""
}

provider "grafana" {
  cloud_access_policy_token = var.cloud_provider_token
}

//--------------------------------------------------------------------------------------//
//                                      Modules                                         //
//--------------------------------------------------------------------------------------//

module "log_stream" {
  count  = var.enable_log_stream ? 1 : 0
  source = "./modules/log-stream"

  log_stream_fallback_bucket_name     = var.log_stream_fallback_bucket_name
  log_stream_name          = var.log_stream_name
  target_endpoint          = var.target_endpoint
  logs_instance_id         = var.logs_instance_id
  logs_write_token         = var.logs_write_token
  log_delivery_errors      = var.log_delivery_errors
  errors_log_group_name    = var.errors_log_group_name
  errors_log_stream_name   = var.errors_log_stream_name
  enable_auto_subscription = var.enable_auto_subscription
}

module "metric_stream" {
  count  = var.enable_metric_stream ? 1 : 0
  source = "./modules/metric-stream"

  grafana_cloud_sts_aws_account_id    = var.grafana_cloud_sts_aws_account_id
  grafana_cloud_stack_slug            = var.grafana_cloud_stack_slug
  cloud_provider_token                = var.cloud_provider_token
  cloud_provider_url                  = var.cloud_provider_url
  metric_stream_fallback_bucket_name  = var.metric_stream_fallback_bucket_name
  metric_stream_name                  = var.metric_stream_name
  metrics_write_token                 = var.metrics_write_token
  include_namespaces                  = var.include_namespaces
  aws_regions                         = var.aws_regions
  log_delivery_errors                 = var.log_delivery_errors
  errors_log_group_name               = var.errors_log_group_name
  errors_log_stream_name              = var.errors_log_stream_name
}

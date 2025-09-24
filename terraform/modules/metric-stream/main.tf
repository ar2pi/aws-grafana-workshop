//--------------------------------------------------------------------------------------//
//                                                                                      //
//                                 Grafana Cloud AWS Metrics Streaming                  //
//                                                                                      //
//--------------------------------------------------------------------------------------//

data "aws_regions" "available" {
  all_regions = true

  # Optional: filter out regions you don't want to monitor
  # Removes regions that require manual opt-in
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required", "opted-in"]
  }
}

data "aws_region" "current" {}

data "grafana_cloud_stack" "main" {
  slug = var.grafana_cloud_stack_slug
}

//--------------------------------------------------------------------------------------//
//                                          S3                                          //
//--------------------------------------------------------------------------------------//
//
// Batches whose delivery failed are written here
//

resource "aws_s3_bucket" "metric_stream_fallback" {
  bucket = var.metric_stream_fallback_bucket_name
}

//--------------------------------------------------------------------------------------//
//                                         IAM                                          //
//--------------------------------------------------------------------------------------//

// main IAM role used by the firehose stream for writing failed batches to S3
resource "aws_iam_role" "metric_stream_firehose" {
  name = format("Firehose-%s", var.metric_stream_name)

  assume_role_policy = data.aws_iam_policy_document.metric_stream_firehose_assume_role.json
}

data "aws_iam_policy_document" "metric_stream_firehose_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

// allow firehose to emit error logs and back up to s3
resource "aws_iam_role_policy" "metric_stream_firehose" {
  name = format("Firehose-%s", var.metric_stream_name)

  // attach to firehose http
  role = aws_iam_role.metric_stream_firehose.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      // allow firehose to write error logs
      {
        Effect   = "Allow"
        Resource = ["*"]
        Action   = ["logs:PutLogEvents"]
      },
      // allow firehose to backup events to s3
      {
        "Sid"    = "s3Permissions"
        "Effect" = "Allow"
        "Action" = [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject",
        ]
        "Resource" = [
          aws_s3_bucket.metric_stream_fallback.arn,
          "${aws_s3_bucket.metric_stream_fallback.arn}/*",
        ]
      },
    ]
  })
}

// IAM role used by CloudWatch metric stream for forwarding metrics to Firehose
resource "aws_iam_role" "metric_stream_role" {
  name = format("MetricStream-%s", var.metric_stream_name)

  // allow metric stream to assume this role
  assume_role_policy = data.aws_iam_policy_document.metric_stream_assume_role.json
}

data "aws_iam_policy_document" "metric_stream_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["streams.metrics.cloudwatch.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy" "metric_stream_role" {
  name = "AWSCloudWatchMetricStreamPolicy"
  role = aws_iam_role.metric_stream_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      // allow metric stream to write to firehose
      {
        Action = ["firehose:PutRecord", "firehose:PutRecordBatch"]
        Effect = "Allow"
        Resource = [
          aws_kinesis_firehose_delivery_stream.stream.arn,
        ]
      },
    ]
  })
}

// IAM resources needed to authorize Grafana Cloud to scrape AWS resource metadata
data "aws_iam_policy_document" "trust_grafana" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.grafana_cloud_sts_aws_account_id}:root"]
    }
    actions = ["sts:AssumeRole"]
    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [data.grafana_cloud_stack.main.prometheus_user_id]
    }
  }
}

resource "aws_iam_role" "grafana_cloud_aws_resource_metadata" {
  name        = "GrafanaAWSResourceMetadataScrapeJobAccess"
  description = "Role used by Grafana CloudWatch integration."
  # Allow Grafana Labs' AWS account to assume this role.
  assume_role_policy = data.aws_iam_policy_document.trust_grafana.json
}

resource "aws_iam_role_policy" "grafana_cloud_aws_resource_metadata" {
  name = "GrafanaAWSResourceMetadataScrapeJobAccess"
  role = aws_iam_role.grafana_cloud_aws_resource_metadata.id
  # This policy allows the role to discover resources via tags and API calls.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "tag:GetResources",
          "apigateway:GET",
          "aps:ListWorkspaces",
          "autoscaling:DescribeAutoScalingGroups",
          "dms:DescribeReplicationInstances",
          "dms:DescribeReplicationTasks",
          "ec2:DescribeTransitGatewayAttachments",
          "ec2:DescribeSpotFleetRequests",
          "shield:ListProtections",
          "storagegateway:ListGateways",
          "storagegateway:ListTagsForResource"
        ]
        Resource = "*"
      }
    ]
  })
}

// Allow some time for IAM (global) changes to propagate
resource "time_sleep" "wait_iam_propagation" {
  depends_on = [
    aws_iam_role.grafana_cloud_aws_resource_metadata,
    aws_iam_role_policy.grafana_cloud_aws_resource_metadata
  ]
  create_duration = "10s"
}


//--------------------------------------------------------------------------------------//
//                    Grafana Cloud AWS Resource Metadata Scrape Job                    //
//--------------------------------------------------------------------------------------//
resource "grafana_cloud_provider_aws_account" "main" {
  depends_on = [
    time_sleep.wait_iam_propagation
  ]

  stack_id = data.grafana_cloud_stack.main.id
  role_arn = aws_iam_role.grafana_cloud_aws_resource_metadata.arn
  regions  = length(var.aws_regions) > 0 ? var.aws_regions : data.aws_regions.available.names
}

resource "grafana_cloud_provider_aws_resource_metadata_scrape_job" "main" {
  stack_id                = data.grafana_cloud_stack.main.id
  name                    = "aws-resource-metadata-scraper"
  aws_account_resource_id = grafana_cloud_provider_aws_account.main.resource_id

  dynamic "service" {
    for_each = var.include_namespaces
    content {
      name = service.value
    }
  }
}


//--------------------------------------------------------------------------------------//
//                                       Firehose                                       //
//--------------------------------------------------------------------------------------//
locals {
  // If the target endpoint is not explicitly provided, then convert the stack's Prometheus URL
  // to the Grafana Cloud AWS Metric Streaming ingest endpoint.
  // Ex: https://prometheus-prod-03-prod-us-central-0.grafana.net
  // becomes https://aws-metric-streams-prod-03.grafana.net/aws-metrics/api/v1/push
  target_endpoint = var.target_endpoint != "" ? var.target_endpoint : format("%s/aws-metrics/api/v1/push", replace(
    replace(data.grafana_cloud_stack.main.prometheus_url, "prometheus", "aws-metric-streams"),
    "-${data.grafana_cloud_stack.main.cluster_slug}",
    ""
  ))
}

resource "aws_kinesis_firehose_delivery_stream" "stream" {
  name        = format("%s-firehose", var.metric_stream_name)
  destination = "http_endpoint"

  http_endpoint_configuration {
    url        = local.target_endpoint
    name       = "Grafana AWS Metric Stream Destination"
    access_key = format("%s:%s", data.grafana_cloud_stack.main.prometheus_user_id, var.metrics_write_token)

    // Buffer incoming data to the specified size, in MBs, before delivering it to the destination
    buffering_size = 1

    // Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination
    // Setting to 1 minute to keep a low enough latency between metric production and actual time they are processed
    buffering_interval = 60

    role_arn       = aws_iam_role.metric_stream_firehose.arn
    s3_backup_mode = "FailedDataOnly"

    request_configuration {
      content_encoding = "GZIP"
    }

    // this block configured the fallback s3 bucket destination
    s3_configuration {
      role_arn           = aws_iam_role.metric_stream_firehose.arn
      bucket_arn         = aws_s3_bucket.metric_stream_fallback.arn
      buffering_size     = 5
      buffering_interval = 300
      compression_format = "GZIP"
    }

    // Optional block for writing delivery failures to a CW log group
    // this assumes the target log group has been created, or is created in this same snippet
    dynamic "cloudwatch_logging_options" {
      for_each = var.log_delivery_errors ? [1] : []
      content {
        enabled         = true
        log_group_name  = var.errors_log_group_name
        log_stream_name = var.errors_log_stream_name
      }
    }
  }
}

//--------------------------------------------------------------------------------------//
//                                   CloudWatch Metric Stream                          //
//--------------------------------------------------------------------------------------//

resource "aws_cloudwatch_metric_stream" "metric_stream" {
  name          = var.metric_stream_name
  role_arn      = aws_iam_role.metric_stream_role.arn
  firehose_arn  = aws_kinesis_firehose_delivery_stream.stream.arn
  output_format = "opentelemetry1.0"

  dynamic "include_filter" {
    // Stream all metrics from the specified namespaces
    for_each = var.include_namespaces
    content {
      namespace = include_filter.value
    }
  }
}

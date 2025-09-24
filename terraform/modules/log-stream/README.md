# Log Stream Module - CloudWatch Log Collection

This module provides three approaches to collect AWS CloudWatch logs and send them to Grafana Cloud Loki.

## 🔧 **Approaches**

### 1. **Static Log Groups** (`static-log-subscriptions.tf`)
**Best for:** Known, specific log groups you want to monitor.

```hcl
# In log-subscriptions.tf, modify the local variable:
locals {
  log_groups_to_monitor = [
    "/aws/lambda/my-function",
    "/aws/ecs/my-service",
    "/aws/apigateway/my-api",
    "/aws/rds/instance/my-db/error"
  ]
}
```

### 2. **Dynamic Discovery** (`dynamic-log-subscriptions.tf`)
**Best for:** Automatically subscribe to all existing log groups.

```hcl
# Subscribes to ALL log groups in your account
resource "aws_cloudwatch_log_subscription_filter" "all_log_groups" {
  for_each = toset(data.aws_cloudwatch_log_groups.all.log_group_names)
  # ... configuration
}
```

## 🚀 **Usage Examples**

### Option A: Monitor Specific Services
```hcl
# terraform.tfvars
enable_log_stream = true

# Edit modules/log-stream/log-subscriptions.tf
locals {
  log_groups_to_monitor = [
    "/aws/lambda/user-auth",
    "/aws/lambda/payment-processor",
    "/aws/ecs/web-app",
    "/aws/apigateway/api-prod"
  ]
}
```

### Option B: Monitor All AWS Service Logs
```hcl
# terraform.tfvars
enable_log_stream = true

# Use dynamic-subscriptions.tf - it's already configured for AWS services
```

### Option C: Monitor Everything + Auto-Subscribe to New Logs
```hcl
# terraform.tfvars
enable_log_stream = true
enable_auto_subscription = true
```

## 🎯 **Filter Patterns**

Control what logs are sent by modifying the `filter_pattern`:

```hcl
resource "aws_cloudwatch_log_subscription_filter" "example" {
  # All logs (default)
  filter_pattern = ""

  # Only ERROR logs
  filter_pattern = "[timestamp, request_id, level=ERROR, message]"

  # Only logs containing "Exception"
  filter_pattern = "Exception"

  # JSON logs with specific field
  filter_pattern = "{ $.level = \"ERROR\" }"
}
```

## 💡 **Cost Optimization Tips**

1. **Use filter patterns** to reduce log volume
2. **Start with specific log groups**, then expand
3. **Monitor Firehose costs** in AWS billing
4. **Set up log retention policies** to manage CloudWatch costs

## 🔍 **Monitoring**

After deployment, check:
- **CloudWatch → Log Groups → Subscription Filters**
- **Kinesis Data Firehose → Delivery Streams**
- **Grafana Cloud → Loki → Log Browser**

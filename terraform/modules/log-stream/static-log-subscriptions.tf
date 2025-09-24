//--------------------------------------------------------------------------------------//
//                            CloudWatch Log Subscription Filters                      //
//--------------------------------------------------------------------------------------//

# Define log groups you want to monitor
locals {
  log_groups_to_monitor = [
    "/ecs/grafana-alloy-task",
    # Add more log groups as needed
  ]
}

# Create subscription filters for each log group
resource "aws_cloudwatch_log_subscription_filter" "static_log_subscriptions" {
  for_each = toset(local.log_groups_to_monitor)

  name            = "grafana-logs-${replace(each.value, "/", "-")}"
  role_arn        = aws_iam_role.logs.arn
  log_group_name  = each.value
  filter_pattern  = ""  # Empty = all logs, or specify pattern like "[ERROR]"
  destination_arn = aws_kinesis_firehose_delivery_stream.main.arn
  distribution    = "ByLogStream"

  # Handle case where log group might not exist yet
  depends_on = [
    aws_iam_role.logs,
    aws_kinesis_firehose_delivery_stream.main
  ]
}

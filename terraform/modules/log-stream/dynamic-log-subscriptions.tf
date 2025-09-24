//--------------------------------------------------------------------------------------//
//                        Dynamic Log Group Discovery & Subscription                   //
//--------------------------------------------------------------------------------------//

# Data source to discover all existing log groups
data "aws_cloudwatch_log_groups" "all" {
  # Optional: filter by log group name prefix
  # log_group_name_prefix = "/aws/"
}

# Create subscription filters for ALL discovered log groups
resource "aws_cloudwatch_log_subscription_filter" "dynamic_log_subscriptions" {
  for_each = toset(data.aws_cloudwatch_log_groups.all.log_group_names)

  name            = "grafana-logs-${replace(each.value, "/", "-")}"
  role_arn        = aws_iam_role.logs.arn
  log_group_name  = each.value
  filter_pattern  = ""  # Capture all logs
  destination_arn = aws_kinesis_firehose_delivery_stream.main.arn
  distribution    = "ByLogStream"

  depends_on = [
    aws_iam_role.logs,
    aws_kinesis_firehose_delivery_stream.main
  ]
}

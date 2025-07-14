resource "grafana_cloud_provider_aws_cloudwatch_scrape_job" "aws_metrics" {
  name                    = "aws_metrics"
  enabled                 = true
  aws_account_resource_id = "99"
  stack_id                = "1312534"
  export_tags             = true
  service {
    name                    = "AWS/ApplicationELB"
    scrape_interval_seconds = 300
    metric {
      name       = "ActiveConnectionCount"
      statistics = ["Average"]
    }
    metric {
      name       = "ClientTLSNegotiationErrorCount"
      statistics = ["Sum"]
    }
    metric {
      name       = "ConsumedLCUs"
      statistics = ["Average"]
    }
    metric {
      name       = "ELBAuthError"
      statistics = ["Sum"]
    }
    metric {
      name       = "ELBAuthFailure"
      statistics = ["Sum"]
    }
    metric {
      name       = "ELBAuthLatency"
      statistics = ["Average"]
    }
    metric {
      name       = "ELBAuthRefreshTokenSuccess"
      statistics = ["Sum"]
    }
    metric {
      name       = "ELBAuthSuccess"
      statistics = ["Sum"]
    }
    metric {
      name       = "ELBAuthUserClaimsSizeExceeded"
      statistics = ["Sum"]
    }
    metric {
      name       = "HTTPCode_ELB_3XX_Count"
      statistics = ["Sum"]
    }
    metric {
      name       = "HTTPCode_ELB_4XX_Count"
      statistics = ["Sum"]
    }
    metric {
      name       = "HTTPCode_ELB_5XX_Count"
      statistics = ["Sum"]
    }
    metric {
      name       = "HTTPCode_Target_2XX_Count"
      statistics = ["Sum"]
    }
    metric {
      name       = "HTTPCode_Target_3XX_Count"
      statistics = ["Sum"]
    }
    metric {
      name       = "HTTPCode_Target_4XX_Count"
      statistics = ["Sum"]
    }
    metric {
      name       = "HTTPCode_Target_5XX_Count"
      statistics = ["Sum"]
    }
    metric {
      name       = "IPv6ProcessedBytes"
      statistics = ["Sum"]
    }
    metric {
      name       = "IPv6RequestCount"
      statistics = ["Sum"]
    }
    metric {
      name       = "NewConnectionCount"
      statistics = ["Average"]
    }
    metric {
      name       = "ProcessedBytes"
      statistics = ["Average"]
    }
    metric {
      name       = "RejectedConnectionCount"
      statistics = ["Average"]
    }
    metric {
      name       = "RequestCount"
      statistics = ["Sum"]
    }
    metric {
      name       = "RuleEvaluations"
      statistics = ["Sum"]
    }
    metric {
      name       = "TargetConnectionErrorCount"
      statistics = ["Average"]
    }
    metric {
      name       = "TargetResponseTime"
      statistics = ["Average"]
    }
    metric {
      name       = "TargetTLSNegotiationErrorCount"
      statistics = ["Sum"]
    }
  }
  service {
    name                    = "AWS/ELB"
    scrape_interval_seconds = 300
    metric {
      name       = "BackendConnectionErrors"
      statistics = ["Sum"]
    }
    metric {
      name       = "HealthyHostCount"
      statistics = ["Average"]
    }
    metric {
      name       = "HTTPCode_Backend_2XX"
      statistics = ["Sum"]
    }
    metric {
      name       = "HTTPCode_Backend_3XX"
      statistics = ["Sum"]
    }
    metric {
      name       = "HTTPCode_Backend_4XX"
      statistics = ["Sum"]
    }
    metric {
      name       = "HTTPCode_Backend_5XX"
      statistics = ["Sum"]
    }
    metric {
      name       = "HTTPCode_ELB_4XX"
      statistics = ["Sum"]
    }
    metric {
      name       = "HTTPCode_ELB_5XX"
      statistics = ["Sum"]
    }
    metric {
      name       = "Latency"
      statistics = ["Average"]
    }
    metric {
      name       = "RequestCount"
      statistics = ["Sum"]
    }
    metric {
      name       = "SpilloverCount"
      statistics = ["Sum"]
    }
    metric {
      name       = "SurgeQueueLength"
      statistics = ["Maximum"]
    }
    metric {
      name       = "UnHealthyHostCount"
      statistics = ["Average"]
    }
  }
  service {
    name                    = "AWS/NetworkELB"
    scrape_interval_seconds = 300
    metric {
      name       = "ActiveFlowCount"
      statistics = ["Sum"]
    }
    metric {
      name       = "ActiveFlowCount_TLS"
      statistics = ["Sum"]
    }
    metric {
      name       = "ClientTLSNegotiationErrorCount"
      statistics = ["Sum"]
    }
    metric {
      name       = "ConsumedLCUs"
      statistics = ["Average", "Sum"]
    }
    metric {
      name       = "HealthyHostCount"
      statistics = ["Sum"]
    }
    metric {
      name       = "NewFlowCount"
      statistics = ["Average"]
    }
    metric {
      name       = "NewFlowCount_TLS"
      statistics = ["Average"]
    }
    metric {
      name       = "ProcessedBytes"
      statistics = ["Average", "Sum"]
    }
    metric {
      name       = "TargetTLSNegotiationErrorCount"
      statistics = ["Sum"]
    }
    metric {
      name       = "TCP_Client_Reset_Count"
      statistics = ["Sum"]
    }
    metric {
      name       = "TCP_Target_Reset_Count"
      statistics = ["Sum"]
    }
    metric {
      name       = "UnHealthyHostCount"
      statistics = ["Sum"]
    }
  }
  service {
    name                    = "AWS/EC2"
    scrape_interval_seconds = 300
    metric {
      name       = "CPUUtilization"
      statistics = ["Maximum", "Average"]
    }
    metric {
      name       = "DiskReadBytes"
      statistics = ["Sum"]
    }
    metric {
      name       = "DiskReadOps"
      statistics = ["Sum"]
    }
    metric {
      name       = "DiskWriteBytes"
      statistics = ["Sum"]
    }
    metric {
      name       = "DiskWriteOps"
      statistics = ["Sum"]
    }
    metric {
      name       = "EBSByteBalance%"
      statistics = ["Average"]
    }
    metric {
      name       = "EBSIOBalance%"
      statistics = ["Average"]
    }
    metric {
      name       = "EBSReadBytes"
      statistics = ["Sum"]
    }
    metric {
      name       = "EBSReadOps"
      statistics = ["Sum"]
    }
    metric {
      name       = "EBSWriteBytes"
      statistics = ["Sum"]
    }
    metric {
      name       = "EBSWriteOps"
      statistics = ["Sum"]
    }
    metric {
      name       = "NetworkIn"
      statistics = ["Average", "Sum"]
    }
    metric {
      name       = "NetworkOut"
      statistics = ["Average", "Sum"]
    }
    metric {
      name       = "NetworkPacketsIn"
      statistics = ["Sum"]
    }
    metric {
      name       = "NetworkPacketsOut"
      statistics = ["Sum"]
    }
    metric {
      name       = "StatusCheckFailed"
      statistics = ["Sum"]
    }
    metric {
      name       = "StatusCheckFailed_Instance"
      statistics = ["Sum"]
    }
    metric {
      name       = "StatusCheckFailed_System"
      statistics = ["Sum"]
    }
  }
  service {
    name                    = "AWS/RDS"
    scrape_interval_seconds = 300
    metric {
      name       = "BurstBalance"
      statistics = ["Average"]
    }
    metric {
      name       = "CPUCreditBalance"
      statistics = ["Average"]
    }
    metric {
      name       = "CPUCreditUsage"
      statistics = ["Average"]
    }
    metric {
      name       = "CPUUtilization"
      statistics = ["Maximum", "Average"]
    }
    metric {
      name       = "DatabaseConnections"
      statistics = ["Sum"]
    }
    metric {
      name       = "DBLoad"
      statistics = ["Average"]
    }
    metric {
      name       = "DBLoadCPU"
      statistics = ["Average"]
    }
    metric {
      name       = "DBLoadNonCPU"
      statistics = ["Average"]
    }
    metric {
      name       = "EBSByteBalance%"
      statistics = ["Average"]
    }
    metric {
      name       = "EBSIOBalance%"
      statistics = ["Average"]
    }
    metric {
      name       = "FreeableMemory"
      statistics = ["Average"]
    }
    metric {
      name       = "FreeStorageSpace"
      statistics = ["Average"]
    }
    metric {
      name       = "FreeStorageSpaceLogVolume"
      statistics = ["Average"]
    }
    metric {
      name       = "ReadIOPS"
      statistics = ["Average"]
    }
    metric {
      name       = "ReadLatency"
      statistics = ["Average", "Maximum"]
    }
    metric {
      name       = "ReadThroughput"
      statistics = ["Average"]
    }
    metric {
      name       = "ReplicaLag"
      statistics = ["Average"]
    }
    metric {
      name       = "SwapUsage"
      statistics = ["Average"]
    }
    metric {
      name       = "WriteIOPS"
      statistics = ["Average"]
    }
    metric {
      name       = "WriteLatency"
      statistics = ["Average", "Maximum"]
    }
    metric {
      name       = "WriteThroughput"
      statistics = ["Average"]
    }
  }
  service {
    name                    = "AWS/Lambda"
    scrape_interval_seconds = 300
    metric {
      name       = "Duration"
      statistics = ["Maximum", "Minimum", "p90"]
    }
    metric {
      name       = "Errors"
      statistics = ["Sum"]
    }
    metric {
      name       = "Invocations"
      statistics = ["Sum"]
    }
    metric {
      name       = "Throttles"
      statistics = ["Sum"]
    }
  }

  depends_on = [
    aws_iam_role.grafana_labs_cloudwatch_integration,
    aws_iam_role_policy.grafana_labs_cloudwatch_integration,
    time_sleep.wait_10_seconds
  ]
}

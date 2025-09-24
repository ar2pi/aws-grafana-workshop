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

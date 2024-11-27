module "cloudwatch_metrics_stream_single_account" {
  source = "sysdiglabs/monitor-for-cloud/aws//modules/cloud-watch-metrics-stream"

  sysdig_monitor_api_token = var.sysdig_monitor_api_token
  sysdig_monitor_url       = var.sysdig_monitor_url
  sysdig_aws_account_id    = var.aws_system_account_id
  monitoring_role_name     = "TerraformSysdigMonitoringRole"
  create_new_role          = true
  sysdig_external_id       = var.aws_role_external_id
  exclude_filters = [
    {
      namespace    = "AWS/Firehose"
      metric_names = ["BytesPerSecondLimit"]
    }
  ]
}
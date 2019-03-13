resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "3tier-nodeapp-dashboard"

{
    "widgets": [
        {
            "type": "metric",
            "x": 0,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "nodeappdb" ],
                    [ ".", "DatabaseConnections", ".", "postgresdb" ]
                ],
                "region": "eu-central-1",
                "period": 300
            }
        },
        {
            "type": "metric",
            "x": 6,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "view": "timeSeries",
                "stacked": false,
                "metrics": [
                    [ "AWS/ELB", "RequestCount", "Service", "ELB", { "stat": "Sum" } ],
                    [ ".", "BackendConnectionErrors", ".", ".", { "stat": "Sum" } ]
                ],
                "region": "eu-central-1"
            }
        },
        {
            "type": "metric",
            "x": 12,
            "y": 0,
            "width": 6,
            "height": 6,
            "properties": {
                "metrics": [
                    [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${output.workers_asg_names}", { "visible": false } ],
                    [ "...", "nodeapp-cluster-worker_nodes_group120190313143704286700000010" ],
                    [ ".", "DiskReadOps", ".", "." ],
                    [ ".", "DiskWriteOps", ".", "." ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "eu-central-1",
                "period": 300
            }
        }
    ]
}
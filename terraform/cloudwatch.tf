resource "aws_cloudwatch_dashboard" "main" {
  dashboard_name = "3tier-nodeapp-dashboard"
  dashboard_body = <<EOF
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
                    [ "AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", "${module.db.this_db_instance_name}" ],
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
                "metrics": [
                    [ "AWS/ELB", "RequestCount", "Service", "ELB", { "stat": "Sum", "id": "m1" } ],
                    [ ".", "BackendConnectionErrors", ".", ".", { "stat": "Sum", "id": "m2" } ],
                    [ ".", "UnHealthyHostCount", ".", ".", { "stat": "SampleCount" } ]
                ],
                "view": "timeSeries",
                "stacked": false,
                "region": "eu-central-1",
                "period": 300
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
                    [ "AWS/EC2", "CPUUtilization", "AutoScalingGroupName", "${module.eks.workers_asg_names}" ],
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
EOF
}

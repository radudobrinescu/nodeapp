module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "nodeappdb"

  engine            = "postgres"
  engine_version    = "9.6.3"
  instance_class    = "db.t2.micro"
  allocated_storage = 10
  storage_encrypted = false

  name = "nodeappdb"

  # NOTE: Do NOT use 'user' as the value for 'username' as it throws:
  # "Error creating DB Instance: InvalidParameterValue: MasterUsername
  # user cannot be used as it is a reserved word used by the engine"
  username = "nodeappadmin"
  password = "nodeappadmin!"
  port     = "5432"

  vpc_security_group_ids = ["${aws_security_group.nodeapp_db_sg.id}"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group - created in the vpn module
  #create_db_subnet_group = false 
  #db_subnet_group_name = "${module.vpc.database_subnet_group}"
  subnet_ids = ["${module.vpc.database_subnets}"]


  # DB parameter group
  family = "postgres9.6"

  # DB option group
  major_engine_version = "9.6"

  # Snapshot name upon DB deletion
  final_snapshot_identifier = "nodeappsnapshot"

  # Database Deletion Protection
  deletion_protection = false
}

resource "aws_security_group" "db_sg" {
  name        = "oiai-db-security-group"
  description = "Allow traffic to RDS from 10.0.0.0/16"
  vpc_id      = local.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.2.0.0/16"]
  ***REMOVED***

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  ***REMOVED***

***REMOVED***
    Name = "oiai-db-security-group"
  ***REMOVED***
***REMOVED***

module "api_db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "oiaidb"

  engine            = "postgres"
  engine_version    = "13"
  instance_class    = "db.t4g.micro"  
  allocated_storage = 5

  db_name  = "demodb"
  username = "oiai"
  port     = "5432"

  iam_database_authentication_enabled = false

  vpc_security_group_ids = [aws_security_group.db_sg.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  manage_master_user_password = true

  family = "postgres13"

***REMOVED***
    Owner       = "user"
    Environment = "dev"
  ***REMOVED***

  create_db_subnet_group = true
  subnet_ids             = local.vpc.private_subnets

  # Database Deletion Protection
  deletion_protection = false
***REMOVED***

data "aws_secretsmanager_secret" "db_secret" {
  arn = module.api_db.db_instance_master_user_secret_arn
***REMOVED***

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = data.aws_secretsmanager_secret.db_secret.id
***REMOVED***

***REMOVED***
  secret_json = jsondecode(data.aws_secretsmanager_secret_version.db_credentials.secret_string)
***REMOVED***

resource "kubernetes_secret" "db_credentials" {
***REMOVED***
    name      = "oiai-db-credentials-secret"
    namespace = "apps"
  ***REMOVED***

***REMOVED***
    host     = module.api_db.db_instance_address
    user     = local.secret_json.username
    port     = 5432
    password = local.secret_json.password
    dbname   = "demodb"
    DATABASE_URL= "postgresql://${local.secret_json.username***REMOVED***:${local.secret_json.password***REMOVED***@${module.api_db.db_instance_address***REMOVED***:5432/demodb"

  ***REMOVED***
***REMOVED***

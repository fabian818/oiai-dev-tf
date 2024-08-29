module "api_db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "oiaidb"

  engine            = "postgres"
  engine_version    = "13"
  instance_class    = "db.t4g.micro"  
  allocated_storage = 5

  db_name  = "demodb"
  username = "user"
  port     = "5432"

  iam_database_authentication_enabled = false

  vpc_security_group_ids = ["sg-12345678"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  manage_master_user_password = true

***REMOVED***
    Owner       = "user"
    Environment = "dev"
  ***REMOVED***

  create_db_subnet_group = true
  subnet_ids             = ["subnet-12345678", "subnet-87654321"]

  # Database Deletion Protection
  deletion_protection = false
***REMOVED***

data "aws_secretsmanager_secret_version" "db_credentials" {
  secret_id = module.db.master_user_secret
***REMOVED***

data "aws_secretsmanager_secret" "db_secret" {
  arn = data.aws_secretsmanager_secret_version.db_credentials.arn
***REMOVED***

***REMOVED***
  secret_json = jsondecode(data.aws_secretsmanager_secret.db_secret.secret_string)
***REMOVED***

resource "kubernetes_secret" "db_credentials" {
***REMOVED***
    name      = "oiai-db-credentials-secret"
    namespace = "apps"
  ***REMOVED***

***REMOVED***
    host     = module.db.this_db_instance_address
    user     = local.secret_json.username
    port     = local.secret_json.port
    password = local.secret_json.password
    dbname   = local.secret_json.dbname
    DATABASE_URL= "postgresql://${local.secret_json.username***REMOVED***:${local.secret_json.password***REMOVED***@${module.db.this_db_instance_address***REMOVED***:${local.secret_json.port***REMOVED***/${local.secret_json.dbname***REMOVED***"

  ***REMOVED***
***REMOVED***

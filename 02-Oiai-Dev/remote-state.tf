data "terraform_remote_state" "oiai-dev-01" {
  backend = "s3"
  config = {
    bucket = "terraform.infrastructure.oiai-dev.adeployguru.com"
    key    = "01-Oiai-Dev/tf.state"
    region = "us-east-1"
  ***REMOVED***
***REMOVED***

***REMOVED***
  main_cluster = data.terraform_remote_state.oiai-dev-01.outputs.main_cluster
  vpc                                 = data.terraform_remote_state.oiai-dev-01.outputs.vpc
***REMOVED***

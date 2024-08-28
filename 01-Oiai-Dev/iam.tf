resource "aws_iam_role" "github_role" {
  name               = "${local.resource_prefix***REMOVED***-github-role"
  assume_role_policy = <<***REMOVED***
{
    "Version": "2012-10-17",
    "Statement": [
***REMOVED***
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::504697764804:oidc-provider/token.actions.githubusercontent.com"
            ***REMOVED***,
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "ForAnyValue:StringLike": {
                    "token.actions.githubusercontent.com:sub": [
                        "repo:fabian818/repo:*"
                  ***REMOVED***
                ***REMOVED***,
                "ForAllValues:StringEquals": {
                    "token.actions.githubusercontent.com:iss": "https://token.actions.githubusercontent.com",
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                ***REMOVED***
            ***REMOVED***
        ***REMOVED***
  ***REMOVED***
***REMOVED***
***REMOVED***

  tags = local.default_tags
***REMOVED***

resource "aws_iam_role_policy_attachment" "github_role_admin" {
  role       = aws_iam_role.github_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
***REMOVED***
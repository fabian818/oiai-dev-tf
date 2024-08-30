resource "aws_iam_role" "github_role" {
  name               = "${local.resource_prefix}-github-role"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::132900311735:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "ForAnyValue:StringLike": {
                    "token.actions.githubusercontent.com:sub": [
                        "repo:fabian818/oiai-backend:*",
                        "repo:fabian818/oiai-frontend:*"
                    ]
                },
                "ForAllValues:StringEquals": {
                    "token.actions.githubusercontent.com:iss": "https://token.actions.githubusercontent.com",
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                }
            }
        }
    ]
}
EOF

  tags = local.default_tags
}

resource "aws_iam_role_policy_attachment" "github_role_admin" {
  role       = aws_iam_role.github_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
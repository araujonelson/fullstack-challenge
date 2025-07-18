resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
}

resource "aws_iam_role" "gha_deploy" {
  name = "GHActionsDeploy"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
      Action    = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:sub" = "repo:my-org/infra-repo:*"
        }
      }
    }]
  })
}

resource "aws_iam_role_policy" "gha_deploy_policy" {
  name = "GHActionsDeployPolicy"
  role = aws_iam_role.gha_deploy.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:ListBucket"]
        Resource = [
          "arn:aws:s3:::my-app-devel",
          "arn:aws:s3:::my-app-stage",
          "arn:aws:s3:::my-app-prod"
        ]
      },
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject","s3:PutObject","s3:DeleteObject"]
        Resource = [
          "arn:aws:s3:::my-app-devel/*",
          "arn:aws:s3:::my-app-stage/*",
          "arn:aws:s3:::my-app-prod/*"
        ]
      }
    ]
  })
}

output "gha_deploy_role_arn" {
  value = aws_iam_role.gha_deploy.arn
}
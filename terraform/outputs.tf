
output "site_bucket" {
  description = "Name of the S3 bucket hosting the site for the current workspace"
  value       = module.s3_site.site_bucket
}

output "cdn_domain" {
  description = "CloudFront distribution domain name for the current workspace"
  value       = module.cloudfront.cdn_domain
}

# output "gha_deploy_role_arn" {
#   description = "IAM Role ARN that GitHub Actions should assume via OIDC"
#   value       = module.iam.gha_deploy_role_arn
# }
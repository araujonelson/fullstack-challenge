// Determine which environment we’re in based on the Terraform workspace
locals {
  env         = terraform.workspace               // “devel”, “stage” or “prod”
  site_bucket = "my-app-${local.env}"
  log_bucket  = "my-app-${local.env}-logs"
}

// 1) IAM / OIDC Role (so GitHub Actions can assume it)
module "iam" {
  source = "./modules/iam"
}

// 2) S3 bucket to hold your built static files (private ACL)
module "s3_site" {
  source                    = "./modules/s3_site"
  site_bucket               = local.site_bucket
  force_destroy             = false
  cloudfront_distribution_arn = module.cloudfront.distribution_arn
}

// 3) CloudFront distribution in front of that bucket, with logging
module "cloudfront" {
  source        = "./modules/cloudfront"
  origin_bucket = module.s3_site.site_bucket
  log_bucket    = local.log_bucket
}



// 4) Branch‐protection rules for your long‐lived branches
# module "protect_devel" {
#   source          = "./modules/branch_protection"
#   github_repo_id  = var.github_repo_id
#   pattern         = "devel"
#   required_checks = ["build","cd"]
# }

# module "protect_stage" {
#   source          = "./modules/branch_protection"
#   github_repo_id  = var.github_repo_id
#   pattern         = "stage"
#   required_checks = ["build","cd"]
# }

# module "protect_prod" {
#   source          = "./modules/branch_protection"
#   github_repo_id  = var.github_repo_id
#   pattern         = "prod"
#   required_checks = ["build","cd"]
# }
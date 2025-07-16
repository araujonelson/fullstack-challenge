variable "aws_region" {
  description = "AWS region into which all resources will be deployed"
  type        = string
  default     = "us-east-1"
}

# variable "github_owner" {
#   description = "GitHub organization or user that owns the infra repo"
#   type        = string
# }

# variable "github_token" {
#   description = "GitHub API token with permissions to manage branch protection"
#   type        = string
#   sensitive   = true
# }

# variable "github_repo_id" {
#   description = "Repository identifier to apply branch protection to (owner/name)"
#   type        = string
# }
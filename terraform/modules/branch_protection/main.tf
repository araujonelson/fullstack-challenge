variable "github_repo_id"  {}
variable "pattern"         {}
variable "required_checks" { type = list(string) }

resource "github_branch_protection" "bp" {
  repository_id = var.github_repo_id
  pattern       = var.pattern

  required_status_checks {
    strict   = true
    contexts = var.required_checks
  }

  required_pull_request_reviews {
    required_approving_review_count = 1
  }

  enforce_admins = true
}
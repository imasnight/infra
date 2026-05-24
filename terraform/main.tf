resource "github_repository" "repos" {
  for_each = { for r in var.repositories : r.name => r }

  name        = each.value.name
  description = each.value.description
  visibility  = each.value.visibility

  has_issues = each.value.has_issues
  has_wiki   = each.value.has_wiki

  lifecycle {
    prevent_destroy = true
  }
}

locals {
  protected_repos = { for r in var.repositories : r.name => r if r.protect_main }
}

resource "github_branch_protection" "main" {
  for_each = local.protected_repos

  repository_id = github_repository.repos[each.key].node_id
  pattern       = "main"

  required_pull_request_reviews {
    required_approving_review_count = 0
  }
}

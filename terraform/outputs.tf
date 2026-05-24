output "repository_urls" {
  description = "HTML URLs of managed repositories"
  value       = { for name, repo in github_repository.repos : name => repo.html_url }
}

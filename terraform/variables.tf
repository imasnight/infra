variable "github_owner" {
  description = "GitHub organization or user name"
  type        = string
  default     = "imasnight"
}

variable "repositories" {
  description = "List of repositories to manage"
  type = list(object({
    name         = string
    description  = optional(string, "")
    visibility   = optional(string, "private")
    has_issues   = optional(bool, true)
    has_wiki     = optional(bool, false)
    protect_main = optional(bool, true)
  }))
}

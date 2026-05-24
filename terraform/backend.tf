terraform {
  cloud {
    organization = "imasnight"
    workspaces {
      name = "infra"
    }
  }
}

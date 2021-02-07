terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "fcrespel"

    workspaces {
      name = "fabinfra-tf"
    }
  }
}

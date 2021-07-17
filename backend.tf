terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "fabinfra"

    workspaces {
      name = "fabinfra-tf"
    }
  }
}

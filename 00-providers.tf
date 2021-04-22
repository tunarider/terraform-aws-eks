provider "aws" {
  region = data.terraform_remote_state.micro.outputs.region

  ignore_tags {
    key_prefixes = ["kubernetes.io/"]
  }
}

provider "tls" {
}

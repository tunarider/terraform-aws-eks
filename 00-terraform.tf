terraform {
  required_version = ">= 0.14.4, < 0.15.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0, < 3.38.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = ">= 3.0.0, < 3.1.0"
    }
  }
}

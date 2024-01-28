terraform {
  required_version = ">=1.0.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }

    http = {
      source  = "hashicorp/http"
      version = "~> 2.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.1.0"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.0"
    }
  }
}
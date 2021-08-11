
provider "aws" {
  region = var.region
}

resource "random_string" "random" {
  length           = 6
  lower            = true
  upper            = false
  special          = false
}


data "aws_caller_identity" "current" {}

resource "aws_codecommit_repository" "cs-image-code" {
  repository_name = "cs-image-code"
  description     = "Repository for sample image build steps with scan"
}

resource "aws_ecr_repository" "cs-image-code" {
  name                 = "cs-image-code"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

resource "aws_s3_bucket" "codebuild-logs" {
  bucket = "codebuild-logs-${random_string.random.result}"
  acl = "private"
  force_destroy = true
}

resource "aws_codebuild_project" "cs-project" {
  name = "cs-image-build"
  description = "Used to showcase image build with scan"
  service_role = aws_iam_role.codebuild-role.arn
  
  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:5.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode = true

    environment_variable {
      name = "AWS_DEFAULT_REGION"
      value = var.region
    }

    environment_variable {
      name = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }

    environment_variable {
      name = "IMAGE_REPO_NAME"
      value = aws_codecommit_repository.cs-image-code.repository_name
    }

    environment_variable {
      name = "IMAGE_TAG"
      value = "latest"
    }

    environment_variable {
      name = "SCORE_THRESHOLD"
      value = var.score_threshold
    }


  }

  artifacts {
    type = "NO_ARTIFACTS"
  }

  logs_config {
      s3_logs {
        status   = "ENABLED"
        location = "${aws_s3_bucket.codebuild-logs.id}/build-log"
    }
  } 

  source {
    type = "CODECOMMIT"
    location = aws_codecommit_repository.cs-image-code.clone_url_http
    git_clone_depth = 1
  }

  source_version = "main"
}
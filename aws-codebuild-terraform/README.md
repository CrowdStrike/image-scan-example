# AWS CodeCommit and CodeBuild Demo

## This demo combines AWS CodeCommit and CodeBuild to showcase CrowdStrike Image Scanning

This repo can be cloned locally and ran with an authenticated AWS CLI

## Resources created

* CodeCommit Repository
* CodeBuild Project
* ECR Repository
* S3 Bucket for logging
* IAM Service Role for CodeBuild
* AWS Secrets Manager Secrets
* Permissions assignment to CodeBuild Service Role to access ECR, S3 and Secrets that were created
* IAM assignment for current user access CodeCommit

## Requirements

* This must be ran from the bash shell
* Authenticated AWS CLI with privelges to create the necessary resources
* jq needs to be installed
* Falcon API Client ID with Falcon Container Image and Falcon Container Regostry R+W

## Variables

* The below variables can be modified in the demo.sh script to fit your needs.

```
AWS_REGION="us-east-2"
FALCON_CLOUD="us-2"
SCORE_THRESHOLD="99999999"
```

## Usage

### Bringing up the demo

* Clone the repo locally
* Run `/bin/bash demo.sh up` from the root directory
* Log into AWS Console and navigate to CodeBuild
* View the latest CodeBuild Project run for `cs-image-build`

### Bringing down the demo

* Run `/bin/bash demo.sh down`

## Known limitations

* This is an early version. Please report or fix and issues.


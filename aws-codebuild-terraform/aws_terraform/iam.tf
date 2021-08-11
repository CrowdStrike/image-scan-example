# Service role for codebuild
resource "aws_iam_role" "codebuild-role" {
  name = "cs-codebuild-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


# Policy to allow codebuild to push to ECR
resource "aws_iam_role_policy" "codebuild-ecr" {
  name = "cs-codebuild-ecr"
  role = aws_iam_role.codebuild-role.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ecr:BatchCheckLayerAvailability",
                "ecr:CompleteLayerUpload",
                "ecr:GetAuthorizationToken",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage",
                "ecr:UploadLayerPart"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
EOF
}


# Policy to allow CodeBuild access to S3
resource "aws_iam_role_policy" "codebuild-s3" {
  name = "cs-codebuild-s3"
  role = aws_iam_role.codebuild-role.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
      "Action": [
        "s3:PutObject",
        "s3:GetBucketAcl",
        "s3:GetBucketLocation"
      ],
      "Resource": [
        "${aws_s3_bucket.codebuild-logs.arn}",
        "${aws_s3_bucket.codebuild-logs.arn}/*"
      ],
      "Effect": "Allow"
    }
  ]
}
EOF
}


# Policy to allow CodeBuild access to CodeCommit
resource "aws_iam_role_policy" "codebuild-codecommit" {
  name = "cs-codebuild-codecommit"
  role = aws_iam_role.codebuild-role.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
          {
            "Effect": "Allow",
            "Resource": [
                "${aws_codecommit_repository.cs-image-code.arn}"
            ],
            "Action": [
                "codecommit:GitPull"
            ]
        }
    ]
}
EOF
}


# Policy to allow CodeBuild access to Secrets
resource "aws_iam_role_policy" "codebuild-secrets" {
  name = "cs-codebuild-secrets"
  role = aws_iam_role.codebuild-role.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "secretsmanager:GetSecretValue"
            ],
            "Resource": [
                "${aws_secretsmanager_secret.falcon_client_id.arn}",
                "${aws_secretsmanager_secret.falcon_client_secret.arn}",
                "${aws_secretsmanager_secret.falcon_cloud.arn}"

            ]
        }
    ]
}
EOF
}

# Attachment to allow current user CodeCommit access
resource "aws_iam_user_policy_attachment" "iam-user-codecommit" {
  user = var.current_user
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeCommitPowerUser"
}

# Policy to allow CodeBuild access to CloudWatch Logs
resource "aws_iam_role_policy" "logs" {
  name = "cs-codebuild-logs"
  role = aws_iam_role.codebuild-role.name
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
              "*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
      }
    ]
}
EOF
}
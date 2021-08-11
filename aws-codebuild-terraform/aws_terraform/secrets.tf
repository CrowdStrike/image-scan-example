resource "aws_secretsmanager_secret" "falcon_client_id" {
  name = "/CodeBuild/falcon_client_id"

}

resource "aws_secretsmanager_secret" "falcon_client_secret" {
  name = "/CodeBuild/falcon_client_secret"
}

resource "aws_secretsmanager_secret" "falcon_cloud" {
  name = "/CodeBuild/falcon_cloud"
}

resource "aws_secretsmanager_secret_version" "falcon_client_id" {
  secret_id = aws_secretsmanager_secret.falcon_client_id.id
  secret_string = "${var.falcon_client_id}" 
}

resource "aws_secretsmanager_secret_version" "falcon_client_secret" {
  secret_id = aws_secretsmanager_secret.falcon_client_secret.id
  secret_string = "${var.falcon_client_secret}" 
}

resource "aws_secretsmanager_secret_version" "falcon_cloud" {
  secret_id = aws_secretsmanager_secret.falcon_cloud.id
  secret_string = "${var.falcon_cloud}" 
}
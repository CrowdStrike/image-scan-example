variable "falcon_client_id" {
    description = "Falcon API Client ID with Falcon Container Image and Falcon Container Regostry R+W"
    sensitive = true
}

variable "current_user" {
    description = "The username of the currently authed user"   
}

variable "falcon_client_secret" {
    description = "Falcon API Client Secret assocaited with the Client"
    sensitive = true
}

variable "falcon_cloud" {
    description = "Falcon Cloud Platform Region. This can be idenified when creating API credentials"
}

variable "region" {
    description = "AWS Region where you want the resources to be created"
}

variable "score_threshold" {
    description = "Score threshold for the image-scan-script"
}
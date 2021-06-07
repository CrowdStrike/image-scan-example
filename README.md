# Image-Scan-Example

## CI Pipeline Examples

The pipeline example can use the Dockerfile inside this directory for build purposes.

The `<repo_name>` tag listed in the pipeline examples file will need to be updated with a repo that is accessible via the docker login credentials outlined in the below example specific instructions.

The `FALCON_CLOUD_REGION` variable may also need to be changed to accommodate your Falcon Platform region.  The current setting is for 'us-2'.

These pipeline examples were built to showcase the `docker build` with a subsequent image scan handled by the CrowdStrike Image Scan API.

## Jenkins Pipeline

### Requirements

* The Jenkinsfile is intended to be built as a Jenkins Pipeline Job using 'Pipeline script from SCM' and the default settings.

#### Credentials

* Github

Github credentials will need to be added to Jenkins Global Credential Manager as the ID of 'github'. This should be the username and a personal access token added with all 'repo' and child object permissions. Personal access tokens can be created at https://github.com/settings/tokens.

* ImageRegistry

This example uses DockerHub as the image registry. DockerHub credentials will need to be added to the Jenkins Global Credential Manager with the ID of 'dockerhub'.

* Falcon API

Falcon API credentials will need to be added as two credentials in the Jenkins Global Credential Manager as Kind 'secret text' with the IDs `FALCON_CLIENT_ID` and `FALCON_CLIENT_SECRET`. OAuth2 API client and keys can be created at https://falcon.crowdstrike.com/support/api-clients-and-keys.

## Azure Devops Pipeline

### Requirements

This example repo should be added as an Azure Devops repo with an existing pipeline using the 'azure-pipeline.yml' file located in the base directory.

#### Variable Group and Secret Variables

This pipeline implies a [variable group](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=yaml) named `cs_falcon_vars` with the following secret variables.

`FALCON_CLIENT_SECRET` and `FALCON_CLIENT_ID`

These variables should be secret variables and Allow access to all pipelines disabled.

These variables could also be added directly to the pipeline as secret variables in a similar manner however that is not covered in this example.

#### Service Connection

This also uses an authenticated docker registry [service connection](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) on the project named 'DockerHub'

## Github Actions

### Requirements

#### Secret Variables

* Falcon API

Falcon API credentials will need to be added as two repository secrets with the IDs `FALCON_CLIENT_ID` and `FALCON_CLIENT_SECRET`. OAuth2 API client and keys can be created at https://falcon.crowdstrike.com/support/api-clients-and-keys.

* ImageRegistry

This example uses Docker Login based GitHub action and therefore requires access token based username and password secrets. DockerHub credentials will need to be added to the repository secrets as `DOCKER_USER` and `DOCKER_PASSWORD`.

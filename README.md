# Image-Scan-Example

#### PREREQUISITES: 

All of the CI examples rely on an existing DockerHub repo that you control and have the ability to push the container images being built. This repo should exist before getting started. This repo value will be used in the `CONTAINER_REPO` variable throughout the examples. You will also need a personal access token to be used for the DockerHub password in all pipelines.

## CI Pipeline Examples

The pipeline examples use the Dockerfile inside this repository for build purposes.

The `<repo_name>` tag listed in the pipeline examples file will need to be updated with a repo that is accessible via the docker login credentials outlined in the below example specific instructions.

The `FALCON_CLOUD_REGION` variable may also need to be changed to accommodate your Falcon Platform region.  The current setting is for `us-2`.

These pipeline examples were built to showcase the `docker build` with a subsequent image scan handled by the CrowdStrike Image Scan API.

## Jenkins Pipeline

* The Jenkinsfile is intended to be built as a Jenkins Pipeline Job using `Pipeline script from SCM` and the default settings.

### Credentials

* Github

Github credentials will need to be added to Jenkins Global Credential Manager as the ID of `github`. This should be the username and a personal access token added with all `repo` and child object permissions. Personal access tokens can be created at https://github.com/settings/tokens.

* ImageRegistry

This example uses DockerHub as the image registry. DockerHub credentials will need to be added to the Jenkins Global Credential Manager with the ID of `dockerhub`.

* Falcon API

Falcon API credentials will need to be added as two credentials in the Jenkins Global Credential Manager as Kind 'secret text' with the IDs `FALCON_CLIENT_ID` and `FALCON_CLIENT_SECRET`. OAuth2 API client and keys can be created at https://falcon.crowdstrike.com/support/api-clients-and-keys.

### Jenkins Instructions

1. Fork the repo
2. Modify the `<repo_name>` tag and perhaps the `FALCON_CLOUD_REGION` to suite your needs
3. Log into your Jenkins instance
4. Browse to `Manage Jenkins` -> `Manage Credentials` -> `(global)`
5. Add the required credentials listed [above](https://github.com/mccbryan3/image-scan-example/tree/initial_examples#credentials)
6. Browse back to the main dashboard
7. Select `New Item`
8. Name your new item `Image Scan Pipeline`, select the `Pipeline` option, and select `OK`
9. Scroll to the `Pipeline` heading and change the definition drop down to `Pipeline script from SCM`
10. Change the SCM option to `Git`
11. Paste your forked repo URL into the `Repository URL`
12. Select your credentials for github
13. Select `Save`
14. Use the `Build Now` option to build the pipeline

## Azure Devops Pipeline

### Variable Group and Secret Variables

This pipeline implies a [variable group](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/variable-groups?view=azure-devops&tabs=yaml) named `cs_falcon_vars` with the following secret variables.

`FALCON_CLIENT_SECRET` and `FALCON_CLIENT_ID`

These variables should be secret variables and Allow access to all pipelines disabled.

These variables could also be added directly to the pipeline as secret variables in a similar manner however that is not covered in this example.

### Service Connection

This also uses an authenticated docker registry [service connection](https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml) on the project named 'DockerHub'

### AzureDevops Instructions

This example repo should be added as an Azure Devops repo with an existing pipeline using the 'azure-pipeline.yml' file located in the base directory.

1. Import this github repo into an existing Azure Devops project.
2. Edit `azure-pipeline.yml` and adjust the values for `FALCON_CLOUD_REGION` and `CONTAINER_REPO` to fit your needs.
3. Browse to the Pipelines -> Library menu and add a variable group named 'cs_falcon_vars'.
4. Add the `FALCON_CLIENT_ID` and `FALCON_CLIENT_SECRET` variables and save
5. Create a Service Connection on the Project for 'Docker Registry' and name it 'DockerHub' for the Service Connection Name.
6. Navigate back to Pipelines -> Pipelines and Create a pipeline
7. Use the Azure Repos Git
8. Choose the image-scan-examples.git repo in your Project
9. Choose 'Existing Azure Pipeline YAML file and select the file 'azure-pipeline.yml' in the drop down and press continue
10. Select Run

## Github Actions

### Secret Variables

* Falcon API

Falcon API credentials will need to be added as two repository secrets with the IDs `FALCON_CLIENT_ID` and `FALCON_CLIENT_SECRET`. OAuth2 API client and keys can be created at https://falcon.crowdstrike.com/support/api-clients-and-keys.

* ImageRegistry

This example uses Docker Login based GitHub action and therefore requires access token based username and password secrets. DockerHub credentials will need to be added to the repository secrets as `DOCKER_USER` and `DOCKER_PASSWORD`.

### GitHub Actions Instructions

1. Fork the repo
2. Click on the repo Settings -> Secrets -> New Repository Secret
3. Add Secrets for `FALCON_CLIENT_ID`, `FACLON_CLIENT_SECRET`, `DOCKER_USER` and `DOCKER_PASSWORD`
4. Navigate back to <> Code -> .github/workflows and edit image-scan.yaml
5. Adjust the `FALCON_CLOUD_REGION` and the `CONTAINER_REPO` variables to fit your needs
6. Commit the repo changes

NOTE: GitHub Action workflow is set to run only in the `main` branch.

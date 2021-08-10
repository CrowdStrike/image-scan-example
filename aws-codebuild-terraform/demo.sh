set -e -o pipefail

CURRENT_USER=$(aws iam get-user | jq '.User.UserName' | sed 's/"//g')
AWS_REGION="us-east-2"
FALCON_CLOUD="us-2"
SCORE_THRESHOLD="99999999"

demo_up() {
    # Bring up terraform
    terraform -chdir=aws_terraform init
    terraform -chdir=aws_terraform apply \
        -var current_user=$CURRENT_USER \
        -var region=$AWS_REGION \
        -var falcon_cloud=$FALCON_CLOUD \
        -var score_threshold=$SCORE_THRESHOLD \
        --auto-approve

    # Install git-codecommit-remote
    if [[ ! $(pip3 list | grep git-remote-codecommit) ]]; then
        pip3 install git-remote-codecommit
    fi

    # Use credential-helper for codecommit
    git config --global credential.helper '!aws codecommit credential-helper $@'
    git config --global credential.UseHttpPath true

    # Setup initial repo
    git remote remove origin
    if [[ ! $(git remote -v | awk  '{print $1}' | grep codecommit) ]]; then
        git remote add codecommit codecommit::$AWS_REGION://cs-image-code
    fi
    files=(../buildspec.yml ../Dockerfile ../scripts/gen_hostname.sh)
    for file in ${files[@]}
    do
        echo "" >> $file
        echo "Adding file $file to repo"
        git add $file
    done
    git commit -m "initial commit"

    # Push repo
    CURRENT_BRANCH=$(git branch | grep '\*' | sed 's/\* //g')
    git push --set-upstream codecommit $CURRENT_BRANCH:main

    # Run codebuild
    aws codebuild start-build --project-name cs-image-build
}

demo_down() {
    # Destroy environment
    terraform -chdir=aws_terraform destroy \
        -var current_user=$CURRENT_USER \
        -var region=$AWS_REGION \
        -var falcon_cloud=$FALCON_CLOUD \
        -var score_threshold=$SCORE_THRESHOLD \
        --auto-approve

    # Force delete secrets
    aws secretsmanager delete-secret --secret-id /CodeBuild/falcon_client_id --force-delete-without-recovery
    aws secretsmanager delete-secret --secret-id /CodeBuild/falcon_client_secret --force-delete-without-recovery
    aws secretsmanager delete-secret --secret-id /CodeBuild/falcon_cid --force-delete-without-recovery
    aws secretsmanager delete-secret --secret-id /CodeBuild/falcon_cloud --force-delete-without-recovery

    # Remove remote for codecommit
    if [[ $(git remote -v | grep codecommmit) ]]; then
        git remote remove codecommit
    fi
}

main(){
    STATE=$(echo $1 | tr '[:upper:]' '[:lower:]')
    if [[ $STATE == 'up' ]]
    then
        echo "Bringing up the demo environment"
        demo_up
    elif [[ $STATE == 'down' ]]
    then
        echo "Bringing down the demo environment"
        demo_down
    else
        echo "Please enter valid argument for demo script (i.e. 'demo up' or 'demo down')"
    fi
}

main "$@"
#!/bin/bash

set -euo pipefail

TF_VAR_db_username="${DB_USERNAME:-changeme}"
TF_VAR_db_password="${DB_PASSWORD:-changeme}"

echo "Checking for required environment variables..."
if [ "${TF_VAR_db_username}" = "changeme" ] || [ "${TF_VAR_db_username}" = "changeme" ]
then
    echo "Set the required environment variables before trying to use this script!"
    exit 1
fi
echo "Environment variables set!"

cd ../terraform/
echo "Current directory: $(pwd)"

terraform init
terraform plan

read -p "Do you want to apply? (y/n) " yn

case $yn in 
	y ) echo "Applying...";
        terraform apply -auto-approve;;
	n ) echo "Exiting...";
		exit 0;;
	* ) echo "Invalid response";
		exit 1;;
esac

echo "Finished!"
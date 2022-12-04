#!/bin/bash

set -euo pipefail

echo "Checking for required environment variables..."
if [ -z "${TF_VAR_rds_db_username}" ] || [ -z "${TF_VAR_rds_db_password}" ]
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
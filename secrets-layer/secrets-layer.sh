#!/bin/bash

# This script is used to coordinate the creation of enivronmental variables by using a Golang exectutable
# that is part of the same layer.  In order for this layer to operate, it must have permissiones to 
# retreive data from Secrets Manager.
# 
# Please note, this example uses AWS Lambda environmental varaibles.  This includes the ARN of the Secret
# to use, the region to pull the Secret from, and the ARN for the role to use to retrieve the Secert.
#
# To use this script, make sure that it is wrapped in a ZIP file along with the go-retreive-secret
# Golang executable and added as a Lambda Layer.  Your Lambda must reference this script by setting the
# AWS_LAMBDA_EXEC_WRAPPER environemntal variable to /opt/get-secrets-layer (the name of this shell script)
# and by referencing this layer within it's configuration.

exec ${args[@]}

echo "This is the layer deployed using Github Actions !"
# The name of this script
name=$(basename $0)
echo "Name: ${name}"

# The full path to this script
fullPath=$(dirname $(readlink -f $0))
echo "Fullpath: ${fullpath}"

# The path to the interpreter and all of the originally intended arguments
args=("$@")

# # The name of the secret
# secretArn="${SECRET_ARN}"

# The region to use for the API calls
region="${SECRET_REGION}"
echo "Region ${region}"

# The role to use for API calls
# roleName="${ASSUME_ROLE_ARN}"

# The timeout for API calls
# timeout="${API_TIMEOUT}"

# Create a temp file to hold values to be exported
tempFile=$(mktemp /tmp/${name}.XXXXXXX)
last_cmd=$?

if [[ ${last_cmd} -ne 0 ]]; then
	echo "Failed to create a temp file"
	exit 1
fi

# Get the secret value by calling the Go executable
SECRETS=$(yq e -o=json ./secrets.yaml | jq '.secrets' | jq -c '.[]')
echo "${SECRETS}"
for s in $SECRETS;do
    secretArn=$(echo $s | jq -r -c .valueFrom)
    echo "Secret ARN: ${secretArn}"
    keyval=$(${fullPath}/get-secret -r "${region}" -s ${secretArn})
    # Verify that the last command was successful
    last_cmd=$?
    if [[ ${last_cmd} -ne 0 ]]; then
        echo "Failed to setup environment for Secret ${secretArn}"
        exit 1
    fi
    # # Read the data line by line and export the data as key value pairs 
    # # and environmental variables
    # echo "${values}" | while read -r line; do 
    
    #     # Split the line into a key and value
    ARRY=(${keyval//|/ })

    # Capture the kay value
    key="${ARRY[0]}"

    # Since the key had been captured, no need to keep it in the array
    unset ARRY[0]

    # Join the other parts of the array into a single value.  There is a chance that
    # The split man have broken the data into multiple values.  This will force the
    # data to be rejoined.
    value="${ARRY[@]}"
        
    # Save as an env var to the temp file for later processing
    echo "export ${key}=\"${value}\"" >> ${tempFile}
    # done
done

# Source the temp file to read in the env vars
. ${tempFile}

# Determine if AWS_LAMBDA_EXEC_WRAPPER points to this layer
# This is necessary as the Secret may have not specified a 
# new layer.
# Without checking, the lambda layer may be called again.
layer_name=$(basename ${AWS_LAMBDA_EXEC_WRAPPER})
if [[ "${layer_name}" == "${name}" ]]; then
    echo "No new layer was specified, unsetting AWS_LAMBDA_EXEC_WRAPPER"
    unset AWS_LAMBDA_EXEC_WRAPPER
else
    # Set args to include the new layer
    args=("${AWS_LAMBDA_EXEC_WRAPPER}" "${args[@]}")
fi

# Remove the temp file
rm ${tempFile} > /dev/null 2>&1

# Execute the next step
exec ${args[@]}
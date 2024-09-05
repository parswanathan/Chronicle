#!/bin/bash

echo "Enter the project name:"
echo
read project_name
echo
echo "Enter the project ID:"
read project_id
echo
echo "Enter the Org ID:"
echo
read org_id
echo
# Set the project using gcloud 
echo  "Setting the project in GCP"
echo
gcloud config set project $project_id

# Construct the pool and provider names

pool_id="${project_name}-chronicle-pool"
provider_id="${project_name}-provider-id"

# Create the Workforce pool

echo "Creating Workforce pool...Please wait"
echo
gcloud iam workforce-pools create $pool_id --location=global --organization="$org_id" --description="$pool_id" --display-name="$pool_id" --allowed-services domain=backstory.chronicle.security
echo

# Create the Workforce provider

echo "Creating Workforce provider..."
echo
echo "Enter the XML file path eg: /home/<user_name>/<file_name>"
echo
read file_path
echo
gcloud iam workforce-pools providers create-saml $provider_id \
    --workforce-pool="$pool_id" \
    --location=global \
    --display-name="$provider_id" \
    --description="$provider_id" \
    --idp-metadata-path="$file_path" \
    --attribute-mapping="google.subject=assertion.subject,google.display_name=assertion.attributes.name[0],google.groups=assertion.attributes.groups" 
echo
echo "Workforce pool and provider created successfully!"
echo
echo "Please find the ACS url as below"
echo
echo https://auth.backstory.chronicle.security/signin-callback/locations/global/workforcePools/${pool_id}/providers/${provider_id}
echo
echo "Please find the Entity url as below"
echo
echo https://iam.googleapis.com/locations/global/workforcePools/"$pool_id"/providers/"$provider_id"
echo
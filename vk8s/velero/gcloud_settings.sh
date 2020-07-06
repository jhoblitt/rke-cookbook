#!/usr/bin/env bash

PROJECT_ID=$(gcloud config get-value project)

##Create a service account:
gcloud iam service-accounts create velero \
    --display-name "Velero service account"

##Set the $SERVICE_ACCOUNT_EMAIL variable to match its email value
SERVICE_ACCOUNT_EMAIL=$(gcloud iam service-accounts list \\n  --filter="displayName:Velero service account" \\n  --format 'value(email)')

##Attach policies to give velero the necessary permissions to function
ROLE_PERMISSIONS=(
    compute.disks.get
    compute.disks.create
    compute.disks.createSnapshot
    compute.snapshots.get
    compute.snapshots.create
    compute.snapshots.useReadOnly
    compute.snapshots.delete
    compute.zones.get
)
 
gcloud iam roles create velero.server \
    --project $PROJECT_ID \
    --title "Velero Server" \
    --permissions "$(IFS=","; echo "${ROLE_PERMISSIONS[*]}")"

gcloud projects add-iam-policy-binding $PROJECT_ID \
    --member serviceAccount:$SERVICE_ACCOUNT_EMAIL \
    --role projects/$PROJECT_ID/roles/velero.server

gsutil iam ch serviceAccount:$SERVICE_ACCOUNT_EMAIL:objectAdmin gs://${BUCKET}

##Create a service account key, specifying an output file (credentials-velero) in your local directory
gcloud iam service-accounts keys create credentials-velero \
    --iam-account $SERVICE_ACCOUNT_EMAIL

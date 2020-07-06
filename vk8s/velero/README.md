Velero k8s listener
===================

Important:
----------

In order to perform the following configuration, you must have priviledges and access to GCP console. The following script must only be used once to create the Velero Service account in GCP; if created more than once it will simply fail:

./gcloud_settings.sh


Creating the Bucket
-------------------

To create the bucket for the cluster, make sure to give the permissions to the Service Account to access it after running the script:

BUCKET=vk8s_backup
./velero.sh
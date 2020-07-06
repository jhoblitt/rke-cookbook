#!/usr/bin/env bash

set -xe

velero install \
    --provider gcp \
    --plugins velero/velero-plugin-for-gcp:v1.1.0 \
    --bucket ${BUCKET} \
    --secret-file ./credentials-velero

#!/usr/bin/bash

export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.gcp/project-factory-gcp.json"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export INFOBLOX_USERNAME=$(lpass show infoblox --username)
export INFOBLOX_PASSWORD=$(lpass show infoblox --password)
export INFOBLOX_SERVER=$(lpass show infoblox --url | awk -F/ '{print $3}')


deactivate() {
    unset GOOGLE_APPLICATION_CREDENTIALS
    unset USE_GKE_GCLOUD_AUTH_PLUGIN
    unset INFOBLOX_USERNAME
    unset INFOBLOX_PASSWORD
    unset INFOBLOX_SERVER
}
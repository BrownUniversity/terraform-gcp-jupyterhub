#!/usr/bin/bash

export GOOGLE_APPLICATION_CREDENTIALS="$HOME/.gcp/project-factory-gcp.json"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export INFOBLOX_USERNAME=$(op item get infoblox --field username)
export INFOBLOX_PASSWORD=$(op item get infoblox --field password --reveal)
export INFOBLOX_SERVER=$(op item get infoblox --format json | jq -r '.urls[].href' | awk -F/ '{print $3}')


deactivate() {
    unset GOOGLE_APPLICATION_CREDENTIALS
    unset USE_GKE_GCLOUD_AUTH_PLUGIN
    unset INFOBLOX_USERNAME
    unset INFOBLOX_PASSWORD
    unset INFOBLOX_SERVER
}
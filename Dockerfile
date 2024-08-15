FROM gcr.io/google.com/cloudsdktool/cloud-sdk:488.0.0-alpine

# Putting the version of alpine here.
# Ruby version available to apk can be found here
# https://pkgs.alpinelinux.org/packages?name=ruby-dev&branch=v3.15&repo=&arch=&maintainer=
# This is often lower than what we use for other packages
# NAME="Alpine Linux"
# ID=alpine
# VERSION_ID=3.15.6
# PRETTY_NAME="Alpine Linux v3.15"
# HOME_URL="https://alpinelinux.org/"
# BUG_REPORT_URL="https://bugs.alpinelinux.org/"

# Install new plugin required for gke 1.25
# See https://cloud.google.com/blog/products/containers-kubernetes/kubectl-auth-changes-in-gke
RUN gcloud components install gke-gcloud-auth-plugin 

RUN gcloud components install kubectl

#terraform
ENV TERRAFORM_VERSION=1.9.2
ENV TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
RUN curl -L ${TERRAFORM_URL} -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/bin/terraform\
    && chmod +x /usr/bin/terraform \
    && rm -rf terraform*

ENTRYPOINT ["/bin/bash"]


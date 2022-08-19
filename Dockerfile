FROM gcr.io/google.com/cloudsdktool/cloud-sdk:398.0.0-alpine

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
ENV TERRAFORM_VERSION=1.2.5
ENV TERRAFORM_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
RUN curl -L ${TERRAFORM_URL} -o terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/bin/terraform\
    && chmod +x /usr/bin/terraform \
    && rm -rf terraform*


COPY .ruby-version .ruby-version

# Update and install all of the required packages.
# At the end, remove the apk cache
RUN apk upgrade && \
    apk add --update \
    openssh ca-certificates bash jq \
    curl-dev \
    "ruby-dev=$(cat .ruby-version)" \
    "ruby-full=$(cat .ruby-version)" \
    build-base \
    python3 && \
    rm -rf /var/cache/apk/*


RUN mkdir /usr/app
WORKDIR /usr/app

COPY Gemfile ./
RUN gem install bundler && \
    bundle config set system 'true' && \
    bundle install

ENTRYPOINT ["/bin/bash"]


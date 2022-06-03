FROM gcr.io/google.com/cloudsdktool/cloud-sdk:356.0.0-alpine

#terraform
ENV TERRAFORM_VERSION=1.0.0
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

COPY Gemfile* ./
RUN gem install bundler && \
    bundle config set system 'true' && \
    bundle install

ENTRYPOINT ["/bin/bash"]


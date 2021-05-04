FROM golang:1.15.11-alpine3.13

ENV TERRAFORM_VERSION=0.15.1
ENV TERRAGRUNT_VERSION=0.29.2

RUN apk add --update git bash openssh openssl curl build-base py-pip python3-dev libffi-dev libressl-dev && \
    pip --no-cache-dir install -U pip && \
    pip --no-cache-dir install azure-cli && \
    az aks install-cli && \
    rm -rf /var/cache/apk/*

RUN cd /tmp && \
    curl -Lo terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform.zip && \
    rm terraform.zip && \
    mv terraform /usr/local/bin/terraform && \
    chmod a+x /usr/local/bin/terraform

RUN curl -Lo /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    chmod a+x /usr/local/bin/terragrunt

RUN mkdir -p ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

ENTRYPOINT ["/usr/local/bin/terragrunt"]
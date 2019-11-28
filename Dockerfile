FROM golang:1.13.1-alpine

ENV TERRAFORM_VERSION=0.12.10
ENV TERRAGRUNT_VERSION=0.20.4
ENV CONSUL_VERSION=1.6.2

RUN apk add --update git bash openssh curl build-base py-pip python-dev libffi-dev libressl-dev && \
    pip --no-cache-dir install -U pip && \
    pip --no-cache-dir install azure-cli && \
    az aks install-cli

RUN cd /tmp && \
    curl -Lo terraform.zip https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform.zip && \
    rm terraform.zip && \
    mv terraform /usr/local/bin/terraform && \
    chmod a+x /usr/local/bin/terraform

RUN curl -Lo /usr/local/bin/terragrunt https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 && \
    chmod a+x /usr/local/bin/terragrunt

RUN cd /tmp && \
    curl -Lo consul.zip https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip && \
    unzip consul.zip && \
    rm consul.zip && \
    mv consul /usr/local/bin/consul && \
    chmod a+x /usr/local/bin/consul

RUN mkdir -p ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

ENTRYPOINT ["/usr/local/bin/terragrunt"]

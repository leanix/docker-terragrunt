FROM golang:1.13.1-alpine

ENV TERRAFORM_VERSION=0.12.18
ENV TERRAGRUNT_VERSION=0.21.9
ENV ISTIO_VERSION=1.4.2

RUN apk add --update git bash openssh openssl curl build-base py-pip python-dev libffi-dev libressl-dev && \
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

RUN curl -Lo istioctl.tar.gz https://github.com/istio/istio/releases/download/${ISTIO_VERSION}/istio-${ISTIO_VERSION}-linux.tar.gz && \
    tar -zxvf istioctl.tar.gz && \
    mv istio-${ISTIO_VERSION}/bin/istioctl /usr/local/bin/istioctl && \
    rm -r istioctl.tar.gz istio-${ISTIO_VERSION} && \
    chmod a+x /usr/local/bin/istioctl

RUN mkdir -p ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

ENTRYPOINT ["/usr/local/bin/terragrunt"]

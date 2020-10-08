FROM python:3.9.0-buster

ENV TERRAFORM_VERSION=0.12.18
ENV TERRAGRUNT_VERSION=0.21.9

RUN pip --no-cache-dir install azure-cli && \
    az aks install-cli

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

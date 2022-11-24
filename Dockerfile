FROM ubuntu:20.04

# Use this to tell Github that this image belongs to that repository.
LABEL org.opencontainers.image.source="https://github.com/64j0/bootcamp-sre-elvenworks"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# update the repository sources list
# and install dependencies
RUN apt-get update \
    && apt-get install -y \
    apt-transport-https \
    build-essential \
    ca-certificates \
    curl \
    git \
    gnupg \
    lsb-release \
    python3 \
    unzip \
    && apt-get -y autoclean

# Terraform
ENV TERRAFORM_VERSION="1.3.5"
RUN git clone --depth=1 https://github.com/tfutils/tfenv.git ~/.tfenv && \
    ln -s ~/.tfenv/bin/* /usr/local/bin && \
    tfenv install "${TERRAFORM_VERSION}" && \
    tfenv use "${TERRAFORM_VERSION}"
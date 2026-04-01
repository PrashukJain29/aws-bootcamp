FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Install system dependencies
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends \
        python3-pip \
        python3-venv \
        python3-full \
        default-jre \
        unzip \
        curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Go
RUN curl -sL https://go.dev/dl/go1.22.3.linux-amd64.tar.gz | tar -C /usr/local -xz
ENV PATH=$PATH:/usr/local/go/bin

# Install AWS CLI
RUN cd /tmp \
    && curl -sSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip -q awscliv2.zip \
    && ./aws/install \
    && rm -rf awscliv2.zip aws

# Install TruffleHog
RUN curl -sSfL https://raw.githubusercontent.com/trufflesecurity/trufflehog/main/scripts/install.sh | sh -s -- -b /usr/local/bin

# Install BFG
RUN curl -sL https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar -o /usr/local/lib/bfg.jar \
    && printf '#!/bin/sh\njava -jar /usr/local/lib/bfg.jar "$@"\n' > /usr/local/bin/bfg \
    && chmod +x /usr/local/bin/bfg

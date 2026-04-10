FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    wget \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Install Go
ARG GO_VERSION
RUN wget -q https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz \
    && rm go${GO_VERSION}.linux-amd64.tar.gz

ENV PATH="/usr/local/go/bin:/root/go/bin:${PATH}"

# Install Hugo extended
ARG HUGO_VERSION
RUN wget -q https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz \
    && tar -xzf hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz hugo \
    && mv hugo /usr/local/bin/hugo \
    && rm hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz

# Install Node.js (required by Claude Code)
ARG NODE_VERSION
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install Claude Code CLI
RUN npm install -g @anthropic-ai/claude-code

WORKDIR /workspace

EXPOSE 1313

# Keep container alive; exec in to run hugo or claude
CMD ["hugo", "server", "--bind", "0.0.0.0"]

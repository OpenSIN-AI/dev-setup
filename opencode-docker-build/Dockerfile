FROM alpine AS base

# Installiere notwendige Abhängigkeiten, einschließlich git und curl für gh cli
# Deaktiviert den Laufzeit-Transpiler-Cache in Docker-Containern standardmäßig.
# Bei kurzlebigen Containern ist der Cache nicht nützlich
ARG BUN_RUNTIME_TRANSPILER_CACHE_PATH=0
ENV BUN_RUNTIME_TRANSPILER_CACHE_PATH=${BUN_RUNTIME_TRANSPILER_CACHE_PATH}
RUN apk add --no-cache libgcc libstdc++ ripgrep git curl bash

# Installiere GitHub CLI
RUN apk add --no-cache github-cli

FROM base AS build-amd64
RUN curl -sL "https://github.com/anomalyco/opencode/releases/download/v1.3.17/opencode-linux-x64-baseline-musl.tar.gz" -o /tmp/oc.tar.gz && \
    tar -xzf /tmp/oc.tar.gz -C /tmp/ && \
    mv /tmp/opencode /usr/local/bin/opencode && \
    chmod +x /usr/local/bin/opencode && \
    rm /tmp/oc.tar.gz

FROM base AS build-arm64
RUN curl -sL "https://github.com/anomalyco/opencode/releases/download/v1.3.17/opencode-linux-arm64-musl.tar.gz" -o /tmp/oc.tar.gz && \
    tar -xzf /tmp/oc.tar.gz -C /tmp/ && \
    mv /tmp/opencode /usr/local/bin/opencode && \
    chmod +x /usr/local/bin/opencode && \
    rm /tmp/oc.tar.gz

ARG TARGETARCH
FROM build-${TARGETARCH}
RUN opencode --version
ENTRYPOINT ["opencode"]

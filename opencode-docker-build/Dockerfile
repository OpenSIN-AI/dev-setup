FROM alpine AS base

ARG BUN_RUNTIME_TRANSPILER_CACHE_PATH=0
ENV BUN_RUNTIME_TRANSPILER_CACHE_PATH=${BUN_RUNTIME_TRANSPILER_CACHE_PATH}

RUN apk add --no-cache libgcc libstdc++ ripgrep git curl bash nodejs npm
RUN apk add --no-cache github-cli

FROM base AS build-amd64
COPY dist/opencode-linux-x64-baseline-musl/bin/opencode /usr/local/bin/opencode

FROM base AS build-arm64
COPY dist/opencode-linux-arm64-musl/bin/opencode /usr/local/bin/opencode

ARG TARGETARCH
FROM build-${TARGETARCH}

# Install plugins (oh-my-opencode + antigravity-auth)
RUN mkdir -p /root/.config/opencode && cd /root/.config/opencode && npm init -y
RUN cd /root/.config/opencode && npm install --ignore-scripts oh-my-opencode@3.11.2 opencode-antigravity-auth@1.6.5-beta.0

# Copy opencode.json template (plugins, model, providers, agents)
COPY opencode.json /root/.config/opencode/opencode.json

RUN opencode --version
ENTRYPOINT ["opencode"]

# syntax=docker/dockerfile:experimental

FROM debian:buster-slim AS build

RUN \
  --mount=type=cache,target=/var/cache/apt,id=apt-cache,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,id=apt-lib,sharing=locked \
  set -eux \
  && apt-get update \
  && apt-get install --yes --no-install-suggests --no-install-recommends \
  ca-certificates \
  wget

ARG version=0.3.7

RUN \
  set -eux \
  && pwd \
  && wget -q -O - https://github.com/rust-lang/mdBook/releases/download/v${version}/mdbook-v${version}-x86_64-unknown-linux-gnu.tar.gz | \
     tar xvzf - \
  && chown root: mdbook

RUN \
  set -eux \
  && wget -O /tini https://github.com/krallin/tini/releases/download/v0.19.0/tini-static-amd64 \
  && chown root: /tini \
  && chmod 0755 /tini

FROM debian:buster-slim

RUN \
  set -eux \
  && groupadd -g 1000 mdbook \
  && useradd -u 1000 -g mdbook -m -d /home/mdbook mdbook

COPY --from=build /tini /usr/local/bin/tini
COPY --from=build /mdbook /usr/local/bin/mdbook

USER mdbook

WORKDIR /home/mdbook

EXPOSE 3000
EXPOSE 3001

ENTRYPOINT ["/usr/local/bin/tini", "--", "/usr/local/bin/mdbook"]

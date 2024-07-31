FROM ubuntu:22.04 as build

RUN apt-get update && apt-get install curl -y
RUN curl -L https://github.com/gohugoio/hugo/releases/download/v0.128.2/hugo_extended_0.128.2_linux-amd64.deb -o hugo.deb
RUN apt install ./hugo.deb

COPY . /files
WORKDIR /files

RUN hugo

FROM nginxinc/nginx-unprivileged:1.27.0-alpine-slim

COPY --from=build /files/public /usr/share/nginx/html
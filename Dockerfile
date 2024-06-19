FROM ubuntu:22.04 as build

RUN apt-get update && apt-get install curl -y
RUN curl -L https://github.com/gohugoio/hugo/releases/download/v0.125.7/hugo_extended_0.125.7_linux-amd64.deb -o hugo.deb
RUN apt install ./hugo.deb

COPY . /files

WORKDIR /files

RUN hugo

FROM nginx:1.26.1

COPY --from=build /files/public /usr/share/nginx/html
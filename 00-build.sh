#!/bin/sh

(cd docker/meany && docker build -t kharmajbird/meany:latest .) && \
(cd docker/logstash && docker build -t kharmajbird/logstash:latest .) && \
(cd docker/go-demo && docker build -f Dockerfile.big -t kharmajbird/go-demo:latest .) && \
(cd docker/mongo && docker build -t kharmajbird/mongo:latest .) && \
\
echo docker login && \
docker push kharmajbird/meany:latest && \
docker push kharmajbird/logstash:latest && \
docker push kharmajbird/go-demo:latest && \
docker push kharmajbird/mongo:latest

if [ `docker ps| grep v2_mirror > /dev/null 2>&1` ]; then
  docker run -d \
    --name v2_mirror \
    --restart=always \
    -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io \
    -p 4000:5000 \
    -v $PWD/rdata:/var/lib/registry \
  registry:2.5
fi

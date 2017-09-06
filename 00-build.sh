#!/bin/sh

(cd docker/meany && docker build -t kharmajbird/meany:latest .) && \
(cd docker/logstash && docker build -t kharmajbird/logstash:latest .) && \
(cd docker/go-demo && docker build -f Dockerfile.big -t kharmajbird/go-demo:latest .) && \
\
echo docker login && \
docker push kharmajbird/meany:latest && \
docker push kharmajbird/logstash:latest && \
docker push kharmajbird/go-demo:latest

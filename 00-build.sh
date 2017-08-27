#!/bin/sh

(cd docker/meany && docker build -t kharmajbird/meany:latest .) && \
(cd docker/logstash && docker build -t kharmajbird/logstash:latest .) && \
\
echo docker login && \
docker push kharmajbird/meany:latest && \
docker push kharmajbird/logstash:latest

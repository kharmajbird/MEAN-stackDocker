#!/bin/sh

(cd docker/meany && docker build -t kharmajbird/meany .) && \
(cd docker/logstash && docker build -t kharmajbird/logstash .) && \
\
docker login && \
docker push kharmajbird/meany && \
docker push kharmajbird/logstash

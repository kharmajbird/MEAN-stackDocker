#!/bin/sh

(cd docker/meany && docker build -t meany .) && \
(cd docker/logstash && docker build -t kharmajbird/logstash:2.4 .) && \
\
docker tag meany kharmajbird/meany && \
\
docker login && \
docker push kharmajbird/meany && \
docker push kharmajbird/logstash

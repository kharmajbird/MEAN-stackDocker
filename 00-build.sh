#!/bin/sh

#
# all of these stacks should be in an environment variable in the Makefile
#

(cd docker/meany && docker build -t kharmajbird/meany:latest .) && \
(cd docker/logstash && docker build -t kharmajbird/logstash:latest .) && \
(cd docker/go-demo && docker build -f Dockerfile.big -t kharmajbird/go-demo:latest .)

echo is go-demo failing?
exit

(cd docker/mongo && docker build -t kharmajbird/mongo:latest .) && \
(cd docker/python-demo && docker build -t kharmajbird/python-demo:latest .) && \
\
echo docker login && \
docker push kharmajbird/meany:latest && \
docker push kharmajbird/logstash:latest && \
docker push kharmajbird/go-demo:latest && \
docker push kharmajbird/mongo:latest && \
docker push kharmajbird/python-demo:latest

if [ `docker ps| grep v2_mirror > /dev/null 2>&1` ]; then
  docker run -d \
    --name v2_mirror \
    --restart=always \
    -e REGISTRY_PROXY_REMOTEURL=https://registry-2.docker.io \
    -p 4000:5000 \
    -v $PWD/rdata:/var/lib/registry \
  registry:2.5
fi

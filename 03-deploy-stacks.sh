#!/bin/sh

STACKS="proxy elk meany logspout viz"

## start Docker registry mirror
##mkdir -p rdata
##
##docker run -d --restart=always -p 4000:5000 --name v2_mirror \
##  -v $PWD/rdata:/var/lib/registry \
##  -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io \
##  registry:2.5


for i in ${STACKS}; do
    docker-machine ssh swarm-1 \
        curl -o docker-compose-$i.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/stack/docker-compose-$i.yml
done

for i in ${STACKS}; do
    docker-machine ssh swarm-1 \
        docker stack deploy -c docker-compose-$i.yml $i
done

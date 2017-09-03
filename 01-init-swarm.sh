#!/bin/bash

./dm-swarm.sh

docker-machine ssh swarm-1 \
    docker network create --driver overlay proxy
docker-machine ssh swarm-1 \
    docker network create --driver overlay elk

docker node update --label-add logger=true swarm-6
docker node update --label-add logger=true swarm-7

# start Docker registry mirror
mkdir -p rdata

##docker run -d --restart=always -p 4000:5000 --name v2_mirror \
##  -v $PWD/rdata:/var/lib/registry \
##  -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io \
##  registry:2.5


#docker-machine ssh swarm-1 \
#    curl -o docker-compose-proxy.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/stack/docker-compose-proxy.yml
#
#docker-machine ssh swarm-1 \
#    curl -o docker-compose-elk.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/stack/docker-compose-elk.yml
#
#docker-machine ssh swarm-1 \
#    curl -o docker-compose-mean-demo.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/stack/docker-compose-mean-demo.yml
#
#docker-machine ssh swarm-1 \
#    curl -o docker-compose-logspout.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/stack/docker-compose-logspout.yml
#
#
#docker-machine ssh swarm-1 \
#    docker stack deploy -c docker-compose-proxy.yml proxy
#
#docker-machine ssh swarm-1 \
#    docker stack deploy -c docker-compose-logspout.yml logspout
#
#docker-machine ssh swarm-1 \
#    docker stack deploy -c docker-compose-elk.yml elk
#
#docker-machine ssh swarm-1 \
#    docker stack deploy -c docker-compose-mean-demo.yml meany

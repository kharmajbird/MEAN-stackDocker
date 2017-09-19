#!/bin/sh

STACKS="proxy go-demo elk meany viz"
BRANCH=master
#BRANCH=mongo-replicaset
#BRANCH=registry


## start Docker registry mirror
##mkdir -p rdata
##
##docker run -d --restart=always -p 4000:5000 --name v2_mirror \
##  -v $PWD/rdata:/var/lib/registry \
##  -e REGISTRY_PROXY_REMOTEURL=https://registry-1.docker.io \
##  registry:2.5



if [ "$1" = "killall" ]; then
    for i in ${STACKS}; do
        docker stack rm $i
    done
else
    for i in ${STACKS}; do
        docker-machine ssh swarm-1 \
        curl -o docker-compose-$i.yml \
            https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/$BRANCH/stack/docker-compose-$i.yml

        docker-machine ssh swarm-1 \
            docker stack deploy -c docker-compose-$i.yml $i
    done
fi

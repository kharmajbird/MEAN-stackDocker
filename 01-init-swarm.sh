#!/bin/bash

./dm-swarm.sh

docker-machine ssh swarm-1 \
    docker network create --driver overlay proxy
docker-machine ssh swarm-1 \
    docker network create --driver overlay elk


docker-machine ssh swarm-1 \
    curl -o docker-compose-proxy.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/stack/docker-compose-proxy.yml

docker-machine ssh swarm-1 \
    curl -o docker-compose-elk.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/stack/docker-compose-elk.yml

docker-machine ssh swarm-1 \
    curl -o docker-compose-mean-demo.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/stack/docker-compose-mean-demo.yml

docker-machine ssh swarm-1 \
    curl -o docker-compose-logspout.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/stack/docker-compose-logspout.yml


docker-machine ssh swarm-1 \
    docker stack deploy -c docker-compose-proxy.yml proxy

docker-machine ssh swarm-1 \
    docker stack deploy -c docker-compose-mean-demo.yml meany

docker-machine ssh swarm-1 \
    docker stack deploy -c docker-compose-elk.yml elk

docker-machine ssh swarm-1 \
    docker stack deploy -c docker-compose-logspout.yml logspout

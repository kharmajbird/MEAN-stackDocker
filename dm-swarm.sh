#!/usr/bin/env bash

NODES="1 2 3 4 5 6 7"
LEADERS="1 2 3"
WORKERS="4 5 6 7"

if [[ "$(uname -s )" == "Linux" ]]; then
  export VIRTUALBOX_SHARE_FOLDER="$PWD:$PWD"
fi

for i in ${NODES}; do
    docker-machine create \
        -d virtualbox \
        swarm-$i
done

eval $(docker-machine env swarm-1)

docker swarm init \
  --advertise-addr $(docker-machine ip swarm-1)

TOKEN=$(docker swarm join-token -q manager)

for i in ${WORKERS}; do
    eval $(docker-machine env swarm-$i)

    docker swarm join \
        --token $TOKEN \
        --advertise-addr $(docker-machine ip swarm-$i) \
        $(docker-machine ip swarm-1):2377
done

for i in ${NODES}; do
    eval $(docker-machine env swarm-$i)

    docker node update \
        --label-add env=prod \
        swarm-$i
done

echo ">> The swarm cluster is up and running"

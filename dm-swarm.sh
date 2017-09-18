#!/usr/bin/env bash

NODES=7
MANAGERS="2 3"
WORKERS="4 5 6 7"

if [[ "$(uname -s )" == "Linux" ]]; then
  export VIRTUALBOX_SHARE_FOLDER="$PWD:$PWD"
fi

for i in $(seq "${NODES}"); do
    docker-machine create \
        -d virtualbox \
        swarm-$i
done

eval $(docker-machine env swarm-1)

docker swarm init \
  --advertise-addr $(docker-machine ip swarm-1)

SWARM_MASTER=$(docker info --format "{{.Swarm.NodeAddr}}")
TOKEN_MANAGER=$(docker swarm join-token -q manager)
TOKEN_WORKER=$(docker swarm join-token -q worker)

for i in ${MANAGERS}; do
    eval $(docker-machine env swarm-$i)

    docker swarm join \
        --token $TOKEN_MANAGER \
        --advertise-addr $(docker-machine ip swarm-$i) \
        $(docker-machine ip swarm-1):2377
done

for i in ${WORKERS}; do
    eval $(docker-machine env swarm-$i)

    docker swarm join \
        --token $TOKEN_WORKER \
        --advertise-addr $(docker-machine ip swarm-$i) \
        $(docker-machine ip swarm-1):2377
done

for i in $(seq "${NODES}" ); do
    eval $(docker-machine env swarm-1)

    docker node update \
        --label-add env=prod \
        swarm-$i

    docker rm --force $(docker ps -q --filter "name=registry-${i}")
    docker run -d --privileged --name registry-${i} --hostname=registry-${i} \
        -p ${i}2375:2375 \
        -p ${i}5000:5000 \
        -p ${i}5001:5001 \
        -p ${i}5601:5601 \
    docker --registry-mirror http://${SWARM_MASTER}:4000

    docker --host=localhost:${i}2375 swarm join --token ${TOKEN_WORKER} ${SWARM_MASTER}:2377
done

echo ">> The swarm cluster is up and running"

#!/bin/bash

./dm-swarm.sh

echo; echo; echo
echo "docker-machine ssh swarm-1"
echo "docker network create --driver overlay proxy"

echo "curl -o docker-compose-stack.yml https://raw.githubusercontent.com/vfarcic/docker-flow-proxy/master/docker-compose-stack.yml"

echo "docker stack deploy -c docker-compose-stack.yml proxy"
echo "docker stack deploy -c docker-compose-mean-demo.yml meany"

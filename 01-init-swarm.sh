#!/bin/bash

./dm-swarm.sh

mkdir -p /tmp/docker/logstash

cat << EOF > /tmp/docker/logstash/logstash.conf
input {
  syslog { port => 51415 }
}
EOF


docker-machine ssh swarm-1 \
    docker network create --driver overlay proxy
docker-machine ssh swarm-1 \
    docker network create --driver overlay elk

docker-machine ssh swarm-1 \
    curl -o docker-compose-stack.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/docker-compose-stack.yml
docker-machine ssh swarm-1 \
    curl -o docker-compose-mean-demo.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/docker-compose-mean-demo.yml

docker-machine ssh swarm-1 \
    docker stack deploy -c docker-compose-stack.yml proxy
docker-machine ssh swarm-1 \
    docker stack deploy -c docker-compose-mean-demo.yml meany

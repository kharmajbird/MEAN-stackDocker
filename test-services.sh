#!/bin/bash

eval $(docker-machine env swarm-1)

docker service create \
    --name logger-test \
    --network elk \
    --restart-condition none \
    debian \
    logger -n logstash -P 51415 Hello Planet

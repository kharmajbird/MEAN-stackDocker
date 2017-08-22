#!/usr/bin/env bash


eval $(docker-machine env swarm-1)
SERVICE=$1
DESIRED=$2

wait_for_me() {

    while true; do
        REPLICAS=$(docker service ls | grep ${SERVICE} | awk '{print $3}')
        REPLICAS_NEW=$(docker service ls | grep ${SERVICE} | awk '{print $4}')
        if [[ $REPLICAS == "1/${DESIRED}" || $REPLICAS_NEW == "1/${DESIRED}" ]]; then
            break
        else
            echo "Waiting for the ${SERVICE} service..."
            sleep 5
        fi
    done
}

wait_for_me ${SERVICE} ${DESIRED}

#!/bin/bash

./dm-swarm.sh

mkdir -p /tmp/docker/logstash

cat << EOF > /tmp/docker/logstash/logstash.conf
input {
  syslog { port => 51415 }
}

output {
  elasticsearch {
    hosts => ["elasticsearch:9200"]
  }
  # Remove in production
  stdout {
    codec => rubydebug
  }
}
EOF

docker-machine ssh swarm-1 \
    docker network create --driver overlay proxy
docker-machine ssh swarm-1 \
    docker network create --driver overlay elk

docker-machine ssh swarm-1 \
    curl -o docker-compose-proxy.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/docker-compose-proxy.yml
docker-machine ssh swarm-1 \
    curl -o docker-compose-elk.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/docker-compose-elk.yml
docker-machine ssh swarm-1 \
    curl -o docker-compose-mean-demo.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/docker-compose-mean-demo.yml

docker-machine ssh swarm-1 \
    docker stack deploy -c docker-compose-proxy.yml proxy
docker-machine ssh swarm-1 \
    docker stack deploy -c docker-compose-mean-demo.yml meany
docker-machine ssh swarm-1 \
    docker stack deploy -c docker-compose-elk.yml elk

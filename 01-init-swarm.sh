#!/bin/bash

./dm-swarm.sh

mkdir -p ./docker/logstash

cat << EOF > ./docker/logstash/logstash.conf
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
    curl -o docker-compose-stack.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/docker-compose-stack.yml
docker-machine ssh swarm-1 \
    curl -o docker-compose-mean-demo.yml https://raw.githubusercontent.com/kharmajbird/MEAN-stackDocker/master/docker-compose-mean-demo.yml

docker-machine ssh swarm-1 \
    docker stack deploy -c docker-compose-stack.yml proxy
docker-machine ssh swarm-1 \
    docker stack deploy -c docker-compose-mean-demo.yml meany

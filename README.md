# MEAN-stackDocker

00-init.sh

eval $(docker-machine env swarm-1)

open "http://$(docker-machine ip swarm-1)/demo"

# MEAN-stackDocker

# 2 docker stacks of 2 services spread over 3 nodes
#

./00-build.sh
./01-init-swarm.sh

eval $(docker-machine env swarm-1)

open "http://$(docker-machine ip swarm-1)"

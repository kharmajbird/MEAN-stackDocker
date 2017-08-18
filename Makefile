all:
	./00-build.sh && \
	./01-init-swarm.sh

clean:
	for i in 1 2 3; do docker-machine rm -f swarm-$i; done

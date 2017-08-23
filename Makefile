NODES="1 2 3 4 5 6 7"

all:
	./00-build.sh && \
	./01-init-swarm.sh

swarm:  clean
	./01-init-swarm.sh

wait:
	eval $(docker-machine env swarm-1)

	./02-wait-for-service.sh swarm-listener 1 1
	./02-wait-for-service.sh proxy_proxy 2 2
	./02-wait-for-service.sh meany_main 3 3
	./02-wait-for-service.sh meany_db 1 1
	open "http://$(docker-machine ip swarm-1)"
	./02-wait-for-service.sh elasticsearch 1 1
	./02-wait-for-service.sh kibana 1 1
	./02-wait-for-service.sh logstash 1 1
	./02-wait-for-service.sh logspout 1 1

clean:
	for i in $(NODES); do docker-machine rm -f swarm-$${i}; done

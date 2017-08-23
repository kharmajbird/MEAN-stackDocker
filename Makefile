NODES="1 2 3 4 5 6 7"

all:
	./00-build.sh && \
	swarm

swarm:  clean
	./01-init-swarm.sh
	wait

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
	# FIXME:  for i in $(NODES); do docker-machine rm -f swarm-$${i}; done
	docker-machine rm -f swarm-1
	docker-machine rm -f swarm-2
	docker-machine rm -f swarm-3
	docker-machine rm -f swarm-4
	docker-machine rm -f swarm-5
	docker-machine rm -f swarm-6
	docker-machine rm -f swarm-7

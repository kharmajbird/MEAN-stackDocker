NODES="1 2 3 4 5 6 7"
LEADER_IP=`docker-machine ip swarm-1`

all:
	@echo
	@echo "make build         # build custom logstash and MEAN containers"
	@echo "make swarm         # tear down any existing swarm and wait on its recreation"
	@echo "make redeploy      # spin up a fresh set of docker stacks"
	@echo "make test"         # perform all tests"
	@echo "make test-logstash # sends a 'Hello Planet' message to the elk network, picked up by kibana"
	@echo "make test-nginx    # test if nginx is configured as an external load balancer for the swarm"
	@echo
	@echo "make everyone      # do the whole thang, Gary Oldman style"
	@echo

everyone: build swarm


build:
	./00-build.sh

swarm:  clean init-swarm wait

init-swarm:
	./01-init-swarm.sh && \
	deploy

wait:
	eval $(docker-machine env swarm-1) && \
	\
	./02-wait-for-service.sh swarm-listener 1 1
	./02-wait-for-service.sh proxy_proxy 2 2
	./02-wait-for-service.sh logspout 7 7
	./02-wait-for-service.sh elasticsearch 2 2
	./02-wait-for-service.sh kibana 2 2
	./02-wait-for-service.sh logstash 2 2
	sleep 5
	open http://$(LEADER_IP):5601
	./02-wait-for-service.sh meany_main 3 3
	./02-wait-for-service.sh meany_db 1 1
	open http://$(LEADER_IP)

deploy:
	eval $(docker-machine env swarm-1) && \
	\
	docker stack deploy -c stack/docker-compose-proxy.yml proxy && \
	docker stack deploy -c stack/docker-compose-mean-demo.yml meany && \
	docker stack deploy -c stack/docker-compose-elk.yml elk && \
	docker stack deploy -c stack/docker-compose-logspout.yml logspout && \
	make wait

redeploy:
	eval $(docker-machine env swarm-1) && \
	\
	docker stack rm proxy
	docker stack rm logspout
	docker stack rm elk
	docker stack rm meany
	sleep 20
	make deploy

clean:
	# FIXME:  for i in $(NODES); do docker-machine rm -f swarm-$${i}; done
	docker-machine rm -f swarm-1
	docker-machine rm -f swarm-2
	docker-machine rm -f swarm-3
	docker-machine rm -f swarm-4
	docker-machine rm -f swarm-5
	docker-machine rm -f swarm-6
	docker-machine rm -f swarm-7


test: test-nginx test-logstash

test-nginx:
	@echo
	@echo "If nginx is configured with the provided docker/nginx.conf"
	@echo "and it is running on the same host the swarm nodes are on,"
	@echo "then the MEAN stack, go-demo, and kibana pages will open in your local browser."
	@echo
	@sleep 10

	@open http://localhost/app/kibana
	@open http://localhost

test-logstash:
	docker service rm logger-test

	docker service create \
	--name logger-test \
	--network elk \
	--restart-condition none \
	debian \
	logger -n logstash -P 51415 Hello Planet

	@open "http://localhost/app/kibana#/discover?_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd))&_a=(columns:!(_source),index:'logstash-*',interval:auto,query:(query_string:(analyze_wildcard:!t,query:'*Hello*')),sort:!(_score,desc))"

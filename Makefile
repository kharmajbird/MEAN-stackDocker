
NODES="1 2 3 4 5 6 7"
LEADER_IP=`docker-machine ip swarm-1`

all:
	@echo
	@echo "make build         # build custom logstash and MEAN containers"
	@echo "make swarm         # tear down any existing swarm and wait on its recreation"
	@echo "make deploy        # spin up/update a set of docker stacks"
	@echo "make test"         # perform all tests"
	@echo "make test-logstash # sends a 'Hello Planet' message to the elk network, picked up by kibana"
	@echo "make test-nginx    # test if nginx is configured as an external load balancer for the swarm"
	@echo "make test-viz      # if nginx is the ELB, proxy the visualizer interface to a manager via http://localhost:8080"
	@echo
	@echo "make everyone      # do the whole thang, Gary Oldman style"
	@echo

everyone: build swarm deploy
	@echo
	@echo "To interact with this swarm from a fresh terminal, run 'eval $(docker-machine env swarm-1)'"
	@echo


build:
	./00-build.sh

swarm:  clean
	./01-init-swarm.sh

deploy:
	./02-deploy-stacks.sh && \
	make wait

	sleep 10

	# Angular app
	open http://$(LEADER_IP)

	# Kibana interface
	open http://$(LEADER_IP):5601

wait:
	./03-wait-for-service.sh swarm-listener 1 1
	./03-wait-for-service.sh proxy_proxy 2 2
	./03-wait-for-service.sh viz 2 2
	./03-wait-for-service.sh logspout 7 7
	./03-wait-for-service.sh elasticsearch 1 1
	./03-wait-for-service.sh elasticsearch2 1 1
	./03-wait-for-service.sh kibana 2 2
	./03-wait-for-service.sh logstash 2 2
	./03-wait-for-service.sh meany_main 3 3
	./03-wait-for-service.sh meany_db 1 1

clean:
	# FIXME:  for i in $(NODES); do docker-machine rm -f swarm-$${i}; done
	docker-machine rm -f swarm-1
	docker-machine rm -f swarm-2
	docker-machine rm -f swarm-3
	docker-machine rm -f swarm-4
	docker-machine rm -f swarm-5
	docker-machine rm -f swarm-6
	docker-machine rm -f swarm-7


test: test-nginx test-logstash test-viz

test-nginx:
	@echo
	@echo "If nginx is configured with the provided docker/nginx.conf"
	@echo "and it is running on the same host the swarm nodes are on,"
	@echo "then the MEAN stack, go-demo, and kibana pages will open in your local browser."
	@echo
	@sleep 3

	# Kibana via ELB
	@open http://localhost/app/kibana

	# Angular app via ELB
	@open http://localhost

test-logstash:
	docker service rm logger-test

	docker service create \
	--name logger-test \
	--network elk \
	--restart-condition none \
	debian \
	logger -n logstash -P 51415 Hello Planet

	# query for "Hello" that was logged above
	@open "http://localhost/app/kibana#/discover?_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd))&_a=(columns:!(_source),index:'logstash-*',interval:auto,query:(query_string:(analyze_wildcard:!t,query:'*Hello*')),sort:!(_score,desc))"

test-viz:
	@echo
	@echo "localhost:8080 will only be accessible if nginx is configured on the host"
	@echo "and viz is running as a service outside of the swarm cluster"
	@echo

	# Swarm visualizer
	@open http://localhost:8080

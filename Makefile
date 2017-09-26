
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
	@echo "To interact with this swarm from a fresh terminal, run 'eval \$$(docker-machine env swarm-1)'"
	@echo


build:
	./00-build.sh

swarm:  clean
	./01-init-swarm.sh

deploy:
	./02-deploy-stacks.sh && \
	make wait

	@echo "Waiting for Elasticsearch to catch up...."
	sleep 20

	# Angular app
	open http://$(LEADER_IP)

	# Kibana interface
	open http://$(LEADER_IP):5601

redeploy:
	./02-deploy-stacks.sh killall && \
	make deploy

wait:
	./03-wait-for-service.sh swarm-listener 1 1
	./03-wait-for-service.sh proxy_proxy 5 5
	./03-wait-for-service.sh viz 2 2
	./03-wait-for-service.sh logspout 7 7
	./03-wait-for-service.sh elasticsearch 1 1
	./03-wait-for-service.sh elasticsearch2 1 1
	./03-wait-for-service.sh kibana 2 2
	./03-wait-for-service.sh logstash 2 2
	./03-wait-for-service.sh meany_db 1 1
	./03-wait-for-service.sh meany_main 3 3
	./03-wait-for-service.sh go-demo_go-demo-db-rs1 1 1
	./03-wait-for-service.sh go-demo_go-demo-db-rs2 1 1
	./03-wait-for-service.sh go-demo_go-demo-db-rs3 1 1
	./03-wait-for-service.sh go-demo_main 3 3
	./03-wait-for-service.sh python-demo_main 3 3

clean:
	# FIXME:  for i in $(NODES); do docker-machine rm -f swarm-$${i}; done
	docker-machine rm -f swarm-1
	docker-machine rm -f swarm-2
	docker-machine rm -f swarm-3
	docker-machine rm -f swarm-4
	docker-machine rm -f swarm-5
	docker-machine rm -f swarm-6
	docker-machine rm -f swarm-7


test: test-nginx test-logstash test-viz test-python

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

	# Golang app via ELB
	@open http://localhost/demo/hello

test-logstash:
	docker service create \
	--name logger-test \
	--restart-condition none \
	--network proxy \
	debian \
	logger -n logstash -P 51415 Hello Planet

	sleep 5

	# query for "Planet" that was logged above (you may need to refresh Kibana....)
	#
	@open "http://localhost/app/kibana#/discover?_g=(refreshInterval:(display:Off,pause:!f,value:0),time:(from:now%2Fd,mode:quick,to:now%2Fd))&_a=(columns:!(_source),index:'logstash-*',interval:auto,query:(query_string:(analyze_wildcard:!t,query:'*Planet*')),sort:!(_score,desc))"

	sleep 30
	docker service rm logger-test

test-viz:
	@echo
	@echo "localhost:8080 will only be accessible if nginx is configured on the host"
	@echo "and viz is running as a service outside of the swarm cluster"
	@echo

	# Swarm visualizer
	@open http://localhost:8080

test-python:
	@open http://localhost:8000

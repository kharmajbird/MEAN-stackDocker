# MEAN-stackDocker

This project is a learning exercise that will deploy various apps onto a swarm of 7 Docker nodes--
  3 managers, 4 workers.

*  Python app with three replicas, no database
*  MEAN stack app with three replicas, no mongo replication
*  ELK stack + logspout; elasticsearch database is clustered across two nodes
*  Golang app with three mongo replica sets



The basics of this kind of infrastructure was written about in "The DevOps Toolkit 2.1",
and I am only standing on the shoulders of giants, receiving further light.

Thanks Viktor Farcic!!

What I added is automating the spinup/down of the Docker Swarm cluster, making the ELK
stack database fault-tolerant, and configuring a local nginx proxy to simulate a
production environment.  The Angular, Python, and Golang "hello world" apps are not mine.
Go-demo is entirely Farcic's work, while the other two examples I pieced together after
Googling "how to write an angular/python web app".


WORKSTATION SPECS:
  OS X 16GB RAM, brew & nginx installed; also Virtualbox and Docker v17; maybe others :)


###

origin	https://github.com/vfarcic/books-ms/ (fetch)
origin	https://github.com/vfarcic/cloud-provisioning (fetch)
origin	https://github.com/vfarcic/docker-flow-proxy (fetch)
origin	https://github.com/vfarcic/go-demo (fetch)

https://github.com/vfarcic/docker-flow/blob/master
https://github.com/vfarcic/ms-lifecycle/blob/master
https://github.com/vfarcic/ms-books/blob/master

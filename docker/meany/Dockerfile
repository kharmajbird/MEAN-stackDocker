FROM node
MAINTAINER <jaynetorg@yahoo.com>

ADD starter-node-angular/ /starter-node-angular

WORKDIR /starter-node-angular

RUN npm install
RUN npm install --save modern-syslog
RUN npm install -g bower
RUN bower install --allow-root

CMD [ "node", "server.js" ]

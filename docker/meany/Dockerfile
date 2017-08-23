#docker run -p 8080:8080 -t meany

FROM node
MAINTAINER <jaynetorg@yahoo.com>

WORKDIR /
RUN git clone https://github.com/scotch-io/starter-node-angular.git

WORKDIR /starter-node-angular

RUN npm install
RUN npm install -g bower
RUN bower install --allow-root

CMD [ "node", "server.js" ]

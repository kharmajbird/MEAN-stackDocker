FROM logstash:2.4
MAINTAINER <jaynetorg@yahoo.com>

COPY logstash-proxy.conf /etc/logstash/conf.d/logstash.conf
##COPY logstash.conf /etc/logstash/conf.d/logstash.conf

CMD logstash -f /etc/logstash/conf.d/logstash.conf

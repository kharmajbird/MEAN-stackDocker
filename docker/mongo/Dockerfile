FROM mongo:3.2.10

#ENV SETS="go-demo-db-rs1 go-demo-db-rs2 go-demo-db-rs3"
ENV SETS="go-demo-db-rs1"

COPY init-mongo-rs.sh /init-mongo-rs.sh
RUN chmod +x /init-mongo-rs.sh

#ENTRYPOINT ["/init-mongo-rs.sh"]
CMD /init-mongo-rs.sh

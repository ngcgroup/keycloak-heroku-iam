FROM jboss/keycloak:latest

COPY docker-entrypoint.sh /opt/jboss/tools
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]


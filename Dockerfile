FROM jboss/keycloak:latest

COPY docker-entrypoint.sh /opt/jboss/tools
USER 0

RUN rm /bin/sh && ln -s /bin/bash /bin/sh
USER 1000
ADD application.keystore /opt/jboss/keycloak/standalone/configuration/
ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]


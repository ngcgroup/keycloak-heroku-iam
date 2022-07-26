FROM jboss/keycloak:latest

COPY docker-entrypoint.sh /opt/jboss/tools
COPY themes/bhn-iam /opt/jboss/keycloak/themes/ 
ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]
CMD ["-b", "0.0.0.0"]


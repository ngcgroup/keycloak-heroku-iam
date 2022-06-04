# Deploy Keycloak to Heroku

```bash
./run.sh
```

local
```bash
export DATABASE_URL=jdbc:postgresql://kc-db:5432/keycloak
export DB_PASS=password
export KEYCLOAK_USER=admin
export KEYCLOAK_PASSWORD=admin
docker-compose -f docker-compose.yml up  --build -d

```
```bash
docker exec -it keycloak-heroku-iam_keycloak_1 /bin/bash
keytool -export -alias server -file /tmp/keycloak.crt -keystore /opt/jboss/keycloak/standalone/configuration/application.keystore -storepass password -noprompt
exit
docker cp keycloak-heroku-iam_keycloak_1:/tmp/keycloak.crt .
```

```bash

export PASSWORD=$(heroku config:get TEST_USER_PASSWORD -a bhn-iam)
export USERNAME=$(heroku config:get TEST_USER_USERNAME -a bhn-iam)
export CLIENT_SECRET=$(heroku config:get TEST_CLIENT_SECRET -a bhn-iam)

curl  -k -X  POST https://bhn-iam.herokuapp.com/auth/realms/apistudio2/protocol/openid-connect/token -H 'Content-Type: application/x-www-form-urlencoded'   -H 'cache-control: no-cache'  -d "username=${USERNAME}&password=${PASSWORD}&grant_type=password&client_id=apim-client&client_secret=${CLIENT_SECRET}"


#type=CLIENT_LOGIN_ERROR, realmId=apistudio2, clientId=apim-client, userId=8c4f07d3-8f26-4625-be20-565444fdd7ad, ipAddress=52.55.52.47, error=invalid_request, grant_type=client_credentials, client_auth_method=client-secret, username=service-account-apim-client
output=`curl  -s -k -X  POST https://bhn-iam.herokuapp.com/auth/realms/apistudio2/protocol/openid-connect/token -H 'Content-Type: application/x-www-form-urlencoded'   -H 'cache-control: no-cache'  -d "username=service-account-apim-client&grant_type=client_credentials&client_id=apim-client&client_secret=${CLIENT_SECRET}"`; export SERVICE_ACCESS_TOKEN=$(echo $output | jq '.access_token' --raw-output)

 curl  -s  -X GET -H "Authorization: bearer $SERVICE_ACCESS_TOKEN" https://bhn-iam.herokuapp.com/auth/realms/apistudio2/protocol/openid-connect/userinfo


#https://bhn-iam.herokuapp.com/auth/realms/apistudio2/.well-known/openid-configuration

curl -X POST \
    -d '{ "clientId": "myclient" }' \
    -H "Content-Type:application/json" \
    -H "Authorization: bearer $SERVICE_ACCESS_TOKEN" \
    https://bhn-iam.herokuapp.com/auth/realms/apistudio2/clients-registrations/openid-connect/default | jq .


```
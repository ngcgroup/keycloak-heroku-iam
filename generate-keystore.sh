#!/bin/bash
keytool -genkey -alias server -keyalg RSA -keysize 2048 -validity 3650 -keystore application.keystore -dname "CN=localhost,OU=Technology,O=BHN,L=Pleasanton,S=CA,C=US" -storepass password -keypass password -noprompt -ext SAN=dns:iam.bhn.technology
kubectl create secret generic keycloak-keystore -n iam --from-file application.keystore=application.keystore
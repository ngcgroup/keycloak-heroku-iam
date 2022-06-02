#!/bin/bash

TEMPIFS=$IFS; 
IFS=$'\n'; 
for var in $(heroku config -a bhn-iam | grep -v "Config Vars"); do 
	line=`echo $var | sed -e "s/:[[:space:]+]/=/g" | sed -e "s/[[:space:]+]//g"`; 
	if [[ "$line" =~ ^([a-zA-Z0-9_]*)=(.*)$ ]]; then 
		export ${BASH_REMATCH[1]}=${BASH_REMATCH[2]}; 
	fi; 
done; 
IFS=$TEMPIFS;
docker-compose -f docker-compose.yml up  --build -d

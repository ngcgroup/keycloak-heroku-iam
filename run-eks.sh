#!/bin/bash
set -e
set -x

export app='/arch/bhn/iam/'
app2=$(echo $app | sed 's/\//\\\//g')
TEMPIFS=$IFS; 
IFS=$'\n'; 
envargs=""
profile="arch"
for line in $(aws ssm get-parameters-by-path --profile ${profile} --path $app --query "Parameters[*].{Name:Name,Value:Value}" | jq -r '.[] |[.Name, .Value] | @tsv' | sed "s/${app2}//g" | sed "s/^\///g" |awk -F '\t' '{print $1"="$2}'); do
	if [[ "$line" =~ ^([a-zA-Z0-9_]*)=(.*)$ ]]; then 
		export ${BASH_REMATCH[1]}=${BASH_REMATCH[2]}; 
		#envargs="${envargs} --env=\"${BASH_REMATCH[1]}=${BASH_REMATCH[2]}\""
	fi; 
done; 
IFS=$TEMPIFS;

envsubst < keycloak.yaml | kubectl apply -f -
#echo kubectl apply -f keycloak.yml ${envargs}
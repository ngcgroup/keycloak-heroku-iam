#!/bin/bash
set -e
set -x

POSITIONAL_ARGS=()

while [[ $# -gt 0 ]]; do
  case $1 in
    -p|--profile)
        profile=$2
        shift # past argument
        shift # past value
        ;;  
    -d|--dry-run)
        dry_run=" --dry-run=client -o yaml"
        shift # past argument
        #shift # past value
        ;;         
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
      POSITIONAL_ARGS+=("$1") # save positional arg
      shift # past argument
      ;;
  esac
done
if [ "$profile" == "" ]; then 
	profile="arch"
fi

export app='/arch/bhn/iam/'
app2=$(echo $app | sed 's/\//\\\//g')
TEMPIFS=$IFS; 
IFS=$'\n'; 
envargs=""
rm -rf env-file
echo "## title ##" >> env-file
for line in $(aws ssm get-parameters-by-path --profile ${profile} --path $app --query "Parameters[*].{Name:Name,Value:Value}" | jq -r '.[] |[.Name, .Value] | @tsv' | sed "s/${app2}//g" | sed "s/^\///g" |awk -F '\t' '{print $1"="$2}'); do
	if [[ "$line" =~ ^([a-zA-Z0-9_]*)=(.*)$ ]]; then 
		export ${BASH_REMATCH[1]}=${BASH_REMATCH[2]}; 
    echo ${BASH_REMATCH[1]}=${BASH_REMATCH[2]} >> env-file
		#envargs="${envargs} --env=\"${BASH_REMATCH[1]}=${BASH_REMATCH[2]}\""
	fi; 
done; 
IFS=$TEMPIFS;

#envsubst < keycloak.yaml | kubectl apply -f -
#kubectl apply  -k . --dry-run=client -o yaml
kubectl apply  -k . $dry_run
#echo kubectl apply -f keycloak.yml ${envargs}
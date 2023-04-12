#!/bin/bash
#!/bin/bash
set -e
set -x

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

for i in $SCRIPT_DIR/common/scripts/*;
  do source $i
done

parse_args $@
source_env_from_aws
#envsubst < keycloak.yaml | kubectl apply -f -
#kubectl apply  -k . --dry-run=client -o yaml
kubectl delete configmap env-bindings-cm -n iam
kubectl create configmap env-bindings-cm --from-file=env-file -n iam
kubectl apply -f readme-app-bridge.yaml
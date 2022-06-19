#!/bin/bash
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )";

for i in $SCRIPT_DIR/common/scripts/*;
  do source $i
done

parse_args $@

kubectl scale statefulsets keycloak $dry_run -n iam --replicas=$scale_count
echo "# statefulsets"
kubectl get statefulsets -n iam
echo "# pods"
kubectl get po -n iam

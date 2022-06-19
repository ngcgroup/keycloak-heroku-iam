#!/bin/bash
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
     -s|--scale)
        scale_count=$2
        shift # past argument
        shift # past value
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

kubectl scale statefulsets keycloak $dry_run -n iam --replicas=$scale_count
echo "# statefulsets"
kubectl get statefulsets -n iam
echo "# pods"
kubectl get po -n iam

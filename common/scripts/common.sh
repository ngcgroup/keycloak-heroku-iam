POSITIONAL_ARGS=()
function parse_args() {
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
}

if [ "$profile" == "" ]; then 
	profile="arch"
fi

export app='/arch/bhn/iam/'
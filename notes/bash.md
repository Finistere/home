Shell scripts
-------------

get dir of the script:

```bash
DIR="$(dirname "$(readlink -f "$0")")"
```

### Argumnents

Simple

```bash
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 [arg]"
  exit 1
fi

ARG="$1"
```

Complex

```bash
usage() {
  echo "Example usage: $0 [-v][-a ARG] <positional arg>"
  echo "  -a description"
  echo "  -v flag"
  echo
}

FIRST_ARG=""
FLAG="no"

while getopts ":hc:d:v" opt; do
  case "$opt" in
    a)
      FIRST_ARG="$OPTARG"
      ;;
    v)
      FLAG="yes"
      ;;
    h)
      usage
      exit 0
      ;;
    \?)
      echo "Invalid option: $OPTARG" 1>&2
      usage
      exit 1
      ;;
    :)
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      usage
      exit 1
      ;;
  esac
done
shift $((OPTIND -1))
POSITIONAL_ARG="$1"
```

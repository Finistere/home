Shell scripts
=============

Commands
--------

### xargs

```
xargs -n 1 -P 10 -I {} bash -c 'command $1 $2' _ "first argument" {}
```


Utilities
---------

temporary file:
```
trap 'rm -f "$TMPFILE"' EXIT

TMPFILE=$(mktemp) || exit 1
# or mktemp -d for a directory
```

escaping `'`:

```
echo 'I'\''am back'
```

get dir of the script:

```bash
DIR="$(dirname "$(readlink -f "$0")")"
```

multiline string:
```bash
multi_line="$(cat <<- EOM

EOM
)"

cat <<- EOM >> "file"

EOM
```

### Checks

```bash
[ -f "file" ]
[ -e "any kind of file" ]
[ -L "symlink ]
[ -d "directory ]
[ -x "$(command -v 'command')" ]
[ -n "${VARIABLE:+1} ]
```

Argumnents
----------

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


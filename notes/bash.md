Shell scripts
=============

Links
-----

[Cheatsheet](https://devhints.io/bash)
[CLI args](http://mywiki.wooledge.org/BashFAQ/035)
[Colors](https://misc.flogisoft.com/bash/tip_colors_and_formatting)

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

CLI
---

### ASCII Images

```bash
# compress
gzip --best -c <file> | base64
# show
base64 -d <<<"..." | gunzip
```

### Arguments

Simple

```bash
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 [arg]"
  exit 1
fi

ARG="$1"
```

Full Custom

```bash
#!/bin/sh
# POSIX

# Taken from http://mywiki.wooledge.org/BashFAQ/035

die() {
    printf '%s\n' "$1" >&2
    exit 1
}

# Initialize all the option variables.
# This ensures we are not contaminated by variables from the environment.
file=
verbose=0

while :; do
    case $1 in
        -h|-\?|--help)
            show_help    # Display a usage synopsis.
            exit
            ;;
        -f|--file)       # Takes an option argument; ensure it has been specified.
            if [ "$2" ]; then
                file=$2
                shift
            else
                die 'ERROR: "--file" requires a non-empty option argument.'
            fi
            ;;
        --file=?*)
            file=${1#*=} # Delete everything up to "=" and assign the remainder.
            ;;
        --file=)         # Handle the case of an empty --file=
            die 'ERROR: "--file" requires a non-empty option argument.'
            ;;
        -v|--verbose)
            verbose=$((verbose + 1))  # Each -v adds 1 to verbosity.
            ;;
        --)              # End of all options.
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)               # Default case: No more options, so break out of the loop.
            break
    esac

    shift
done

# if --file was provided, open it for writing, else duplicate stdout
if [ "$file" ]; then
    exec 3> "$file"
else
    exec 3>&1
fi

# Rest of the program here.
# If there are input files (for example) that follow the options, they
# will remain in the "$@" positional parameters.
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


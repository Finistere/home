Shell scripts
-------------

get dir of the script:

```bash
DIR="$(dirname "$(readlink -f "$0")")"
```


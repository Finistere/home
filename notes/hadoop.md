Compute total storage size of a directory:

```bash
hdfs-size () {
  hdfs dfs -du "$0" | sed 's/  */ /g' | cut -d" "  -f1 | paste -sd+ | bc | numfmt --to=iec-i --suffix=B 
}
```

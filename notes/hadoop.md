Compute total storage size of a directory:

```bash
hdfs-size () {
  hdfs dfs -du "$0" | sed 's/  */ /g' | cut -d" "  -f1 | paste -sd+ | bc | numfmt --to=iec-i --suffix=B 
}
```

Parquet-tools

```
git clone git@github.com:apache/parquet-mr.git
mvn -pl :parquet-generator,:parquet-common,:parquet-jackson,:parquet-column,:parquet-encoding,:parquet-hadoop,:parquet-tools clean package -Plocal -DskipTests
```
See https://issues.apache.org/jira/browse/PARQUET-1129


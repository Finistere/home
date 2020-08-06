Hadoop Ecosystem
================


HDFS
----

Compute total storage size of a directory:

```bash
hdfs-size () {
  hdfs dfs -du "$0" | sed 's/  */ /g' | cut -d" "  -f1 | paste -sd+ | bc | numfmt --to=iec-i --suffix=B 
}
```


Parquet
-------

### parquet-tools

#### build locally

Parquet-tools

```
git clone git@github.com:apache/parquet-mr.git
mvn -pl :parquet-generator,:parquet-common,:parquet-jackson,:parquet-column,:parquet-encoding,:parquet-hadoop,:parquet-tools clean package -Plocal -DskipTests
```
See https://issues.apache.org/jira/browse/PARQUET-1129

#### meta

```
> parquet-tools meta <parquet file>

row group 15:                 RC:14890 TS:1434009 OFFSET:345986958
--------------------------------------------------------------------------------
unixtime:                      INT64 UNCOMPRESSED DO:0 FPO:345986958 SZ:8555/8555/1.00 VC:14890 ENC:PLAIN_DICTIONARY,RLE,BIT_PACKED ST:[min: 1560815234, max: 1560815999, num_nulls: 0]
```

Row group:
- RC: row count.
- TS: uncompressed total size. It does take into account the encodings.
- OFFSET: offset of the row group within the file, only way to get the actual compressed row group size (with the offset of the next row group).

Field:
- DO: dictionnary page offset. (?)
- FPO: first data page offset. Offset of the first page within the whole file.
- SZ: `<compressed size>/<uncompressed size>/<ratio>`. Uncompressed size still takes into account encodings.
- VC: value counts (with nulls).
- ENC: Not sure, but probably `<VLE>,<RLE>,<DLE>` (See [Encodings](https://github.com/apache/parquet-format/blob/master/Encodings.md)).
  - VLE: Value encoding
  - RLE: Repetition level encoding
  - DLE: Definition level encoding
- ST: statistics

#### dump

```
> parquet-tools dump -c <column> -d -n <parquet file>
row group 14
--------------------------------------------------------------------------------
dummyid:  INT32 UNCOMPRESSED DO:0 FPO:347383409 SZ:27884/27884/1.00 VC:14890 ENC:BIT_PACKED,RLE,PLAIN_DICTIONARY ST:[min: 6793, max: 1417651, num_nulls: 0]

    zone_id TV=14890 RL=0 DL=1 DS: 1824 DE:PLAIN_DICTIONARY
    ----------------------------------------------------------------------------
    page 0:                         DLE:RLE RLE:BIT_PACKED VLE:PLAIN_DICTIONARY ST:[min: 6793, max: 1417651, num_nulls: 0] SZ:20521 VC:14890
```

Output is very similar to `meta` but it is explicit which encoding is used for what and you can see the actual pages of data.

- TV: total values
- RL: max repetition level
- DL: max definition level
- DS: dictionnary page size
- DE: dictionnary encoding

Size of column is more or less: `sum(page size) + dictionnary size + stats & co.`


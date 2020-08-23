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

### parquet-hadoop

Parameters:

- `parquet.block.size`: row group size, parquet will try its best to not go above that threshold.
- `parquet.page.size`: page size, used for compression.
- `paruqet.dictionnary.page.size`: page size used for the dictionnary. It is always encoded in `PLAIN`, so with v2 writer it can be harmful. i
  I suggest keeping it lower than page size
- `parquet.writer.version`: Use v2 whenever possible, biggest difference is for binary which was encoded with `PLAIN` and now with `DELTA_BYTE_ARRAY`. i
  Even with zstd, it's 11-2% storage gained.
- `parquet.compression`: Use zstd whenever possible.

Parquet hadoop tries to respect the specified row group size by computing regularly the current size of the data of each column. This is calculated through:

```
Size<repetition level> + Size<definition level> + Size<buffered data> + Size<written pages>
```

- For repetition and definition level, RLE is used, so it's quite accurate to what will actually be written.
- buffered data takes into account Parquet's encoding, but not the compression which is only done when writing the page
- written pages have the actual disk size.

So when specifying `parquet.block.size`, `parquet.page.size` has an impact as it dictates how much data will be at maximum in the buffer. Knowing that one can expect
a factor of 2 with the compression, row groups can be a lot smaller than expected with bigger page sizes.


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


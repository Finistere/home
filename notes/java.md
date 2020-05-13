Java
====

Debugging
---------

### Out Of Memory

Create a heapdump:
```
jmap -dump:live,format=b,file=/tmp/dump.hprof <pid>
```

Or automatically
```
-XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=<file-or-dir-path>
```

#### Analyzing Heapdump remotely

```
jhat -port X <dump-file>
```

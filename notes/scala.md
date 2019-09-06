Scala
=====


timeit

```scala
def time[R](block: => R): R = {
    val t0 = System.nanoTime()
    val result = block    // call-by-name
    val t1 = System.nanoTime()
    println("Elapsed time: " + (t1 - t0) + "ns")
    result
}

def timeN[R](n: Int)(block: => R): R = {
    val t0 = System.nanoTime()
    for (_ <- (0 until n)) block
    val t1 = System.nanoTime()
    println("Elapsed time: " + (t1 - t0) + "ns")
    result
}
```

snakify

```scala
/**
  * SomeName -> some_name
  * Taken from https://gist.github.com/sidharthkuruvila/3154845
  */
private def snakify(str: String): String = {
  @tailrec def camel2SnakeRec(s: String, output: String, lastUppercase: Boolean): String =
    if (s.isEmpty) output
    else {
      val c = if (s.head.isUpper && !lastUppercase) "_" + s.head.toLower else s.head.toLower
      camel2SnakeRec(s.tail, output + c, s.head.isUpper && !lastUppercase)
    }
  if (str.forall(_.isUpper)) str.map(_.toLower)
  else {
    camel2SnakeRec(str, "", true)
  }
}
```

local infos:
```
def getListOfFiles(dir: String):List[File] = {
    val d = new File(dir)
    if (d.exists && d.isDirectory) {
      d.listFiles.filter(_.isFile).toList
    } else {
      List[File]()
    }
  }

  def printInfos(): Unit = {
    import scala.collection.JavaConversions._
    val p = System.getProperties
    p.keys.toSeq.asInstanceOf[Seq[String]].sorted.foreach(key => {
      val value = p.get(key).asInstanceOf[String]
      System.out.println(key + ": " + value)
    })
    val cwdir = System.getProperty("user.dir");
    println(getListOfFiles( cwdir).map(_.toString.replace(cwdir, "")).mkString("\n"))
  }
```

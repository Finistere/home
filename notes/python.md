Python
======


Resources
---------

### General

[Python-oop](https://github.com/metaperl/python-oop)
[Courses list](http://bafflednerd.com/learn-python-online/)

### Code training

[Interactive Coding Challenges](https://github.com/donnemartin/interactive-coding-challenges)


Libraries
---------

### Tests

[Coverage](https://github.com/nedbat/coveragepy): test code coverage
[Pylint](https://github.com/PyCQA/pylint): how healthy is a code base ?


### Computing

[Blaze Ecosystem](http://blaze.readthedocs.io/en/latest/index.html) (tools by Continuum Analytics):
- [Dask](http://dask.pydata.org/en/latest/): integrates well with Numpy & Pandas (compared to Spark)
- [Odo](https://github.com/blaze/odo): Migrate data efficiently (ex: DataFrame -> Postgres)

[NetworkX](https://github.com/networkx/networkx): Graph manipulation

[Cachier](https://github.com/shaypal5/cachier): local / cross-machine cache

[SortedContainers](https://github.com/grantjenks/sorted_containers): sorted list, dict, etc..

Performance tips: [PythonSpeed](https://wiki.python.org/moin/PythonSpeed) ([examples](https://wiki.python.org/moin/PythonSpeed/PerformanceTips))


### Network

`socketserver` module to easily create a simple server with sockets.


### Web

#### API

- [API Star](https://github.com/tomchristie/apista): fast and easy (brand new)
- [Hug](https://github.com/timothycrosley/hug): production ready, similar concepts


### Plotting

[Matplotlib](http://matplotlib.org/):
- [Effectively Using Matplotlib](http://pbpython.com/effective-matplotlib.html)
- [Speeding up Matplotlib](http://bastibe.de/2013-05-30-speeding-up-matplotlib.html): Update only parts of the figure. (2013, may be deprecated)
- [Seaborn](http://seaborn.pydata.org/): easier plotting library built on top of Matplotlib

Faster:
- [PyQtGraph](http://www.pyqtgraph.org/): built on Qt
- [VisPy](http://vispy.org/index.html): built on OpenGL (GPU-based)

More Interactive:
- [Bokeh](http://bokeh.pydata.org/en/latest/): need to check, seems awesome
- [Plotly](https://plot.ly/python/)
- [bqplot](https://github.com/bloomberg/bqplot)
- [D3.js](https://github.com/d3/d3) simply using D3 ([tutorial](http://alignedleft.com/tutorials/d3))

ggpy seems to be paused (rewriting it to be closer to R) or dead ?

[Altair](https://altair-viz.github.io/): based on [Vega-lite](https://vega.github.io/vega-lite/), simple syntax.


### Templating

[Jinja2](https://github.com/pallets/jinja)


### Profiling

standard tools: line_profiler, memory_profiler

[SnakeViz](https://jiffyclub.github.io/snakeviz/#snakeviz): Nice visual profiling (CPU)


### Software Engineering

[Siringa](https://github.com/h2non/siringa): minimalist depency injection (new)


### Packaging

[Foster](https://github.com/hugollm/foster) (brand new)

[Flit](https://github.com/takluyver/flit)

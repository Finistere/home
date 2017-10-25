Python
======


Resources
---------

### General

- [Python-oop](https://github.com/metaperl/python-oop)
- [Courses list](http://bafflednerd.com/learn-python-online/)
- [Hitchhiker’s Guide](http://docs.python-guide.org/en/latest/)

### Code training

- [Interactive Coding Challenges](https://github.com/donnemartin/interactive-coding-challenges)
- [100 days of algorithms](https://github.com/coells/100days)

Libraries
---------

### Tests

- [Coverage](https://github.com/nedbat/coveragepy): test code coverage
- [Pylint](https://github.com/PyCQA/pylint): how healthy is a code base ?
- [Faker](https://github.com/joke2k/faker): Generate fake data (like address, names, etc...)

### Computing

Numba & Pythran (integrates numpy ! Hell yeah)

[Blaze Ecosystem](http://blaze.readthedocs.io/en/latest/index.html) (tools by Continuum Analytics):
- [Dask](http://dask.pydata.org/en/latest/): integrates well with Numpy & Pandas (compared to Spark)
- [Odo](https://github.com/blaze/odo): Migrate data efficiently (ex: DataFrame -> Postgres)

[NetworkX](https://github.com/networkx/networkx): Graph manipulation

[Cachier](https://github.com/shaypal5/cachier): local / cross-machine cache

[SortedContainers](https://github.com/grantjenks/sorted_containers): sorted list, dict, etc..

Performance tips: [PythonSpeed](https://wiki.python.org/moin/PythonSpeed) ([examples](https://wiki.python.org/moin/PythonSpeed/PerformanceTips))

[ArrayFire](https://github.com/arrayfire/arrayfire): Use GPU for array computation

[ModernGL](https://github.com/cprogrammer1994/ModernGL): OpenGL with Python (said to be easier than PyOpenGL)

[cppyy](https://pypi.python.org/pypi/cppyy/): bindings to C++ code


### Deep Learning

[MinPy](https://github.com/dmlc/minpy): NumPy interface aboce [MXNet](https://github.com/dmlc/mxnet). (deep learning framework)
Pytorch, Keras, Tensorflow, ...

### Network/Communication

`socketserver` module to easily create a simple server with sockets.

[Delegator](https://github.com/kennethreitz/delegator.py): better API than `subprocess`

### Web

#### API

- [API Star](https://github.com/tomchristie/apista): fast and easy (brand new)
- [Hug](https://github.com/timothycrosley/hug): production ready, similar concepts

Django, Flask, Tornado

#### Async

aiohttp, twisted, tornado

[uvloop](https://github.com/MagicStack/uvloop): faster replacement for asyncio (~go performance !)

### Plotting

[graph gallery](https://python-graph-gallery.com/)

[Matplotlib](http://matplotlib.org/):
- [Effectively Using Matplotlib](http://pbpython.com/effective-matplotlib.html)
- [Speeding up Matplotlib](http://bastibe.de/2013-05-30-speeding-up-matplotlib.html): Update only parts of the figure. (2013, may be deprecated)
- [Seaborn](http://seaborn.pydata.org/): easier plotting library built on top of Matplotlib

Faster:
- [PyQtGraph](http://www.pyqtgraph.org/): built on Qt
- [VisPy](http://vispy.org/index.html): built on OpenGL (better than VTK and Mayavi, but not as mature)

More Interactive:
- [Bokeh](http://bokeh.pydata.org/en/latest/): need to check, seems awesome
- [Plotly](https://plot.ly/python/)
- [bqplot](https://github.com/bloomberg/bqplot)
- [D3.js](https://github.com/d3/d3): simply using D3 ([tutorial](http://alignedleft.com/tutorials/d3))
- [Vaex](https://github.com/maartenbreddels/vaex): for big data (~10^9), designed for exploration

ggpy seems to be paused (rewriting it to be closer to R) or dead ?

[Altair](https://altair-viz.github.io/): based on [Vega-lite](https://vega.github.io/vega-lite/), simple syntax.


### Templating

[Jinja2](https://github.com/pallets/jinja)


### Profiling

standard tools: line_profiler, memory_profiler

[SnakeViz](https://jiffyclub.github.io/snakeviz/#snakeviz): Nice visual profiling (CPU)

[pyprof2calltree](https://github.com/pwaller/pyprof2calltree/): Use Kcachegrind for visualization (with cProfile). It's waaayyy faster than snakeviz for large profiles

### Software Engineering

[Siringa](https://github.com/h2non/siringa): minimalist depency injection (new)

[wrapt](https://github.com/GrahamDumpleton/wrapt): create decorators for instance  methods, function, etc.

[attrs](https://attrs.readthedocs.io/en/stable/index.html): non-boilerplate way to define attributes

[structlog](https://github.com/hynek/structlog): easier logging

### Packaging

[Foster](https://github.com/hugollm/foster) (brand new)

[Flit](https://github.com/takluyver/flit)


### CLI

[Prompt Toolkit](https://github.com/jonathanslenders/python-prompt-toolkit): powerful library to create interactive CLI

[Pygments](http://pygments.org/): Syntax highlighter (to combine with Prompt)

[Click](https://github.com/pallets/click): CLI creator with decorators

[Plac](https://github.com/micheles/plac): CLI creator with annotations (not sure if still active)

[FuzzyFinder](https://github.com/amjith/fuzzyfinder): Vim Ctrl-P like search in a set of words


### DataScience

#### Stats

- [statsmodel](http://www.statsmodels.org/stable/index.html): seems kinda hard to understand ([tutorial](https://tomaugspurger.github.io/modern-7-timeseries.html) ?)
- [tdiget](https://github.com/CamDavidsonPilon/tdigest): effective percentile estimation on streaming data (fast and quite accurate)
- [Welford](https://stackoverflow.com/questions/895929/how-do-i-determine-the-standard-deviation-stddev-of-a-set-of-values): To compute standard deviation on a stream dataset
- [Bounter](https://github.com/RaRe-Technologies/bounter): Efficient counting of elements with low memory foot print (really good approximation)

#### Maths

[SymPy](http://www.sympy.org/en/index.html): Symbolic mathematics



### Test REST API

Insomnia, Portman, paw...


### Processing and parsing

[html5-parser](https://github.com/kovidgoyal/html5-parser): fast html5 parser (in C)

[text parsing](https://tomassetti.me/parsing-in-python/): list of tools to create a parser (with grammar)

[Construct](https://github.com/construct/construct): parser and builder for binary data

[libvips](https://github.com/jcupitt/libvips): fast image processing

[serpy](https://serpy.readthedocs.io/en/latest/index.html): pretty fast object -> json serialization (comparable to pickle speed)

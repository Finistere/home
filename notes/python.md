Python
======


Resources
---------

### General

- [Python-oop](https://github.com/metaperl/python-oop)
- [Awesome Python](https://github.com/vinta/awesome-python)
- [Hitchhiker’s Guide](http://docs.python-guide.org/en/latest)
- [Python 3 Module of the Week](https://pymotw.com/3/index.html)


### Blogs

- https://tomaugspurger.github.io/
- https://wesmckinney.com/archives.html: Founder of `pandas`


Tests & QA
----------

### Coverage

Based on [Coverage](https://github.com/nedbat/coveragepy). Quick start:

```buildoutcfg
[run]
branch = True

[html]
directory = cov_html

[paths]
source =
    src/
    .tox/py*/lib/python*/site-packages/
```

Use [pytest-cov](https://github.com/pytest-dev/pytest-cov) for `pytest` integration. For 
Pycharm :
```bash
pytest --cov=src \
       --cov-report term-missing:skip-covered \
       --cov-report html \
       tests
```

In `tox`, it's usually useful to just skip the coverage report :

```bash
pytest --cov=src --cov-report= tests
```

### QA

- [Black](https://github.com/ambv/black): Code formatting, Warehouse uses it. Worth checking.
- [Flake8](https://gitlab.com/pycqa/flake8): Checks formatting, complexity, etc...
- [Pylint](https://github.com/PyCQA/pylint): More complex than flake8.

Standard ignored rules in `flake8`:

```buildoutcfg
[flake8]
ignore = F401,W503
;        F401: X imported but unused (Pycharm does it better)
;        W503: line break before binary operator (not best pratice)
max-line-length = 88
exclude =
    docs/_build
    docs/_themes
```

### Data Generation

- [Faker](https://github.com/joke2k/faker): Generate fake data (like address, names, etc...)
- [Mimesis](https://github.com/lk-geimfari/mimesis): Same as `Faker` but, supposedly, faster.
- [Hypothesis](https://github.com/HypothesisWorks/hypothesis): Random data generation for tests.

### Others

- [vcrpy](https://github.com/kevin1024/vcrpy): record http requests from pretty much any library.
- clients to test REST API: Postman, Insomnia, Paw...


Profiling
---------

### CPU

Use of [cProfile](https://docs.python.org/3/library/profile.html) for most things:

```bash
python -m cProfile -o /tmp/profile example.py
```
```python
import cProfile
cProfile.run('f()', '/tmp/profile')
```
```
%prun -D -q /tmp/profile foo()
```

The next step is to use [pyprof2calltree](https://github.com/pwaller/pyprof2calltree) to visualize 
data collected with Kcachegrind.

If you need more information on a specific function, use 
[line_profiler](https://github.com/rkern/line_profiler):

```bash
# profiles function with the @profile decorator.
kernprof -l example.py
```
```
%lprun -f function_to_be_profiled foo() 
```

### Memory

[memory_profiler](https://github.com/pythonprofilers/memory_profiler)

```bash
mprof run example.py
mprof plot
```

To track children :

```bash
# Combined memory usage
mprof run --include-children example.py
# Track each child independently
mprof run --multiprocess example.py
```

To profile line by line some functions:

```bash
# profiles function with the @profile decorator.
python -m memory_profiler example.py
```


Computing
---------

### Cython

[cython](https://github.com/cython/cython): Generates optimized C code from a language close to Python.
Useful for speed-ups and interfacing with C/C++ libraries. For dynamic import:
```python
import pyximport; pyximport.install()
```

[Package template with Cython](https://github.com/Technologicat/setup-template-cython)

Cython also integrates [Pythran](https://github.com/serge-sans-paille/pythran) which can be used
to "compile" Numpy to pure C++ which uses among others SIMD instructions, which can lead to 
interesting speedup in some cases, going from 2 up to 16, depending on the targeted CPU architecture 
and the original algorithm

### Numba

[numba](https://github.com/numba/numba): Generates machine code from Python with LLVM (awesome). Can
be used for parallelization, by-passing the GIL, etc... The most important is to always use 
`nopython=True` :

```python
from numba import jit

@jit(nopython=True)
def f(x, y):
    return x + y
```

### GPU

- [ArrayFire](https://github.com/arrayfire/arrayfire): Use GPU for array computation

### Data Structures

- [SortedContainers](https://github.com/grantjenks/sorted_containers): sorted list, dict, etc..
- [tdiget](https://github.com/CamDavidsonPilon/tdigest): effective percentile estimation on streaming data (fast and quite accurate)
- [Welford](https://stackoverflow.com/questions/895929/how-do-i-determine-the-standard-deviation-stddev-of-a-set-of-values): To compute standard deviation on a stream dataset
- [Bounter](https://github.com/RaRe-Technologies/bounter): Efficient counting of elements with low memory foot print (really good approximation)

### Other libraries

- [NetworkX](https://github.com/networkx/networkx): Graph manipulation
- [Blaze Ecosystem](http://blaze.readthedocs.io/en/latest/index.html): Ecosystem build by Continuum  
  Analytics for Anaconda. Unsure how much it is really used and maintained, except for 
  [Dask](http://dask.pydata.org/en/latest/) which is quite nice.


Interfacing with the world
--------------------------

### C

Cython is usually a good option.

- [cppyy](https://pypi.python.org/pypi/cppyy/): bindings to C++ code

### sockets

- `socketserver` module to easily create a simple server with sockets.

### sub-processes

- [Delegator](https://github.com/kennethreitz/delegator.py): better API than `subprocess` and 
  uses [pexpect](https://github.com/pexpect/pexpect) under the hood.

### Web - API

- [Falcon](https://github.com/falconry/falcon): Interesting for pure REST-like APIs.
- [Pyramid](https://github.com/Pylons/pyramid): Seems to be best option for non trivial applications.
- [Sanic](https://github.com/huge-success/sanic): Currently one, if not the only one, async framework 
  which is mature enough to be production-ready.
- [Vibora](https://github.com/vibora-io/vibora): High performance, but alpha stage.

### CLI

- [Prompt Toolkit](https://github.com/jonathanslenders/python-prompt-toolkit): powerful library to 
  create interactive CLI
- [Pygments](http://pygments.org/): Syntax highlighter (to combine with Prompt)
- [Click](https://github.com/pallets/click): CLI creator with decorators
- [FuzzyFinder](https://github.com/amjith/fuzzyfinder): Vim Ctrl-P like search in a set of words


Async
-----

- [aio-libs](https://github.com/aio-libs): Multiple interesting async libraries, in particular 
  [aiohttp](https://github.com/aio-libs/aiohttp).
- [MagicStack](https://github.com/MagicStack): Also interesting packages 
  [uvloop](https://github.com/MagicStack/uvloop) for Python and fast async PostgreSQL communication
  with [asyncpg](https://github.com/MagicStack/asyncpg)
- [aiofiles](https://github.com/Tinche/aiofiles): Reading of files.


Parsing Inputs
--------------

- [html5-parser](https://github.com/kovidgoyal/html5-parser): fast html5 parser (in C)
- [text parsing](https://tomassetti.me/parsing-in-python): Article (2017) on how to create a DSL.
- [libvips](https://github.com/libvips/libvips): fast and efficient image processing.

### Serialization

Protobufs, msgpack, ujson

- [marshmallow](https://github.com/marshmallow-code/marshmallow): probably the current reference 
  regarding JSON serialization.
- [serpy](https://github.com/clarkduvall/serpy): faster object serialization than marshmallow.

### Validation

- [fastjsonschema](https://github.com/horejsek/python-fastjsonschema): fast JSON schema validation.


Generating Outputs
------------------

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


Tools
-----

- [wrapt](https://github.com/GrahamDumpleton/wrapt): easiest way to create universal decorators.
- [attrs](https://attrs.readthedocs.io/en/stable/index.html): non-boilerplate way to define 
  attributes, but never needed it and [dataclasses](https://docs.python.org/3/library/dataclasses.html)
  exists now.
- [structlog](https://github.com/hynek/structlog): easier logging (used by Warehouse)
- [whoosh](https://whoosh.readthedocs.io/en/latest/): Lucene in pure Python.

### Packaging

- [poetry](https://github.com/sdispater/poetry): Interesting project for proper dependency 
  management
- [setuptools_scm](https://github.com/pypa/setuptools_scm/): By far the best way to manage versions.


Random stuff
------------

- [ModernGL](https://github.com/cprogrammer1994/ModernGL): OpenGL with Python (said to be easier than PyOpenGL)
- [SymPy](http://www.sympy.org/en/index.html): Symbolic mathematics

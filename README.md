# cl-gdal
### _Jeremiah LaRocco <jeremiah_larocco@fastmail.com>_

Common Lisp bindings to [GDAL](https://github.com/osgeo/GDAL).

## Getting Started
Fortunately, [cl-autowrap](https://github.com/jl2/cl-autowrap) makes it easy to build the bindings from the source code.

Note: I've made changes to cl-autowrap that aren't yet in the upstream version.  Specifically, I've added a :language parameter to autowrap:c-include to force parsing as a specific language.

### Install GDAL
Install GDAL using [the instructions](https://gdal.org/index.html) on their website.

### Get GDAL Bindings
In your local Lisp project directory, clone the cl-gdal library:

```Bash
git clone git@github.com:jl2/cl-gdal.git
```

### Load GDAL bindings in the REPL
In Slime:

```Common Lisp
(ql:quickload :gdal.examples)
```

The quickload will take several seconds the first time, as autwrap needs to run c2ffi, parse the .spec files, and generate code.  Subsequent loads should be much faster.

Next, run one of the getting started examples:

```Common Lisp
;; TODO: Replace this with a real example
(gdal.examples:getting-started-1)
```


## License
ISC

Copyright (c) 2019 Jeremiah LaRocco <jeremiah_larocco@fastmail.com>



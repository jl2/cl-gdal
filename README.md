# cl-gdal
### _Jeremiah LaRocco <jeremiah_larocco@fastmail.com>_

Common Lisp bindings to the [GDAL](https://github.com/osgeo/GDAL) C API.

At some point I intend to add these bindings to QuickLisp, but until then it must be installed manually.

## Getting Started
This binding uses [cl-autowrap](https://github.com/jl2/cl-autowrap), which makes it easy to build the bindings from the source code.

Note that I've made changes to cl-autowrap that aren't yet in the upstream version.  Specifically, I've added a :language parameter to autowrap:c-include to force parsing as a specific language.  This ensures clang only looks at the C sources instead of C++.

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
;; TODO: Include a GeoTiff in the examples directory to show.
(gdal.examples:getting-started-2 :file-name "some-file.tif")
```


## License
ISC

Copyright (c) 2019 Jeremiah LaRocco <jeremiah_larocco@fastmail.com>



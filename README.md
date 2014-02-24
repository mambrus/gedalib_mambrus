Ambrus gEDA symbol & sub-module library
=======================================

Directory & file structure:
---------------------------

### sym
symbols root directory. Contains either symbols with extension sym or
sub-category symbols.

#### any-dirname
sub-category directory

#### any-filename.sym
A symbol

### sub
sub-module root directory

#### src
Source-files in gschem format. Consist of standard library and
whats in this repo. Library source files has the suffix sch.

#### sym
Structure similar to this root, but with symbols for the sub-modules only.

### tragesym
Sources and references for automatic symbol-generation based on tragesym
script. See 'man tragesym'

To use:
-------

* To use this library, clone it somewhere
* In your ~/.gEDA/gafrc

    (component-library "/complete/path/to/this/gedalib/sym" "AmbrusLib")
    (component-library "/complete/path/to/this/gedalib/sub/sym" "AmbrusSub-mods")
    (source-library "/complete/path/to/this/gedalib/sub/src")

* __Note:__ gEDA does not accept environment variables in search paths.

Hints:
------

### Private sub-modules:

If you want to make your own sub-modules part of your project you can. In
this case you can use relative paths in a local cafrc in the root-directory
of you project. Often the border between a sub-module and another sheet in a
larger collection of drawings is blurred. Therefore my recommendation is to
not compartmentalize between then but to put all in the same directory.

In the local cafrc-file you put two entries for example something like the
following:

(component-library "./localsym" "sub-symbols")
(source-library "./")

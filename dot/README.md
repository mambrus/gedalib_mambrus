DOT files
=========

Template dot-files.

Since configuring gEDA is awkward, here's a few good templates. They go as
copies into your ~/gEDA/ directory. Note that you can't link to any of the
rc files that contain any absolute path (as the paths will likely not be the
same on different machines) like for example:


    (component-library "/complete/path/to/this/gedalib/sym" "A-Lib")
    (component-library "/complete/path/to/this/gedalib/sub/sym" "A-Sub-mods")
    (source-library "/complete/path/to/this/gedalib/sub/src")

This is in particularly true for the gafrc-file. The others are likely OK.

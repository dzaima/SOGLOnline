# SOGLOnline

This repository is the Javascript version of [SOGL](https://github.com/dzaima/SOGL) (that repository is really old though) - [the online interpreter](https://dzaima.github.io/SOGLOnline/) and [the compressor](https://dzaima.github.io/SOGLOnline/compression/index.html) are available on GitHub pages. Explanation of SOGLs characters is [here](https://github.com/dzaima/SOGLOnline/blob/master/compiler/interpreter/data/charDefs.txt) and the interpreters code is found [here](https://github.com/dzaima/SOGLOnline/tree/master/compiler/interpreter). The interpreter mostly still works in Processing Java.

SOGL is a very weakly typed language, meaning that every function will do something for all types of input.  
For example, 05AB1E has a function `u` for uppercasing and `î` for ceiling, but SOGL has one for both - `U`.  
You'll never need to uppercase a number and take the ceiling of a string, will you?  
This makes the language very complex, but makes many more free characters available.

Kolmogorov-complexity and ASCII-art art seem to be SOGLs strong side, but there still are remains of the times this was supposed to be all-purpose.

To make it easier to type SOGL characters, I've made a [SOGL keyboard](https://github.com/dzaima/keyboard) that uses AutoHotkey.
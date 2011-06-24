
#error Please add the libraries libxml2.2.dylib and libz.dylib to the target ___PACKAGENAME___. \
       Comment this warning after you are done.

// Sorry, since I can't add dynamic libraries using Apple templates you'll have to do it yourself.
// Here is how: go to project > target ___PACKAGENAME___ > Build Phases > Link Binary with Libraries 
// and add libxml2.2.dylib and libz.dylib. 

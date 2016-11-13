--- swift/cmake/modules/SwiftSharedCMakeConfig.cmake	2016-11-12 21:51:38.691286000 +0000
+++ swift/cmake/modules/SwiftSharedCMakeConfig.cmake	2016-11-13 00:22:51.439184000 +0000
@@ -113,7 +113,7 @@
 
   # *NOTE* if we want to support separate Clang builds as well as separate LLVM
   # builds, the clang build directory needs to be added here.
-  link_directories("${LLVM_LIBRARY_DIR}")
+  link_directories("/usr/local/lib" "${LLVM_LIBRARY_DIR}")
 
   set(LIT_ARGS_DEFAULT "-sv")
   if(XCODE)

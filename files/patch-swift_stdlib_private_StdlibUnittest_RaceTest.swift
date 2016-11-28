--- swift/stdlib/private/StdlibUnittest/RaceTest.swift.orig	2016-11-15 20:14:55.826149000 +0000
+++ swift/stdlib/private/StdlibUnittest/RaceTest.swift	2016-11-15 19:39:12.595091000 +0000
@@ -44,6 +44,9 @@
 import Glibc
 #endif
 
+#if os(FreeBSD)
+#else
+
 #if _runtime(_ObjC)
 import ObjectiveC
 #else
@@ -602,3 +605,4 @@
   ClosureBasedRaceTest.thread = body
   runRaceTest(ClosureBasedRaceTest.self, trials: trials, threads: threads)
 }
+#endif

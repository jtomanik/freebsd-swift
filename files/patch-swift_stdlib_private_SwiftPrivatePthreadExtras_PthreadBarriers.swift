--- swift/stdlib/private/SwiftPrivatePthreadExtras/PthreadBarriers.swift.orig	2016-11-15 19:26:50.574728000 +0000
+++ swift/stdlib/private/SwiftPrivatePthreadExtras/PthreadBarriers.swift	2016-11-15 19:35:45.959728000 +0000
@@ -16,6 +16,8 @@
 import Glibc
 #endif
 
+#if os(FreeBSD)
+#else
 //
 // Implement pthread barriers.
 //
@@ -129,3 +131,4 @@
     return _stdlib_PTHREAD_BARRIER_SERIAL_THREAD
   }
 }
+#endif

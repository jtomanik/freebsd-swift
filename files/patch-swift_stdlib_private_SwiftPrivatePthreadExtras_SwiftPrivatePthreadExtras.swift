--- swift/stdlib/private/SwiftPrivatePthreadExtras/SwiftPrivatePthreadExtras.swift.orig	2016-11-15 19:36:28.386171000 +0000
+++ swift/stdlib/private/SwiftPrivatePthreadExtras/SwiftPrivatePthreadExtras.swift	2016-11-15 19:37:28.409352000 +0000
@@ -21,6 +21,9 @@
 import Glibc
 #endif
 
+#if os(FreeBSD)
+#else
+
 /// An abstract base class to encapsulate the context necessary to invoke
 /// a block from pthread_create.
 internal class PthreadBlockContext {
@@ -140,3 +143,4 @@
     }
   }
 }
+#endif

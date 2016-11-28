--- swift/stdlib/public/stubs/CommandLine.cpp.orig	2016-11-15 19:45:21.249156000 +0000
+++ swift/stdlib/public/stubs/CommandLine.cpp	2016-11-15 19:46:53.162268000 +0000
@@ -67,7 +67,11 @@
     return _swift_stdlib_ProcessOverrideUnsafeArgv;
   }
 
+#if defined(__FreeBSD__)
+  FILE *cmdline = fopen("/proc/curproc/cmdline", "rb");
+#else
   FILE *cmdline = fopen("/proc/self/cmdline", "rb");
+#endif
   if (!cmdline) {
     swift::fatalError(0,
             "fatal error: Unable to open interface to '/proc/self/cmdline'.\n");

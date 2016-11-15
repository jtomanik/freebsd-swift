--- swift/stdlib/public/Platform/Platform.swift.orig	2016-11-15 19:17:05.896134000 +0000
+++ swift/stdlib/public/Platform/Platform.swift	2016-11-15 19:21:00.439106000 +0000
@@ -124,13 +124,15 @@
 }
 
 public func dprintf(_ fd: Int, _ format: UnsafePointer<Int8>, _ args: CVarArg...) -> Int32 {
-  let va_args = getVaList(args)
-  return vdprintf(Int32(fd), format, va_args)
+  return withVaList(args) { va_args in
+    vdprintf(Int32(fd), format, va_args)
+  }
 }
 
 public func snprintf(ptr: UnsafeMutablePointer<Int8>, _ len: Int, _ format: UnsafePointer<Int8>, _ args: CVarArg...) -> Int32 {
-  let va_args = getVaList(args)
-  return vsnprintf(ptr, len, format, va_args)
+  return withVaList(args) { va_args in
+    return vsnprintf(ptr, len, format, va_args)
+  }
 }
 #endif
 

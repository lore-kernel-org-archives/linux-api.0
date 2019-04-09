From: Florian Weimer <fweimer@redhat.com>
Subject: [PATCH] Linux: Define struct termios2 in <termios.h> under _GNU_SOURCE [BZ #10339]
Date: Tue, 09 Apr 2019 12:47:30 +0200
Message-ID: <875zrnlakd.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <libc-alpha-return-101263-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
To: libc-alpha@sourceware.org
Cc: hpa@zytor.com, adhemerval.zanella@linaro.org, linux-api@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
List-Id: linux-api@vger.kernel.org

struct termios2 is required for setting arbitrary baud rates on serial
ports.  <sys/ioctl.h> and <linux/termios.h> have conflicting
definitions in the existing termios definitions, which means that it
is currently very difficult to use TCGETS2/TCSETS2 and struct termios2
with glibc.  Providing a definition within glibc resolves this problem.

This does not completely address bug 10339, but it at least exposes
the current kernel functionality in this area.

Support for struct termios2 is architecture-specific in the kernel.
Support on alpha was only added in Linux 4.20.  POWER support is
currently missing.  The expectation is that the kernel will eventually
use the generic UAPI definition for struct termios2.

2019-04-09  Florian Weimer  <fweimer@redhat.com>

	[BZ #10339]
	Linux: Define struct termios2 in <termios.h> under _GNU_SOURCE.
	* sysdeps/unix/sysv/linux/Makefile [$(subdir) == termios] (tests):
	Add tst-termios2.
	* sysdeps/unix/sysv/linux/tst-termios2.c: New file.
	* sysdeps/unix/sysv/linux/bits/termios2-struct.h: Likewise.
	* sysdeps/unix/sysv/linux/bits/termios.h [__USE_GNU]: Include it.
	* sysdeps/unix/sysv/linux/alpha/bits/termios2-struct.h: New file.
	* sysdeps/unix/sysv/linux/sparc/bits/termios2-struct.h: Likewise.

diff --git a/NEWS b/NEWS
index b58e2469d4..5e6ecb9c7d 100644
--- a/NEWS
+++ b/NEWS
@@ -18,6 +18,9 @@ Major new features:
 
 * On Linux, the gettid function has been added.
 
+* On Linux, <termios.h> now provides a definition of struct termios2 with
+  the _GNU_SOURCE feature test macro.
+
 * Minguo (Republic of China) calendar support has been added as an
   alternative calendar for the following locales: zh_TW, cmn_TW, hak_TW,
   nan_TW, lzh_TW.
diff --git a/sysdeps/unix/sysv/linux/Makefile b/sysdeps/unix/sysv/linux/Makefile
index 52ac6ad484..4cb5e4f0d2 100644
--- a/sysdeps/unix/sysv/linux/Makefile
+++ b/sysdeps/unix/sysv/linux/Makefile
@@ -156,6 +156,7 @@ endif
 
 ifeq ($(subdir),termios)
 sysdep_headers += termio.h
+tests += tst-termios2
 endif
 
 ifeq ($(subdir),posix)
diff --git a/sysdeps/unix/sysv/linux/alpha/bits/termios2-struct.h b/sysdeps/unix/sysv/linux/alpha/bits/termios2-struct.h
new file mode 100644
index 0000000000..5f09445e23
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/alpha/bits/termios2-struct.h
@@ -0,0 +1,33 @@
+/* struct termios2 definition.  Linux/alpha version.
+   Copyright (C) 2019 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+
+   The GNU C Library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The GNU C Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the GNU C Library.  If not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#ifndef _TERMIOS_H
+# error "Never include <bits/termios2-struct.h> directly; use <termios.h> instead."
+#endif
+
+struct termios2
+{
+  tcflag_t c_iflag;
+  tcflag_t c_oflag;
+  tcflag_t c_cflag;
+  tcflag_t c_lflag;
+  cc_t c_cc[NCCS];
+  cc_t c_line;
+  speed_t c_ispeed;
+  speed_t c_ospeed;
+};
diff --git a/sysdeps/unix/sysv/linux/bits/termios.h b/sysdeps/unix/sysv/linux/bits/termios.h
index 997231cd03..45ac7affdf 100644
--- a/sysdeps/unix/sysv/linux/bits/termios.h
+++ b/sysdeps/unix/sysv/linux/bits/termios.h
@@ -25,6 +25,10 @@ typedef unsigned int	speed_t;
 typedef unsigned int	tcflag_t;
 
 #include <bits/termios-struct.h>
+#ifdef __USE_GNU
+# include <bits/termios2-struct.h>
+#endif
+
 #include <bits/termios-c_cc.h>
 #include <bits/termios-c_iflag.h>
 #include <bits/termios-c_oflag.h>
diff --git a/sysdeps/unix/sysv/linux/bits/termios2-struct.h b/sysdeps/unix/sysv/linux/bits/termios2-struct.h
new file mode 100644
index 0000000000..5a48e45ef3
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/bits/termios2-struct.h
@@ -0,0 +1,33 @@
+/* struct termios2 definition.  Linux/generic version.
+   Copyright (C) 2019 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+
+   The GNU C Library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The GNU C Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the GNU C Library.  If not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#ifndef _TERMIOS_H
+# error "Never include <bits/termios2-struct.h> directly; use <termios.h> instead."
+#endif
+
+struct termios2
+{
+  tcflag_t c_iflag;
+  tcflag_t c_oflag;
+  tcflag_t c_cflag;
+  tcflag_t c_lflag;
+  cc_t c_line;
+  cc_t c_cc[NCCS];
+  speed_t c_ispeed;
+  speed_t c_ospeed;
+};
diff --git a/sysdeps/unix/sysv/linux/sparc/bits/termios2-struct.h b/sysdeps/unix/sysv/linux/sparc/bits/termios2-struct.h
new file mode 100644
index 0000000000..7c889e575c
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/sparc/bits/termios2-struct.h
@@ -0,0 +1,33 @@
+/* struct termios2 definition.  Linux/sparc version.
+   Copyright (C) 2019 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+
+   The GNU C Library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The GNU C Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the GNU C Library.  If not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#ifndef _TERMIOS_H
+# error "Never include <bits/termios2-struct.h> directly; use <termios.h> instead."
+#endif
+
+struct termios2
+{
+  tcflag_t c_iflag;
+  tcflag_t c_oflag;
+  tcflag_t c_cflag;
+  tcflag_t c_lflag;
+  cc_t c_line;
+  cc_t c_cc[NCCS + 2];
+  speed_t c_ispeed;
+  speed_t c_ospeed;
+};
diff --git a/sysdeps/unix/sysv/linux/tst-termios2.c b/sysdeps/unix/sysv/linux/tst-termios2.c
new file mode 100644
index 0000000000..82326a1288
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/tst-termios2.c
@@ -0,0 +1,48 @@
+/* Minimal test of struct termios2 definition.
+   Copyright (C) 2019 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+
+   The GNU C Library is free software; you can redistribute it and/or
+   modify it under the terms of the GNU Lesser General Public
+   License as published by the Free Software Foundation; either
+   version 2.1 of the License, or (at your option) any later version.
+
+   The GNU C Library is distributed in the hope that it will be useful,
+   but WITHOUT ANY WARRANTY; without even the implied warranty of
+   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+   Lesser General Public License for more details.
+
+   You should have received a copy of the GNU Lesser General Public
+   License along with the GNU C Library.  If not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#include <termios.h>
+#include <sys/ioctl.h>
+
+/* This function is never executed, but must be compiled successfully.
+   Accessing serial ports in the test suite is problematic because
+   they likely correspond with low-level system functionality.  */
+void
+not_executed (int fd)
+{
+  /* Avoid a compilation failure if TCGETS2, TCSETS2 are not
+     defined.  */
+#if defined (TCGETS2) && defined (TCSETS2)
+  struct termios2 ti;
+  ioctl (fd, TCGETS2, &ti);
+  ioctl (fd, TCSETS2, &ti);
+#endif
+}
+
+static int
+do_test (void)
+{
+  /* Fail at run time if TCGETS2 or TCSETS2 is not defined.  */
+#if defined (TCGETS2) && defined (TCSETS2)
+  return 0;
+#else
+  return 1;
+#endif
+}
+
+#include <support/test-driver.c>

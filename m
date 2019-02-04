From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH 1/4] glibc: Perform rseq(2) registration at C startup and thread creation (v7)
Date: Mon,  4 Feb 2019 16:28:59 -0500
Message-ID: <20190204212902.31474-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Carlos O'Donell <carlos@redhat.com>
Cc: Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha@sourceware.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Register rseq(2) TLS for each thread (including main), and unregister
for each thread (excluding main). "rseq" stands for Restartable
Sequences.

See the rseq(2) man page proposed here:
  https://lkml.org/lkml/2018/9/19/647

This patch is based on glibc-2.29. The rseq(2) system call was merged
into Linux 4.18.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Carlos O'Donell <carlos@redhat.com>
CC: Florian Weimer <fweimer@redhat.com>
CC: Joseph Myers <joseph@codesourcery.com>
CC: Szabolcs Nagy <szabolcs.nagy@arm.com>
CC: Thomas Gleixner <tglx@linutronix.de>
CC: Ben Maurer <bmaurer@fb.com>
CC: Peter Zijlstra <peterz@infradead.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Boqun Feng <boqun.feng@gmail.com>
CC: Will Deacon <will.deacon@arm.com>
CC: Dave Watson <davejwatson@fb.com>
CC: Paul Turner <pjt@google.com>
CC: Rich Felker <dalias@libc.org>
CC: libc-alpha@sourceware.org
CC: linux-kernel@vger.kernel.org
CC: linux-api@vger.kernel.org
---
Changes since v1:
- Move __rseq_refcount to an extra field at the end of __rseq_abi to
  eliminate one symbol.

  All libraries/programs which try to register rseq (glibc,
  early-adopter applications, early-adopter libraries) should use the
  rseq refcount. It becomes part of the ABI within a user-space
  process, but it's not part of the ABI shared with the kernel per se.

- Restructure how this code is organized so glibc keeps building on
  non-Linux targets.

- Use non-weak symbol for __rseq_abi.

- Move rseq registration/unregistration implementation into its own
  nptl/rseq.c compile unit.

- Move __rseq_abi symbol under GLIBC_2.29.

Changes since v2:
- Move __rseq_refcount to its own symbol, which is less ugly than
  trying to play tricks with the rseq uapi.
- Move __rseq_abi from nptl to csu (C start up), so it can be used
  across glibc, including memory allocator and sched_getcpu(). The
  __rseq_refcount symbol is kept in nptl, because there is no reason
  to use it elsewhere in glibc.

Changes since v3:
- Set __rseq_refcount TLS to 1 on register/set to 0 on unregister
  because glibc is the first/last user.
- Unconditionally register/unregister rseq at thread start/exit, because
  glibc is the first/last user.
- Add missing abilist items.
- Rebase on glibc master commit a502c5294.
- Add NEWS entry.

Changes since v4:
- Do not use "weak" symbols for __rseq_abi and __rseq_refcount. Based on
  "System V Application Binary Interface", weak only affects the link
  editor, not the dynamic linker.
- Install a new sys/rseq.h system header on Linux, which contains the
  RSEQ_SIG definition, __rseq_abi declaration and __rseq_refcount
  declaration. Move those definition/declarations from rseq-internal.h
  to the installed sys/rseq.h header.
- Considering that rseq is only available on Linux, move csu/rseq.c to
  sysdeps/unix/sysv/linux/rseq-sym.c.
- Move __rseq_refcount from nptl/rseq.c to
  sysdeps/unix/sysv/linux/rseq-sym.c, so it is only defined on Linux.
- Move both ABI definitions for __rseq_abi and __rseq_refcount to
  sysdeps/unix/sysv/linux/Versions, so they only appear on Linux.
- Document __rseq_abi and __rseq_refcount volatile.
- Document the RSEQ_SIG signature define.
- Move registration functions from rseq.c to rseq-internal.h static
  inline functions. Introduce empty stubs in misc/rseq-internal.h,
  which can be overridden by architecture code in
  sysdeps/unix/sysv/linux/rseq-internal.h.
- Rename __rseq_register_current_thread and __rseq_unregister_current_thread
  to rseq_register_current_thread and rseq_unregister_current_thread,
  now that those are only visible as internal static inline functions.
- Invoke rseq_register_current_thread() from libc-start.c LIBC_START_MAIN
  rather than nptl init, so applications not linked against
  libpthread.so have rseq registered for their main() thread. Note that
  it is invoked separately for SHARED and !SHARED builds.

Changes since v5:
- Replace __rseq_refcount by __rseq_lib_abi, which contains two
  uint32_t: register_state and refcount. The "register_state" field
  allows inhibiting rseq registration from signal handlers nested on top
  of glibc registration and occuring after rseq unregistration by glibc.
- Introduce enum rseq_register_state, which contains the states allowed
  for the struct rseq_lib_abi register_state field.

Changes since v6:
- Introduce bits/rseq.h to define RSEQ_SIG for each architecture.
  The generic bits/rseq.h does not define RSEQ_SIG, meaning that each
  architecture implementing rseq needs to implement bits/rseq.h.
- Rename enum item RSEQ_REGISTER_NESTED to RSEQ_REGISTER_ONGOING.
- Port to glibc-2.29.
---
 NEWS                                          | 11 +++
 csu/libc-start.c                              | 12 ++-
 misc/Makefile                                 |  3 +-
 misc/rseq-internal.h                          | 34 +++++++
 nptl/pthread_create.c                         |  9 ++
 sysdeps/unix/sysv/linux/Makefile              |  4 +-
 sysdeps/unix/sysv/linux/Versions              |  4 +
 sysdeps/unix/sysv/linux/aarch64/bits/rseq.h   | 24 +++++
 sysdeps/unix/sysv/linux/aarch64/libc.abilist  |  2 +
 sysdeps/unix/sysv/linux/alpha/libc.abilist    |  2 +
 sysdeps/unix/sysv/linux/arm/bits/rseq.h       | 24 +++++
 sysdeps/unix/sysv/linux/arm/libc.abilist      |  2 +
 sysdeps/unix/sysv/linux/bits/rseq.h           | 24 +++++
 sysdeps/unix/sysv/linux/hppa/libc.abilist     |  2 +
 sysdeps/unix/sysv/linux/i386/libc.abilist     |  2 +
 sysdeps/unix/sysv/linux/ia64/libc.abilist     |  2 +
 .../sysv/linux/m68k/coldfire/libc.abilist     |  2 +
 .../unix/sysv/linux/m68k/m680x0/libc.abilist  |  2 +
 .../unix/sysv/linux/microblaze/libc.abilist   |  2 +
 sysdeps/unix/sysv/linux/mips/bits/rseq.h      | 24 +++++
 .../sysv/linux/mips/mips32/fpu/libc.abilist   |  2 +
 .../sysv/linux/mips/mips32/nofpu/libc.abilist |  2 +
 .../sysv/linux/mips/mips64/n32/libc.abilist   |  2 +
 .../sysv/linux/mips/mips64/n64/libc.abilist   |  2 +
 sysdeps/unix/sysv/linux/nios2/libc.abilist    |  2 +
 sysdeps/unix/sysv/linux/powerpc/bits/rseq.h   | 24 +++++
 .../linux/powerpc/powerpc32/fpu/libc.abilist  |  2 +
 .../powerpc/powerpc32/nofpu/libc.abilist      |  2 +
 .../linux/powerpc/powerpc64/be/libc.abilist   |  2 +
 .../linux/powerpc/powerpc64/le/libc.abilist   |  2 +
 .../unix/sysv/linux/riscv/rv64/libc.abilist   |  2 +
 sysdeps/unix/sysv/linux/rseq-internal.h       | 91 +++++++++++++++++++
 sysdeps/unix/sysv/linux/rseq-sym.c            | 54 +++++++++++
 sysdeps/unix/sysv/linux/s390/bits/rseq.h      | 24 +++++
 .../unix/sysv/linux/s390/s390-32/libc.abilist |  2 +
 .../unix/sysv/linux/s390/s390-64/libc.abilist |  2 +
 sysdeps/unix/sysv/linux/sh/libc.abilist       |  2 +
 .../sysv/linux/sparc/sparc32/libc.abilist     |  2 +
 .../sysv/linux/sparc/sparc64/libc.abilist     |  2 +
 sysdeps/unix/sysv/linux/sys/rseq.h            | 65 +++++++++++++
 sysdeps/unix/sysv/linux/x86/bits/rseq.h       | 24 +++++
 .../unix/sysv/linux/x86_64/64/libc.abilist    |  2 +
 .../unix/sysv/linux/x86_64/x32/libc.abilist   |  2 +
 43 files changed, 501 insertions(+), 6 deletions(-)
 create mode 100644 misc/rseq-internal.h
 create mode 100644 sysdeps/unix/sysv/linux/aarch64/bits/rseq.h
 create mode 100644 sysdeps/unix/sysv/linux/arm/bits/rseq.h
 create mode 100644 sysdeps/unix/sysv/linux/bits/rseq.h
 create mode 100644 sysdeps/unix/sysv/linux/mips/bits/rseq.h
 create mode 100644 sysdeps/unix/sysv/linux/powerpc/bits/rseq.h
 create mode 100644 sysdeps/unix/sysv/linux/rseq-internal.h
 create mode 100644 sysdeps/unix/sysv/linux/rseq-sym.c
 create mode 100644 sysdeps/unix/sysv/linux/s390/bits/rseq.h
 create mode 100644 sysdeps/unix/sysv/linux/sys/rseq.h
 create mode 100644 sysdeps/unix/sysv/linux/x86/bits/rseq.h

diff --git a/NEWS b/NEWS
index 912a9bdc0f..0608c60f7d 100644
--- a/NEWS
+++ b/NEWS
@@ -5,6 +5,17 @@ See the end for copying conditions.
 Please send GNU C library bug reports via <https://sourceware.org/bugzilla/>
 using `glibc' in the "product" field.
 
+Version 2.30
+
+Major new features:
+
+* Support for automatically registering threads with the Linux rseq(2)
+  system call has been added. This system call is implemented starting
+  from Linux 4.18. In order to be activated, it requires that glibc is built
+  against kernel headers that include this system call, and that glibc
+  detects availability of that system call at runtime.
+
+
 Version 2.29
 
 Major new features:
diff --git a/csu/libc-start.c b/csu/libc-start.c
index 5d9c3675fa..8680afc0ef 100644
--- a/csu/libc-start.c
+++ b/csu/libc-start.c
@@ -22,6 +22,7 @@
 #include <ldsodefs.h>
 #include <exit-thread.h>
 #include <libc-internal.h>
+#include <rseq-internal.h>
 
 #include <elf/dl-tunables.h>
 
@@ -140,7 +141,10 @@ LIBC_START_MAIN (int (*main) (int, char **, char ** MAIN_AUXVEC_DECL),
 
   __libc_multiple_libcs = &_dl_starting_up && !_dl_starting_up;
 
-#ifndef SHARED
+#ifdef SHARED
+  /* Register rseq ABI to the kernel. */
+  (void) rseq_register_current_thread ();
+#else
   _dl_relocate_static_pie ();
 
   char **ev = &argv[argc + 1];
@@ -218,6 +222,9 @@ LIBC_START_MAIN (int (*main) (int, char **, char ** MAIN_AUXVEC_DECL),
     }
 # endif
 
+  /* Register rseq ABI to the kernel. */
+  (void) rseq_register_current_thread ();
+
   /* Initialize libpthread if linked in.  */
   if (__pthread_initialize_minimal != NULL)
     __pthread_initialize_minimal ();
@@ -230,8 +237,7 @@ LIBC_START_MAIN (int (*main) (int, char **, char ** MAIN_AUXVEC_DECL),
 # else
   __pointer_chk_guard_local = pointer_chk_guard;
 # endif
-
-#endif /* !SHARED  */
+#endif
 
   /* Register the destructor of the dynamic linker if there is any.  */
   if (__glibc_likely (rtld_fini != NULL))
diff --git a/misc/Makefile b/misc/Makefile
index cf0daa1161..0ae1dbaf80 100644
--- a/misc/Makefile
+++ b/misc/Makefile
@@ -36,7 +36,8 @@ headers	:= sys/uio.h bits/uio-ext.h bits/uio_lim.h \
 	   syslog.h sys/syslog.h \
 	   bits/syslog.h bits/syslog-ldbl.h bits/syslog-path.h bits/error.h \
 	   bits/select2.h bits/hwcap.h sys/auxv.h \
-	   sys/sysmacros.h bits/sysmacros.h bits/types/struct_iovec.h
+	   sys/sysmacros.h bits/sysmacros.h bits/types/struct_iovec.h \
+	   rseq-internal.h
 
 routines := brk sbrk sstk ioctl \
 	    readv writev preadv preadv64 pwritev pwritev64 \
diff --git a/misc/rseq-internal.h b/misc/rseq-internal.h
new file mode 100644
index 0000000000..915122e4bf
--- /dev/null
+++ b/misc/rseq-internal.h
@@ -0,0 +1,34 @@
+/* Copyright (C) 2018 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 2018.
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
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#ifndef RSEQ_INTERNAL_H
+#define RSEQ_INTERNAL_H
+
+static inline int
+rseq_register_current_thread (void)
+{
+  return -1;
+}
+
+static inline int
+rseq_unregister_current_thread (void)
+{
+  return -1;
+}
+
+#endif /* rseq-internal.h */
diff --git a/nptl/pthread_create.c b/nptl/pthread_create.c
index 2bd2b10727..90b3419390 100644
--- a/nptl/pthread_create.c
+++ b/nptl/pthread_create.c
@@ -33,6 +33,7 @@
 #include <default-sched.h>
 #include <futex-internal.h>
 #include <tls-setup.h>
+#include <rseq-internal.h>
 #include "libioP.h"
 
 #include <shlib-compat.h>
@@ -378,6 +379,7 @@ __free_tcb (struct pthread *pd)
 START_THREAD_DEFN
 {
   struct pthread *pd = START_THREAD_SELF;
+  bool has_rseq = false;
 
 #if HP_TIMING_AVAIL
   /* Remember the time when the thread was started.  */
@@ -396,6 +398,9 @@ START_THREAD_DEFN
   if (__glibc_unlikely (atomic_exchange_acq (&pd->setxid_futex, 0) == -2))
     futex_wake (&pd->setxid_futex, 1, FUTEX_PRIVATE);
 
+  /* Register rseq TLS to the kernel. */
+  has_rseq = !rseq_register_current_thread ();
+
 #ifdef __NR_set_robust_list
 # ifndef __ASSUME_SET_ROBUST_LIST
   if (__set_robust_list_avail >= 0)
@@ -573,6 +578,10 @@ START_THREAD_DEFN
     }
 #endif
 
+  /* Unregister rseq TLS from kernel. */
+  if (has_rseq && rseq_unregister_current_thread ())
+    abort();
+
   advise_stack_range (pd->stackblock, pd->stackblock_size, (uintptr_t) pd,
 		      pd->guardsize);
 
diff --git a/sysdeps/unix/sysv/linux/Makefile b/sysdeps/unix/sysv/linux/Makefile
index 5f8c2c7c7d..5b541469ec 100644
--- a/sysdeps/unix/sysv/linux/Makefile
+++ b/sysdeps/unix/sysv/linux/Makefile
@@ -1,5 +1,5 @@
 ifeq ($(subdir),csu)
-sysdep_routines += errno-loc
+sysdep_routines += errno-loc rseq-sym
 endif
 
 ifeq ($(subdir),assert)
@@ -48,7 +48,7 @@ sysdep_headers += sys/mount.h sys/acct.h sys/sysctl.h \
 		  bits/termios-c_iflag.h bits/termios-c_oflag.h \
 		  bits/termios-baud.h bits/termios-c_cflag.h \
 		  bits/termios-c_lflag.h bits/termios-tcflow.h \
-		  bits/termios-misc.h
+		  bits/termios-misc.h sys/rseq.h bits/rseq.h
 
 tests += tst-clone tst-clone2 tst-clone3 tst-fanotify tst-personality \
 	 tst-quota tst-sync_file_range tst-sysconf-iov_max tst-ttyname \
diff --git a/sysdeps/unix/sysv/linux/Versions b/sysdeps/unix/sysv/linux/Versions
index f1e12d9c69..ad88c2b7ff 100644
--- a/sysdeps/unix/sysv/linux/Versions
+++ b/sysdeps/unix/sysv/linux/Versions
@@ -174,6 +174,10 @@ libc {
   GLIBC_2.29 {
     getcpu;
   }
+  GLIBC_2.30 {
+    __rseq_abi;
+    __rseq_lib_abi;
+  }
   GLIBC_PRIVATE {
     # functions used in other libraries
     __syscall_rt_sigqueueinfo;
diff --git a/sysdeps/unix/sysv/linux/aarch64/bits/rseq.h b/sysdeps/unix/sysv/linux/aarch64/bits/rseq.h
new file mode 100644
index 0000000000..543bc5388a
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/aarch64/bits/rseq.h
@@ -0,0 +1,24 @@
+/* Copyright (C) 2019 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 2019.
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
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#ifndef _SYS_RSEQ_H
+# error "Never use <bits/rseq.h> directly; include <sys/rseq.h> instead."
+#endif
+
+/* Signature required before each abort handler code.  */
+#define RSEQ_SIG 0xd428bc00	/* BRK #0x45E0.  */
diff --git a/sysdeps/unix/sysv/linux/aarch64/libc.abilist b/sysdeps/unix/sysv/linux/aarch64/libc.abilist
index 9c330f325e..bc937f585d 100644
--- a/sysdeps/unix/sysv/linux/aarch64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/aarch64/libc.abilist
@@ -2141,3 +2141,5 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
diff --git a/sysdeps/unix/sysv/linux/alpha/libc.abilist b/sysdeps/unix/sysv/linux/alpha/libc.abilist
index f630fa4c6f..89cc8b1cfb 100644
--- a/sysdeps/unix/sysv/linux/alpha/libc.abilist
+++ b/sysdeps/unix/sysv/linux/alpha/libc.abilist
@@ -2036,6 +2036,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/arm/bits/rseq.h b/sysdeps/unix/sysv/linux/arm/bits/rseq.h
new file mode 100644
index 0000000000..19d3755837
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/arm/bits/rseq.h
@@ -0,0 +1,24 @@
+/* Copyright (C) 2019 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 2019.
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
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#ifndef _SYS_RSEQ_H
+# error "Never use <bits/rseq.h> directly; include <sys/rseq.h> instead."
+#endif
+
+/* Signature required before each abort handler code.  */
+#define RSEQ_SIG 0x53053053
diff --git a/sysdeps/unix/sysv/linux/arm/libc.abilist b/sysdeps/unix/sysv/linux/arm/libc.abilist
index b96f45590f..e5055f2d4e 100644
--- a/sysdeps/unix/sysv/linux/arm/libc.abilist
+++ b/sysdeps/unix/sysv/linux/arm/libc.abilist
@@ -126,6 +126,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.4 _Exit F
 GLIBC_2.4 _IO_2_1_stderr_ D 0xa0
 GLIBC_2.4 _IO_2_1_stdin_ D 0xa0
diff --git a/sysdeps/unix/sysv/linux/bits/rseq.h b/sysdeps/unix/sysv/linux/bits/rseq.h
new file mode 100644
index 0000000000..d60f02cfeb
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/bits/rseq.h
@@ -0,0 +1,24 @@
+/* Copyright (C) 2019 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 2019.
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
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#ifndef _SYS_RSEQ_H
+# error "Never use <bits/rseq.h> directly; include <sys/rseq.h> instead."
+#endif
+
+/* Each architecture supporting rseq should define RSEQ_SIG as a 32-bit
+   signature inserted before each rseq abort label in the code section.  */
diff --git a/sysdeps/unix/sysv/linux/hppa/libc.abilist b/sysdeps/unix/sysv/linux/hppa/libc.abilist
index 088a8ee369..546d073cdb 100644
--- a/sysdeps/unix/sysv/linux/hppa/libc.abilist
+++ b/sysdeps/unix/sysv/linux/hppa/libc.abilist
@@ -1883,6 +1883,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/i386/libc.abilist b/sysdeps/unix/sysv/linux/i386/libc.abilist
index f7ff2c57b9..ac1de6e4b3 100644
--- a/sysdeps/unix/sysv/linux/i386/libc.abilist
+++ b/sysdeps/unix/sysv/linux/i386/libc.abilist
@@ -2048,6 +2048,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/ia64/libc.abilist b/sysdeps/unix/sysv/linux/ia64/libc.abilist
index becd8b1033..cc3445b958 100644
--- a/sysdeps/unix/sysv/linux/ia64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/ia64/libc.abilist
@@ -1917,6 +1917,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/m68k/coldfire/libc.abilist b/sysdeps/unix/sysv/linux/m68k/coldfire/libc.abilist
index 74e42a5209..f7e28bd5a0 100644
--- a/sysdeps/unix/sysv/linux/m68k/coldfire/libc.abilist
+++ b/sysdeps/unix/sysv/linux/m68k/coldfire/libc.abilist
@@ -127,6 +127,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.4 _Exit F
 GLIBC_2.4 _IO_2_1_stderr_ D 0x98
 GLIBC_2.4 _IO_2_1_stdin_ D 0x98
diff --git a/sysdeps/unix/sysv/linux/m68k/m680x0/libc.abilist b/sysdeps/unix/sysv/linux/m68k/m680x0/libc.abilist
index 4af5a74e8a..b8f00f6111 100644
--- a/sysdeps/unix/sysv/linux/m68k/m680x0/libc.abilist
+++ b/sysdeps/unix/sysv/linux/m68k/m680x0/libc.abilist
@@ -1992,6 +1992,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/microblaze/libc.abilist b/sysdeps/unix/sysv/linux/microblaze/libc.abilist
index ccef673fd2..19f191434f 100644
--- a/sysdeps/unix/sysv/linux/microblaze/libc.abilist
+++ b/sysdeps/unix/sysv/linux/microblaze/libc.abilist
@@ -2133,3 +2133,5 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
diff --git a/sysdeps/unix/sysv/linux/mips/bits/rseq.h b/sysdeps/unix/sysv/linux/mips/bits/rseq.h
new file mode 100644
index 0000000000..19d3755837
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/mips/bits/rseq.h
@@ -0,0 +1,24 @@
+/* Copyright (C) 2019 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 2019.
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
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#ifndef _SYS_RSEQ_H
+# error "Never use <bits/rseq.h> directly; include <sys/rseq.h> instead."
+#endif
+
+/* Signature required before each abort handler code.  */
+#define RSEQ_SIG 0x53053053
diff --git a/sysdeps/unix/sysv/linux/mips/mips32/fpu/libc.abilist b/sysdeps/unix/sysv/linux/mips/mips32/fpu/libc.abilist
index 1054bb599e..fe43507f55 100644
--- a/sysdeps/unix/sysv/linux/mips/mips32/fpu/libc.abilist
+++ b/sysdeps/unix/sysv/linux/mips/mips32/fpu/libc.abilist
@@ -1970,6 +1970,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/mips/mips32/nofpu/libc.abilist b/sysdeps/unix/sysv/linux/mips/mips32/nofpu/libc.abilist
index 4f5b5ffebf..b247c6ea9b 100644
--- a/sysdeps/unix/sysv/linux/mips/mips32/nofpu/libc.abilist
+++ b/sysdeps/unix/sysv/linux/mips/mips32/nofpu/libc.abilist
@@ -1968,6 +1968,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/mips/mips64/n32/libc.abilist b/sysdeps/unix/sysv/linux/mips/mips64/n32/libc.abilist
index 943aee58d4..5339ca52b6 100644
--- a/sysdeps/unix/sysv/linux/mips/mips64/n32/libc.abilist
+++ b/sysdeps/unix/sysv/linux/mips/mips64/n32/libc.abilist
@@ -1976,6 +1976,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/mips/mips64/n64/libc.abilist b/sysdeps/unix/sysv/linux/mips/mips64/n64/libc.abilist
index 17a5d17ef9..11f24eb440 100644
--- a/sysdeps/unix/sysv/linux/mips/mips64/n64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/mips/mips64/n64/libc.abilist
@@ -1971,6 +1971,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/nios2/libc.abilist b/sysdeps/unix/sysv/linux/nios2/libc.abilist
index 4d62a540fd..fd223bfc44 100644
--- a/sysdeps/unix/sysv/linux/nios2/libc.abilist
+++ b/sysdeps/unix/sysv/linux/nios2/libc.abilist
@@ -2174,3 +2174,5 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
diff --git a/sysdeps/unix/sysv/linux/powerpc/bits/rseq.h b/sysdeps/unix/sysv/linux/powerpc/bits/rseq.h
new file mode 100644
index 0000000000..19d3755837
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/powerpc/bits/rseq.h
@@ -0,0 +1,24 @@
+/* Copyright (C) 2019 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 2019.
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
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#ifndef _SYS_RSEQ_H
+# error "Never use <bits/rseq.h> directly; include <sys/rseq.h> instead."
+#endif
+
+/* Signature required before each abort handler code.  */
+#define RSEQ_SIG 0x53053053
diff --git a/sysdeps/unix/sysv/linux/powerpc/powerpc32/fpu/libc.abilist b/sysdeps/unix/sysv/linux/powerpc/powerpc32/fpu/libc.abilist
index ecc2d6fa13..cc53178e81 100644
--- a/sysdeps/unix/sysv/linux/powerpc/powerpc32/fpu/libc.abilist
+++ b/sysdeps/unix/sysv/linux/powerpc/powerpc32/fpu/libc.abilist
@@ -1996,6 +1996,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/powerpc/powerpc32/nofpu/libc.abilist b/sysdeps/unix/sysv/linux/powerpc/powerpc32/nofpu/libc.abilist
index f5830f9c33..2de3134bc7 100644
--- a/sysdeps/unix/sysv/linux/powerpc/powerpc32/nofpu/libc.abilist
+++ b/sysdeps/unix/sysv/linux/powerpc/powerpc32/nofpu/libc.abilist
@@ -2000,6 +2000,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/powerpc/powerpc64/be/libc.abilist b/sysdeps/unix/sysv/linux/powerpc/powerpc64/be/libc.abilist
index 633d8f4792..aae3def700 100644
--- a/sysdeps/unix/sysv/linux/powerpc/powerpc64/be/libc.abilist
+++ b/sysdeps/unix/sysv/linux/powerpc/powerpc64/be/libc.abilist
@@ -126,6 +126,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 _Exit F
 GLIBC_2.3 _IO_2_1_stderr_ D 0xe0
 GLIBC_2.3 _IO_2_1_stdin_ D 0xe0
diff --git a/sysdeps/unix/sysv/linux/powerpc/powerpc64/le/libc.abilist b/sysdeps/unix/sysv/linux/powerpc/powerpc64/le/libc.abilist
index 2c712636ef..8d582a3a9b 100644
--- a/sysdeps/unix/sysv/linux/powerpc/powerpc64/le/libc.abilist
+++ b/sysdeps/unix/sysv/linux/powerpc/powerpc64/le/libc.abilist
@@ -2231,3 +2231,5 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
diff --git a/sysdeps/unix/sysv/linux/riscv/rv64/libc.abilist b/sysdeps/unix/sysv/linux/riscv/rv64/libc.abilist
index 195bc8b2cf..155953f6cf 100644
--- a/sysdeps/unix/sysv/linux/riscv/rv64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/riscv/rv64/libc.abilist
@@ -2103,3 +2103,5 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
diff --git a/sysdeps/unix/sysv/linux/rseq-internal.h b/sysdeps/unix/sysv/linux/rseq-internal.h
new file mode 100644
index 0000000000..d676da3701
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/rseq-internal.h
@@ -0,0 +1,91 @@
+/* Copyright (C) 2018 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 2018.
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
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#ifndef RSEQ_INTERNAL_H
+#define RSEQ_INTERNAL_H
+
+#include <sysdep.h>
+
+#ifdef __NR_rseq
+
+#include <errno.h>
+#include <sys/rseq.h>
+
+static inline int
+rseq_register_current_thread (void)
+{
+  int rc, ret = 0;
+  INTERNAL_SYSCALL_DECL (err);
+
+  if (__rseq_abi.cpu_id == RSEQ_CPU_ID_REGISTRATION_FAILED)
+    return -1;
+  /* Temporarily prevent nested signal handlers from registering rseq.  */
+  __rseq_lib_abi.register_state = RSEQ_REGISTER_ONGOING;
+  if (__rseq_lib_abi.refcount == UINT_MAX)
+    {
+      ret = -1;
+      goto end;
+    }
+  if (__rseq_lib_abi.refcount++)
+    goto end;
+  rc = INTERNAL_SYSCALL_CALL (rseq, err, &__rseq_abi, sizeof (struct rseq),
+                              0, RSEQ_SIG);
+  if (!rc)
+    goto end;
+  if (INTERNAL_SYSCALL_ERRNO (rc, err) != EBUSY)
+    __rseq_abi.cpu_id = RSEQ_CPU_ID_REGISTRATION_FAILED;
+  ret = -1;
+end:
+  __rseq_lib_abi.register_state = RSEQ_REGISTER_ALLOWED;
+  return ret;
+}
+
+static inline int
+rseq_unregister_current_thread (void)
+{
+  int rc, ret = 0;
+  INTERNAL_SYSCALL_DECL (err);
+
+  /* Setting __rseq_register_state = RSEQ_REGISTER_EXITING for the rest of the
+     thread lifetime. Ensures signal handlers nesting just before thread exit
+     don't try to register rseq.  */
+  __rseq_lib_abi.register_state = RSEQ_REGISTER_EXITING;
+  __rseq_lib_abi.refcount = 0;
+  rc = INTERNAL_SYSCALL_CALL (rseq, err, &__rseq_abi, sizeof (struct rseq),
+                              RSEQ_FLAG_UNREGISTER, RSEQ_SIG);
+  if (!rc)
+    goto end;
+  ret = -1;
+end:
+  return ret;
+}
+#else
+static inline int
+rseq_register_current_thread (void)
+{
+  return -1;
+}
+
+static inline int
+rseq_unregister_current_thread (void)
+{
+  return -1;
+}
+#endif
+
+#endif /* rseq-internal.h */
diff --git a/sysdeps/unix/sysv/linux/rseq-sym.c b/sysdeps/unix/sysv/linux/rseq-sym.c
new file mode 100644
index 0000000000..99b277e9d6
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/rseq-sym.c
@@ -0,0 +1,54 @@
+/* Copyright (C) 2018 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 2018.
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
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#include <sys/syscall.h>
+#include <stdint.h>
+
+#ifdef __NR_rseq
+#include <sys/rseq.h>
+#else
+
+enum rseq_cpu_id_state {
+  RSEQ_CPU_ID_UNINITIALIZED = -1,
+  RSEQ_CPU_ID_REGISTRATION_FAILED = -2,
+};
+
+/* linux/rseq.h defines struct rseq as aligned on 32 bytes. The kernel ABI
+   size is 20 bytes.  */
+struct rseq {
+  uint32_t cpu_id_start;
+  uint32_t cpu_id;
+  uint64_t rseq_cs;
+  uint32_t flags;
+} __attribute__ ((aligned(4 * sizeof(uint64_t))));
+
+struct rseq_lib_abi
+{
+  uint32_t register_state;
+  uint32_t refcount;
+};
+
+#endif
+
+/* volatile because fields can be read/updated by the kernel.  */
+__thread volatile struct rseq __rseq_abi = {
+  .cpu_id = RSEQ_CPU_ID_UNINITIALIZED,
+};
+
+/* volatile because fields can be read/updated by signal handlers.  */
+__thread volatile struct rseq_lib_abi __rseq_lib_abi;
diff --git a/sysdeps/unix/sysv/linux/s390/bits/rseq.h b/sysdeps/unix/sysv/linux/s390/bits/rseq.h
new file mode 100644
index 0000000000..19d3755837
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/s390/bits/rseq.h
@@ -0,0 +1,24 @@
+/* Copyright (C) 2019 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 2019.
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
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#ifndef _SYS_RSEQ_H
+# error "Never use <bits/rseq.h> directly; include <sys/rseq.h> instead."
+#endif
+
+/* Signature required before each abort handler code.  */
+#define RSEQ_SIG 0x53053053
diff --git a/sysdeps/unix/sysv/linux/s390/s390-32/libc.abilist b/sysdeps/unix/sysv/linux/s390/s390-32/libc.abilist
index 334def033c..42316d8666 100644
--- a/sysdeps/unix/sysv/linux/s390/s390-32/libc.abilist
+++ b/sysdeps/unix/sysv/linux/s390/s390-32/libc.abilist
@@ -2005,6 +2005,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/s390/s390-64/libc.abilist b/sysdeps/unix/sysv/linux/s390/s390-64/libc.abilist
index 536f4c4ced..c6c4e55a77 100644
--- a/sysdeps/unix/sysv/linux/s390/s390-64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/s390/s390-64/libc.abilist
@@ -1911,6 +1911,8 @@ GLIBC_2.29 __fentry__ F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/sh/libc.abilist b/sysdeps/unix/sysv/linux/sh/libc.abilist
index 30ae3b6ebb..8652dfea59 100644
--- a/sysdeps/unix/sysv/linux/sh/libc.abilist
+++ b/sysdeps/unix/sysv/linux/sh/libc.abilist
@@ -1887,6 +1887,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/sparc/sparc32/libc.abilist b/sysdeps/unix/sysv/linux/sparc/sparc32/libc.abilist
index 68b107d080..95b58dfa67 100644
--- a/sysdeps/unix/sysv/linux/sparc/sparc32/libc.abilist
+++ b/sysdeps/unix/sysv/linux/sparc/sparc32/libc.abilist
@@ -1999,6 +1999,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/sparc/sparc64/libc.abilist b/sysdeps/unix/sysv/linux/sparc/sparc64/libc.abilist
index e5b6a4da50..bfd24f9d1c 100644
--- a/sysdeps/unix/sysv/linux/sparc/sparc64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/sparc/sparc64/libc.abilist
@@ -1940,6 +1940,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/sys/rseq.h b/sysdeps/unix/sysv/linux/sys/rseq.h
new file mode 100644
index 0000000000..83c8976f50
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/sys/rseq.h
@@ -0,0 +1,65 @@
+/* Copyright (C) 2019 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 2019.
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
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#ifndef _SYS_RSEQ_H
+#define _SYS_RSEQ_H	1
+
+/* We use the structures declarations from the kernel headers.  */
+#include <linux/rseq.h>
+/* Architecture-specific rseq signature.  */
+#include <bits/rseq.h>
+#include <stdint.h>
+
+enum rseq_register_state
+{
+  /* Value RSEQ_REGISTER_ALLOWED means it is allowed to update
+     the refcount field and to register/unregister rseq.  */
+  RSEQ_REGISTER_ALLOWED = 0,
+  /* Value RSEQ_REGISTER_ONGOING means a rseq registration is in progress,
+     so it is temporarily forbidden to update the refcount field or to
+     register/unregister rseq for this thread or signal handlers nested
+     on this thread.  */
+  RSEQ_REGISTER_ONGOING = 1,
+  /* Value RSEQ_REGISTER_EXITING means it is forbidden to update the
+     refcount field or to register/unregister rseq for the rest of the
+     thread's lifetime.  */
+  RSEQ_REGISTER_EXITING = 2,
+};
+
+struct rseq_lib_abi
+{
+  uint32_t register_state; /* enum rseq_register_state.  */
+  /* The refcount field keeps track of rseq users, so early adopters
+     of rseq can cooperate amongst each other and with glibc to
+     share rseq thread registration. The refcount field can only be
+     updated when allowed by the value of field register_state.
+     Registering rseq should be performed when incrementing refcount
+     from 0 to 1, and unregistering rseq should be performed when
+     decrementing refcount from 1 to 0.  */
+  uint32_t refcount;
+};
+
+/* volatile because fields can be read/updated by the kernel.  */
+extern __thread volatile struct rseq __rseq_abi
+__attribute__ ((tls_model ("initial-exec")));
+
+/* volatile because fields can be read/updated by signal handlers.  */
+extern __thread volatile struct rseq_lib_abi __rseq_lib_abi
+__attribute__ ((tls_model ("initial-exec")));
+
+#endif /* sys/rseq.h */
diff --git a/sysdeps/unix/sysv/linux/x86/bits/rseq.h b/sysdeps/unix/sysv/linux/x86/bits/rseq.h
new file mode 100644
index 0000000000..19d3755837
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/x86/bits/rseq.h
@@ -0,0 +1,24 @@
+/* Copyright (C) 2019 Free Software Foundation, Inc.
+   This file is part of the GNU C Library.
+   Contributed by Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 2019.
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
+   License along with the GNU C Library; if not, see
+   <http://www.gnu.org/licenses/>.  */
+
+#ifndef _SYS_RSEQ_H
+# error "Never use <bits/rseq.h> directly; include <sys/rseq.h> instead."
+#endif
+
+/* Signature required before each abort handler code.  */
+#define RSEQ_SIG 0x53053053
diff --git a/sysdeps/unix/sysv/linux/x86_64/64/libc.abilist b/sysdeps/unix/sysv/linux/x86_64/64/libc.abilist
index 86dfb0c94d..e9f8411fb2 100644
--- a/sysdeps/unix/sysv/linux/x86_64/64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/x86_64/64/libc.abilist
@@ -1898,6 +1898,8 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
 GLIBC_2.3 __ctype_toupper_loc F
diff --git a/sysdeps/unix/sysv/linux/x86_64/x32/libc.abilist b/sysdeps/unix/sysv/linux/x86_64/x32/libc.abilist
index dd688263aa..f9432d07f1 100644
--- a/sysdeps/unix/sysv/linux/x86_64/x32/libc.abilist
+++ b/sysdeps/unix/sysv/linux/x86_64/x32/libc.abilist
@@ -2149,3 +2149,5 @@ GLIBC_2.28 thrd_yield F
 GLIBC_2.29 getcpu F
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.29 posix_spawn_file_actions_addfchdir_np F
+GLIBC_2.30 __rseq_abi T 0x20
+GLIBC_2.30 __rseq_lib_abi T 0x8
-- 
2.17.1

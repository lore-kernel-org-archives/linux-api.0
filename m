From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH glibc 1/4] glibc: Perform rseq(2) registration at C startup and thread creation (v5)
Date: Mon, 14 Jan 2019 20:51:45 -0500
Message-ID: <20190115015148.32155-1-mathieu.desnoyers@efficios.com>
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

This patch is based on glibc commit a502c5294. The rseq(2) system call
was merged into Linux 4.18.

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
---
 NEWS                                          |  6 ++
 csu/libc-start.c                              | 12 ++-
 misc/Makefile                                 |  3 +-
 misc/rseq-internal.h                          | 34 ++++++++
 nptl/pthread_create.c                         |  9 +++
 sysdeps/unix/sysv/linux/Makefile              |  5 +-
 sysdeps/unix/sysv/linux/Versions              |  4 +
 sysdeps/unix/sysv/linux/aarch64/libc.abilist  |  2 +
 sysdeps/unix/sysv/linux/alpha/libc.abilist    |  2 +
 sysdeps/unix/sysv/linux/arm/libc.abilist      |  2 +
 sysdeps/unix/sysv/linux/hppa/libc.abilist     |  2 +
 sysdeps/unix/sysv/linux/i386/libc.abilist     |  2 +
 sysdeps/unix/sysv/linux/ia64/libc.abilist     |  2 +
 .../sysv/linux/m68k/coldfire/libc.abilist     |  2 +
 .../unix/sysv/linux/m68k/m680x0/libc.abilist  |  2 +
 .../unix/sysv/linux/microblaze/libc.abilist   |  2 +
 .../sysv/linux/mips/mips32/fpu/libc.abilist   |  2 +
 .../sysv/linux/mips/mips32/nofpu/libc.abilist |  2 +
 .../sysv/linux/mips/mips64/n32/libc.abilist   |  2 +
 .../sysv/linux/mips/mips64/n64/libc.abilist   |  2 +
 sysdeps/unix/sysv/linux/nios2/libc.abilist    |  2 +
 .../linux/powerpc/powerpc32/fpu/libc.abilist  |  2 +
 .../powerpc/powerpc32/nofpu/libc.abilist      |  2 +
 .../linux/powerpc/powerpc64/libc-le.abilist   |  2 +
 .../sysv/linux/powerpc/powerpc64/libc.abilist |  2 +
 .../unix/sysv/linux/riscv/rv64/libc.abilist   |  2 +
 sysdeps/unix/sysv/linux/rseq-internal.h       | 80 +++++++++++++++++++
 sysdeps/unix/sysv/linux/rseq-sym.c            | 48 +++++++++++
 .../unix/sysv/linux/s390/s390-32/libc.abilist |  2 +
 .../unix/sysv/linux/s390/s390-64/libc.abilist |  2 +
 sysdeps/unix/sysv/linux/sh/libc.abilist       |  2 +
 .../sysv/linux/sparc/sparc32/libc.abilist     |  2 +
 .../sysv/linux/sparc/sparc64/libc.abilist     |  2 +
 sysdeps/unix/sysv/linux/sys/rseq.h            | 37 +++++++++
 .../unix/sysv/linux/x86_64/64/libc.abilist    |  2 +
 .../unix/sysv/linux/x86_64/x32/libc.abilist   |  2 +
 36 files changed, 284 insertions(+), 6 deletions(-)
 create mode 100644 misc/rseq-internal.h
 create mode 100644 sysdeps/unix/sysv/linux/rseq-internal.h
 create mode 100644 sysdeps/unix/sysv/linux/rseq-sym.c
 create mode 100644 sysdeps/unix/sysv/linux/sys/rseq.h

diff --git a/NEWS b/NEWS
index f488821af1..b238eaa391 100644
--- a/NEWS
+++ b/NEWS
@@ -35,6 +35,12 @@ Major new features:
   different directory.  This is a GNU extension and similar to the
   Solaris function of the same name.
 
+* Support for automatically registering threads with the Linux rseq(2)
+  system call has been added. This system call is implemented starting
+  from Linux 4.18. In order to be activated, it requires that glibc is built
+  against kernel headers that include this system call, and that glibc
+  detects availability of that system call at runtime.
+
 Deprecated and removed features, and other changes affecting compatibility:
 
 * The glibc.tune tunable namespace has been renamed to glibc.cpu and the
diff --git a/csu/libc-start.c b/csu/libc-start.c
index 494132368f..dc39e09685 100644
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
index c2c9994d17..4175cbb3d3 100644
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
index fe75d04113..bb80f97d2d 100644
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
index 72b6b641d5..b18e1cd450 100644
--- a/sysdeps/unix/sysv/linux/Makefile
+++ b/sysdeps/unix/sysv/linux/Makefile
@@ -1,5 +1,5 @@
 ifeq ($(subdir),csu)
-sysdep_routines += errno-loc
+sysdep_routines += errno-loc rseq-sym
 endif
 
 ifeq ($(subdir),assert)
@@ -43,7 +43,8 @@ sysdep_headers += sys/mount.h sys/acct.h sys/sysctl.h \
 		  bits/siginfo-arch.h bits/siginfo-consts-arch.h \
 		  bits/procfs.h bits/procfs-id.h bits/procfs-extra.h \
 		  bits/procfs-prregset.h bits/mman-map-flags-generic.h \
-		  bits/msq-pad.h bits/sem-pad.h bits/shmlba.h bits/shm-pad.h
+		  bits/msq-pad.h bits/sem-pad.h bits/shmlba.h bits/shm-pad.h \
+		  sys/rseq.h
 
 tests += tst-clone tst-clone2 tst-clone3 tst-fanotify tst-personality \
 	 tst-quota tst-sync_file_range tst-sysconf-iov_max tst-ttyname \
diff --git a/sysdeps/unix/sysv/linux/Versions b/sysdeps/unix/sysv/linux/Versions
index 336c13b57d..a41562ea6e 100644
--- a/sysdeps/unix/sysv/linux/Versions
+++ b/sysdeps/unix/sysv/linux/Versions
@@ -171,6 +171,10 @@ libc {
     mlock2;
     pkey_alloc; pkey_free; pkey_set; pkey_get; pkey_mprotect;
   }
+  GLIBC_2.29 {
+    __rseq_abi;
+    __rseq_refcount;
+  }
   GLIBC_PRIVATE {
     # functions used in other libraries
     __syscall_rt_sigqueueinfo;
diff --git a/sysdeps/unix/sysv/linux/aarch64/libc.abilist b/sysdeps/unix/sysv/linux/aarch64/libc.abilist
index e66c741d04..ee112311e9 100644
--- a/sysdeps/unix/sysv/linux/aarch64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/aarch64/libc.abilist
@@ -2138,4 +2138,6 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
diff --git a/sysdeps/unix/sysv/linux/alpha/libc.abilist b/sysdeps/unix/sysv/linux/alpha/libc.abilist
index 8df162fe99..91e484af8f 100644
--- a/sysdeps/unix/sysv/linux/alpha/libc.abilist
+++ b/sysdeps/unix/sysv/linux/alpha/libc.abilist
@@ -2033,6 +2033,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/arm/libc.abilist b/sysdeps/unix/sysv/linux/arm/libc.abilist
index 43c804f9dc..82da790ffd 100644
--- a/sysdeps/unix/sysv/linux/arm/libc.abilist
+++ b/sysdeps/unix/sysv/linux/arm/libc.abilist
@@ -123,6 +123,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.4 _Exit F
 GLIBC_2.4 _IO_2_1_stderr_ D 0xa0
diff --git a/sysdeps/unix/sysv/linux/hppa/libc.abilist b/sysdeps/unix/sysv/linux/hppa/libc.abilist
index 88b01c2e75..71b6df73dd 100644
--- a/sysdeps/unix/sysv/linux/hppa/libc.abilist
+++ b/sysdeps/unix/sysv/linux/hppa/libc.abilist
@@ -1880,6 +1880,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/i386/libc.abilist b/sysdeps/unix/sysv/linux/i386/libc.abilist
index 6d02f31612..9f8ea92974 100644
--- a/sysdeps/unix/sysv/linux/i386/libc.abilist
+++ b/sysdeps/unix/sysv/linux/i386/libc.abilist
@@ -2045,6 +2045,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/ia64/libc.abilist b/sysdeps/unix/sysv/linux/ia64/libc.abilist
index 4249712611..b5320a65d6 100644
--- a/sysdeps/unix/sysv/linux/ia64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/ia64/libc.abilist
@@ -1914,6 +1914,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/m68k/coldfire/libc.abilist b/sysdeps/unix/sysv/linux/m68k/coldfire/libc.abilist
index d47b808862..b2ef85ea01 100644
--- a/sysdeps/unix/sysv/linux/m68k/coldfire/libc.abilist
+++ b/sysdeps/unix/sysv/linux/m68k/coldfire/libc.abilist
@@ -124,6 +124,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.4 _Exit F
 GLIBC_2.4 _IO_2_1_stderr_ D 0x98
diff --git a/sysdeps/unix/sysv/linux/m68k/m680x0/libc.abilist b/sysdeps/unix/sysv/linux/m68k/m680x0/libc.abilist
index d5e38308be..a86ad65117 100644
--- a/sysdeps/unix/sysv/linux/m68k/m680x0/libc.abilist
+++ b/sysdeps/unix/sysv/linux/m68k/m680x0/libc.abilist
@@ -1989,6 +1989,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/microblaze/libc.abilist b/sysdeps/unix/sysv/linux/microblaze/libc.abilist
index 8596b84399..2b5142b35f 100644
--- a/sysdeps/unix/sysv/linux/microblaze/libc.abilist
+++ b/sysdeps/unix/sysv/linux/microblaze/libc.abilist
@@ -2130,4 +2130,6 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
diff --git a/sysdeps/unix/sysv/linux/mips/mips32/fpu/libc.abilist b/sysdeps/unix/sysv/linux/mips/mips32/fpu/libc.abilist
index 88e0f896d5..b9a9736f7e 100644
--- a/sysdeps/unix/sysv/linux/mips/mips32/fpu/libc.abilist
+++ b/sysdeps/unix/sysv/linux/mips/mips32/fpu/libc.abilist
@@ -1967,6 +1967,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/mips/mips32/nofpu/libc.abilist b/sysdeps/unix/sysv/linux/mips/mips32/nofpu/libc.abilist
index aff7462c34..7c5cbad251 100644
--- a/sysdeps/unix/sysv/linux/mips/mips32/nofpu/libc.abilist
+++ b/sysdeps/unix/sysv/linux/mips/mips32/nofpu/libc.abilist
@@ -1965,6 +1965,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/mips/mips64/n32/libc.abilist b/sysdeps/unix/sysv/linux/mips/mips64/n32/libc.abilist
index 71d82444aa..2c41bae596 100644
--- a/sysdeps/unix/sysv/linux/mips/mips64/n32/libc.abilist
+++ b/sysdeps/unix/sysv/linux/mips/mips64/n32/libc.abilist
@@ -1973,6 +1973,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/mips/mips64/n64/libc.abilist b/sysdeps/unix/sysv/linux/mips/mips64/n64/libc.abilist
index de6c53d293..77a0765a93 100644
--- a/sysdeps/unix/sysv/linux/mips/mips64/n64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/mips/mips64/n64/libc.abilist
@@ -1968,6 +1968,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/nios2/libc.abilist b/sysdeps/unix/sysv/linux/nios2/libc.abilist
index e724bab9fb..4b8ad84b31 100644
--- a/sysdeps/unix/sysv/linux/nios2/libc.abilist
+++ b/sysdeps/unix/sysv/linux/nios2/libc.abilist
@@ -2171,4 +2171,6 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
diff --git a/sysdeps/unix/sysv/linux/powerpc/powerpc32/fpu/libc.abilist b/sysdeps/unix/sysv/linux/powerpc/powerpc32/fpu/libc.abilist
index e9ecbccb71..bbc93a1db7 100644
--- a/sysdeps/unix/sysv/linux/powerpc/powerpc32/fpu/libc.abilist
+++ b/sysdeps/unix/sysv/linux/powerpc/powerpc32/fpu/libc.abilist
@@ -1993,6 +1993,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/powerpc/powerpc32/nofpu/libc.abilist b/sysdeps/unix/sysv/linux/powerpc/powerpc32/nofpu/libc.abilist
index da83ea6028..923f0e3248 100644
--- a/sysdeps/unix/sysv/linux/powerpc/powerpc32/nofpu/libc.abilist
+++ b/sysdeps/unix/sysv/linux/powerpc/powerpc32/nofpu/libc.abilist
@@ -1997,6 +1997,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc-le.abilist b/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc-le.abilist
index 4535b40d15..7d5648125a 100644
--- a/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc-le.abilist
+++ b/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc-le.abilist
@@ -2228,4 +2228,6 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
diff --git a/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc.abilist b/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc.abilist
index 65725de4f0..7bfd4efda6 100644
--- a/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc.abilist
@@ -123,6 +123,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 _Exit F
 GLIBC_2.3 _IO_2_1_stderr_ D 0xe0
diff --git a/sysdeps/unix/sysv/linux/riscv/rv64/libc.abilist b/sysdeps/unix/sysv/linux/riscv/rv64/libc.abilist
index bbb3c4a8e7..78e33194c4 100644
--- a/sysdeps/unix/sysv/linux/riscv/rv64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/riscv/rv64/libc.abilist
@@ -2100,4 +2100,6 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
diff --git a/sysdeps/unix/sysv/linux/rseq-internal.h b/sysdeps/unix/sysv/linux/rseq-internal.h
new file mode 100644
index 0000000000..949e2556cb
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/rseq-internal.h
@@ -0,0 +1,80 @@
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
+  rc = INTERNAL_SYSCALL_CALL (rseq, err, &__rseq_abi, sizeof (struct rseq),
+                              0, RSEQ_SIG);
+  if (!rc)
+    {
+      __rseq_refcount = 1;
+      goto end;
+    }
+  if (INTERNAL_SYSCALL_ERRNO (rc, err) != EBUSY)
+    __rseq_abi.cpu_id = RSEQ_CPU_ID_REGISTRATION_FAILED;
+  ret = -1;
+end:
+  return ret;
+}
+
+static inline int
+rseq_unregister_current_thread (void)
+{
+  int rc, ret = 0;
+  INTERNAL_SYSCALL_DECL (err);
+
+  __rseq_refcount = 0;
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
index 0000000000..6856d0388a
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/rseq-sym.c
@@ -0,0 +1,48 @@
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
+#endif
+
+/* volatile because fields can be read/updated by the kernel.  */
+__thread volatile struct rseq __rseq_abi = {
+  .cpu_id = RSEQ_CPU_ID_UNINITIALIZED,
+};
+
+/* volatile because refcount can be read/updated by signal handlers.  */
+__thread volatile uint32_t __rseq_refcount;
diff --git a/sysdeps/unix/sysv/linux/s390/s390-32/libc.abilist b/sysdeps/unix/sysv/linux/s390/s390-32/libc.abilist
index e85ac2a178..790b94fb97 100644
--- a/sysdeps/unix/sysv/linux/s390/s390-32/libc.abilist
+++ b/sysdeps/unix/sysv/linux/s390/s390-32/libc.abilist
@@ -2002,6 +2002,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/s390/s390-64/libc.abilist b/sysdeps/unix/sysv/linux/s390/s390-64/libc.abilist
index d56931022c..bc195da640 100644
--- a/sysdeps/unix/sysv/linux/s390/s390-64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/s390/s390-64/libc.abilist
@@ -1908,6 +1908,8 @@ GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
 GLIBC_2.29 __fentry__ F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/sh/libc.abilist b/sysdeps/unix/sysv/linux/sh/libc.abilist
index ff939a15c4..ae265d7a8f 100644
--- a/sysdeps/unix/sysv/linux/sh/libc.abilist
+++ b/sysdeps/unix/sysv/linux/sh/libc.abilist
@@ -1884,6 +1884,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/sparc/sparc32/libc.abilist b/sysdeps/unix/sysv/linux/sparc/sparc32/libc.abilist
index 64fa9e10a5..b1ed05b4cb 100644
--- a/sysdeps/unix/sysv/linux/sparc/sparc32/libc.abilist
+++ b/sysdeps/unix/sysv/linux/sparc/sparc32/libc.abilist
@@ -1996,6 +1996,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/sparc/sparc64/libc.abilist b/sysdeps/unix/sysv/linux/sparc/sparc64/libc.abilist
index db909d1506..2a31ea25b9 100644
--- a/sysdeps/unix/sysv/linux/sparc/sparc64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/sparc/sparc64/libc.abilist
@@ -1937,6 +1937,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/sys/rseq.h b/sysdeps/unix/sysv/linux/sys/rseq.h
new file mode 100644
index 0000000000..5aad4b0fae
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/sys/rseq.h
@@ -0,0 +1,37 @@
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
+#include <stdint.h>
+
+/* Signature required before each abort handler code.  */
+#define RSEQ_SIG 0x53053053
+
+/* volatile because fields can be read/updated by the kernel.  */
+extern __thread volatile struct rseq __rseq_abi
+__attribute__ ((tls_model ("initial-exec")));
+
+/* volatile because refcount can be read/updated by signal handlers.  */
+extern __thread volatile uint32_t __rseq_refcount
+__attribute__ ((tls_model ("initial-exec")));
+
+#endif /* sys/rseq.h */
diff --git a/sysdeps/unix/sysv/linux/x86_64/64/libc.abilist b/sysdeps/unix/sysv/linux/x86_64/64/libc.abilist
index 3b175f104b..cd0b66fcd9 100644
--- a/sysdeps/unix/sysv/linux/x86_64/64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/x86_64/64/libc.abilist
@@ -1895,6 +1895,8 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/x86_64/x32/libc.abilist b/sysdeps/unix/sysv/linux/x86_64/x32/libc.abilist
index 1b57710477..46ddfa3abc 100644
--- a/sysdeps/unix/sysv/linux/x86_64/x32/libc.abilist
+++ b/sysdeps/unix/sysv/linux/x86_64/x32/libc.abilist
@@ -2146,4 +2146,6 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
-- 
2.17.1

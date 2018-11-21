From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH v4 1/5] glibc: Perform rseq(2) registration at nptl init and thread creation
Date: Wed, 21 Nov 2018 13:39:32 -0500
Message-ID: <20181121183936.8176-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Carlos O'Donell <carlos@redhat.com>
Cc: Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha@sourceware.org, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
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
- Use atomic_fetch_add_relaxed to update __rseq_refcount TLS in a
  async-signal-safe way. This is sufficient for the required atomicity
  guarantees provided that the refcount is only touched by the current
  thread and nested signal handlers, but more lightweight than
  atomic_increment_val and atomic_decrement_val.
- Add missing abilist items.
- Rebase on glibc master commit a502c5294.
- Add NEWS entry.
---
 NEWS                                          |  6 ++
 csu/Makefile                                  |  2 +-
 csu/Versions                                  |  3 +
 csu/rseq.c                                    | 38 ++++++++++
 nptl/Makefile                                 |  2 +-
 nptl/Versions                                 |  4 +
 nptl/nptl-init.c                              |  3 +
 nptl/pthreadP.h                               |  3 +
 nptl/pthread_create.c                         |  8 ++
 nptl/rseq.c                                   | 42 +++++++++++
 sysdeps/nptl/rseq-internal.h                  | 34 +++++++++
 sysdeps/unix/sysv/linux/aarch64/libc.abilist  |  1 +
 .../sysv/linux/aarch64/libpthread.abilist     |  1 +
 sysdeps/unix/sysv/linux/alpha/libc.abilist    |  1 +
 .../unix/sysv/linux/alpha/libpthread.abilist  |  1 +
 sysdeps/unix/sysv/linux/arm/libc.abilist      |  1 +
 .../unix/sysv/linux/arm/libpthread.abilist    |  1 +
 sysdeps/unix/sysv/linux/hppa/libc.abilist     |  1 +
 .../unix/sysv/linux/hppa/libpthread.abilist   |  1 +
 sysdeps/unix/sysv/linux/i386/libc.abilist     |  1 +
 .../unix/sysv/linux/i386/libpthread.abilist   |  1 +
 sysdeps/unix/sysv/linux/ia64/libc.abilist     |  1 +
 .../unix/sysv/linux/ia64/libpthread.abilist   |  1 +
 .../sysv/linux/m68k/coldfire/libc.abilist     |  1 +
 .../linux/m68k/coldfire/libpthread.abilist    |  1 +
 .../unix/sysv/linux/m68k/m680x0/libc.abilist  |  1 +
 .../sysv/linux/m68k/m680x0/libpthread.abilist |  1 +
 .../unix/sysv/linux/microblaze/libc.abilist   |  1 +
 .../sysv/linux/microblaze/libpthread.abilist  |  1 +
 .../sysv/linux/mips/mips32/fpu/libc.abilist   |  1 +
 .../sysv/linux/mips/mips32/libpthread.abilist |  1 +
 .../sysv/linux/mips/mips32/nofpu/libc.abilist |  1 +
 .../sysv/linux/mips/mips64/libpthread.abilist |  1 +
 .../sysv/linux/mips/mips64/n32/libc.abilist   |  1 +
 .../sysv/linux/mips/mips64/n64/libc.abilist   |  1 +
 sysdeps/unix/sysv/linux/nios2/libc.abilist    |  1 +
 .../unix/sysv/linux/nios2/libpthread.abilist  |  1 +
 .../linux/powerpc/powerpc32/fpu/libc.abilist  |  1 +
 .../powerpc/powerpc32/libpthread.abilist      |  1 +
 .../powerpc/powerpc32/nofpu/libc.abilist      |  1 +
 .../linux/powerpc/powerpc64/libc-le.abilist   |  1 +
 .../sysv/linux/powerpc/powerpc64/libc.abilist |  1 +
 .../powerpc/powerpc64/libpthread-le.abilist   |  1 +
 .../powerpc/powerpc64/libpthread.abilist      |  1 +
 .../unix/sysv/linux/riscv/rv64/libc.abilist   |  1 +
 .../sysv/linux/riscv/rv64/libpthread.abilist  |  1 +
 sysdeps/unix/sysv/linux/rseq-internal.h       | 73 +++++++++++++++++++
 .../unix/sysv/linux/s390/s390-32/libc.abilist |  1 +
 .../linux/s390/s390-32/libpthread.abilist     |  1 +
 .../unix/sysv/linux/s390/s390-64/libc.abilist |  1 +
 .../linux/s390/s390-64/libpthread.abilist     |  1 +
 sysdeps/unix/sysv/linux/sh/libc.abilist       |  1 +
 sysdeps/unix/sysv/linux/sh/libpthread.abilist |  1 +
 .../sysv/linux/sparc/sparc32/libc.abilist     |  1 +
 .../linux/sparc/sparc32/libpthread.abilist    |  1 +
 .../sysv/linux/sparc/sparc64/libc.abilist     |  1 +
 .../linux/sparc/sparc64/libpthread.abilist    |  1 +
 .../unix/sysv/linux/x86_64/64/libc.abilist    |  1 +
 .../sysv/linux/x86_64/64/libpthread.abilist   |  1 +
 .../unix/sysv/linux/x86_64/x32/libc.abilist   |  1 +
 .../sysv/linux/x86_64/x32/libpthread.abilist  |  1 +
 61 files changed, 265 insertions(+), 2 deletions(-)
 create mode 100644 csu/rseq.c
 create mode 100644 nptl/rseq.c
 create mode 100644 sysdeps/nptl/rseq-internal.h
 create mode 100644 sysdeps/unix/sysv/linux/rseq-internal.h

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
diff --git a/csu/Makefile b/csu/Makefile
index 88fc77662e..81d471587f 100644
--- a/csu/Makefile
+++ b/csu/Makefile
@@ -28,7 +28,7 @@ include ../Makeconfig
 
 routines = init-first libc-start $(libc-init) sysdep version check_fds \
 	   libc-tls elf-init dso_handle
-aux	 = errno
+aux	 = errno rseq
 elide-routines.os = libc-tls
 static-only-routines = elf-init
 csu-dummies = $(filter-out $(start-installed-name),crt1.o Mcrt1.o)
diff --git a/csu/Versions b/csu/Versions
index 43010c3443..0f44ebf991 100644
--- a/csu/Versions
+++ b/csu/Versions
@@ -7,6 +7,9 @@ libc {
     # New special glibc functions.
     gnu_get_libc_release; gnu_get_libc_version;
   }
+  GLIBC_2.29 {
+    __rseq_abi;
+  }
   GLIBC_PRIVATE {
     errno;
   }
diff --git a/csu/rseq.c b/csu/rseq.c
new file mode 100644
index 0000000000..ccc88e4582
--- /dev/null
+++ b/csu/rseq.c
@@ -0,0 +1,38 @@
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
+#include <stdint.h>
+
+enum libc_rseq_cpu_id_state {
+  LIBC_RSEQ_CPU_ID_UNINITIALIZED = -1,
+  LIBC_RSEQ_CPU_ID_REGISTRATION_FAILED = -2,
+};
+
+/* linux/rseq.h defines struct rseq as aligned on 32 bytes. The kernel ABI
+   size is 20 bytes.  */
+struct libc_rseq {
+  uint32_t cpu_id_start;
+  uint32_t cpu_id;
+  uint64_t rseq_cs;
+  uint32_t flags;
+} __attribute__ ((aligned(4 * sizeof(uint64_t))));
+
+__attribute__ ((weak))
+__thread volatile struct libc_rseq __rseq_abi = {
+  .cpu_id = LIBC_RSEQ_CPU_ID_UNINITIALIZED,
+};
diff --git a/nptl/Makefile b/nptl/Makefile
index 49b6faa330..3a5dc80c65 100644
--- a/nptl/Makefile
+++ b/nptl/Makefile
@@ -145,7 +145,7 @@ libpthread-routines = nptl-init nptlfreeres vars events version pt-interp \
 		      mtx_destroy mtx_init mtx_lock mtx_timedlock \
 		      mtx_trylock mtx_unlock call_once cnd_broadcast \
 		      cnd_destroy cnd_init cnd_signal cnd_timedwait cnd_wait \
-		      tss_create tss_delete tss_get tss_set
+		      tss_create tss_delete tss_get tss_set rseq
 #		      pthread_setuid pthread_seteuid pthread_setreuid \
 #		      pthread_setresuid \
 #		      pthread_setgid pthread_setegid pthread_setregid \
diff --git a/nptl/Versions b/nptl/Versions
index e7f691da7a..f7890f73fc 100644
--- a/nptl/Versions
+++ b/nptl/Versions
@@ -277,6 +277,10 @@ libpthread {
     cnd_timedwait; cnd_wait; tss_create; tss_delete; tss_get; tss_set;
   }
 
+  GLIBC_2.29 {
+    __rseq_refcount;
+  }
+
   GLIBC_PRIVATE {
     __pthread_initialize_minimal;
     __pthread_clock_gettime; __pthread_clock_settime;
diff --git a/nptl/nptl-init.c b/nptl/nptl-init.c
index 907411d5bc..ab17bbb6e4 100644
--- a/nptl/nptl-init.c
+++ b/nptl/nptl-init.c
@@ -279,6 +279,9 @@ __pthread_initialize_minimal_internal (void)
   THREAD_SETMEM (pd, cpuclock_offset, GL(dl_cpuclock_offset));
 #endif
 
+  /* Register rseq ABI to the kernel. */
+  (void) __rseq_register_current_thread ();
+
   /* Initialize the robust mutex data.  */
   {
 #if __PTHREAD_MUTEX_HAVE_PREV
diff --git a/nptl/pthreadP.h b/nptl/pthreadP.h
index 19efe1e35f..7fb996f12d 100644
--- a/nptl/pthreadP.h
+++ b/nptl/pthreadP.h
@@ -609,6 +609,9 @@ extern void __shm_directory_freeres (void) attribute_hidden;
 
 extern void __wait_lookup_done (void) attribute_hidden;
 
+extern int __rseq_register_current_thread (void) attribute_hidden;
+extern int __rseq_unregister_current_thread (void) attribute_hidden;
+
 #ifdef SHARED
 # define PTHREAD_STATIC_FN_REQUIRE(name)
 #else
diff --git a/nptl/pthread_create.c b/nptl/pthread_create.c
index fe75d04113..a5233cdf2f 100644
--- a/nptl/pthread_create.c
+++ b/nptl/pthread_create.c
@@ -378,6 +378,7 @@ __free_tcb (struct pthread *pd)
 START_THREAD_DEFN
 {
   struct pthread *pd = START_THREAD_SELF;
+  bool has_rseq = false;
 
 #if HP_TIMING_AVAIL
   /* Remember the time when the thread was started.  */
@@ -396,6 +397,9 @@ START_THREAD_DEFN
   if (__glibc_unlikely (atomic_exchange_acq (&pd->setxid_futex, 0) == -2))
     futex_wake (&pd->setxid_futex, 1, FUTEX_PRIVATE);
 
+  /* Register rseq TLS to the kernel. */
+  has_rseq = !__rseq_register_current_thread ();
+
 #ifdef __NR_set_robust_list
 # ifndef __ASSUME_SET_ROBUST_LIST
   if (__set_robust_list_avail >= 0)
@@ -573,6 +577,10 @@ START_THREAD_DEFN
     }
 #endif
 
+  /* Unregister rseq TLS from kernel. */
+  if (has_rseq && __rseq_unregister_current_thread ())
+    abort();
+
   advise_stack_range (pd->stackblock, pd->stackblock_size, (uintptr_t) pd,
 		      pd->guardsize);
 
diff --git a/nptl/rseq.c b/nptl/rseq.c
new file mode 100644
index 0000000000..415674964f
--- /dev/null
+++ b/nptl/rseq.c
@@ -0,0 +1,42 @@
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
+#include "pthreadP.h"
+
+__attribute__((weak))
+__thread volatile uint32_t __rseq_refcount;
+
+#ifdef __NR_rseq
+#include <sysdeps/unix/sysv/linux/rseq-internal.h>
+#else
+#include <sysdeps/nptl/rseq-internal.h>
+#endif  /* __NR_rseq.  */
+
+int
+attribute_hidden
+__rseq_register_current_thread (void)
+{
+  return sysdep_rseq_register_current_thread ();
+}
+
+int
+attribute_hidden
+__rseq_unregister_current_thread (void)
+{
+  return sysdep_rseq_register_current_thread ();
+}
diff --git a/sysdeps/nptl/rseq-internal.h b/sysdeps/nptl/rseq-internal.h
new file mode 100644
index 0000000000..96422ebd57
--- /dev/null
+++ b/sysdeps/nptl/rseq-internal.h
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
+sysdep_rseq_register_current_thread (void)
+{
+  return -1;
+}
+
+static inline int
+sysdep_rseq_unregister_current_thread (void)
+{
+  return -1;
+}
+
+#endif	/* rseq-internal.h */
diff --git a/sysdeps/unix/sysv/linux/aarch64/libc.abilist b/sysdeps/unix/sysv/linux/aarch64/libc.abilist
index e66c741d04..36af4d0e94 100644
--- a/sysdeps/unix/sysv/linux/aarch64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/aarch64/libc.abilist
@@ -2138,4 +2138,5 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
diff --git a/sysdeps/unix/sysv/linux/aarch64/libpthread.abilist b/sysdeps/unix/sysv/linux/aarch64/libpthread.abilist
index 9a9e4cee85..d5b010eee1 100644
--- a/sysdeps/unix/sysv/linux/aarch64/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/aarch64/libpthread.abilist
@@ -243,3 +243,4 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
diff --git a/sysdeps/unix/sysv/linux/alpha/libc.abilist b/sysdeps/unix/sysv/linux/alpha/libc.abilist
index 8df162fe99..cdf1d53e35 100644
--- a/sysdeps/unix/sysv/linux/alpha/libc.abilist
+++ b/sysdeps/unix/sysv/linux/alpha/libc.abilist
@@ -2033,6 +2033,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/alpha/libpthread.abilist b/sysdeps/unix/sysv/linux/alpha/libpthread.abilist
index b413007ccb..d477af8d10 100644
--- a/sysdeps/unix/sysv/linux/alpha/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/alpha/libpthread.abilist
@@ -227,6 +227,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.3.2 pthread_cond_broadcast F
 GLIBC_2.3.2 pthread_cond_destroy F
 GLIBC_2.3.2 pthread_cond_init F
diff --git a/sysdeps/unix/sysv/linux/arm/libc.abilist b/sysdeps/unix/sysv/linux/arm/libc.abilist
index 43c804f9dc..f11ff5c5cf 100644
--- a/sysdeps/unix/sysv/linux/arm/libc.abilist
+++ b/sysdeps/unix/sysv/linux/arm/libc.abilist
@@ -123,6 +123,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.4 _Exit F
 GLIBC_2.4 _IO_2_1_stderr_ D 0xa0
diff --git a/sysdeps/unix/sysv/linux/arm/libpthread.abilist b/sysdeps/unix/sysv/linux/arm/libpthread.abilist
index af82a4c632..b49c38114a 100644
--- a/sysdeps/unix/sysv/linux/arm/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/arm/libpthread.abilist
@@ -27,6 +27,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.4 _IO_flockfile F
 GLIBC_2.4 _IO_ftrylockfile F
 GLIBC_2.4 _IO_funlockfile F
diff --git a/sysdeps/unix/sysv/linux/hppa/libc.abilist b/sysdeps/unix/sysv/linux/hppa/libc.abilist
index 88b01c2e75..deb2dd860b 100644
--- a/sysdeps/unix/sysv/linux/hppa/libc.abilist
+++ b/sysdeps/unix/sysv/linux/hppa/libc.abilist
@@ -1880,6 +1880,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/hppa/libpthread.abilist b/sysdeps/unix/sysv/linux/hppa/libpthread.abilist
index bcba07f575..3a307653f4 100644
--- a/sysdeps/unix/sysv/linux/hppa/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/hppa/libpthread.abilist
@@ -219,6 +219,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.3.2 pthread_cond_broadcast F
 GLIBC_2.3.2 pthread_cond_destroy F
 GLIBC_2.3.2 pthread_cond_init F
diff --git a/sysdeps/unix/sysv/linux/i386/libc.abilist b/sysdeps/unix/sysv/linux/i386/libc.abilist
index 6d02f31612..156235898a 100644
--- a/sysdeps/unix/sysv/linux/i386/libc.abilist
+++ b/sysdeps/unix/sysv/linux/i386/libc.abilist
@@ -2045,6 +2045,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/i386/libpthread.abilist b/sysdeps/unix/sysv/linux/i386/libpthread.abilist
index bece86d246..e95ce92103 100644
--- a/sysdeps/unix/sysv/linux/i386/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/i386/libpthread.abilist
@@ -227,6 +227,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.3.2 pthread_cond_broadcast F
 GLIBC_2.3.2 pthread_cond_destroy F
 GLIBC_2.3.2 pthread_cond_init F
diff --git a/sysdeps/unix/sysv/linux/ia64/libc.abilist b/sysdeps/unix/sysv/linux/ia64/libc.abilist
index 4249712611..39f291f97d 100644
--- a/sysdeps/unix/sysv/linux/ia64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/ia64/libc.abilist
@@ -1914,6 +1914,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/ia64/libpthread.abilist b/sysdeps/unix/sysv/linux/ia64/libpthread.abilist
index ccc9449826..6e23c0e62d 100644
--- a/sysdeps/unix/sysv/linux/ia64/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/ia64/libpthread.abilist
@@ -219,6 +219,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.3.2 pthread_cond_broadcast F
 GLIBC_2.3.2 pthread_cond_destroy F
 GLIBC_2.3.2 pthread_cond_init F
diff --git a/sysdeps/unix/sysv/linux/m68k/coldfire/libc.abilist b/sysdeps/unix/sysv/linux/m68k/coldfire/libc.abilist
index d47b808862..a18501e570 100644
--- a/sysdeps/unix/sysv/linux/m68k/coldfire/libc.abilist
+++ b/sysdeps/unix/sysv/linux/m68k/coldfire/libc.abilist
@@ -124,6 +124,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.4 _Exit F
 GLIBC_2.4 _IO_2_1_stderr_ D 0x98
diff --git a/sysdeps/unix/sysv/linux/m68k/coldfire/libpthread.abilist b/sysdeps/unix/sysv/linux/m68k/coldfire/libpthread.abilist
index af82a4c632..b49c38114a 100644
--- a/sysdeps/unix/sysv/linux/m68k/coldfire/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/m68k/coldfire/libpthread.abilist
@@ -27,6 +27,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.4 _IO_flockfile F
 GLIBC_2.4 _IO_ftrylockfile F
 GLIBC_2.4 _IO_funlockfile F
diff --git a/sysdeps/unix/sysv/linux/m68k/m680x0/libc.abilist b/sysdeps/unix/sysv/linux/m68k/m680x0/libc.abilist
index d5e38308be..cf0f41ec70 100644
--- a/sysdeps/unix/sysv/linux/m68k/m680x0/libc.abilist
+++ b/sysdeps/unix/sysv/linux/m68k/m680x0/libc.abilist
@@ -1989,6 +1989,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/m68k/m680x0/libpthread.abilist b/sysdeps/unix/sysv/linux/m68k/m680x0/libpthread.abilist
index bece86d246..e95ce92103 100644
--- a/sysdeps/unix/sysv/linux/m68k/m680x0/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/m68k/m680x0/libpthread.abilist
@@ -227,6 +227,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.3.2 pthread_cond_broadcast F
 GLIBC_2.3.2 pthread_cond_destroy F
 GLIBC_2.3.2 pthread_cond_init F
diff --git a/sysdeps/unix/sysv/linux/microblaze/libc.abilist b/sysdeps/unix/sysv/linux/microblaze/libc.abilist
index 8596b84399..1405f27555 100644
--- a/sysdeps/unix/sysv/linux/microblaze/libc.abilist
+++ b/sysdeps/unix/sysv/linux/microblaze/libc.abilist
@@ -2130,4 +2130,5 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
diff --git a/sysdeps/unix/sysv/linux/microblaze/libpthread.abilist b/sysdeps/unix/sysv/linux/microblaze/libpthread.abilist
index 5067375d23..2a94d9e588 100644
--- a/sysdeps/unix/sysv/linux/microblaze/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/microblaze/libpthread.abilist
@@ -243,3 +243,4 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
diff --git a/sysdeps/unix/sysv/linux/mips/mips32/fpu/libc.abilist b/sysdeps/unix/sysv/linux/mips/mips32/fpu/libc.abilist
index 88e0f896d5..7b0144392f 100644
--- a/sysdeps/unix/sysv/linux/mips/mips32/fpu/libc.abilist
+++ b/sysdeps/unix/sysv/linux/mips/mips32/fpu/libc.abilist
@@ -1967,6 +1967,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/mips/mips32/libpthread.abilist b/sysdeps/unix/sysv/linux/mips/mips32/libpthread.abilist
index 02144967c6..e507b677ee 100644
--- a/sysdeps/unix/sysv/linux/mips/mips32/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/mips/mips32/libpthread.abilist
@@ -227,6 +227,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.3.2 pthread_cond_broadcast F
 GLIBC_2.3.2 pthread_cond_destroy F
 GLIBC_2.3.2 pthread_cond_init F
diff --git a/sysdeps/unix/sysv/linux/mips/mips32/nofpu/libc.abilist b/sysdeps/unix/sysv/linux/mips/mips32/nofpu/libc.abilist
index aff7462c34..430426e03e 100644
--- a/sysdeps/unix/sysv/linux/mips/mips32/nofpu/libc.abilist
+++ b/sysdeps/unix/sysv/linux/mips/mips32/nofpu/libc.abilist
@@ -1965,6 +1965,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/mips/mips64/libpthread.abilist b/sysdeps/unix/sysv/linux/mips/mips64/libpthread.abilist
index 02144967c6..e507b677ee 100644
--- a/sysdeps/unix/sysv/linux/mips/mips64/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/mips/mips64/libpthread.abilist
@@ -227,6 +227,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.3.2 pthread_cond_broadcast F
 GLIBC_2.3.2 pthread_cond_destroy F
 GLIBC_2.3.2 pthread_cond_init F
diff --git a/sysdeps/unix/sysv/linux/mips/mips64/n32/libc.abilist b/sysdeps/unix/sysv/linux/mips/mips64/n32/libc.abilist
index 71d82444aa..60915c4d81 100644
--- a/sysdeps/unix/sysv/linux/mips/mips64/n32/libc.abilist
+++ b/sysdeps/unix/sysv/linux/mips/mips64/n32/libc.abilist
@@ -1973,6 +1973,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/mips/mips64/n64/libc.abilist b/sysdeps/unix/sysv/linux/mips/mips64/n64/libc.abilist
index de6c53d293..958488bf19 100644
--- a/sysdeps/unix/sysv/linux/mips/mips64/n64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/mips/mips64/n64/libc.abilist
@@ -1968,6 +1968,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/nios2/libc.abilist b/sysdeps/unix/sysv/linux/nios2/libc.abilist
index e724bab9fb..9f4be44396 100644
--- a/sysdeps/unix/sysv/linux/nios2/libc.abilist
+++ b/sysdeps/unix/sysv/linux/nios2/libc.abilist
@@ -2171,4 +2171,5 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
diff --git a/sysdeps/unix/sysv/linux/nios2/libpthread.abilist b/sysdeps/unix/sysv/linux/nios2/libpthread.abilist
index 78cac2ae27..79fbbec7bb 100644
--- a/sysdeps/unix/sysv/linux/nios2/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/nios2/libpthread.abilist
@@ -241,3 +241,4 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
diff --git a/sysdeps/unix/sysv/linux/powerpc/powerpc32/fpu/libc.abilist b/sysdeps/unix/sysv/linux/powerpc/powerpc32/fpu/libc.abilist
index e9ecbccb71..758a88cb40 100644
--- a/sysdeps/unix/sysv/linux/powerpc/powerpc32/fpu/libc.abilist
+++ b/sysdeps/unix/sysv/linux/powerpc/powerpc32/fpu/libc.abilist
@@ -1993,6 +1993,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/powerpc/powerpc32/libpthread.abilist b/sysdeps/unix/sysv/linux/powerpc/powerpc32/libpthread.abilist
index 09e8447b06..2def055dec 100644
--- a/sysdeps/unix/sysv/linux/powerpc/powerpc32/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/powerpc/powerpc32/libpthread.abilist
@@ -227,6 +227,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.3.2 pthread_cond_broadcast F
 GLIBC_2.3.2 pthread_cond_destroy F
 GLIBC_2.3.2 pthread_cond_init F
diff --git a/sysdeps/unix/sysv/linux/powerpc/powerpc32/nofpu/libc.abilist b/sysdeps/unix/sysv/linux/powerpc/powerpc32/nofpu/libc.abilist
index da83ea6028..ab8d68446a 100644
--- a/sysdeps/unix/sysv/linux/powerpc/powerpc32/nofpu/libc.abilist
+++ b/sysdeps/unix/sysv/linux/powerpc/powerpc32/nofpu/libc.abilist
@@ -1997,6 +1997,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc-le.abilist b/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc-le.abilist
index 4535b40d15..d9dc159d85 100644
--- a/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc-le.abilist
+++ b/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc-le.abilist
@@ -2228,4 +2228,5 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
diff --git a/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc.abilist b/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc.abilist
index 65725de4f0..cc47390688 100644
--- a/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/powerpc/powerpc64/libc.abilist
@@ -123,6 +123,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 _Exit F
 GLIBC_2.3 _IO_2_1_stderr_ D 0xe0
diff --git a/sysdeps/unix/sysv/linux/powerpc/powerpc64/libpthread-le.abilist b/sysdeps/unix/sysv/linux/powerpc/powerpc64/libpthread-le.abilist
index 9a9e4cee85..d5b010eee1 100644
--- a/sysdeps/unix/sysv/linux/powerpc/powerpc64/libpthread-le.abilist
+++ b/sysdeps/unix/sysv/linux/powerpc/powerpc64/libpthread-le.abilist
@@ -243,3 +243,4 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
diff --git a/sysdeps/unix/sysv/linux/powerpc/powerpc64/libpthread.abilist b/sysdeps/unix/sysv/linux/powerpc/powerpc64/libpthread.abilist
index 8300958d47..26a5ced7a2 100644
--- a/sysdeps/unix/sysv/linux/powerpc/powerpc64/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/powerpc/powerpc64/libpthread.abilist
@@ -27,6 +27,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.3 _IO_flockfile F
 GLIBC_2.3 _IO_ftrylockfile F
 GLIBC_2.3 _IO_funlockfile F
diff --git a/sysdeps/unix/sysv/linux/riscv/rv64/libc.abilist b/sysdeps/unix/sysv/linux/riscv/rv64/libc.abilist
index bbb3c4a8e7..a59d67aca2 100644
--- a/sysdeps/unix/sysv/linux/riscv/rv64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/riscv/rv64/libc.abilist
@@ -2100,4 +2100,5 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
diff --git a/sysdeps/unix/sysv/linux/riscv/rv64/libpthread.abilist b/sysdeps/unix/sysv/linux/riscv/rv64/libpthread.abilist
index c370fda73d..9da78d59d2 100644
--- a/sysdeps/unix/sysv/linux/riscv/rv64/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/riscv/rv64/libpthread.abilist
@@ -235,3 +235,4 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
diff --git a/sysdeps/unix/sysv/linux/rseq-internal.h b/sysdeps/unix/sysv/linux/rseq-internal.h
new file mode 100644
index 0000000000..b6616ef32c
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/rseq-internal.h
@@ -0,0 +1,73 @@
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
+#include <stdint.h>
+#include <atomic.h>
+#include <linux/rseq.h>
+
+#define RSEQ_SIG 0x53053053
+
+extern __thread volatile struct rseq __rseq_abi
+__attribute__ ((tls_model ("initial-exec")));
+
+extern __thread volatile uint32_t __rseq_refcount
+__attribute__ ((tls_model ("initial-exec")));
+
+static inline int
+sysdep_rseq_register_current_thread (void)
+{
+  int rc, ret = 0;
+  INTERNAL_SYSCALL_DECL (err);
+
+  if (__rseq_abi.cpu_id == RSEQ_CPU_ID_REGISTRATION_FAILED)
+    return -1;
+  if (atomic_fetch_add_relaxed (&__rseq_refcount, 1))
+    goto end;
+  rc = INTERNAL_SYSCALL_CALL (rseq, err, &__rseq_abi, sizeof (struct rseq),
+                              0, RSEQ_SIG);
+  if (!rc)
+    goto end;
+  if (INTERNAL_SYSCALL_ERRNO (rc, err) != EBUSY)
+    __rseq_abi.cpu_id = RSEQ_CPU_ID_REGISTRATION_FAILED;
+  ret = -1;
+  atomic_decrement (&__rseq_refcount);
+end:
+  return ret;
+}
+
+static inline int
+sysdep_rseq_unregister_current_thread (void)
+{
+  int rc, ret = 0;
+  INTERNAL_SYSCALL_DECL (err);
+
+  if (atomic_fetch_add_relaxed (&__rseq_refcount, -1) - 1)
+    goto end;
+  rc = INTERNAL_SYSCALL_CALL (rseq, err, &__rseq_abi, sizeof (struct rseq),
+                              RSEQ_FLAG_UNREGISTER, RSEQ_SIG);
+  if (!rc)
+    goto end;
+  ret = -1;
+end:
+  return ret;
+}
+
+#endif	/* rseq-internal.h */
diff --git a/sysdeps/unix/sysv/linux/s390/s390-32/libc.abilist b/sysdeps/unix/sysv/linux/s390/s390-32/libc.abilist
index e85ac2a178..fca7f6de8d 100644
--- a/sysdeps/unix/sysv/linux/s390/s390-32/libc.abilist
+++ b/sysdeps/unix/sysv/linux/s390/s390-32/libc.abilist
@@ -2002,6 +2002,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/s390/s390-32/libpthread.abilist b/sysdeps/unix/sysv/linux/s390/s390-32/libpthread.abilist
index d05468f3b2..8876434f46 100644
--- a/sysdeps/unix/sysv/linux/s390/s390-32/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/s390/s390-32/libpthread.abilist
@@ -229,6 +229,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.3.2 pthread_cond_broadcast F
 GLIBC_2.3.2 pthread_cond_destroy F
 GLIBC_2.3.2 pthread_cond_init F
diff --git a/sysdeps/unix/sysv/linux/s390/s390-64/libc.abilist b/sysdeps/unix/sysv/linux/s390/s390-64/libc.abilist
index d56931022c..74eebccbd0 100644
--- a/sysdeps/unix/sysv/linux/s390/s390-64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/s390/s390-64/libc.abilist
@@ -1908,6 +1908,7 @@ GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
 GLIBC_2.29 __fentry__ F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/s390/s390-64/libpthread.abilist b/sysdeps/unix/sysv/linux/s390/s390-64/libpthread.abilist
index e8161aa747..2ae3980aba 100644
--- a/sysdeps/unix/sysv/linux/s390/s390-64/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/s390/s390-64/libpthread.abilist
@@ -221,6 +221,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.3.2 pthread_cond_broadcast F
 GLIBC_2.3.2 pthread_cond_destroy F
 GLIBC_2.3.2 pthread_cond_init F
diff --git a/sysdeps/unix/sysv/linux/sh/libc.abilist b/sysdeps/unix/sysv/linux/sh/libc.abilist
index ff939a15c4..e614aa9f0c 100644
--- a/sysdeps/unix/sysv/linux/sh/libc.abilist
+++ b/sysdeps/unix/sysv/linux/sh/libc.abilist
@@ -1884,6 +1884,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/sh/libpthread.abilist b/sysdeps/unix/sysv/linux/sh/libpthread.abilist
index bcba07f575..3a307653f4 100644
--- a/sysdeps/unix/sysv/linux/sh/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/sh/libpthread.abilist
@@ -219,6 +219,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.3.2 pthread_cond_broadcast F
 GLIBC_2.3.2 pthread_cond_destroy F
 GLIBC_2.3.2 pthread_cond_init F
diff --git a/sysdeps/unix/sysv/linux/sparc/sparc32/libc.abilist b/sysdeps/unix/sysv/linux/sparc/sparc32/libc.abilist
index 64fa9e10a5..03b0c2dc32 100644
--- a/sysdeps/unix/sysv/linux/sparc/sparc32/libc.abilist
+++ b/sysdeps/unix/sysv/linux/sparc/sparc32/libc.abilist
@@ -1996,6 +1996,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/sparc/sparc32/libpthread.abilist b/sysdeps/unix/sysv/linux/sparc/sparc32/libpthread.abilist
index b413007ccb..d477af8d10 100644
--- a/sysdeps/unix/sysv/linux/sparc/sparc32/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/sparc/sparc32/libpthread.abilist
@@ -227,6 +227,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.3.2 pthread_cond_broadcast F
 GLIBC_2.3.2 pthread_cond_destroy F
 GLIBC_2.3.2 pthread_cond_init F
diff --git a/sysdeps/unix/sysv/linux/sparc/sparc64/libc.abilist b/sysdeps/unix/sysv/linux/sparc/sparc64/libc.abilist
index db909d1506..800ea4d98b 100644
--- a/sysdeps/unix/sysv/linux/sparc/sparc64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/sparc/sparc64/libc.abilist
@@ -1937,6 +1937,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/sparc/sparc64/libpthread.abilist b/sysdeps/unix/sysv/linux/sparc/sparc64/libpthread.abilist
index ccc9449826..6e23c0e62d 100644
--- a/sysdeps/unix/sysv/linux/sparc/sparc64/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/sparc/sparc64/libpthread.abilist
@@ -219,6 +219,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.3.2 pthread_cond_broadcast F
 GLIBC_2.3.2 pthread_cond_destroy F
 GLIBC_2.3.2 pthread_cond_init F
diff --git a/sysdeps/unix/sysv/linux/x86_64/64/libc.abilist b/sysdeps/unix/sysv/linux/x86_64/64/libc.abilist
index 3b175f104b..b694817e55 100644
--- a/sysdeps/unix/sysv/linux/x86_64/64/libc.abilist
+++ b/sysdeps/unix/sysv/linux/x86_64/64/libc.abilist
@@ -1895,6 +1895,7 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
 GLIBC_2.3 __ctype_b_loc F
 GLIBC_2.3 __ctype_tolower_loc F
diff --git a/sysdeps/unix/sysv/linux/x86_64/64/libpthread.abilist b/sysdeps/unix/sysv/linux/x86_64/64/libpthread.abilist
index 931c8277a8..889b71fb92 100644
--- a/sysdeps/unix/sysv/linux/x86_64/64/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/x86_64/64/libpthread.abilist
@@ -219,6 +219,7 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
 GLIBC_2.3.2 pthread_cond_broadcast F
 GLIBC_2.3.2 pthread_cond_destroy F
 GLIBC_2.3.2 pthread_cond_init F
diff --git a/sysdeps/unix/sysv/linux/x86_64/x32/libc.abilist b/sysdeps/unix/sysv/linux/x86_64/x32/libc.abilist
index 1b57710477..e885d3c6eb 100644
--- a/sysdeps/unix/sysv/linux/x86_64/x32/libc.abilist
+++ b/sysdeps/unix/sysv/linux/x86_64/x32/libc.abilist
@@ -2146,4 +2146,5 @@ GLIBC_2.28 thrd_current F
 GLIBC_2.28 thrd_equal F
 GLIBC_2.28 thrd_sleep F
 GLIBC_2.28 thrd_yield F
+GLIBC_2.29 __rseq_abi T 0x20
 GLIBC_2.29 posix_spawn_file_actions_addchdir_np F
diff --git a/sysdeps/unix/sysv/linux/x86_64/x32/libpthread.abilist b/sysdeps/unix/sysv/linux/x86_64/x32/libpthread.abilist
index c09c9b015a..68886246a2 100644
--- a/sysdeps/unix/sysv/linux/x86_64/x32/libpthread.abilist
+++ b/sysdeps/unix/sysv/linux/x86_64/x32/libpthread.abilist
@@ -243,3 +243,4 @@ GLIBC_2.28 tss_create F
 GLIBC_2.28 tss_delete F
 GLIBC_2.28 tss_get F
 GLIBC_2.28 tss_set F
+GLIBC_2.29 __rseq_refcount T 0x4
-- 
2.17.1

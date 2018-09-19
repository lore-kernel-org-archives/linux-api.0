From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: [RFC PATCH] glibc: Perform rseq(2) registration at nptl init and thread creation
Date: Wed, 19 Sep 2018 10:44:38 -0400
Message-ID: <20180919144438.1066-1-mathieu.desnoyers@efficios.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Carlos O'Donell <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Will Deacon <will.deacon@arm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, libc-alpha@sourceware.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Here is a rough prototype registering rseq(2) TLS for each thread
(including main), and unregistering for each thread (excluding
main). "rseq" stands for Restartable Sequences.

Things to consider:

- Move __rseq_refcount to an extra field at the end of __rseq_abi to
  eliminate one symbol. This would require to wrap struct rseq into
  e.g. struct rseq_lib or such, e.g.:

struct rseq_lib {
  struct rseq kabi;
  int refcount;
};

All libraries/programs which try to register rseq (glibc, early-adopter
applications, early-adopter libraries) should use the rseq refcount.
It becomes part of the ABI within a user-space process, but it's not
part of the ABI shared with the kernel per se.

- Restructure how this code is organized so glibc keeps building on
  non-Linux targets.

- We do not need an atomic increment/decrement for the refcount per
  se. Just being atomic with respect to the current thread (and nested
  signals) would be enough. What is the proper API to use there ?
  Should we expose struct rseq_lib in a public glibc header ? Should
  we create a rseq(3) man page ?

- Revisit use of "weak" symbol for __rseq_abi in glibc. Perhaps we
  want a non-weak symbol there ? (and let all other early user
  libraries use weak)

- Should we pull linux/rseq.h from the Linux kernel into the glibc
  tree or keep a dependency on installed kernel headers ?

- I plan to host a librseq library containing mostly helper headers
  that vastly simplify using rseq. It will contain a librseq.so
  which provides an API to explicitly register rseq to the
  kernel (for early adopters). The refcounting mechanism in the TLS
  would be used to ensure combining librseq.so and libc.so.6 with rseq
  support works fine.

- How early do we want to register rseq and how late do we want to
  unregister it ? It's important to consider if we expect rseq to
  be used by the memory allocator and within destructor callbacks.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Carlos O'Donell <carlos@redhat.com>
CC: Florian Weimer <fweimer@redhat.com>
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
 nptl/Versions                  |   1 +
 nptl/nptl-init.c               |   3 +
 nptl/pthreadP.h                |  45 ++++++++++
 nptl/pthread_create.c          |  15 ++++
 sysdeps/unix/sysv/linux/rseq.h | 147 +++++++++++++++++++++++++++++++++
 5 files changed, 211 insertions(+)
 create mode 100644 sysdeps/unix/sysv/linux/rseq.h

diff --git a/nptl/Versions b/nptl/Versions
index e7f691da7a..7316c2815d 100644
--- a/nptl/Versions
+++ b/nptl/Versions
@@ -275,6 +275,7 @@ libpthread {
     mtx_init; mtx_lock; mtx_timedlock; mtx_trylock; mtx_unlock; mtx_destroy;
     call_once; cnd_broadcast; cnd_destroy; cnd_init; cnd_signal;
     cnd_timedwait; cnd_wait; tss_create; tss_delete; tss_get; tss_set;
+    __rseq_abi; __rseq_refcount;
   }
 
   GLIBC_PRIVATE {
diff --git a/nptl/nptl-init.c b/nptl/nptl-init.c
index 907411d5bc..0c056c3fce 100644
--- a/nptl/nptl-init.c
+++ b/nptl/nptl-init.c
@@ -431,6 +431,9 @@ __pthread_initialize_minimal_internal (void)
 
   /* Determine whether the machine is SMP or not.  */
   __is_smp = is_smp_system ();
+
+    /* Register rseq ABI to the kernel. */
+  (void) rseq_register_current_thread();
 }
 strong_alias (__pthread_initialize_minimal_internal,
 	      __pthread_initialize_minimal)
diff --git a/nptl/pthreadP.h b/nptl/pthreadP.h
index 13bdb11133..94f54c630e 100644
--- a/nptl/pthreadP.h
+++ b/nptl/pthreadP.h
@@ -33,6 +33,8 @@
 #include <kernel-features.h>
 #include <errno.h>
 #include <internal-signals.h>
+//TODO: fix sysdeps include to make it portable to non-Linux systems.
+#include <sysdeps/unix/sysv/linux/rseq.h>
 
 
 /* Atomic operations on TLS memory.  */
@@ -660,4 +662,47 @@ check_stacksize_attr (size_t st)
 		  "offset of " #member " field of " #type " != "	\
 		  ASSERT_PTHREAD_STRING (offset))
 
+//TODO: we may want to move the rseq code to a linux sysdeps file.
+#define RSEQ_SIG 0x53053053
+
+extern __thread volatile struct rseq __rseq_abi;
+extern __thread volatile int __rseq_refcount;
+
+static inline int
+rseq_register_current_thread (void)
+{
+  int rc, ret = 0;
+  INTERNAL_SYSCALL_DECL (err);
+
+  if (atomic_increment_val(&__rseq_refcount) - 1)
+    goto end;
+  rc = INTERNAL_SYSCALL_CALL(rseq, err, &__rseq_abi, sizeof(struct rseq),
+                             0, RSEQ_SIG);
+  if (!rc)
+    goto end;
+  if (INTERNAL_SYSCALL_ERRNO(rc, err) != EBUSY)
+    __rseq_abi.cpu_id = -2;
+  ret = -1;
+  atomic_decrement(&__rseq_refcount);
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
+  if (atomic_decrement_val(&__rseq_refcount))
+    goto end;
+  rc = INTERNAL_SYSCALL_CALL(rseq, err, &__rseq_abi, sizeof(struct rseq),
+                             RSEQ_FLAG_UNREGISTER, RSEQ_SIG);
+  if (!rc)
+    goto end;
+  ret = -1;
+end:
+  return ret;
+}
+
 #endif	/* pthreadP.h */
diff --git a/nptl/pthread_create.c b/nptl/pthread_create.c
index fe75d04113..20ee197d94 100644
--- a/nptl/pthread_create.c
+++ b/nptl/pthread_create.c
@@ -52,6 +52,13 @@ static struct pthread *__nptl_last_event __attribute_used__;
 /* Number of threads running.  */
 unsigned int __nptl_nthreads = 1;
 
+__attribute__((weak, tls_model("initial-exec"))) __thread
+volatile struct rseq __rseq_abi = {
+	.cpu_id = RSEQ_CPU_ID_UNINITIALIZED,
+};
+
+__attribute__((weak, tls_model("initial-exec"))) __thread
+volatile int __rseq_refcount;
 
 /* Code to allocate and deallocate a stack.  */
 #include "allocatestack.c"
@@ -378,6 +385,7 @@ __free_tcb (struct pthread *pd)
 START_THREAD_DEFN
 {
   struct pthread *pd = START_THREAD_SELF;
+  bool has_rseq = false;
 
 #if HP_TIMING_AVAIL
   /* Remember the time when the thread was started.  */
@@ -445,6 +453,9 @@ START_THREAD_DEFN
   unwind_buf.priv.data.prev = NULL;
   unwind_buf.priv.data.cleanup = NULL;
 
+  /* Register rseq TLS to the kernel. */
+  has_rseq = !rseq_register_current_thread();
+
   if (__glibc_likely (! not_first_call))
     {
       /* Store the new cleanup handler info.  */
@@ -487,6 +498,10 @@ START_THREAD_DEFN
       THREAD_SETMEM (pd, result, ret);
     }
 
+  /* Unregister rseq TLS from kernel. */
+  if (has_rseq && rseq_unregister_current_thread())
+    abort();
+
   /* Call destructors for the thread_local TLS variables.  */
 #ifndef SHARED
   if (&__call_tls_dtors != NULL)
diff --git a/sysdeps/unix/sysv/linux/rseq.h b/sysdeps/unix/sysv/linux/rseq.h
new file mode 100644
index 0000000000..9a402fdb60
--- /dev/null
+++ b/sysdeps/unix/sysv/linux/rseq.h
@@ -0,0 +1,147 @@
+/* SPDX-License-Identifier: GPL-2.0+ WITH Linux-syscall-note */
+#ifndef _UAPI_LINUX_RSEQ_H
+#define _UAPI_LINUX_RSEQ_H
+
+/*
+ * linux/rseq.h
+ *
+ * Restartable sequences system call API
+ *
+ * Copyright (c) 2015-2018 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
+ */
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+
+enum rseq_cpu_id_state {
+	RSEQ_CPU_ID_UNINITIALIZED		= -1,
+	RSEQ_CPU_ID_REGISTRATION_FAILED		= -2,
+};
+
+enum rseq_flags {
+	RSEQ_FLAG_UNREGISTER = (1 << 0),
+};
+
+enum rseq_cs_flags_bit {
+	RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT_BIT	= 0,
+	RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL_BIT	= 1,
+	RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE_BIT	= 2,
+};
+
+enum rseq_cs_flags {
+	RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT	=
+		(1U << RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT_BIT),
+	RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL	=
+		(1U << RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL_BIT),
+	RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE	=
+		(1U << RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE_BIT),
+};
+
+/*
+ * struct rseq_cs is aligned on 4 * 8 bytes to ensure it is always
+ * contained within a single cache-line. It is usually declared as
+ * link-time constant data.
+ */
+struct rseq_cs {
+	/* Version of this structure. */
+	__u32 version;
+	/* enum rseq_cs_flags */
+	__u32 flags;
+	__u64 start_ip;
+	/* Offset from start_ip. */
+	__u64 post_commit_offset;
+	__u64 abort_ip;
+} __attribute__((aligned(4 * sizeof(__u64))));
+
+/*
+ * struct rseq is aligned on 4 * 8 bytes to ensure it is always
+ * contained within a single cache-line.
+ *
+ * A single struct rseq per thread is allowed.
+ */
+struct rseq {
+	/*
+	 * Restartable sequences cpu_id_start field. Updated by the
+	 * kernel. Read by user-space with single-copy atomicity
+	 * semantics. This field should only be read by the thread which
+	 * registered this data structure. Aligned on 32-bit. Always
+	 * contains a value in the range of possible CPUs, although the
+	 * value may not be the actual current CPU (e.g. if rseq is not
+	 * initialized). This CPU number value should always be compared
+	 * against the value of the cpu_id field before performing a rseq
+	 * commit or returning a value read from a data structure indexed
+	 * using the cpu_id_start value.
+	 */
+	__u32 cpu_id_start;
+	/*
+	 * Restartable sequences cpu_id field. Updated by the kernel.
+	 * Read by user-space with single-copy atomicity semantics. This
+	 * field should only be read by the thread which registered this
+	 * data structure. Aligned on 32-bit. Values
+	 * RSEQ_CPU_ID_UNINITIALIZED and RSEQ_CPU_ID_REGISTRATION_FAILED
+	 * have a special semantic: the former means "rseq uninitialized",
+	 * and latter means "rseq initialization failed". This value is
+	 * meant to be read within rseq critical sections and compared
+	 * with the cpu_id_start value previously read, before performing
+	 * the commit instruction, or read and compared with the
+	 * cpu_id_start value before returning a value loaded from a data
+	 * structure indexed using the cpu_id_start value.
+	 */
+	__u32 cpu_id;
+	/*
+	 * Restartable sequences rseq_cs field.
+	 *
+	 * Contains NULL when no critical section is active for the current
+	 * thread, or holds a pointer to the currently active struct rseq_cs.
+	 *
+	 * Updated by user-space, which sets the address of the currently
+	 * active rseq_cs at the beginning of assembly instruction sequence
+	 * block, and set to NULL by the kernel when it restarts an assembly
+	 * instruction sequence block, as well as when the kernel detects that
+	 * it is preempting or delivering a signal outside of the range
+	 * targeted by the rseq_cs. Also needs to be set to NULL by user-space
+	 * before reclaiming memory that contains the targeted struct rseq_cs.
+	 *
+	 * Read and set by the kernel. Set by user-space with single-copy
+	 * atomicity semantics. This field should only be updated by the
+	 * thread which registered this data structure. Aligned on 64-bit.
+	 */
+	union {
+		__u64 ptr64;
+#ifdef __LP64__
+		__u64 ptr;
+#else
+		struct {
+#if (defined(__BYTE_ORDER) && (__BYTE_ORDER == __BIG_ENDIAN)) || defined(__BIG_ENDIAN)
+			__u32 padding;		/* Initialized to zero. */
+			__u32 ptr32;
+#else /* LITTLE */
+			__u32 ptr32;
+			__u32 padding;		/* Initialized to zero. */
+#endif /* ENDIAN */
+		} ptr;
+#endif
+	} rseq_cs;
+
+	/*
+	 * Restartable sequences flags field.
+	 *
+	 * This field should only be updated by the thread which
+	 * registered this data structure. Read by the kernel.
+	 * Mainly used for single-stepping through rseq critical sections
+	 * with debuggers.
+	 *
+	 * - RSEQ_CS_FLAG_NO_RESTART_ON_PREEMPT
+	 *     Inhibit instruction sequence block restart on preemption
+	 *     for this thread.
+	 * - RSEQ_CS_FLAG_NO_RESTART_ON_SIGNAL
+	 *     Inhibit instruction sequence block restart on signal
+	 *     delivery for this thread.
+	 * - RSEQ_CS_FLAG_NO_RESTART_ON_MIGRATE
+	 *     Inhibit instruction sequence block restart on migration for
+	 *     this thread.
+	 */
+	__u32 flags;
+} __attribute__((aligned(4 * sizeof(__u64))));
+
+#endif /* _UAPI_LINUX_RSEQ_H */
-- 
2.17.1

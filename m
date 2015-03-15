From: Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH v2 3/7] Introduce a new clone4 syscall with more flag bits
 and extensible arguments
Date: Sun, 15 Mar 2015 00:59:47 -0700
Message-ID: <367b888ef58831b6812c3cf80ca973c65edc67f5.1426376419.git.josh@joshtriplett.org>
References: <cover.1426376419.git.josh@joshtriplett.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1426376419.git.josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, "H. Peter Anvin" <hpa@zytor.com>, Rik van Riel <riel@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Michael Kerrisk <mtk.manpages@gmail.com>, Thiago Macieira <thiago.macieira@intel.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, x86@kernel.org
List-Id: linux-api@vger.kernel.org

clone() has no more usable flags available.  It has three now-unused
flags (CLONE_PID, CLONE_DETACHED, and CLONE_STOPPED), but current
kernels just ignore those flags without returning an error like EINVAL,
so reusing those flags would not allow userspace to detect the
availability of the new functionality.

Introduce a new system call, clone4, which accepts a second 32-bit flags
field.  clone4 also returns EINVAL for the currently unused flags in
clone, allowing their reuse.

To process these new flags, change the flags argument of _do_fork to a
u64.  sys_clone and do_fork both still use "unsigned long" for flags as
they did before, truncating it to 32-bit and masking out the obsolete
flags to behave like clone currently does.

clone4 accepts its remaining arguments as a structure, and userspace
passes in the size of that structure.  clone4 has well-defined semantics
that allow extending that structure in the future.  New userspace
passing in a larger structure than the kernel expects will receive
EINVAL, and can use a smaller structure to work with old kernels.  New
kernels accept smaller argument structures passed by userspace, and any
un-passed arguments default to 0.

clone4 handles arguments in the same order on all architectures, with no
backwards variations; to do so, it depends on the new
HAVE_COPY_THREAD_TLS.

The new system call currently accepts exactly the same flags as clone;
future commits will introduce new flags for additional functionality.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Thiago Macieira <thiago.macieira@intel.com>
---
 arch/x86/ia32/ia32entry.S         |  1 +
 arch/x86/kernel/entry_64.S        |  1 +
 arch/x86/syscalls/syscall_32.tbl  |  1 +
 arch/x86/syscalls/syscall_64.tbl  |  2 ++
 include/linux/compat.h            | 12 +++++++++
 include/uapi/asm-generic/unistd.h |  4 ++-
 include/uapi/linux/sched.h        | 36 ++++++++++++++++++++++---
 init/Kconfig                      | 10 +++++++
 kernel/fork.c                     | 56 ++++++++++++++++++++++++++++++++++++---
 kernel/sys_ni.c                   |  1 +
 10 files changed, 116 insertions(+), 8 deletions(-)

diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index 0286735..ba28306 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -483,6 +483,7 @@ GLOBAL(\label)
 	PTREGSCALL stub32_execveat, compat_sys_execveat
 	PTREGSCALL stub32_fork, sys_fork
 	PTREGSCALL stub32_vfork, sys_vfork
+	PTREGSCALL stub32_clone4, compat_sys_clone4
 
 	ALIGN
 GLOBAL(stub32_clone)
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index 1d74d16..ead143f 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -520,6 +520,7 @@ END(\label)
 	FORK_LIKE  clone
 	FORK_LIKE  fork
 	FORK_LIKE  vfork
+	FORK_LIKE  clone4
 	FIXED_FRAME stub_iopl, sys_iopl
 
 ENTRY(stub_execve)
diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index b3560ec..56fcc90 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -365,3 +365,4 @@
 356	i386	memfd_create		sys_memfd_create
 357	i386	bpf			sys_bpf
 358	i386	execveat		sys_execveat			stub32_execveat
+359	i386	clone4			sys_clone4			stub32_clone4
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 8d656fb..af15b0f 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -329,6 +329,7 @@
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
 322	64	execveat		stub_execveat
+323	64	clone4			stub_clone4
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
@@ -368,3 +369,4 @@
 543	x32	io_setup		compat_sys_io_setup
 544	x32	io_submit		compat_sys_io_submit
 545	x32	execveat		stub_x32_execveat
+546	x32	clone4			stub32_clone4
diff --git a/include/linux/compat.h b/include/linux/compat.h
index ab25814..6c4a68d 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -293,6 +293,14 @@ struct compat_old_sigaction {
 };
 #endif
 
+struct compat_clone4_args {
+	compat_uptr_t ptid;
+	compat_uptr_t ctid;
+	compat_ulong_t stack_start;
+	compat_ulong_t stack_size;
+	compat_ulong_t tls;
+};
+
 struct compat_statfs;
 struct compat_statfs64;
 struct compat_old_linux_dirent;
@@ -713,6 +721,10 @@ asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 
 asmlinkage long compat_sys_fanotify_mark(int, unsigned int, __u32, __u32,
 					    int, const char __user *);
+
+asmlinkage long compat_sys_clone4(unsigned, unsigned, compat_ulong_t,
+				  struct compat_clone4_args __user *);
+
 #else
 
 #define is_compat_task() (0)
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index e016bd9..3740166 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -709,9 +709,11 @@ __SYSCALL(__NR_memfd_create, sys_memfd_create)
 __SYSCALL(__NR_bpf, sys_bpf)
 #define __NR_execveat 281
 __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
+#define __NR_clone4 282
+__SC_COMP(__NR_clone4, sys_clone4, compat_sys_clone4)
 
 #undef __NR_syscalls
-#define __NR_syscalls 282
+#define __NR_syscalls 283
 
 /*
  * All syscalls below here should go away really,
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index cc89dde..7656152 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -1,6 +1,8 @@
 #ifndef _UAPI_LINUX_SCHED_H
 #define _UAPI_LINUX_SCHED_H
 
+#include <linux/types.h>
+
 /*
  * cloning flags:
  */
@@ -18,11 +20,8 @@
 #define CLONE_SETTLS	0x00080000	/* create a new TLS for the child */
 #define CLONE_PARENT_SETTID	0x00100000	/* set the TID in the parent */
 #define CLONE_CHILD_CLEARTID	0x00200000	/* clear the TID in the child */
-#define CLONE_DETACHED		0x00400000	/* Unused, ignored */
 #define CLONE_UNTRACED		0x00800000	/* set if the tracing process can't force CLONE_PTRACE on this clone */
 #define CLONE_CHILD_SETTID	0x01000000	/* set the TID in the child */
-/* 0x02000000 was previously the unused CLONE_STOPPED (Start in stopped state)
-   and is now available for re-use. */
 #define CLONE_NEWUTS		0x04000000	/* New utsname namespace */
 #define CLONE_NEWIPC		0x08000000	/* New ipc namespace */
 #define CLONE_NEWUSER		0x10000000	/* New user namespace */
@@ -31,6 +30,37 @@
 #define CLONE_IO		0x80000000	/* Clone io context */
 
 /*
+ * Old flags, unused by current clone.  clone does not return EINVAL for these
+ * flags, so they can't easily be reused.  clone4 can use them.
+ */
+#define CLONE_PID	0x00001000
+#define CLONE_DETACHED	0x00400000
+#define CLONE_STOPPED	0x02000000
+
+#ifdef __KERNEL__
+/*
+ * Valid flags for clone and for clone4. Kept in this file next to the flag
+ * list above, but not exposed to userspace.
+ */
+#define CLONE_VALID_FLAGS	(0xffffffffULL & ~(CLONE_PID | CLONE_DETACHED | CLONE_STOPPED))
+#define CLONE4_VALID_FLAGS	CLONE_VALID_FLAGS
+#endif /* __KERNEL__ */
+
+/*
+ * Structure passed to clone4 for additional arguments.  Initialized to 0,
+ * then overwritten with arguments from userspace, so arguments not supplied by
+ * userspace will remain 0.  New versions of the kernel may safely append new
+ * arguments to the end.
+ */
+struct clone4_args {
+	__kernel_pid_t __user *ptid;
+	__kernel_pid_t __user *ctid;
+	__kernel_ulong_t stack_start;
+	__kernel_ulong_t stack_size;
+	__kernel_ulong_t tls;
+};
+
+/*
  * Scheduling policies
  */
 #define SCHED_NORMAL		0
diff --git a/init/Kconfig b/init/Kconfig
index f5dbc6d..3ab6649 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1511,6 +1511,16 @@ config EVENTFD
 
 	  If unsure, say Y.
 
+config CLONE4
+	bool "Enable clone4() system call" if EXPERT
+	depends on HAVE_COPY_THREAD_TLS
+	default y
+	help
+	  Enable the clone4() system call, which supports passing additional
+	  flags.
+
+	  If unsure, say Y.
+
 # syscall, maps, verifier
 config BPF_SYSCALL
 	bool "Enable bpf() system call" if EXPERT
diff --git a/kernel/fork.c b/kernel/fork.c
index b3dadf4..8a21f9e 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1187,7 +1187,7 @@ init_task_pid(struct task_struct *task, enum pid_type type, struct pid *pid)
  * parts of the process environment (as per the clone
  * flags). The actual kick-off is left to the caller.
  */
-static struct task_struct *copy_process(unsigned long clone_flags,
+static struct task_struct *copy_process(u64 clone_flags,
 					unsigned long stack_start,
 					unsigned long stack_size,
 					int __user *child_tidptr,
@@ -1198,6 +1198,9 @@ static struct task_struct *copy_process(unsigned long clone_flags,
 	int retval;
 	struct task_struct *p;
 
+	if (clone_flags & ~CLONE4_VALID_FLAGS)
+		return ERR_PTR(-EINVAL);
+
 	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
 		return ERR_PTR(-EINVAL);
 
@@ -1630,7 +1633,7 @@ struct task_struct *fork_idle(int cpu)
  * it and waits for it to finish using the VM if required.
  */
 static long _do_fork(
-		unsigned long clone_flags,
+		u64 clone_flags,
 		unsigned long stack_start,
 		unsigned long stack_size,
 		int __user *parent_tidptr,
@@ -1701,6 +1704,15 @@ static long _do_fork(
 	return nr;
 }
 
+/*
+ * Convenience function for callers passing unsigned long flags, to prevent old
+ * syscall entry points from unexpectedly returning EINVAL.
+ */
+static inline u64 squelch_clone_flags(unsigned long clone_flags)
+{
+	return clone_flags & CLONE_VALID_FLAGS;
+}
+
 #ifndef CONFIG_HAVE_COPY_THREAD_TLS
 /* For compatibility with architectures that call do_fork directly rather than
  * using the syscall entry points below. */
@@ -1710,7 +1722,8 @@ long do_fork(unsigned long clone_flags,
 	      int __user *parent_tidptr,
 	      int __user *child_tidptr)
 {
-	return _do_fork(clone_flags, stack_start, stack_size,
+	return _do_fork(squelch_clone_flags(clone_flags),
+			stack_start, stack_size,
 			parent_tidptr, child_tidptr, 0);
 }
 #endif
@@ -1768,10 +1781,45 @@ SYSCALL_DEFINE5(clone, unsigned long, clone_flags, unsigned long, newsp,
 		 unsigned long, tls)
 #endif
 {
-	return _do_fork(clone_flags, newsp, 0, parent_tidptr, child_tidptr, tls);
+	return _do_fork(squelch_clone_flags(clone_flags), newsp, 0,
+			parent_tidptr, child_tidptr, tls);
 }
 #endif
 
+#ifdef CONFIG_CLONE4
+SYSCALL_DEFINE4(clone4, unsigned, flags_high, unsigned, flags_low,
+		unsigned long, args_size, struct clone4_args __user *, args)
+{
+	u64 flags = (u64)flags_high << 32 | flags_low;
+	struct clone4_args kargs = {};
+	if (args_size > sizeof(kargs))
+		return -EINVAL;
+	if (args_size && copy_from_user(&kargs, args, args_size))
+		return -EFAULT;
+	return _do_fork(flags, kargs.stack_start, kargs.stack_size,
+			kargs.ptid, kargs.ctid, kargs.tls);
+}
+
+#ifdef CONFIG_COMPAT
+COMPAT_SYSCALL_DEFINE4(clone4, unsigned, flags_high, unsigned, flags_low,
+			compat_ulong_t, args_size,
+			struct compat_clone4_args __user *, args)
+{
+	u64 flags = (u64)flags_high << 32 | flags_low;
+	struct compat_clone4_args compat_kargs = {};
+	if (args_size > sizeof(compat_kargs))
+		return -EINVAL;
+	if (args_size && copy_from_user(&compat_kargs, args, args_size))
+		return -EFAULT;
+	return _do_fork(flags, compat_kargs.stack_start,
+			compat_kargs.stack_size,
+			compat_ptr(compat_kargs.ptid),
+			compat_ptr(compat_kargs.ctid),
+			compat_kargs.tls);
+}
+#endif /* CONFIG_COMPAT */
+#endif /* CONFIG_CLONE4 */
+
 #ifndef ARCH_MIN_MMSTRUCT_ALIGN
 #define ARCH_MIN_MMSTRUCT_ALIGN 0
 #endif
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 5adcb0a..5b5d2b9 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -159,6 +159,7 @@ cond_syscall(sys_uselib);
 cond_syscall(sys_fadvise64);
 cond_syscall(sys_fadvise64_64);
 cond_syscall(sys_madvise);
+cond_syscall(sys_clone4);
 
 /* arch-specific weak syscall entries */
 cond_syscall(sys_pciconfig_read);
-- 
2.1.4

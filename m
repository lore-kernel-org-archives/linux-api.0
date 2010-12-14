From: Dan Smith <danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 06/19] c/r: create syscalls: sys_checkpoint, sys_restart
Date: Tue, 14 Dec 2010 08:14:54 -0800
Message-ID: <1292343307-7870-6-git-send-email-danms@us.ibm.com>
References: <1292343307-7870-1-git-send-email-danms@us.ibm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292343307-7870-1-git-send-email-danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: danms-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org, Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>, Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

From: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>

Create trivial sys_checkpoint and sys_restore system calls. They will
enable to checkpoint and restart an entire container, to and from a
checkpoint image file descriptor.

The syscalls take a pid, a file descriptor (for the image file) and
flags as arguments. The pid identifies the top-most (root) task in the
process tree, e.g. the container init: for sys_checkpoint the first
argument identifies the pid of the target container/subtree; for
sys_restart it will identify the pid of restarting root task.

A checkpoint, much like a process coredump, dumps the state of multiple
processes at once, including the state of the container. The checkpoint
image is written to (and read from) the file descriptor directly from
the kernel. This way the data is generated and then pushed out naturally
as resources and tasks are scanned to save their state. This is the
approach taken by, e.g., Zap and OpenVZ.

By using a return value and not a file descriptor, we can distinguish
between a return from checkpoint, a return from restart (in case of a
checkpoint that includes self, i.e. a task checkpointing its own
container, or itself), and an error condition, in a manner analogous
to a fork() call.

We don't use copy_from_user()/copy_to_user() because it requires
holding the entire image in user space, and does not make sense for
restart.  Also, we don't use a pipe, pseudo-fs file and the like,
because they work by generating data on demand as the user pulls it
(unless the entire image is buffered in the kernel) and would require
more complex logic.  They also would significantly complicate
checkpoint that includes self.

Changelog[v21-rc3]:
  - Reorganize code:move checkpoint/* to kernel/checkpoint/*
Changelog[v19-rc1]:
  - Add 'int logfd' to prototype of sys_{checkpoint,restart}
Changelog[v18]:
  - [John Dykstra] Fix no-dot-config-targets pattern in linux/Makefile
Changelog[v17]:
  - Move checkpoint closer to namespaces (kconfig)
  - Kill "Enable" in c/r config option
Changelog[v16]:
  - Change sys_restart() first argument to be 'pid_t pid'
Changelog[v14]:
  - Change CONFIG_CHEKCPOINT_RESTART to CONFIG_CHECKPOINT (Ingo)
  - Remove line 'def_bool n' (default is already 'n')
  - Add CHECKPOINT_SUPPORT in Kconfig (Nathan Lynch)
Changelog[v5]:
  - Config is 'def_bool n' by default

Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org
Signed-off-by: Oren Laadan <orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org>
Signed-off-by: Dave Hansen <dave-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Acked-by: Serge E. Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Tested-by: Serge E. Hallyn <serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
---
 Makefile                           |    2 +-
 arch/x86/Kconfig                   |    4 +++
 arch/x86/include/asm/unistd_32.h   |    4 ++-
 arch/x86/kernel/syscall_table_32.S |    2 +
 include/linux/syscalls.h           |    4 +++
 init/Kconfig                       |    2 +
 kernel/Makefile                    |    1 +
 kernel/checkpoint/Kconfig          |   14 +++++++++++
 kernel/checkpoint/Makefile         |    5 ++++
 kernel/checkpoint/sys.c            |   45 ++++++++++++++++++++++++++++++++++++
 kernel/sys_ni.c                    |    4 +++
 11 files changed, 85 insertions(+), 2 deletions(-)
 create mode 100644 kernel/checkpoint/Kconfig
 create mode 100644 kernel/checkpoint/Makefile
 create mode 100644 kernel/checkpoint/sys.c

diff --git a/Makefile b/Makefile
index ab5359d..38f5a25 100644
--- a/Makefile
+++ b/Makefile
@@ -421,7 +421,7 @@ endif
 
 no-dot-config-targets := clean mrproper distclean \
 			 cscope TAGS tags help %docs check% coccicheck \
-			 include/linux/version.h headers_% \
+			 checkstack include/linux/version.h headers_% \
 			 kernelversion %src-pkg
 
 config-targets := 0
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index e832768..0e043fa 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -101,6 +101,10 @@ config STACKTRACE_SUPPORT
 config HAVE_LATENCYTOP_SUPPORT
 	def_bool y
 
+config CHECKPOINT_SUPPORT
+	bool
+	default y if X86_32
+
 config MMU
 	def_bool y
 
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index b766a5e..a2d589f 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -346,10 +346,12 @@
 #define __NR_fanotify_init	338
 #define __NR_fanotify_mark	339
 #define __NR_prlimit64		340
+#define __NR_checkpoint		341
+#define __NR_restart		342
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 341
+#define NR_syscalls 343
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index b35786d..13fbe8a 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -340,3 +340,5 @@ ENTRY(sys_call_table)
 	.long sys_fanotify_init
 	.long sys_fanotify_mark
 	.long sys_prlimit64		/* 340 */
+	.long ptregs_checkpoint
+	.long ptregs_restart
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index cacc27a..20be1a6 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -820,6 +820,10 @@ asmlinkage long sys_fanotify_init(unsigned int flags, unsigned int event_f_flags
 asmlinkage long sys_fanotify_mark(int fanotify_fd, unsigned int flags,
 				  u64 mask, int fd,
 				  const char  __user *pathname);
+asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags,
+			       int logfd);
+asmlinkage long sys_restart(pid_t pid, int fd, unsigned long flags,
+			    int logfd);
 
 int kernel_execve(const char *filename, const char *const argv[], const char *const envp[]);
 
diff --git a/init/Kconfig b/init/Kconfig
index 88c1046..75650df 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -780,6 +780,8 @@ config RELAY
 
 	  If unsure, say N.
 
+source "kernel/checkpoint/Kconfig"
+
 config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
diff --git a/kernel/Makefile b/kernel/Makefile
index 0b5ff08..3f6238c 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -106,6 +106,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
+obj-$(CONFIG_CHECKPOINT) += checkpoint/
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan-HpYC8cTCicIJY7gZg3T8ig@public.gmane.org>, the -fno-omit-frame-pointer is
diff --git a/kernel/checkpoint/Kconfig b/kernel/checkpoint/Kconfig
new file mode 100644
index 0000000..ef7d406
--- /dev/null
+++ b/kernel/checkpoint/Kconfig
@@ -0,0 +1,14 @@
+# Architectures should define CHECKPOINT_SUPPORT when they have
+# implemented the hooks for processor state etc. needed by the
+# core checkpoint/restart code.
+
+config CHECKPOINT
+	bool "Checkpoint/restart (EXPERIMENTAL)"
+	depends on CHECKPOINT_SUPPORT && EXPERIMENTAL
+	help
+	  Application checkpoint/restart is the ability to save the
+	  state of a running application so that it can later resume
+	  its execution from the time at which it was checkpointed.
+
+	  Turning this option on will enable checkpoint and restart
+	  functionality in the kernel.
diff --git a/kernel/checkpoint/Makefile b/kernel/checkpoint/Makefile
new file mode 100644
index 0000000..8a32c6f
--- /dev/null
+++ b/kernel/checkpoint/Makefile
@@ -0,0 +1,5 @@
+#
+# Makefile for linux checkpoint/restart.
+#
+
+obj-$(CONFIG_CHECKPOINT) += sys.o
diff --git a/kernel/checkpoint/sys.c b/kernel/checkpoint/sys.c
new file mode 100644
index 0000000..a81750a
--- /dev/null
+++ b/kernel/checkpoint/sys.c
@@ -0,0 +1,45 @@
+/*
+ *  Generic container checkpoint-restart
+ *
+ *  Copyright (C) 2008-2009 Oren Laadan
+ *
+ *  This file is subject to the terms and conditions of the GNU General Public
+ *  License.  See the file COPYING in the main directory of the Linux
+ *  distribution for more details.
+ */
+
+#include <linux/sched.h>
+#include <linux/kernel.h>
+#include <linux/syscalls.h>
+
+/**
+ * sys_checkpoint - checkpoint a container
+ * @pid: pid of the container init(1) process
+ * @fd: file to which dump the checkpoint image
+ * @flags: checkpoint operation flags
+ * @logfd: fd to which to dump debug and error messages
+ *
+ * Returns positive identifier on success, 0 when returning from restart
+ * or negative value on error
+ */
+SYSCALL_DEFINE4(checkpoint, pid_t, pid, int, fd,
+		unsigned long, flags, int, logfd)
+{
+	return -ENOSYS;
+}
+
+/**
+ * sys_restart - restart a container
+ * @pid: pid of task root (in coordinator's namespace), or 0
+ * @fd: file from which read the checkpoint image
+ * @flags: restart operation flags
+ * @logfd: fd to which to dump debug and error messages
+ *
+ * Returns negative value on error, or otherwise returns in the realm
+ * of the original checkpoint
+ */
+SYSCALL_DEFINE4(restart, pid_t, pid, int, fd,
+		unsigned long, flags, int, logfd)
+{
+	return -ENOSYS;
+}
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index c782fe9..b73a106 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -186,3 +186,7 @@ cond_syscall(sys_perf_event_open);
 /* fanotify! */
 cond_syscall(sys_fanotify_init);
 cond_syscall(sys_fanotify_mark);
+
+/* checkpoint/restart */
+cond_syscall(sys_checkpoint);
+cond_syscall(sys_restart);
-- 
1.7.2.2

From: Oren Laadan <orenl@cs.columbia.edu>
Subject: [PATCH v21 021/100] c/r: create syscalls: sys_checkpoint, sys_restart
Date: Sat,  1 May 2010 10:15:03 -0400
Message-ID: <1272723382-19470-22-git-send-email-orenl@cs.columbia.edu>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>, Matt Helsley <matthltc@us.ibm.com>, Pavel Emelyanov <xemul@openvz.org>, Oren Laadan <orenl@cs.columbia.edu>, linux-api@vger.kernel.org, x86@kernel.org, linux-s390@vger.kernel.org, linuxppc-dev@ozlabs.org, Dave Hansen <dave@linux.vnet.ibm.com>
List-Id: linux-api@vger.kernel.org

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

Cc: linux-api@vger.kernel.org
Cc: x86@kernel.org
Cc: linux-s390@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org
Signed-off-by: Oren Laadan <orenl@cs.columbia.edu>
Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Acked-by: Serge E. Hallyn <serue@us.ibm.com>
Tested-by: Serge E. Hallyn <serue@us.ibm.com>
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
index fa1db90..93be4e1 100644
--- a/Makefile
+++ b/Makefile
@@ -409,7 +409,7 @@ endif
 # of make so .config is not included in this case either (for *config).
 
 no-dot-config-targets := clean mrproper distclean \
-			 cscope TAGS tags help %docs check% \
+			 cscope TAGS tags help %docs checkstack \
 			 include/linux/version.h headers_% \
 			 kernelrelease kernelversion
 
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 9458685..0874484 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -93,6 +93,10 @@ config STACKTRACE_SUPPORT
 config HAVE_LATENCYTOP_SUPPORT
 	def_bool y
 
+config CHECKPOINT_SUPPORT
+	bool
+	default y if X86_32
+
 config MMU
 	def_bool y
 
diff --git a/arch/x86/include/asm/unistd_32.h b/arch/x86/include/asm/unistd_32.h
index e543b0e..007d7cd 100644
--- a/arch/x86/include/asm/unistd_32.h
+++ b/arch/x86/include/asm/unistd_32.h
@@ -344,10 +344,12 @@
 #define __NR_perf_event_open	336
 #define __NR_recvmmsg		337
 #define __NR_eclone		338
+#define __NR_checkpoint		339
+#define __NR_restart		340
 
 #ifdef __KERNEL__
 
-#define NR_syscalls 339
+#define NR_syscalls 341
 
 #define __ARCH_WANT_IPC_PARSE_VERSION
 #define __ARCH_WANT_OLD_READDIR
diff --git a/arch/x86/kernel/syscall_table_32.S b/arch/x86/kernel/syscall_table_32.S
index 0c92570..2d5a6b0 100644
--- a/arch/x86/kernel/syscall_table_32.S
+++ b/arch/x86/kernel/syscall_table_32.S
@@ -338,3 +338,5 @@ ENTRY(sys_call_table)
 	.long sys_perf_event_open
 	.long sys_recvmmsg
 	.long ptregs_eclone
+	.long sys_checkpoint
+	.long sys_restart		/* 340 */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 057929b..d1d1703 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -834,6 +834,10 @@ asmlinkage long sys_pselect6(int, fd_set __user *, fd_set __user *,
 asmlinkage long sys_ppoll(struct pollfd __user *, unsigned int,
 			  struct timespec __user *, const sigset_t __user *,
 			  size_t);
+asmlinkage long sys_checkpoint(pid_t pid, int fd, unsigned long flags,
+			       int logfd);
+asmlinkage long sys_restart(pid_t pid, int fd, unsigned long flags,
+			    int logfd);
 
 int kernel_execve(const char *filename, char *const argv[], char *const envp[]);
 
diff --git a/init/Kconfig b/init/Kconfig
index bd8174f..2345902 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -715,6 +715,8 @@ config NET_NS
 	  Allow user space to create what appear to be multiple instances
 	  of the network stack.
 
+source "kernel/checkpoint/Kconfig"
+
 config BLK_DEV_INITRD
 	bool "Initial RAM filesystem and RAM disk (initramfs/initrd) support"
 	depends on BROKEN || !FRV
diff --git a/kernel/Makefile b/kernel/Makefile
index a987aa1..1b78cca 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -105,6 +105,7 @@ obj-$(CONFIG_PERF_EVENTS) += perf_event.o
 obj-$(CONFIG_HAVE_HW_BREAKPOINT) += hw_breakpoint.o
 obj-$(CONFIG_USER_RETURN_NOTIFIER) += user-return-notifier.o
 obj-$(CONFIG_PADATA) += padata.o
+obj-$(CONFIG_CHECKPOINT) += checkpoint/
 
 ifneq ($(CONFIG_SCHED_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
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
index 70f2ea7..0206aca 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -181,3 +181,7 @@ cond_syscall(sys_eventfd2);
 
 /* performance counters: */
 cond_syscall(sys_perf_event_open);
+
+/* checkpoint/restart */
+cond_syscall(sys_checkpoint);
+cond_syscall(sys_restart);
-- 
1.6.3.3

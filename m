From: Aubrey Li <aubrey.li@linux.intel.com>
Subject: [PATCH v17 1/3] proc: add /proc/<pid>/arch_status
Date: Mon, 22 Apr 2019 02:35:27 +0800
Message-ID: <20190421183529.9141-1-aubrey.li@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: tglx@linutronix.de, mingo@redhat.com, peterz@infradead.org, hpa@zytor.com
Cc: ak@linux.intel.com, tim.c.chen@linux.intel.com, dave.hansen@intel.com, arjan@linux.intel.com, adobriyan@gmail.com, akpm@linux-foundation.org, aubrey.li@intel.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Aubrey Li <aubrey.li@linux.intel.com>, Andy Lutomirski <luto@kernel.org>
List-Id: linux-api@vger.kernel.org

The architecture specific information of the running processes
could be useful to the userland. Add /proc/<pid>/arch_status
interface support to examine process architecture specific
information externally.

Signed-off-by: Aubrey Li <aubrey.li@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Linux API <linux-api@vger.kernel.org>
---
 arch/x86/Kconfig |  1 +
 fs/proc/Kconfig  | 10 ++++++++++
 fs/proc/base.c   | 23 +++++++++++++++++++++++
 3 files changed, 34 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5ad92419be19..d5a9c5ddd453 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -208,6 +208,7 @@ config X86
 	select USER_STACKTRACE_SUPPORT
 	select VIRT_TO_BUS
 	select X86_FEATURE_NAMES		if PROC_FS
+	select PROC_PID_ARCH_STATUS		if PROC_FS
 
 config INSTRUCTION_DECODER
 	def_bool y
diff --git a/fs/proc/Kconfig b/fs/proc/Kconfig
index 817c02b13b1d..101bf5054e81 100644
--- a/fs/proc/Kconfig
+++ b/fs/proc/Kconfig
@@ -97,3 +97,13 @@ config PROC_CHILDREN
 
 	  Say Y if you are running any user-space software which takes benefit from
 	  this interface. For example, rkt is such a piece of software.
+
+config PROC_PID_ARCH_STATUS
+	bool "Enable /proc/<pid>/arch_status file"
+	default n
+	help
+	  Provides a way to examine process architecture specific information.
+	  See <file:Documentation/filesystems/proc.txt> for more information.
+
+	  Say Y if you are running any user-space software which wants to obtain
+	  process architecture specific information from this interface.
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6a803a0b75df..a890d9f12851 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -94,6 +94,7 @@
 #include <linux/sched/debug.h>
 #include <linux/sched/stat.h>
 #include <linux/posix-timers.h>
+#include <linux/processor.h>
 #include <trace/events/oom.h>
 #include "internal.h"
 #include "fd.h"
@@ -2957,6 +2958,22 @@ static int proc_stack_depth(struct seq_file *m, struct pid_namespace *ns,
 }
 #endif /* CONFIG_STACKLEAK_METRICS */
 
+/*
+ * Add support for task architecture specific output in /proc/pid/arch_status.
+ * task_arch_status() must be defined in asm/processor.h
+ */
+#ifdef CONFIG_PROC_PID_ARCH_STATUS
+# ifndef task_arch_status
+# define task_arch_status(m, task)
+# endif
+static int proc_pid_arch_status(struct seq_file *m, struct pid_namespace *ns,
+				struct pid *pid, struct task_struct *task)
+{
+	task_arch_status(m, task);
+	return 0;
+}
+#endif /* CONFIG_PROC_PID_ARCH_STATUS */
+
 /*
  * Thread groups
  */
@@ -3061,6 +3078,9 @@ static const struct pid_entry tgid_base_stuff[] = {
 #ifdef CONFIG_STACKLEAK_METRICS
 	ONE("stack_depth", S_IRUGO, proc_stack_depth),
 #endif
+#ifdef CONFIG_PROC_PID_ARCH_STATUS
+	ONE("arch_status", S_IRUGO, proc_pid_arch_status),
+#endif
 };
 
 static int proc_tgid_base_readdir(struct file *file, struct dir_context *ctx)
@@ -3449,6 +3469,9 @@ static const struct pid_entry tid_base_stuff[] = {
 #ifdef CONFIG_LIVEPATCH
 	ONE("patch_state",  S_IRUSR, proc_pid_patch_state),
 #endif
+#ifdef CONFIG_PROC_PID_ARCH_STATUS
+	ONE("arch_status", S_IRUGO, proc_pid_arch_status),
+#endif
 };
 
 static int proc_tid_base_readdir(struct file *file, struct dir_context *ctx)
-- 
2.17.1

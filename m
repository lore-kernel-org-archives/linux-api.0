From: Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH v4 1/4] seccomp: Add sysctl to display available actions
Date: Tue, 14 Feb 2017 03:55:56 +0000
Message-ID: <1487044559-6351-2-git-send-email-tyhicks@canonical.com>
References: <1487044559-6351-1-git-send-email-tyhicks@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487044559-6351-1-git-send-email-tyhicks@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Moore <paul@paul-moore.com>, Eric Paris <eparis@redhat.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org, John Crispin <john@phrozen.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patch creates a read-only sysctl containing an ordered list of
seccomp actions that the kernel supports. The ordering, from left to
right, is the lowest action value (kill) to the highest action value
(allow). Currently, a read of the sysctl file would return "kill trap
errno trace allow". The contents of this sysctl file can be useful for
userspace code as well as the system administrator.

The path to the sysctl is:

  /proc/sys/kernel/seccomp/actions_avail

libseccomp and other userspace code can easily determine which actions
the current kernel supports. The set of actions supported by the current
kernel may be different than the set of action macros found in kernel
headers that were installed where the userspace code was built.

In addition, this sysctl will allow system administrators to know which
actions are supported by the kernel and make it easier to configure
exactly what seccomp logs through the audit subsystem. Support for this
level of logging configuration will come in a future patch.

Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
---
 Documentation/prctl/seccomp_filter.txt | 16 ++++++++++
 Documentation/sysctl/kernel.txt        |  1 +
 kernel/seccomp.c                       | 55 ++++++++++++++++++++++++++++++++++
 3 files changed, 72 insertions(+)

diff --git a/Documentation/prctl/seccomp_filter.txt b/Documentation/prctl/seccomp_filter.txt
index 1e469ef..a5554ff 100644
--- a/Documentation/prctl/seccomp_filter.txt
+++ b/Documentation/prctl/seccomp_filter.txt
@@ -166,7 +166,23 @@ The samples/seccomp/ directory contains both an x86-specific example
 and a more generic example of a higher level macro interface for BPF
 program generation.
 
+Sysctls
+-------
+
+Seccomp's sysctl files can be found in the /proc/sys/kernel/seccomp/
+directory. Here's a description of each file in that directory:
+
+actions_avail:
+	A read-only ordered list of seccomp return values (refer to the
+	SECCOMP_RET_* macros above) in string form. The ordering, from
+	left-to-right, is the least permissive return value to the most
+	permissive return value.
 
+	The list represents the set of seccomp return values supported
+	by the kernel. A userspace program may use this list to
+	determine if the actions found in the seccomp.h, when the
+	program was built, differs from the set of actions actually
+	supported in the current running kernel.
 
 Adding architecture support
 -----------------------
diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index a32b4b7..56f9b29 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -74,6 +74,7 @@ show up in /proc/sys/kernel:
 - reboot-cmd                  [ SPARC only ]
 - rtsig-max
 - rtsig-nr
+- seccomp/                    ==> Documentation/prctl/seccomp_filter.txt
 - sem
 - sem_next_id		      [ sysv ipc ]
 - sg-big-buff                 [ generic SCSI device (sg) ]
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index f7ce79a..e36dfe9 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -16,10 +16,12 @@
 #include <linux/atomic.h>
 #include <linux/audit.h>
 #include <linux/compat.h>
+#include <linux/kmemleak.h>
 #include <linux/sched.h>
 #include <linux/seccomp.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
+#include <linux/sysctl.h>
 
 #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
 #include <asm/syscall.h>
@@ -905,3 +907,56 @@ long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
 	return ret;
 }
 #endif
+
+#ifdef CONFIG_SYSCTL
+
+/* Human readable action names for friendly sysctl interaction */
+#define SECCOMP_RET_KILL_NAME		"kill"
+#define SECCOMP_RET_TRAP_NAME		"trap"
+#define SECCOMP_RET_ERRNO_NAME		"errno"
+#define SECCOMP_RET_TRACE_NAME		"trace"
+#define SECCOMP_RET_ALLOW_NAME		"allow"
+
+static char seccomp_actions_avail[] = SECCOMP_RET_KILL_NAME	" "
+				      SECCOMP_RET_TRAP_NAME	" "
+				      SECCOMP_RET_ERRNO_NAME	" "
+				      SECCOMP_RET_TRACE_NAME	" "
+				      SECCOMP_RET_ALLOW_NAME;
+
+static struct ctl_path seccomp_sysctl_path[] = {
+	{ .procname = "kernel", },
+	{ .procname = "seccomp", },
+	{ }
+};
+
+static struct ctl_table seccomp_sysctl_table[] = {
+	{
+		.procname	= "actions_avail",
+		.data		= &seccomp_actions_avail,
+		.maxlen		= sizeof(seccomp_actions_avail),
+		.mode		= 0444,
+		.proc_handler	= proc_dostring,
+	},
+	{ }
+};
+
+static int __init seccomp_sysctl_init(void)
+{
+	struct ctl_table_header *hdr;
+
+	hdr = register_sysctl_paths(seccomp_sysctl_path, seccomp_sysctl_table);
+	if (!hdr)
+		pr_warn("seccomp: sysctl registration failed\n");
+	else
+		kmemleak_not_leak(hdr);
+
+	return 0;
+}
+
+#else /* CONFIG_SYSCTL */
+
+static __init int seccomp_sysctl_init(void) { return 0; }
+
+#endif /* CONFIG_SYSCTL */
+
+device_initcall(seccomp_sysctl_init)
-- 
2.7.4

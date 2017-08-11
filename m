From: Tyler Hicks <tyhicks@canonical.com>
Subject: [PATCH v6 1/6] seccomp: Sysctl to display available actions
Date: Fri, 11 Aug 2017 04:33:52 +0000
Message-ID: <1502426037-3777-2-git-send-email-tyhicks@canonical.com>
References: <1502426037-3777-1-git-send-email-tyhicks@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <1502426037-3777-1-git-send-email-tyhicks@canonical.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
To: Kees Cook <keescook@chromium.org>
Cc: Tycho Andersen <tycho@docker.com>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, linux-audit@redhat.com, John Crispin <john@phrozen.org>, Will Drewry <wad@chromium.org>
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
 Documentation/sysctl/kernel.txt                |  1 +
 Documentation/userspace-api/seccomp_filter.rst | 16 ++++++++
 kernel/seccomp.c                               | 51 ++++++++++++++++++++++++++
 3 files changed, 68 insertions(+)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index bac23c1..995c42c 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -74,6 +74,7 @@ show up in /proc/sys/kernel:
 - reboot-cmd                  [ SPARC only ]
 - rtsig-max
 - rtsig-nr
+- seccomp/                    ==> Documentation/userspace-api/seccomp_filter.rst
 - sem
 - sem_next_id		      [ sysv ipc ]
 - sg-big-buff                 [ generic SCSI device (sg) ]
diff --git a/Documentation/userspace-api/seccomp_filter.rst b/Documentation/userspace-api/seccomp_filter.rst
index f71eb5e..35fc7cb 100644
--- a/Documentation/userspace-api/seccomp_filter.rst
+++ b/Documentation/userspace-api/seccomp_filter.rst
@@ -169,7 +169,23 @@ The ``samples/seccomp/`` directory contains both an x86-specific example
 and a more generic example of a higher level macro interface for BPF
 program generation.
 
+Sysctls
+=======
+
+Seccomp's sysctl files can be found in the ``/proc/sys/kernel/seccomp/``
+directory. Here's a description of each file in that directory:
+
+``actions_avail``:
+	A read-only ordered list of seccomp return values (refer to the
+	``SECCOMP_RET_*`` macros above) in string form. The ordering, from
+	left-to-right, is the least permissive return value to the most
+	permissive return value.
 
+	The list represents the set of seccomp return values supported
+	by the kernel. A userspace program may use this list to
+	determine if the actions found in the ``seccomp.h``, when the
+	program was built, differs from the set of actions actually
+	supported in the current running kernel.
 
 Adding architecture support
 ===========================
diff --git a/kernel/seccomp.c b/kernel/seccomp.c
index 6a196d1..ee77eb3 100644
--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -17,11 +17,13 @@
 #include <linux/audit.h>
 #include <linux/compat.h>
 #include <linux/coredump.h>
+#include <linux/kmemleak.h>
 #include <linux/sched.h>
 #include <linux/sched/task_stack.h>
 #include <linux/seccomp.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
+#include <linux/sysctl.h>
 
 #ifdef CONFIG_HAVE_ARCH_SECCOMP_FILTER
 #include <asm/syscall.h>
@@ -980,3 +982,52 @@ long seccomp_get_filter(struct task_struct *task, unsigned long filter_off,
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
+static const char seccomp_actions_avail[] = SECCOMP_RET_KILL_NAME	" "
+					    SECCOMP_RET_TRAP_NAME	" "
+					    SECCOMP_RET_ERRNO_NAME	" "
+					    SECCOMP_RET_TRACE_NAME	" "
+					    SECCOMP_RET_ALLOW_NAME;
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
+		.data		= (void *) &seccomp_actions_avail,
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
+device_initcall(seccomp_sysctl_init)
+
+#endif /* CONFIG_SYSCTL */
-- 
2.7.4

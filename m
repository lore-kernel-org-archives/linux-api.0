From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [PATCH bpf-next v8 08/11] landlock: Add ptrace restrictions
Date: Tue, 27 Feb 2018 01:41:18 +0100
Message-ID: <20180227004121.3633-9-mic@digikod.net>
References: <20180227004121.3633-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180227004121.3633-1-mic@digikod.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Alexei Starovoitov <ast@kernel.org>, Andy Lutomirski <luto@amacapital.net>, Arnaldo Carvalho de Melo <acme@kernel.org>, Casey Schaufler <casey@schaufler-ca.com>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, "David S . Miller" <davem@davemloft.net>, "Eric W . Biederman" <ebiederm@xmission.com>, James Morris <james.l.morris@oracle.com>, Jann Horn <jann@thejh.net>, Jonathan Corbet <corbet@lwn.net>, Michael Kerrisk <mtk.manpages@gmail.com>, Kees Cook <keescook@chromium.org>, Paul Moore <paul@paul-moore.com>, Sargun Dhillon <sargun@sargun.me>, "Serge E . Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Thomas Graf <tgraf@suug.ch>
List-Id: linux-api@vger.kernel.org

A landlocked process has less privileges than a non-landlocked process
and must then be subject to additional restrictions when manipulating
processes. To be allowed to use ptrace(2) and related syscalls on a
target process, a landlocked process must have a subset of the target
process' rules.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: David S. Miller <davem@davemloft.net>
Cc: James Morris <james.l.morris@oracle.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Serge E. Hallyn <serge@hallyn.com>
---

Changes since v6:
* factor out ptrace check
* constify pointers
* cleanup headers
* use the new security_add_hooks()
---
 security/landlock/Makefile       |   2 +-
 security/landlock/hooks_ptrace.c | 124 +++++++++++++++++++++++++++++++++++++++
 security/landlock/hooks_ptrace.h |  11 ++++
 security/landlock/init.c         |   2 +
 4 files changed, 138 insertions(+), 1 deletion(-)
 create mode 100644 security/landlock/hooks_ptrace.c
 create mode 100644 security/landlock/hooks_ptrace.h

diff --git a/security/landlock/Makefile b/security/landlock/Makefile
index d0f532a93b4e..605504d852d3 100644
--- a/security/landlock/Makefile
+++ b/security/landlock/Makefile
@@ -3,4 +3,4 @@ obj-$(CONFIG_SECURITY_LANDLOCK) := landlock.o
 landlock-y := init.o chain.o task.o \
 	tag.o tag_fs.o \
 	enforce.o enforce_seccomp.o \
-	hooks.o hooks_cred.o hooks_fs.o
+	hooks.o hooks_cred.o hooks_fs.o hooks_ptrace.o
diff --git a/security/landlock/hooks_ptrace.c b/security/landlock/hooks_ptrace.c
new file mode 100644
index 000000000000..f1b977b9c808
--- /dev/null
+++ b/security/landlock/hooks_ptrace.c
@@ -0,0 +1,124 @@
+/*
+ * Landlock LSM - ptrace hooks
+ *
+ * Copyright © 2017 Mickaël Salaün <mic@digikod.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+#include <asm/current.h>
+#include <linux/errno.h>
+#include <linux/kernel.h> /* ARRAY_SIZE */
+#include <linux/lsm_hooks.h>
+#include <linux/sched.h> /* struct task_struct */
+#include <linux/seccomp.h>
+
+#include "common.h" /* struct landlock_prog_set */
+#include "hooks.h" /* landlocked() */
+#include "hooks_ptrace.h"
+
+static bool progs_are_subset(const struct landlock_prog_set *parent,
+		const struct landlock_prog_set *child)
+{
+	size_t i;
+
+	if (!parent || !child)
+		return false;
+	if (parent == child)
+		return true;
+
+	for (i = 0; i < ARRAY_SIZE(child->programs); i++) {
+		struct landlock_prog_list *walker;
+		bool found_parent = false;
+
+		if (!parent->programs[i])
+			continue;
+		for (walker = child->programs[i]; walker;
+				walker = walker->prev) {
+			if (walker == parent->programs[i]) {
+				found_parent = true;
+				break;
+			}
+		}
+		if (!found_parent)
+			return false;
+	}
+	return true;
+}
+
+static bool task_has_subset_progs(const struct task_struct *parent,
+		const struct task_struct *child)
+{
+#ifdef CONFIG_SECCOMP_FILTER
+	if (progs_are_subset(parent->seccomp.landlock_prog_set,
+				child->seccomp.landlock_prog_set))
+		/* must be ANDed with other providers (i.e. cgroup) */
+		return true;
+#endif /* CONFIG_SECCOMP_FILTER */
+	return false;
+}
+
+static int task_ptrace(const struct task_struct *parent,
+		const struct task_struct *child)
+{
+	if (!landlocked(parent))
+		return 0;
+
+	if (!landlocked(child))
+		return -EPERM;
+
+	if (task_has_subset_progs(parent, child))
+		return 0;
+
+	return -EPERM;
+}
+
+/**
+ * hook_ptrace_access_check - determine whether the current process may access
+ *			      another
+ *
+ * @child: the process to be accessed
+ * @mode: the mode of attachment
+ *
+ * If the current task has Landlock programs, then the child must have at least
+ * the same programs.  Else denied.
+ *
+ * Determine whether a process may access another, returning 0 if permission
+ * granted, -errno if denied.
+ */
+static int hook_ptrace_access_check(struct task_struct *child,
+		unsigned int mode)
+{
+	return task_ptrace(current, child);
+}
+
+/**
+ * hook_ptrace_traceme - determine whether another process may trace the
+ *			 current one
+ *
+ * @parent: the task proposed to be the tracer
+ *
+ * If the parent has Landlock programs, then the current task must have the
+ * same or more programs.
+ * Else denied.
+ *
+ * Determine whether the nominated task is permitted to trace the current
+ * process, returning 0 if permission is granted, -errno if denied.
+ */
+static int hook_ptrace_traceme(struct task_struct *parent)
+{
+	return task_ptrace(parent, current);
+}
+
+static struct security_hook_list landlock_hooks[] = {
+	LSM_HOOK_INIT(ptrace_access_check, hook_ptrace_access_check),
+	LSM_HOOK_INIT(ptrace_traceme, hook_ptrace_traceme),
+};
+
+__init void landlock_add_hooks_ptrace(void)
+{
+	security_add_hooks(landlock_hooks, ARRAY_SIZE(landlock_hooks),
+			LANDLOCK_NAME);
+}
diff --git a/security/landlock/hooks_ptrace.h b/security/landlock/hooks_ptrace.h
new file mode 100644
index 000000000000..15b1f3479e0e
--- /dev/null
+++ b/security/landlock/hooks_ptrace.h
@@ -0,0 +1,11 @@
+/*
+ * Landlock LSM - ptrace hooks
+ *
+ * Copyright © 2017 Mickaël Salaün <mic@digikod.net>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ */
+
+__init void landlock_add_hooks_ptrace(void);
diff --git a/security/landlock/init.c b/security/landlock/init.c
index 3486272d17b2..0f16848f5ad1 100644
--- a/security/landlock/init.c
+++ b/security/landlock/init.c
@@ -17,6 +17,7 @@
 #include "common.h" /* LANDLOCK_* */
 #include "hooks_fs.h"
 #include "hooks_cred.h"
+#include "hooks_ptrace.h"
 
 static bool bpf_landlock_is_valid_access(int off, int size,
 		enum bpf_access_type type, struct bpf_insn_access_aux *info,
@@ -232,5 +233,6 @@ void __init landlock_add_hooks(void)
 {
 	pr_info(LANDLOCK_NAME ": Ready to sandbox with seccomp\n");
 	landlock_add_hooks_cred();
+	landlock_add_hooks_ptrace();
 	landlock_add_hooks_fs();
 }
-- 
2.16.2

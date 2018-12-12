From: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>
Subject: [RFC PATCH v1 3/5] Yama: Enforces noexec mounts or file executability through O_MAYEXEC
Date: Wed, 12 Dec 2018 09:17:10 +0100
Message-ID: <20181212081712.32347-4-mic@digikod.net>
References: <20181212081712.32347-1-mic@digikod.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-14682-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <20181212081712.32347-1-mic@digikod.net>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>, Al Viro <viro@zeniv.linux.org.uk>, James Morris <jmorris@namei.org>, Jonathan Corbet <corbet@lwn.net>, Kees Cook <keescook@chromium.org>, Matthew Garrett <mjg59@google.com>, Michael Kerrisk <mtk.manpages@gmail.com>, =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mickael.salaun@ssi.gouv.fr>, Mimi Zohar <zohar@linux.ibm.com>, =?UTF-8?q?Philippe=20Tr=C3=A9buchet?= <philippe.trebuchet@ssi.gouv.fr>, Shuah Khan <shuah@kernel.org>, Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>, Vincent Strubel <vincent.strubel@ssi.gouv.fr>, Yves-Alexis Perez <yves-alexis.perez@ssi.gouv.fr>, kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Enable to either propagate the mount options from the underlying VFS
mount to prevent execution, or to propagate the file execute permission.
This may allow a script interpreter to check execution permissions
before reading commands from a file.

The main goal is to be able to protect the kernel by restricting
arbitrary syscalls that an attacker could perform with a crafted binary
or certain script languages.  It also improves multilevel isolation
by reducing the ability of an attacker to use side channels with
specific code.  These restrictions can natively be enforced for ELF
binaries (with the noexec mount option) but require this kernel
extension to properly handle scripts (e.g., Python, Perl).

Add a new sysctl kernel.yama.open_mayexec_enforce to control this
behavior.  A following patch adds documentation.

Signed-off-by: Mickaël Salaün <mic@digikod.net>
Reviewed-by: Philippe Trébuchet <philippe.trebuchet@ssi.gouv.fr>
Reviewed-by: Thibaut Sautereau <thibaut.sautereau@ssi.gouv.fr>
Cc: Kees Cook <keescook@chromium.org>
Cc: Mickaël Salaün <mickael.salaun@ssi.gouv.fr>
---
 security/yama/Kconfig    |  3 +-
 security/yama/yama_lsm.c | 82 +++++++++++++++++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/security/yama/Kconfig b/security/yama/Kconfig
index 96b27405558a..9457619fabd5 100644
--- a/security/yama/Kconfig
+++ b/security/yama/Kconfig
@@ -5,7 +5,8 @@ config SECURITY_YAMA
 	help
 	  This selects Yama, which extends DAC support with additional
 	  system-wide security settings beyond regular Linux discretionary
-	  access controls. Currently available is ptrace scope restriction.
+	  access controls. Currently available are ptrace scope restriction and
+	  enforcement of the O_MAYEXEC open flag.
 	  Like capabilities, this security module stacks with other LSMs.
 	  Further information can be found in
 	  Documentation/admin-guide/LSM/Yama.rst.
diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index ffda91a4a1aa..120664e94ee5 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -1,10 +1,12 @@
 /*
  * Yama Linux Security Module
  *
- * Author: Kees Cook <keescook@chromium.org>
+ * Authors: Kees Cook <keescook@chromium.org>
+ *          Mickaël Salaün <mickael.salaun@ssi.gouv.fr>
  *
  * Copyright (C) 2010 Canonical, Ltd.
  * Copyright (C) 2011 The Chromium OS Authors.
+ * Copyright (C) 2018 ANSSI
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2, as
@@ -28,7 +30,14 @@
 #define YAMA_SCOPE_CAPABILITY	2
 #define YAMA_SCOPE_NO_ATTACH	3
 
+#define YAMA_OMAYEXEC_ENFORCE_NONE	0
+#define YAMA_OMAYEXEC_ENFORCE_MOUNT	(1 << 0)
+#define YAMA_OMAYEXEC_ENFORCE_FILE	(1 << 1)
+#define _YAMA_OMAYEXEC_LAST		YAMA_OMAYEXEC_ENFORCE_FILE
+#define _YAMA_OMAYEXEC_MASK		((_YAMA_OMAYEXEC_LAST << 1) - 1)
+
 static int ptrace_scope = YAMA_SCOPE_RELATIONAL;
+static int open_mayexec_enforce = YAMA_OMAYEXEC_ENFORCE_NONE;
 
 /* describe a ptrace relationship for potential exception */
 struct ptrace_relation {
@@ -423,7 +432,40 @@ int yama_ptrace_traceme(struct task_struct *parent)
 	return rc;
 }
 
+/**
+ * yama_inode_permission - check O_MAYEXEC permission before accessing an inode
+ * @inode: inode structure to check
+ * @mask: permission mask
+ *
+ * Return 0 if access is permitted, -EACCES otherwise.
+ */
+int yama_inode_permission(struct inode *inode, int mask)
+{
+	if (!(mask & MAY_OPENEXEC))
+		return 0;
+	/*
+	 * Match regular files and directories to make it easier to
+	 * modify script interpreters.
+	 */
+	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode))
+		return 0;
+
+	if ((open_mayexec_enforce & YAMA_OMAYEXEC_ENFORCE_MOUNT) &&
+			!(mask & MAY_EXECMOUNT))
+		return -EACCES;
+
+	/*
+	 * May prefer acl_permission_check() instead of generic_permission(),
+	 * to not be bypassable with CAP_DAC_READ_SEARCH.
+	 */
+	if (open_mayexec_enforce & YAMA_OMAYEXEC_ENFORCE_FILE)
+		return generic_permission(inode, MAY_EXEC);
+
+	return 0;
+}
+
 static struct security_hook_list yama_hooks[] __lsm_ro_after_init = {
+	LSM_HOOK_INIT(inode_permission, yama_inode_permission),
 	LSM_HOOK_INIT(ptrace_access_check, yama_ptrace_access_check),
 	LSM_HOOK_INIT(ptrace_traceme, yama_ptrace_traceme),
 	LSM_HOOK_INIT(task_prctl, yama_task_prctl),
@@ -447,6 +489,37 @@ static int yama_dointvec_minmax(struct ctl_table *table, int write,
 	return proc_dointvec_minmax(&table_copy, write, buffer, lenp, ppos);
 }
 
+static int yama_dointvec_bitmask_macadmin(struct ctl_table *table, int write,
+					  void __user *buffer, size_t *lenp,
+					  loff_t *ppos)
+{
+	int error;
+
+	if (write) {
+		struct ctl_table table_copy;
+		int tmp_mayexec_enforce;
+
+		if (!capable(CAP_MAC_ADMIN))
+			return -EPERM;
+		tmp_mayexec_enforce = *((int *)table->data);
+		table_copy = *table;
+		/* do not erase open_mayexec_enforce */
+		table_copy.data = &tmp_mayexec_enforce;
+		error = proc_dointvec(&table_copy, write, buffer, lenp, ppos);
+		if (error)
+			return error;
+		if ((tmp_mayexec_enforce | _YAMA_OMAYEXEC_MASK) !=
+				_YAMA_OMAYEXEC_MASK)
+			return -EINVAL;
+		*((int *)table->data) = tmp_mayexec_enforce;
+	} else {
+		error = proc_dointvec(table, write, buffer, lenp, ppos);
+		if (error)
+			return error;
+	}
+	return 0;
+}
+
 static int zero;
 static int max_scope = YAMA_SCOPE_NO_ATTACH;
 
@@ -466,6 +539,13 @@ static struct ctl_table yama_sysctl_table[] = {
 		.extra1         = &zero,
 		.extra2         = &max_scope,
 	},
+	{
+		.procname       = "open_mayexec_enforce",
+		.data           = &open_mayexec_enforce,
+		.maxlen         = sizeof(int),
+		.mode           = 0644,
+		.proc_handler   = yama_dointvec_bitmask_macadmin,
+	},
 	{ }
 };
 static void __init yama_init_sysctl(void)
-- 
2.20.0.rc2

From: Matthew Garrett <matthewgarrett@google.com>
Subject: [PATCH V32 01/27] Add the ability to lock down access to the running
 kernel image
Date: Wed,  3 Apr 2019 17:32:23 -0700
Message-ID: <20190404003249.14356-2-matthewgarrett@google.com>
References: <20190404003249.14356-1-matthewgarrett@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190404003249.14356-1-matthewgarrett@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jmorris@namei.org
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, dhowells@redhat.com, linux-api@vger.kernel.org, luto@kernel.org, Matthew Garrett <matthewgarrett@google.com>
List-Id: linux-api@vger.kernel.org

From: David Howells <dhowells@redhat.com>

Provide a single call to allow kernel code to determine whether the system
should be locked down, thereby disallowing various accesses that might
allow the running kernel image to be changed including the loading of
modules that aren't validly signed with a key we recognise, fiddling with
MSR registers and disallowing hibernation.

Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Matthew Garrett <matthewgarrett@google.com>
---
 Documentation/ABI/testing/lockdown            |  19 +++
 .../admin-guide/kernel-parameters.txt         |   9 ++
 Documentation/admin-guide/lockdown.rst        |  60 +++++++
 include/linux/kernel.h                        |  28 ++++
 include/linux/security.h                      |   9 +-
 init/main.c                                   |   1 +
 security/Kconfig                              |  39 +++++
 security/Makefile                             |   3 +
 security/lock_down.c                          | 147 ++++++++++++++++++
 9 files changed, 314 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/ABI/testing/lockdown
 create mode 100644 Documentation/admin-guide/lockdown.rst
 create mode 100644 security/lock_down.c

diff --git a/Documentation/ABI/testing/lockdown b/Documentation/ABI/testing/lockdown
new file mode 100644
index 000000000000..5bd51e20917a
--- /dev/null
+++ b/Documentation/ABI/testing/lockdown
@@ -0,0 +1,19 @@
+What:		security/lockdown
+Date:		March 2019
+Contact:	Matthew Garrett <mjg59@google.com>
+Description:
+		If CONFIG_LOCK_DOWN_KERNEL is enabled, the kernel can be
+		moved to a more locked down state at runtime by writing to
+		this attribute. Valid values are:
+
+		integrity:
+			The kernel will disable functionality that allows
+			userland to modify the running kernel image, other
+			than through the loading or execution of appropriately
+			signed objects.
+
+		confidentiality:
+			The kernel will disable all functionality disabled by
+			the integrity mode, but additionally will disable
+			features that potentially permit userland to obtain
+			confidential information stored within the kernel.
diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 91c0251fdb86..594d268d92ba 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -2213,6 +2213,15 @@
 	lockd.nlm_udpport=M	[NFS] Assign UDP port.
 			Format: <integer>
 
+	lockdown=	[SECURITY]
+			{ integrity | confidentiality }
+			Enable the kernel lockdown feature. If set to
+			integrity, kernel features that allow userland to
+			modify the running kernel are disabled. If set to
+			confidentiality, kernel features that allow userland
+			to extract confidential information from the kernel
+			are also disabled.
+
 	locktorture.nreaders_stress= [KNL]
 			Set the number of locking read-acquisition kthreads.
 			Defaults to being automatically set based on the
diff --git a/Documentation/admin-guide/lockdown.rst b/Documentation/admin-guide/lockdown.rst
new file mode 100644
index 000000000000..d05dcedd20d1
--- /dev/null
+++ b/Documentation/admin-guide/lockdown.rst
@@ -0,0 +1,60 @@
+Kernel lockdown functionality
+-----------------------------
+
+.. CONTENTS
+..
+.. - Overview.
+.. - Enabling Lockdown.
+
+========
+Overview
+========
+
+Traditionally Linux systems have been run with the presumption that a
+process running with full capabilities is effectively equivalent in
+privilege to the kernel itself. The lockdown feature attempts to draw
+a stronger boundary between privileged processes and the kernel,
+increasing the level of trust that can be placed in the kernel even in
+the face of hostile processes.
+
+Lockdown can be run in two modes - integrity and confidentiality. In
+integrity mode, kernel features that allow arbitrary modification of
+the running kernel image are disabled. Confidentiality mode behaves in
+the same way as integrity mode, but also blocks features that
+potentially allow a hostile userland process to extract secret
+information from the kernel.
+
+Note that lockdown depends upon the correct behaviour of the
+kernel. Exploitable vulnerabilities in the kernel may still permit
+arbitrary modification of the kernel or make it possible to disable
+lockdown features.
+
+=================
+Enabling Lockdown
+=================
+
+Lockdown can be enabled in multiple ways.
+
+Kernel configuration
+====================
+
+The kernel can be statically configured by setting either
+CONFIG_LOCK_DOWN_KERNEL_FORCE_INTEGRITY or
+CONFIG_LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY. A kernel configured
+with CONFIG_LOCK_DOWN_KERNEL_FORCE_INTEGRITY may be booted into
+confidentiality mode using one of the other mechanisms, but otherwise
+the kernel will always boot into the configured mode.
+
+Kernel command line
+===================
+
+Passing lockdown=integrity or lockdown=confidentiality on the kernel
+command line will configure lockdown into the appropriate mode.
+
+Runtime configuration
+=====================
+
+/sys/kernel/security/lockdown will indicate the current lockdown
+state. The system state may be made stricter by writing either
+"integrity" or "confidentiality" into this file, but any attempts to
+make it less strict will fail.
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 8f0e68e250a7..30cf695719d5 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -340,6 +340,34 @@ static inline void refcount_error_report(struct pt_regs *regs, const char *err)
 { }
 #endif
 
+enum lockdown_level {
+	LOCKDOWN_NONE,
+	LOCKDOWN_INTEGRITY,
+	LOCKDOWN_CONFIDENTIALITY,
+	LOCKDOWN_MAX,
+};
+
+#ifdef CONFIG_LOCK_DOWN_KERNEL
+extern bool __kernel_is_locked_down(const char *what,
+				    enum lockdown_level level,
+				    bool first);
+#else
+static inline bool __kernel_is_locked_down(const char *what,
+					   enum lockdown_level level,
+					   bool first)
+{
+	return false;
+}
+#endif
+
+#define kernel_is_locked_down(what, level)				\
+	({								\
+		static bool message_given;				\
+		bool locked_down = __kernel_is_locked_down(what, level, !message_given); \
+		message_given = true;					\
+		locked_down;						\
+	})
+
 /* Internal, do not use. */
 int __must_check _kstrtoul(const char *s, unsigned int base, unsigned long *res);
 int __must_check _kstrtol(const char *s, unsigned int base, long *res);
diff --git a/include/linux/security.h b/include/linux/security.h
index 13537a49ae97..b290946341a4 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1798,5 +1798,12 @@ static inline void security_bpf_prog_free(struct bpf_prog_aux *aux)
 #endif /* CONFIG_SECURITY */
 #endif /* CONFIG_BPF_SYSCALL */
 
-#endif /* ! __LINUX_SECURITY_H */
+#ifdef CONFIG_LOCK_DOWN_KERNEL
+extern void __init init_lockdown(void);
+#else
+static inline void __init init_lockdown(void)
+{
+}
+#endif
 
+#endif /* ! __LINUX_SECURITY_H */
diff --git a/init/main.c b/init/main.c
index e2e80ca3165a..4c6cca9681c7 100644
--- a/init/main.c
+++ b/init/main.c
@@ -555,6 +555,7 @@ asmlinkage __visible void __init start_kernel(void)
 	boot_cpu_init();
 	page_address_init();
 	pr_notice("%s", linux_banner);
+	init_lockdown();
 	setup_arch(&command_line);
 	/*
 	 * Set up the the initial canary and entropy after arch
diff --git a/security/Kconfig b/security/Kconfig
index 1d6463fb1450..593ff231eac6 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -229,6 +229,45 @@ config STATIC_USERMODEHELPER_PATH
 	  If you wish for all usermode helper programs to be disabled,
 	  specify an empty string here (i.e. "").
 
+config LOCK_DOWN_KERNEL
+	bool "Allow the kernel to be 'locked down'"
+	help
+	  Allow the kernel to be locked down. If lockdown support is enabled
+	  and activated, the kernel will impose additional restrictions
+	  intended to prevent uid 0 from being able to modify the running
+	  kernel. This may break userland applications that rely on low-level
+	  access to hardware.
+
+choice
+	prompt "Kernel default lockdown mode"
+	default LOCK_DOWN_KERNEL_FORCE_NONE
+	depends on LOCK_DOWN_KERNEL
+	help
+	  The kernel can be configured to default to differing levels of
+	  lockdown.
+
+config LOCK_DOWN_KERNEL_FORCE_NONE
+       bool "None"
+       help
+          No lockdown functionality is enabled by default. Lockdown may be
+	  enabled via the kernel commandline or /sys/kernel/security/lockdown.
+
+config LOCK_DOWN_KERNEL_FORCE_INTEGRITY
+       bool "Integrity"
+       help
+         The kernel runs in integrity mode by default. Features that allow
+	 the kernel to be modified at runtime are disabled.
+
+config LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY
+       bool "Confidentiality"
+       help
+         The kernel runs in confidentiality mode by default. Features that
+	 allow the kernel to be modified at runtime or that permit userland
+	 code to read confidential material held inside the kernel are
+	 disabled.
+
+endchoice
+
 source "security/selinux/Kconfig"
 source "security/smack/Kconfig"
 source "security/tomoyo/Kconfig"
diff --git a/security/Makefile b/security/Makefile
index c598b904938f..5ff090149c88 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -32,3 +32,6 @@ obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
 # Object integrity file lists
 subdir-$(CONFIG_INTEGRITY)		+= integrity
 obj-$(CONFIG_INTEGRITY)			+= integrity/
+
+# Allow the kernel to be locked down
+obj-$(CONFIG_LOCK_DOWN_KERNEL)		+= lock_down.o
diff --git a/security/lock_down.c b/security/lock_down.c
new file mode 100644
index 000000000000..9913fff09ad0
--- /dev/null
+++ b/security/lock_down.c
@@ -0,0 +1,147 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Lock down the kernel
+ *
+ * Copyright (C) 2016 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/security.h>
+#include <linux/export.h>
+
+static enum lockdown_level kernel_locked_down;
+
+char *lockdown_levels[LOCKDOWN_MAX] = {"none", "integrity", "confidentiality"};
+
+/*
+ * Put the kernel into lock-down mode.
+ */
+static int lock_kernel_down(const char *where, enum lockdown_level level)
+{
+	if (kernel_locked_down >= level)
+		return -EPERM;
+
+	kernel_locked_down = level;
+	pr_notice("Kernel is locked down from %s; see man kernel_lockdown.7\n",
+		  where);
+	return 0;
+}
+
+static int __init lockdown_param(char *level)
+{
+	if (!level)
+		return -EINVAL;
+
+	if (strcmp(level, "integrity") == 0)
+		lock_kernel_down("command line", LOCKDOWN_INTEGRITY);
+	else if (strcmp(level, "confidentiality") == 0)
+		lock_kernel_down("command line", LOCKDOWN_CONFIDENTIALITY);
+	else
+		return -EINVAL;
+
+	return 0;
+}
+
+early_param("lockdown", lockdown_param);
+
+/*
+ * This must be called before arch setup code in order to ensure that the
+ * appropriate default can be applied without being overridden by the command
+ * line option.
+ */
+void __init init_lockdown(void)
+{
+#if defined(CONFIG_LOCK_DOWN_KERNEL_FORCE_INTEGRITY)
+	lock_kernel_down("Kernel configuration", LOCKDOWN_INTEGRITY);
+#elif defined(CONFIG_LOCK_DOWN_KERNEL_FORCE_CONFIDENTIALITY)
+	lock_kernel_down("Kernel configuration", LOCKDOWN_CONFIDENTIALITY);
+#endif
+}
+
+/**
+ * kernel_is_locked_down - Find out if the kernel is locked down
+ * @what: Tag to use in notice generated if lockdown is in effect
+ */
+bool __kernel_is_locked_down(const char *what, enum lockdown_level level,
+			     bool first)
+{
+	if ((kernel_locked_down >= level) && what && first)
+		pr_notice("Lockdown: %s is restricted; see man kernel_lockdown.7\n",
+			  what);
+	return (kernel_locked_down >= level);
+}
+EXPORT_SYMBOL(__kernel_is_locked_down);
+
+static ssize_t lockdown_read(struct file *filp, char __user *buf, size_t count,
+			     loff_t *ppos)
+{
+	char temp[80];
+	int i, offset=0;
+
+	for (i = LOCKDOWN_NONE; i < LOCKDOWN_MAX; i++) {
+		if (lockdown_levels[i]) {
+			const char *label = lockdown_levels[i];
+
+			if (kernel_locked_down == i)
+				offset += sprintf(temp+offset, "[%s] ", label);
+			else
+				offset += sprintf(temp+offset, "%s ", label);
+		}
+	}
+
+	/* Convert the last space to a newline if needed. */
+	if (offset > 0)
+		temp[offset-1] = '\n';
+
+	return simple_read_from_buffer(buf, count, ppos, temp, strlen(temp));
+}
+
+static ssize_t lockdown_write(struct file *file, const char __user *buf,
+			      size_t n, loff_t *ppos)
+{
+	char *state;
+	int i, len, err = -EINVAL;
+
+	state = memdup_user_nul(buf, n);
+	if (IS_ERR(state))
+		return PTR_ERR(state);
+
+	len = strlen(state);
+	if (len && state[len-1] == '\n') {
+		state[len-1] = '\0';
+		len--;
+	}
+
+	for (i = 0; i < LOCKDOWN_MAX; i++) {
+		const char *label = lockdown_levels[i];
+
+		if (label && !strcmp(state, label))
+			err = lock_kernel_down("securityfs", i);
+	}
+
+	kfree(state);
+	return err ? err : n;
+}
+
+static const struct file_operations lockdown_ops = {
+	.read  = lockdown_read,
+	.write = lockdown_write,
+};
+
+static int __init lockdown_secfs_init(void)
+{
+	struct dentry *dentry;
+
+	dentry = securityfs_create_file("lockdown", 0600, NULL, NULL,
+					&lockdown_ops);
+	if (IS_ERR(dentry))
+		return PTR_ERR(dentry);
+
+	return 0;
+}
+
+core_initcall(lockdown_secfs_init);
-- 
2.21.0.392.gf8f6787159e-goog

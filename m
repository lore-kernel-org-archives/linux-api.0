From: David Drysdale <drysdale@google.com>
Subject: [PATCH 09/11] capsicum: implementations of new LSM hooks
Date: Mon, 30 Jun 2014 11:28:09 +0100
Message-ID: <1404124096-21445-10-git-send-email-drysdale@google.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1404124096-21445-1-git-send-email-drysdale@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, linux-api@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

If the LSM does not provide implementations of the .file_lookup and
.file_install LSM hooks, always use the Capsicum implementations.

The Capsicum implementation of file_lookup checks for a Capsicum
capability wrapper file and unwraps to if the appropriate rights
are available.

The Capsicum implementation of file_install checks whether the file
has restricted rights associated with it.  If it does, it is replaced
with a Capsicum capability wrapper file before installation into the
fdtable.

Signed-off-by: David Drysdale <drysdale@google.com>
---
 include/linux/capsicum.h         |   7 ++
 include/uapi/asm-generic/errno.h |   3 +
 security/Makefile                |   2 +-
 security/capability.c            |  17 ++-
 security/capsicum.c              | 257 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 283 insertions(+), 3 deletions(-)
 create mode 100644 security/capsicum.c

diff --git a/include/linux/capsicum.h b/include/linux/capsicum.h
index 74f79756097a..a3e7540f15e7 100644
--- a/include/linux/capsicum.h
+++ b/include/linux/capsicum.h
@@ -13,6 +13,13 @@ struct capsicum_rights {
 	unsigned int *ioctls;
 };
 
+/* LSM hook fallback functions */
+struct file *capsicum_file_lookup(struct file *file,
+				  const struct capsicum_rights *required_rights,
+				  const struct capsicum_rights **actual_rights);
+struct file *capsicum_file_install(const struct capsicum_rights *base_rights,
+				   struct file *file);
+
 #define CAP_LIST_END	0ULL
 
 #ifdef CONFIG_SECURITY_CAPSICUM
diff --git a/include/uapi/asm-generic/errno.h b/include/uapi/asm-generic/errno.h
index 1e1ea6e6e7a5..550570ed7b9f 100644
--- a/include/uapi/asm-generic/errno.h
+++ b/include/uapi/asm-generic/errno.h
@@ -110,4 +110,7 @@
 
 #define EHWPOISON	133	/* Memory page has hardware error */
 
+#define ECAPMODE        134     /* Not permitted in capability mode */
+#define ENOTCAPABLE     135     /* Capability FD rights insufficient */
+
 #endif
diff --git a/security/Makefile b/security/Makefile
index c5e1363ae136..e46d014a74b3 100644
--- a/security/Makefile
+++ b/security/Makefile
@@ -14,7 +14,7 @@ obj-y					+= commoncap.o
 obj-$(CONFIG_MMU)			+= min_addr.o
 
 # Object file lists
-obj-$(CONFIG_SECURITY)			+= security.o capability.o capsicum-rights.o
+obj-$(CONFIG_SECURITY)			+= security.o capability.o capsicum.o capsicum-rights.o
 obj-$(CONFIG_SECURITYFS)		+= inode.o
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/
 obj-$(CONFIG_SECURITY_SMACK)		+= smack/
diff --git a/security/capability.c b/security/capability.c
index ad0d4de69944..11d5a1bd6e57 100644
--- a/security/capability.c
+++ b/security/capability.c
@@ -11,6 +11,7 @@
  */
 
 #include <linux/security.h>
+#include <linux/capsicum.h>
 
 static int cap_syslog(int type)
 {
@@ -917,9 +918,19 @@ static void cap_audit_rule_free(void *lsmrule)
 #define set_to_cap_if_null(ops, function)				\
 	do {								\
 		if (!ops->function) {					\
-			ops->function = cap_##function;			\
+			ops->function = cap_##function;		\
 			pr_debug("Had to override the " #function	\
-				 " security operation with the default.\n");\
+				 " security operation with the default "\
+				 "cap_" #function ".\n");		\
+			}						\
+	} while (0)
+#define set_to_capsicum_if_null(ops, function)				\
+	do {								\
+		if (!ops->function) {					\
+			ops->function = capsicum_##function;		\
+			pr_debug("Had to override the " #function	\
+				 " security operation with the default "\
+				 "capsicum_" #function ".\n");		\
 			}						\
 	} while (0)
 
@@ -1007,6 +1018,8 @@ void __init security_fixup_ops(struct security_operations *ops)
 	set_to_cap_if_null(ops, file_send_sigiotask);
 	set_to_cap_if_null(ops, file_receive);
 	set_to_cap_if_null(ops, file_open);
+	set_to_capsicum_if_null(ops, file_lookup);
+	set_to_capsicum_if_null(ops, file_install);
 	set_to_cap_if_null(ops, task_create);
 	set_to_cap_if_null(ops, task_free);
 	set_to_cap_if_null(ops, cred_alloc_blank);
diff --git a/security/capsicum.c b/security/capsicum.c
new file mode 100644
index 000000000000..83677eef3fb6
--- /dev/null
+++ b/security/capsicum.c
@@ -0,0 +1,257 @@
+/*
+ * Main implementation of Capsicum, a capability framework for UNIX.
+ *
+ * Copyright (C) 2012-2013 The Chromium OS Authors
+ *                         <chromium-os-dev@chromium.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2, as
+ * published by the Free Software Foundation.
+ *
+ * See Documentation/security/capsicum.txt for information on Capsicum.
+ */
+
+#include <linux/anon_inodes.h>
+#include <linux/fs.h>
+#include <linux/fdtable.h>
+#include <linux/file.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/printk.h>
+#include <linux/slab.h>
+#include <linux/security.h>
+#include <linux/syscalls.h>
+#include <linux/capsicum.h>
+
+#include "capsicum-rights.h"
+
+#ifdef CONFIG_SECURITY_CAPSICUM
+/*
+ * Capsicum capability structure, holding the associated rights and underlying
+ * real file.  Capabilities are not stacked, i.e. underlying always points to a
+ * normal file not another Capsicum capability. Accessed via file->private_data.
+ */
+struct capsicum_capability {
+	struct capsicum_rights rights;
+	struct file *underlying;
+};
+
+static void capsicum_panic_not_unwrapped(void);
+static int capsicum_release(struct inode *i, struct file *capf);
+static int capsicum_show_fdinfo(struct seq_file *m, struct file *capf);
+
+#define panic_ptr ((void *)&capsicum_panic_not_unwrapped)
+static const struct file_operations capsicum_file_ops = {
+	.owner = NULL,
+	.llseek = panic_ptr,
+	.read = panic_ptr,
+	.write = panic_ptr,
+	.aio_read = panic_ptr,
+	.aio_write = panic_ptr,
+	.iterate = panic_ptr,
+	.poll = panic_ptr,
+	.unlocked_ioctl = panic_ptr,
+	.compat_ioctl = panic_ptr,
+	.mmap = panic_ptr,
+	.open = panic_ptr,
+	.flush = NULL,  /* This is called on close if implemented. */
+	.release = capsicum_release,  /* This is the only one we want. */
+	.fsync = panic_ptr,
+	.aio_fsync = panic_ptr,
+	.fasync = panic_ptr,
+	.lock = panic_ptr,
+	.sendpage = panic_ptr,
+	.get_unmapped_area = panic_ptr,
+	.check_flags = panic_ptr,
+	.flock = panic_ptr,
+	.splice_write = panic_ptr,
+	.splice_read = panic_ptr,
+	.setlease = panic_ptr,
+	.fallocate = panic_ptr,
+	.show_fdinfo = capsicum_show_fdinfo
+};
+
+static inline bool capsicum_is_cap(const struct file *file)
+{
+	return file->f_op == &capsicum_file_ops;
+}
+
+static struct capsicum_rights all_rights = {
+	.primary = {.cr_rights = {CAP_ALL0, CAP_ALL1} },
+	.fcntls = CAP_FCNTL_ALL,
+	.nioctls = -1,
+	.ioctls = NULL
+};
+
+static struct file *capsicum_cap_alloc(const struct capsicum_rights *rights,
+				       bool take_ioctls)
+{
+	int err;
+	struct file *capf;
+	/* memory to be freed on error exit: */
+	struct capsicum_capability *cap = NULL;
+	unsigned int *ioctls = (take_ioctls ? rights->ioctls : NULL);
+
+	BUG_ON((rights->nioctls > 0) != (rights->ioctls != NULL));
+
+	cap = kmalloc(sizeof(*cap), GFP_KERNEL);
+	if (!cap) {
+		err = -ENOMEM;
+		goto out_err;
+	}
+	cap->underlying = NULL;
+	cap->rights = *rights;
+	if (!take_ioctls && rights->nioctls > 0) {
+		cap->rights.ioctls = kmemdup(rights->ioctls,
+					rights->nioctls * sizeof(unsigned int),
+					GFP_KERNEL);
+		if (!cap->rights.ioctls) {
+			err = -ENOMEM;
+			goto out_err;
+		}
+		ioctls = cap->rights.ioctls;
+	}
+
+	capf = anon_inode_getfile("[capability]", &capsicum_file_ops, cap, 0);
+	if (IS_ERR(capf)) {
+		err = PTR_ERR(capf);
+		goto out_err;
+	}
+	return capf;
+
+out_err:
+	kfree(ioctls);
+	kfree(cap);
+	return ERR_PTR(err);
+}
+
+/*
+ * File operations functions.
+ */
+
+/*
+ * When we release a Capsicum capability, release our reference to the
+ * underlying (wrapped) file as well.
+ */
+static int capsicum_release(struct inode *i, struct file *capf)
+{
+	struct capsicum_capability *cap;
+
+	if (!capsicum_is_cap(capf))
+		return -EINVAL;
+
+	cap = capf->private_data;
+	BUG_ON(!cap);
+	if (cap->underlying)
+		fput(cap->underlying);
+	cap->underlying = NULL;
+	kfree(cap->rights.ioctls);
+	kfree(cap);
+	return 0;
+}
+
+static int capsicum_show_fdinfo(struct seq_file *m, struct file *capf)
+{
+	int i;
+	struct capsicum_capability *cap;
+
+	if (!capsicum_is_cap(capf))
+		return -EINVAL;
+
+	cap = capf->private_data;
+	BUG_ON(!cap);
+	seq_puts(m, "rights:");
+	for (i = 0; i < (CAP_RIGHTS_VERSION + 2); i++)
+		seq_printf(m, "\t%#016llx", cap->rights.primary.cr_rights[i]);
+	seq_puts(m, "\n");
+	seq_printf(m, " fcntls: %#08x\n", cap->rights.fcntls);
+	if (cap->rights.nioctls > 0) {
+		seq_puts(m, " ioctls:");
+		for (i = 0; i < cap->rights.nioctls; i++)
+			seq_printf(m, "\t%#08x", cap->rights.ioctls[i]);
+		seq_puts(m, "\n");
+	}
+	return 0;
+}
+
+static void capsicum_panic_not_unwrapped(void)
+{
+	/*
+	 * General Capsicum file operations should never be called, because the
+	 * relevant file should always be unwrapped and the underlying real file
+	 * used instead.
+	 */
+	panic("Called a file_operations member on a Capsicum wrapper");
+}
+
+/*
+ * LSM hook fallback functions.
+ */
+
+/*
+ * We are looking up a file by its file descriptor. If it is a Capsicum
+ * capability, and has the required rights, we unwrap it and return the
+ * underlying file.
+ */
+struct file *capsicum_file_lookup(struct file *file,
+				  const struct capsicum_rights *required_rights,
+				  const struct capsicum_rights **actual_rights)
+{
+	struct capsicum_capability *cap;
+
+	/* See if the file in question is a Capsicum capability. */
+	if (!capsicum_is_cap(file)) {
+		if (actual_rights)
+			*actual_rights = &all_rights;
+		return file;
+	}
+	cap = file->private_data;
+	if (required_rights &&
+	    !cap_rights_contains(&cap->rights, required_rights)) {
+		return ERR_PTR(-ENOTCAPABLE);
+	}
+	if (actual_rights)
+		*actual_rights = &cap->rights;
+	return cap->underlying;
+}
+EXPORT_SYMBOL(capsicum_file_lookup);
+
+struct file *capsicum_file_install(const struct capsicum_rights *base_rights,
+				   struct file *file)
+{
+	struct file *capf;
+	struct capsicum_capability *cap;
+	if (!base_rights || cap_rights_is_all(base_rights))
+		return file;
+
+	capf = capsicum_cap_alloc(base_rights, false);
+	if (IS_ERR(capf))
+		return capf;
+
+	if (!atomic_long_inc_not_zero(&file->f_count)) {
+		fput(capf);
+		return ERR_PTR(-EBADF);
+	}
+	cap = capf->private_data;
+	cap->underlying = file;
+	return capf;
+}
+EXPORT_SYMBOL(capsicum_file_install);
+
+#else
+
+struct file *capsicum_file_lookup(struct file *file,
+				  const struct capsicum_rights *required_rights,
+				  const struct capsicum_rights **actual_rights)
+{
+	return file;
+}
+
+struct file *
+capsicum_file_install(const const struct capsicum_rights *base_rights,
+		      struct file *file)
+{
+	return file;
+}
+
+#endif
-- 
2.0.0.526.g5318336

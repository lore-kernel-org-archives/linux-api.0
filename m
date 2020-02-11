From: Daniel Colascione <dancol@google.com>
Subject: [PATCH v2 3/6] Teach SELinux about a new userfaultfd class
Date: Tue, 11 Feb 2020 14:55:44 -0800
Message-ID: <20200211225547.235083-4-dancol@google.com>
References: <20200211225547.235083-1-dancol@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200211225547.235083-1-dancol@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dancol@google.com, timmurray@google.com, nosh@google.com, nnk@google.com, lokeshgidra@google.com, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, selinux@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Use the secure anonymous inode LSM hook we just added to let SELinux
policy place restrictions on userfaultfd use. The create operation
applies to processes creating new instances of these file objects;
transfer between processes is covered by restrictions on read, write,
and ioctl access already checked inside selinux_file_receive.

Signed-off-by: Daniel Colascione <dancol@google.com>
---
 fs/userfaultfd.c                    |  4 +-
 include/linux/userfaultfd_k.h       |  2 +
 security/selinux/hooks.c            | 68 +++++++++++++++++++++++++++++
 security/selinux/include/classmap.h |  2 +
 4 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 37df7c9eedb1..07b0f6e03849 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1014,8 +1014,6 @@ static __poll_t userfaultfd_poll(struct file *file, poll_table *wait)
 	}
 }
 
-static const struct file_operations userfaultfd_fops;
-
 static int resolve_userfault_fork(struct userfaultfd_ctx *ctx,
 				  struct userfaultfd_ctx *new,
 				  struct uffd_msg *msg)
@@ -1920,7 +1918,7 @@ static void userfaultfd_show_fdinfo(struct seq_file *m, struct file *f)
 }
 #endif
 
-static const struct file_operations userfaultfd_fops = {
+const struct file_operations userfaultfd_fops = {
 #ifdef CONFIG_PROC_FS
 	.show_fdinfo	= userfaultfd_show_fdinfo,
 #endif
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index ac9d71e24b81..549c8b0cca52 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -30,6 +30,8 @@
 
 extern int sysctl_unprivileged_userfaultfd;
 
+extern const struct file_operations userfaultfd_fops;
+
 extern vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason);
 
 extern ssize_t mcopy_atomic(struct mm_struct *dst_mm, unsigned long dst_start,
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1659b59fb5d7..e178f6f40e93 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -92,6 +92,10 @@
 #include <linux/fsnotify.h>
 #include <linux/fanotify.h>
 
+#ifdef CONFIG_USERFAULTFD
+#include <linux/userfaultfd_k.h>
+#endif
+
 #include "avc.h"
 #include "objsec.h"
 #include "netif.h"
@@ -2915,6 +2919,69 @@ static int selinux_inode_init_security(struct inode *inode, struct inode *dir,
 	return 0;
 }
 
+static int selinux_inode_init_security_anon(struct inode *inode,
+					    const char *name,
+					    const struct file_operations *fops)
+{
+	const struct task_security_struct *tsec = selinux_cred(current_cred());
+	struct common_audit_data ad;
+	struct inode_security_struct *isec;
+
+	if (unlikely(IS_PRIVATE(inode)))
+		return 0;
+
+	/*
+	 * We shouldn't be creating secure anonymous inodes before LSM
+	 * initialization completes.
+	 */
+	if (unlikely(!selinux_state.initialized))
+		return -EBUSY;
+
+	isec = selinux_inode(inode);
+
+	/*
+	 * We only get here once per ephemeral inode.  The inode has
+	 * been initialized via inode_alloc_security but is otherwise
+	 * untouched, so check that the state is as
+	 * inode_alloc_security left it.
+	 */
+	BUG_ON(isec->initialized != LABEL_INVALID);
+	BUG_ON(isec->sclass != SECCLASS_FILE);
+
+#ifdef CONFIG_USERFAULTFD
+	if (fops == &userfaultfd_fops)
+		isec->sclass = SECCLASS_UFFD;
+#endif
+
+	if (isec->sclass == SECCLASS_FILE) {
+		printk(KERN_WARNING "refusing to create secure anonymous inode "
+		       "of unknown type");
+		return -EOPNOTSUPP;
+	}
+	/*
+	 * Always give secure anonymous inodes the sid of the
+	 * creating task.
+	 */
+
+	isec->sid = tsec->sid;
+	isec->initialized = LABEL_INITIALIZED;
+
+	/*
+	 * Now that we've initialized security, check whether we're
+	 * allowed to actually create this type of anonymous inode.
+	 */
+
+	ad.type = LSM_AUDIT_DATA_INODE;
+	ad.u.inode = inode;
+
+	return avc_has_perm(&selinux_state,
+			    tsec->sid,
+			    isec->sid,
+			    isec->sclass,
+			    FILE__CREATE,
+			    &ad);
+}
+
 static int selinux_inode_create(struct inode *dir, struct dentry *dentry, umode_t mode)
 {
 	return may_create(dir, dentry, SECCLASS_FILE);
@@ -6923,6 +6990,7 @@ static struct security_hook_list selinux_hooks[] __lsm_ro_after_init = {
 
 	LSM_HOOK_INIT(inode_free_security, selinux_inode_free_security),
 	LSM_HOOK_INIT(inode_init_security, selinux_inode_init_security),
+	LSM_HOOK_INIT(inode_init_security_anon, selinux_inode_init_security_anon),
 	LSM_HOOK_INIT(inode_create, selinux_inode_create),
 	LSM_HOOK_INIT(inode_link, selinux_inode_link),
 	LSM_HOOK_INIT(inode_unlink, selinux_inode_unlink),
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 986f3ac14282..6d4f9ebf2017 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -248,6 +248,8 @@ struct security_class_mapping secclass_map[] = {
 	  {"open", "cpu", "kernel", "tracepoint", "read", "write"} },
 	{ "lockdown",
 	  { "integrity", "confidentiality", NULL } },
+	{ "uffd",
+	  { COMMON_FILE_PERMS, NULL } },
 	{ NULL }
   };
 
-- 
2.25.0.225.g125e21ebc7-goog

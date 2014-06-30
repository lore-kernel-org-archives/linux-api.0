From: David Drysdale <drysdale@google.com>
Subject: [PATCH 08/11] capsicum: add new LSM hooks on FD/file conversion
Date: Mon, 30 Jun 2014 11:28:08 +0100
Message-ID: <1404124096-21445-9-git-send-email-drysdale@google.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1404124096-21445-1-git-send-email-drysdale@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, linux-api@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Add the following new LSM hooks:
 - file_lookup: check an fd->struct file conversion operation,
   potentially failing the lookup or potentially altering the looked
   up file
 - file_install: check a file to be installed in the fd table, to
   potentially allow the LSM to replace it.

Signed-off-by: David Drysdale <drysdale@google.com>
---
 include/linux/security.h | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 security/security.c      | 13 +++++++++++++
 2 files changed, 61 insertions(+)

diff --git a/include/linux/security.h b/include/linux/security.h
index 6478ce3252c7..4d0c079187d4 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -53,6 +53,7 @@ struct msg_queue;
 struct xattr;
 struct xfrm_sec_ctx;
 struct mm_struct;
+struct capsicum_rights;
 
 /* Maximum number of letters for an LSM name string */
 #define SECURITY_NAME_MAX	10
@@ -656,6 +657,28 @@ static inline void security_free_mnt_opts(struct security_mnt_opts *opts)
  *	to receive an open file descriptor via socket IPC.
  *	@file contains the file structure being received.
  *	Return 0 if permission is granted.
+ * @file_lookup:
+ *	This hook allows security modules to intercept file descriptor lookups
+ *	to check whether a required set of rights are available for the file
+ *	descriptor. This allows the security model to fail the lookup, or to
+ *	substitute a new return value for fget().
+ *	@file is the file in the process's file table, which may be replaced by
+ *	another file as the return value from the hook.
+ *	@required_rights is the rights that the file descriptor should hold, or
+ *	may be NULL to indicate that no specific rights are needed.
+ *	@actual_rights is returned (if it is non-NULL) as a pointer to the
+ *	rights that the file descriptor has.  The caller does not own this
+ *	memory, and should only use if while maintaining a refcount to the
+ *	returned unwrapped file.
+ *	Return PTR_ERR holding the unwrapped file.
+ * @file_install:
+ *	This hook allows security modules to intercept newly created files that
+ *	are about to be installed in the file descriptor table, to potentially
+ *	substitute a different file for the newly opened file.
+ *	@base_rights is the rights associated with an existing file that the
+ *	new file is derived from; CAP_ALL for non-capabilities.
+ *	@file is the newly opened struct file.
+ *	Return PTR_ERR holding the struct file to be used.
  * @file_open
  *	Save open-time permission checking state for later use upon
  *	file_permission, and recheck access if anything has changed
@@ -1555,6 +1578,11 @@ struct security_operations {
 				    struct fown_struct *fown, int sig);
 	int (*file_receive) (struct file *file);
 	int (*file_open) (struct file *file, const struct cred *cred);
+	struct file * (*file_lookup)(struct file *orig,
+				const struct capsicum_rights *required_rights,
+				const struct capsicum_rights **actual_rights);
+	struct file * (*file_install)(const struct capsicum_rights *base_rights,
+				      struct file *file);
 
 	int (*task_create) (unsigned long clone_flags);
 	void (*task_free) (struct task_struct *task);
@@ -1829,6 +1857,11 @@ int security_file_send_sigiotask(struct task_struct *tsk,
 				 struct fown_struct *fown, int sig);
 int security_file_receive(struct file *file);
 int security_file_open(struct file *file, const struct cred *cred);
+struct file *security_file_lookup(struct file *orig,
+				  const struct capsicum_rights *required_rights,
+				  const struct capsicum_rights **actual_rights);
+struct file *security_file_install(const struct capsicum_rights *base_rights,
+				   struct file *file);
 int security_task_create(unsigned long clone_flags);
 void security_task_free(struct task_struct *task);
 int security_cred_alloc_blank(struct cred *cred, gfp_t gfp);
@@ -2324,6 +2357,21 @@ static inline int security_file_open(struct file *file,
 	return 0;
 }
 
+static inline struct file *
+security_file_lookup(struct file *orig,
+		     const struct capsicum_rights *required_rights,
+		     const struct capsicum_rights **actual_rights)
+{
+	return orig;
+}
+
+static inline struct file *
+security_file_install(const struct capsicum_rights *base_rights,
+		      struct file *file)
+{
+	return file;
+}
+
 static inline int security_task_create(unsigned long clone_flags)
 {
 	return 0;
diff --git a/security/security.c b/security/security.c
index 8b774f362a3d..5ab3e893b46c 100644
--- a/security/security.c
+++ b/security/security.c
@@ -802,6 +802,19 @@ int security_file_open(struct file *file, const struct cred *cred)
 	return fsnotify_perm(file, MAY_OPEN);
 }
 
+struct file *security_file_lookup(struct file *file,
+				  const struct capsicum_rights *required_rights,
+				  const struct capsicum_rights **actual_rights)
+{
+	return security_ops->file_lookup(file, required_rights, actual_rights);
+}
+
+struct file *security_file_install(const struct capsicum_rights *base_rights,
+				   struct file *file)
+{
+	return security_ops->file_install(base_rights, file);
+}
+
 int security_task_create(unsigned long clone_flags)
 {
 	return security_ops->task_create(clone_flags);
-- 
2.0.0.526.g5318336

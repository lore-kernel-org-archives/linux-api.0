From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/34] vfs: syscall: Add fsopen() to prepare for superblock
 creation [ver #12]
Date: Fri, 21 Sep 2018 17:33:41 +0100
Message-ID: <153754762168.17872.8158019966378388627.stgit@warthog.procyon.org.uk>
References: <153754740781.17872.7869536526927736855.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153754740781.17872.7869536526927736855.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: linux-api@vger.kernel.org, torvalds@linux-foundation.org, dhowells@redhat.com, ebiederm@xmission.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, mszeredi@redhat.com
List-Id: linux-api@vger.kernel.org

Provide an fsopen() system call that starts the process of preparing to
create a superblock that will then be mountable, using an fd as a context
handle.  fsopen() is given the name of the filesystem that will be used:

	int mfd = fsopen(const char *fsname, unsigned int flags);

where flags can be 0 or FSOPEN_CLOEXEC.

For example:

	sfd = fsopen("ext4", FSOPEN_CLOEXEC);
	fsconfig(sfd, FSCONFIG_SET_PATH, "source", "/dev/sda1", AT_FDCWD);
	fsconfig(sfd, FSCONFIG_SET_FLAG, "noatime", NULL, 0);
	fsconfig(sfd, FSCONFIG_SET_FLAG, "acl", NULL, 0);
	fsconfig(sfd, FSCONFIG_SET_FLAG, "user_xattr", NULL, 0);
	fsconfig(sfd, FSCONFIG_SET_STRING, "sb", "1", 0);
	fsconfig(sfd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
	fsinfo(sfd, NULL, ...); // query new superblock attributes
	mfd = fsmount(sfd, FSMOUNT_CLOEXEC, MS_RELATIME);
	move_mount(mfd, "", sfd, AT_FDCWD, "/mnt", MOVE_MOUNT_F_EMPTY_PATH);

	sfd = fsopen("afs", -1);
	fsconfig(fd, FSCONFIG_SET_STRING, "source",
		 "#grand.central.org:root.cell", 0);
	fsconfig(fd, FSCONFIG_CMD_CREATE, NULL, NULL, 0);
	mfd = fsmount(sfd, 0, MS_NODEV);
	move_mount(mfd, "", sfd, AT_FDCWD, "/mnt", MOVE_MOUNT_F_EMPTY_PATH);

If an error is reported at any step, an error message may be available to be
read() back (ENODATA will be reported if there isn't an error available) in
the form:

	"e <subsys>:<problem>"
	"e SELinux:Mount on mountpoint not permitted"

Once fsmount() has been called, further fsconfig() calls will incur EBUSY,
even if the fsmount() fails.  read() is still possible to retrieve error
information.

The fsopen() syscall creates a mount context and hangs it of the fd that it
returns.

Netlink is not used because it is optional and would make the core VFS
dependent on the networking layer and also potentially add network
namespace issues.

Note that, for the moment, the caller must have SYS_CAP_ADMIN to use
fsopen().

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-api@vger.kernel.org
---

 arch/x86/entry/syscalls/syscall_32.tbl |    1 
 arch/x86/entry/syscalls/syscall_64.tbl |    1 
 fs/Makefile                            |    2 -
 fs/fs_context.c                        |    4 +
 fs/fsopen.c                            |   87 ++++++++++++++++++++++++++++++++
 include/linux/fs_context.h             |   18 +++++++
 include/linux/syscalls.h               |    1 
 include/uapi/linux/fs.h                |    5 ++
 8 files changed, 118 insertions(+), 1 deletion(-)
 create mode 100644 fs/fsopen.c

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 76d092b7d1b0..1647fefd2969 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -400,3 +400,4 @@
 386	i386	rseq			sys_rseq			__ia32_sys_rseq
 387	i386	open_tree		sys_open_tree			__ia32_sys_open_tree
 388	i386	move_mount		sys_move_mount			__ia32_sys_move_mount
+389	i386	fsopen			sys_fsopen			__ia32_sys_fsopen
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 37ba4e65eee6..235d33dbccb2 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -345,6 +345,7 @@
 334	common	rseq			__x64_sys_rseq
 335	common	open_tree		__x64_sys_open_tree
 336	common	move_mount		__x64_sys_move_mount
+337	common	fsopen			__x64_sys_fsopen
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/Makefile b/fs/Makefile
index ae681523b4b1..e3ea8093b178 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -13,7 +13,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o splice.o sync.o utimes.o d_path.o \
 		stack.o fs_struct.o statfs.o fs_pin.o nsfs.o \
-		fs_context.o fs_parser.o
+		fs_context.o fs_parser.o fsopen.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o block_dev.o direct-io.o mpage.o
diff --git a/fs/fs_context.c b/fs/fs_context.c
index 328fcb764667..5d93c86c649d 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -267,6 +267,8 @@ struct fs_context *vfs_new_fs_context(struct file_system_type *fs_type,
 	fc->fs_type	= get_filesystem(fs_type);
 	fc->cred	= get_current_cred();
 
+	mutex_init(&fc->uapi_mutex);
+
 	switch (purpose) {
 	case FS_CONTEXT_FOR_KERNEL_MOUNT:
 		fc->sb_flags |= SB_KERNMOUNT;
@@ -334,6 +336,8 @@ struct fs_context *vfs_dup_fs_context(struct fs_context *src_fc,
 	if (!fc)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&fc->uapi_mutex);
+
 	fc->fs_private	= NULL;
 	fc->s_fs_info	= NULL;
 	fc->source	= NULL;
diff --git a/fs/fsopen.c b/fs/fsopen.c
new file mode 100644
index 000000000000..a9a36f61d76c
--- /dev/null
+++ b/fs/fsopen.c
@@ -0,0 +1,87 @@
+/* Filesystem access-by-fd.
+ *
+ * Copyright (C) 2017 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public Licence
+ * as published by the Free Software Foundation; either version
+ * 2 of the Licence, or (at your option) any later version.
+ */
+
+#include <linux/fs_context.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include <linux/syscalls.h>
+#include <linux/security.h>
+#include <linux/anon_inodes.h>
+#include <linux/namei.h>
+#include <linux/file.h>
+#include "mount.h"
+
+static int fscontext_release(struct inode *inode, struct file *file)
+{
+	struct fs_context *fc = file->private_data;
+
+	if (fc) {
+		file->private_data = NULL;
+		put_fs_context(fc);
+	}
+	return 0;
+}
+
+const struct file_operations fscontext_fops = {
+	.release	= fscontext_release,
+	.llseek		= no_llseek,
+};
+
+/*
+ * Attach a filesystem context to a file and an fd.
+ */
+static int fscontext_create_fd(struct fs_context *fc, unsigned int o_flags)
+{
+	int fd;
+
+	fd = anon_inode_getfd("fscontext", &fscontext_fops, fc,
+			      O_RDWR | o_flags);
+	if (fd < 0)
+		put_fs_context(fc);
+	return fd;
+}
+
+/*
+ * Open a filesystem by name so that it can be configured for mounting.
+ *
+ * We are allowed to specify a container in which the filesystem will be
+ * opened, thereby indicating which namespaces will be used (notably, which
+ * network namespace will be used for network filesystems).
+ */
+SYSCALL_DEFINE2(fsopen, const char __user *, _fs_name, unsigned int, flags)
+{
+	struct file_system_type *fs_type;
+	struct fs_context *fc;
+	const char *fs_name;
+
+	if (!ns_capable(current->nsproxy->mnt_ns->user_ns, CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (flags & ~FSOPEN_CLOEXEC)
+		return -EINVAL;
+
+	fs_name = strndup_user(_fs_name, PAGE_SIZE);
+	if (IS_ERR(fs_name))
+		return PTR_ERR(fs_name);
+
+	fs_type = get_fs_type(fs_name);
+	kfree(fs_name);
+	if (!fs_type)
+		return -ENODEV;
+
+	fc = vfs_new_fs_context(fs_type, NULL, 0, 0, FS_CONTEXT_FOR_USER_MOUNT);
+	put_filesystem(fs_type);
+	if (IS_ERR(fc))
+		return PTR_ERR(fc);
+
+	fc->phase = FS_CONTEXT_CREATE_PARAMS;
+	return fscontext_create_fd(fc, flags & FSOPEN_CLOEXEC ? O_CLOEXEC : 0);
+}
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 0415510f64ed..37f8bafaaec3 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -14,6 +14,7 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/mutex.h>
 
 struct cred;
 struct dentry;
@@ -37,6 +38,19 @@ enum fs_context_purpose {
 	FS_CONTEXT_FOR_EMERGENCY_RO,	/* Emergency reconfiguration to R/O */
 };
 
+/*
+ * Userspace usage phase for fsopen/fspick.
+ */
+enum fs_context_phase {
+	FS_CONTEXT_CREATE_PARAMS,	/* Loading params for sb creation */
+	FS_CONTEXT_CREATING,		/* A superblock is being created */
+	FS_CONTEXT_AWAITING_MOUNT,	/* Superblock created, awaiting fsmount() */
+	FS_CONTEXT_AWAITING_RECONF,	/* Awaiting initialisation for reconfiguration */
+	FS_CONTEXT_RECONF_PARAMS,	/* Loading params for reconfiguration */
+	FS_CONTEXT_RECONFIGURING,	/* Reconfiguring the superblock */
+	FS_CONTEXT_FAILED,		/* Failed to correctly transition a context */
+};
+
 /*
  * Type of parameter value.
  */
@@ -77,6 +91,7 @@ struct fs_parameter {
  */
 struct fs_context {
 	const struct fs_context_operations *ops;
+	struct mutex		uapi_mutex;	/* Userspace access mutex */
 	struct file_system_type	*fs_type;
 	void			*fs_private;	/* The filesystem's context */
 	struct dentry		*root;		/* The root and superblock */
@@ -91,6 +106,7 @@ struct fs_context {
 	unsigned int		sb_flags_mask;	/* Superblock flags that were changed */
 	unsigned int		lsm_flags;	/* Information flags from the fs to the LSM */
 	enum fs_context_purpose	purpose:8;
+	enum fs_context_phase	phase:8;	/* The phase the context is in */
 	bool			sloppy:1;	/* T if unrecognised options are okay */
 	bool			silent:1;	/* T if "o silent" specified */
 	bool			need_free:1;	/* Need to call ops->free() */
@@ -136,6 +152,8 @@ extern int vfs_get_super(struct fs_context *fc,
 			 int (*fill_super)(struct super_block *sb,
 					   struct fs_context *fc));
 
+extern const struct file_operations fscontext_fops;
+
 #define logfc(FC, FMT, ...) pr_notice(FMT, ## __VA_ARGS__)
 
 /**
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 79042396f7e5..650d99c91987 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -910,6 +910,7 @@ asmlinkage long sys_open_tree(int dfd, const char __user *path, unsigned flags);
 asmlinkage long sys_move_mount(int from_dfd, const char __user *from_path,
 			       int to_dfd, const char __user *to_path,
 			       unsigned int ms_flags);
+asmlinkage long sys_fsopen(const char __user *fs_name, unsigned int flags);
 
 /*
  * Architecture-specific system calls
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 1c982eb44ff4..f8818e6cddd6 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -344,4 +344,9 @@ typedef int __bitwise __kernel_rwf_t;
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
 			 RWF_APPEND)
 
+/*
+ * Flags for fsopen() and co.
+ */
+#define FSOPEN_CLOEXEC		0x00000001
+
 #endif /* _UAPI_LINUX_FS_H */

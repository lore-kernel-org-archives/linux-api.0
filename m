From: David Howells <dhowells@redhat.com>
Subject: [PATCH 26/38] vfs: syscall: Add fsopen() to prepare for superblock
 creation [ver #10]
Date: Fri, 27 Jul 2018 18:34:16 +0100
Message-ID: <153271285663.9458.12735854403480633217.stgit@warthog.procyon.org.uk>
References: <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153271267980.9458.7640156373438016898.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: linux-api@vger.kernel.org, torvalds@linux-foundation.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Provide an fsopen() system call that starts the process of preparing to
create a superblock that will then be mountable, using an fd as a context
handle.  fsopen() is given the name of the filesystem that will be used:

	int mfd = fsopen(const char *fsname, unsigned int flags);

where flags can be 0 or FSOPEN_CLOEXEC.

For example:

	sfd = fsopen("ext4", FSOPEN_CLOEXEC);
        fsconfig(sfd, fsconfig_set_path, "source", "/dev/sda1", AT_FDCWD);
        fsconfig(sfd, fsconfig_set_flag, "noatime", NULL, 0);
        fsconfig(sfd, fsconfig_set_flag, "acl", NULL, 0);
        fsconfig(sfd, fsconfig_set_flag, "user_xattr", NULL, 0);
        fsconfig(sfd, fsconfig_set_string, "sb", "1", 0);
        fsconfig(sfd, fsconfig_cmd_create, NULL, NULL, 0);
	fsinfo(sfd, NULL, ...); // query new superblock attributes
	mfd = fsmount(sfd, FSMOUNT_CLOEXEC, MS_RELATIME);
	move_mount(mfd, "", sfd, AT_FDCWD, "/mnt", MOVE_MOUNT_F_EMPTY_PATH);

	sfd = fsopen("afs", -1);
        fsconfig(fd, fsconfig_set_string, "source", "#grand.central.org:root.cell", 0);
        fsconfig(fd, fsconfig_cmd_create, NULL, NULL, 0);
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
 include/linux/fs_context.h             |    4 +
 include/linux/syscalls.h               |    1 
 include/uapi/linux/fs.h                |    5 ++
 8 files changed, 104 insertions(+), 1 deletion(-)
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
index c298cbfb62a2..7259caf42c24 100644
--- a/fs/fs_context.c
+++ b/fs/fs_context.c
@@ -263,6 +263,8 @@ struct fs_context *vfs_new_fs_context(struct file_system_type *fs_type,
 	fc->fs_type	= get_filesystem(fs_type);
 	fc->cred	= get_current_cred();
 
+	mutex_init(&fc->uapi_mutex);
+
 	switch (purpose) {
 	case FS_CONTEXT_FOR_KERNEL_MOUNT:
 		fc->sb_flags |= SB_KERNMOUNT;
@@ -347,6 +349,8 @@ struct fs_context *vfs_dup_fs_context(struct fs_context *src_fc)
 	if (!fc)
 		return ERR_PTR(-ENOMEM);
 
+	mutex_init(&fc->uapi_mutex);
+
 	fc->fs_private	= NULL;
 	fc->s_fs_info	= NULL;
 	fc->source	= NULL;
diff --git a/fs/fsopen.c b/fs/fsopen.c
new file mode 100644
index 000000000000..f30080e1ebc4
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
+	fc = vfs_new_fs_context(fs_type, NULL, 0, FS_CONTEXT_FOR_USER_MOUNT);
+	put_filesystem(fs_type);
+	if (IS_ERR(fc))
+		return PTR_ERR(fc);
+
+	fc->phase = FS_CONTEXT_CREATE_PARAMS;
+	return fscontext_create_fd(fc, flags & FSOPEN_CLOEXEC ? O_CLOEXEC : 0);
+}
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 8d812fcc5f54..488d30de1f4f 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -14,6 +14,7 @@
 
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/mutex.h>
 
 struct cred;
 struct dentry;
@@ -87,6 +88,7 @@ struct fs_parameter {
  */
 struct fs_context {
 	const struct fs_context_operations *ops;
+	struct mutex		uapi_mutex;	/* Userspace access mutex */
 	struct file_system_type	*fs_type;
 	void			*fs_private;	/* The filesystem's context */
 	struct dentry		*root;		/* The root and superblock */
@@ -142,6 +144,8 @@ extern int vfs_get_super(struct fs_context *fc,
 			 int (*fill_super)(struct super_block *sb,
 					   struct fs_context *fc));
 
+extern const struct file_operations fscontext_fops;
+
 #define logfc(FC, FMT, ...) pr_notice(FMT, ## __VA_ARGS__)
 
 /**
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 3c0855d9b105..ad6c7ff33c01 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -904,6 +904,7 @@ asmlinkage long sys_open_tree(int dfd, const char __user *path, unsigned flags);
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

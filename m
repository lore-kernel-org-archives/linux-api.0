From: David Howells <dhowells@redhat.com>
Subject: [PATCH 25/32] vfs: syscall: Add fsmount() to create a mount for a
 superblock [ver #9]
Date: Tue, 10 Jul 2018 23:44:16 +0100
Message-ID: <153126265618.14533.14836767135315368046.stgit@warthog.procyon.org.uk>
References: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153126248868.14533.9751473662727327569.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: dhowells@redhat.com, linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Provide a system call by which a filesystem opened with fsopen() and
configured by a series of writes can be mounted:

	int ret = fsmount(int fsfd, unsigned int flags,
			  unsigned int ms_flags);

where fsfd is the file descriptor returned by fsopen().  flags can be 0 or
FSMOUNT_CLOEXEC.  ms_flags is a bitwise-OR of the following flags:

	MS_RDONLY
	MS_NOSUID
	MS_NODEV
	MS_NOEXEC
	MS_NOATIME
	MS_NODIRATIME
	MS_RELATIME
	MS_STRICTATIME

	MS_UNBINDABLE
	MS_PRIVATE
	MS_SLAVE
	MS_SHARED

In the event that fsmount() fails, it may be possible to get an error
message by calling read() on fsfd.  If no message is available, ENODATA
will be reported.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-api@vger.kernel.org
---

 arch/x86/entry/syscalls/syscall_32.tbl |    1 
 arch/x86/entry/syscalls/syscall_64.tbl |    1 
 fs/namespace.c                         |  140 +++++++++++++++++++++++++++++++-
 include/linux/fs_context.h             |    2 
 include/linux/syscalls.h               |    1 
 include/uapi/linux/fs.h                |    2 
 6 files changed, 143 insertions(+), 4 deletions(-)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 1647fefd2969..537572098032 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -401,3 +401,4 @@
 387	i386	open_tree		sys_open_tree			__ia32_sys_open_tree
 388	i386	move_mount		sys_move_mount			__ia32_sys_move_mount
 389	i386	fsopen			sys_fsopen			__ia32_sys_fsopen
+390	i386	fsmount			sys_fsmount			__ia32_sys_fsmount
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 235d33dbccb2..47abbc2a2bbe 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -346,6 +346,7 @@
 335	common	open_tree		__x64_sys_open_tree
 336	common	move_mount		__x64_sys_move_mount
 337	common	fsopen			__x64_sys_fsopen
+338	common	fsmount			__x64_sys_fsmount
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/namespace.c b/fs/namespace.c
index d5a4d9351a17..a6fbfba8e448 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2503,7 +2503,7 @@ static int do_move_mount(struct path *old_path, struct path *new_path)
 
 	attached = mnt_has_parent(old);
 	/*
-	 * We need to allow open_tree(OPEN_TREE_CLONE) followed by
+	 * We need to allow open_tree(OPEN_TREE_CLONE) or fsmount() followed by
 	 * move_mount(), but mustn't allow "/" to be moved.
 	 */
 	if (old->mnt_ns && !attached)
@@ -3347,9 +3347,141 @@ struct vfsmount *kern_mount(struct file_system_type *type)
 EXPORT_SYMBOL_GPL(kern_mount);
 
 /*
- * Move a mount from one place to another.
- * In combination with open_tree(OPEN_TREE_CLONE [| AT_RECURSIVE]) it can be
- * used to copy a mount subtree.
+ * Create a kernel mount representation for a new, prepared superblock
+ * (specified by fs_fd) and attach to an open_tree-like file descriptor.
+ */
+SYSCALL_DEFINE3(fsmount, int, fs_fd, unsigned int, flags, unsigned int, ms_flags)
+{
+	struct fs_context *fc;
+	struct file *file;
+	struct path newmount;
+	struct fd f;
+	unsigned int mnt_flags = 0;
+	long ret;
+
+	if (!may_mount())
+		return -EPERM;
+
+	if ((flags & ~(FSMOUNT_CLOEXEC)) != 0)
+		return -EINVAL;
+
+	if (ms_flags & ~(MS_RDONLY | MS_NOSUID | MS_NODEV | MS_NOEXEC |
+			 MS_NOATIME | MS_NODIRATIME | MS_RELATIME |
+			 MS_STRICTATIME))
+		return -EINVAL;
+
+	if (ms_flags & MS_RDONLY)
+		mnt_flags |= MNT_READONLY;
+	if (ms_flags & MS_NOSUID)
+		mnt_flags |= MNT_NOSUID;
+	if (ms_flags & MS_NODEV)
+		mnt_flags |= MNT_NODEV;
+	if (ms_flags & MS_NOEXEC)
+		mnt_flags |= MNT_NOEXEC;
+	if (ms_flags & MS_NODIRATIME)
+		mnt_flags |= MNT_NODIRATIME;
+
+	if (ms_flags & MS_STRICTATIME) {
+		if (ms_flags & MS_NOATIME)
+			return -EINVAL;
+	} else if (ms_flags & MS_NOATIME) {
+		mnt_flags |= MNT_NOATIME;
+	} else {
+		mnt_flags |= MNT_RELATIME;
+	}
+
+	f = fdget(fs_fd);
+	if (!f.file)
+		return -EBADF;
+
+	ret = -EINVAL;
+	if (f.file->f_op != &fscontext_fs_fops)
+		goto err_fsfd;
+
+	fc = f.file->private_data;
+
+	/* There must be a valid superblock or we can't mount it */
+	ret = -EINVAL;
+	if (!fc->root)
+		goto err_fsfd;
+
+	ret = -EPERM;
+	if (mount_too_revealing(fc->root->d_sb, &mnt_flags)) {
+		pr_warn("VFS: Mount too revealing\n");
+		goto err_fsfd;
+	}
+
+	ret = mutex_lock_interruptible(&fc->uapi_mutex);
+	if (ret < 0)
+		goto err_fsfd;
+
+	ret = -EBUSY;
+	if (fc->phase != FS_CONTEXT_AWAITING_MOUNT)
+		goto err_unlock;
+
+	ret = -EPERM;
+	if ((fc->sb_flags & SB_MANDLOCK) && !may_mandlock())
+		goto err_unlock;
+
+	newmount.mnt = vfs_create_mount(fc, mnt_flags);
+	if (IS_ERR(newmount.mnt)) {
+		ret = PTR_ERR(newmount.mnt);
+		goto err_unlock;
+	}
+	newmount.dentry = dget(fc->root);
+
+	/* We've done the mount bit - now move the file context into more or
+	 * less the same state as if we'd done an fspick().  We don't want to
+	 * do any memory allocation or anything like that at this point as we
+	 * don't want to have to handle any errors incurred.
+	 */
+	if (fc->ops && fc->ops->free)
+		fc->ops->free(fc);
+	fc->fs_private = NULL;
+	fc->s_fs_info = NULL;
+	fc->sb_flags = 0;
+	fc->sloppy = false;
+	fc->silent = false;
+	security_fs_context_free(fc);
+	fc->security = NULL;
+	kfree(fc->subtype);
+	fc->subtype = NULL;
+	kfree(fc->source);
+	fc->source = NULL;
+
+	fc->purpose = FS_CONTEXT_FOR_RECONFIGURE;
+	fc->phase = FS_CONTEXT_AWAITING_RECONF;
+
+	/* Attach to an apparent O_PATH fd with a note that we need to unmount
+	 * it, not just simply put it.
+	 */
+	file = dentry_open(&newmount, O_PATH, fc->cred);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+		goto err_path;
+	}
+	file->f_mode |= FMODE_NEED_UNMOUNT;
+
+	ret = get_unused_fd_flags((flags & FSMOUNT_CLOEXEC) ? O_CLOEXEC : 0);
+	if (ret >= 0)
+		fd_install(ret, file);
+	else
+		fput(file);
+
+err_path:
+	path_put(&newmount);
+err_unlock:
+	mutex_unlock(&fc->uapi_mutex);
+err_fsfd:
+	fdput(f);
+	return ret;
+}
+
+/*
+ * Move a mount from one place to another.  In combination with
+ * fsopen()/fsmount() this is used to install a new mount and in combination
+ * with open_tree(OPEN_TREE_CLONE [| AT_RECURSIVE]) it can be used to copy
+ * a mount subtree.
  *
  * Note the flags value is a combination of MOVE_MOUNT_* flags.
  */
diff --git a/include/linux/fs_context.h b/include/linux/fs_context.h
index 387f25d7acc4..2cde97490c6f 100644
--- a/include/linux/fs_context.h
+++ b/include/linux/fs_context.h
@@ -115,4 +115,6 @@ extern int vfs_get_super(struct fs_context *fc,
 			 int (*fill_super)(struct super_block *sb,
 					   struct fs_context *fc));
 
+extern const struct file_operations fscontext_fs_fops;
+
 #endif /* _LINUX_FS_CONTEXT_H */
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index ad6c7ff33c01..917fe10e1030 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -905,6 +905,7 @@ asmlinkage long sys_move_mount(int from_dfd, const char __user *from_path,
 			       int to_dfd, const char __user *to_path,
 			       unsigned int ms_flags);
 asmlinkage long sys_fsopen(const char __user *fs_name, unsigned int flags);
+asmlinkage long sys_fsmount(int fs_fd, unsigned int flags, unsigned int ms_flags);
 
 /*
  * Architecture-specific system calls
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index f8818e6cddd6..30a2fb85c4b7 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -349,4 +349,6 @@ typedef int __bitwise __kernel_rwf_t;
  */
 #define FSOPEN_CLOEXEC		0x00000001
 
+#define FSMOUNT_CLOEXEC		0x00000001
+
 #endif /* _UAPI_LINUX_FS_H */

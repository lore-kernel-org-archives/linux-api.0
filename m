From: David Howells <dhowells@redhat.com>
Subject: [PATCH 01/33] vfs: syscall: Add open_tree(2) to reference or clone
 a mount [ver #11]
Date: Wed, 01 Aug 2018 16:24:11 +0100
Message-ID: <153313705165.13253.4602180607294286849.stgit@warthog.procyon.org.uk>
References: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <153313703562.13253.5766498657900728120.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk
Cc: linux-api@vger.kernel.org, torvalds@linux-foundation.org, dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

open_tree(dfd, pathname, flags)

Returns an O_PATH-opened file descriptor or an error.
dfd and pathname specify the location to open, in usual
fashion (see e.g. fstatat(2)).  flags should be an OR of
some of the following:
	* AT_PATH_EMPTY, AT_NO_AUTOMOUNT, AT_SYMLINK_NOFOLLOW -
same meanings as usual
	* OPEN_TREE_CLOEXEC - make the resulting descriptor
close-on-exec
	* OPEN_TREE_CLONE or OPEN_TREE_CLONE | AT_RECURSIVE -
instead of opening the location in question, create a detached
mount tree matching the subtree rooted at location specified by
dfd/pathname.  With AT_RECURSIVE the entire subtree is cloned,
without it - only the part within in the mount containing the
location in question.  In other words, the same as mount --rbind
or mount --bind would've taken.  The detached tree will be
dissolved on the final close of obtained file.  Creation of such
detached trees requires the same capabilities as doing mount --bind.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-api@vger.kernel.org
---

 arch/x86/entry/syscalls/syscall_32.tbl |    1 
 arch/x86/entry/syscalls/syscall_64.tbl |    1 
 fs/file_table.c                        |    9 +-
 fs/internal.h                          |    1 
 fs/namespace.c                         |  132 +++++++++++++++++++++++++++-----
 include/linux/fs.h                     |    3 +
 include/linux/syscalls.h               |    1 
 include/uapi/linux/fcntl.h             |    2 
 include/uapi/linux/mount.h             |   10 ++
 9 files changed, 135 insertions(+), 25 deletions(-)
 create mode 100644 include/uapi/linux/mount.h

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 3cf7b533b3d1..ea1b413afd47 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -398,3 +398,4 @@
 384	i386	arch_prctl		sys_arch_prctl			__ia32_compat_sys_arch_prctl
 385	i386	io_pgetevents		sys_io_pgetevents		__ia32_compat_sys_io_pgetevents
 386	i386	rseq			sys_rseq			__ia32_sys_rseq
+387	i386	open_tree		sys_open_tree			__ia32_sys_open_tree
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index f0b1709a5ffb..0545bed581dc 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -343,6 +343,7 @@
 332	common	statx			__x64_sys_statx
 333	common	io_pgetevents		__x64_sys_io_pgetevents
 334	common	rseq			__x64_sys_rseq
+335	common	open_tree		__x64_sys_open_tree
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/fs/file_table.c b/fs/file_table.c
index 7ec0b3e5f05d..7480271a0d21 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -189,6 +189,7 @@ static void __fput(struct file *file)
 	struct dentry *dentry = file->f_path.dentry;
 	struct vfsmount *mnt = file->f_path.mnt;
 	struct inode *inode = file->f_inode;
+	fmode_t mode = file->f_mode;
 
 	might_sleep();
 
@@ -209,14 +210,14 @@ static void __fput(struct file *file)
 		file->f_op->release(inode, file);
 	security_file_free(file);
 	if (unlikely(S_ISCHR(inode->i_mode) && inode->i_cdev != NULL &&
-		     !(file->f_mode & FMODE_PATH))) {
+		     !(mode & FMODE_PATH))) {
 		cdev_put(inode->i_cdev);
 	}
 	fops_put(file->f_op);
 	put_pid(file->f_owner.pid);
-	if ((file->f_mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
+	if ((mode & (FMODE_READ | FMODE_WRITE)) == FMODE_READ)
 		i_readcount_dec(inode);
-	if (file->f_mode & FMODE_WRITER) {
+	if (mode & FMODE_WRITER) {
 		put_write_access(inode);
 		__mnt_drop_write(mnt);
 	}
@@ -224,6 +225,8 @@ static void __fput(struct file *file)
 	file->f_path.mnt = NULL;
 	file->f_inode = NULL;
 	file_free(file);
+	if (unlikely(mode & FMODE_NEED_UNMOUNT))
+		dissolve_on_fput(mnt);
 	dput(dentry);
 	mntput(mnt);
 }
diff --git a/fs/internal.h b/fs/internal.h
index 56533b08532e..383ee4724f77 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -85,6 +85,7 @@ extern void __mnt_drop_write(struct vfsmount *);
 extern void __mnt_drop_write_file(struct file *);
 extern void mnt_drop_write_file_path(struct file *);
 
+extern void dissolve_on_fput(struct vfsmount *);
 /*
  * fs_struct.c
  */
diff --git a/fs/namespace.c b/fs/namespace.c
index 03cc3b5bcf00..a4a01ecbcacd 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -20,12 +20,14 @@
 #include <linux/init.h>		/* init_rootfs */
 #include <linux/fs_struct.h>	/* get_fs_root et.al. */
 #include <linux/fsnotify.h>	/* fsnotify_vfsmount_delete */
+#include <linux/file.h>
 #include <linux/uaccess.h>
 #include <linux/proc_ns.h>
 #include <linux/magic.h>
 #include <linux/bootmem.h>
 #include <linux/task_work.h>
 #include <linux/sched/task.h>
+#include <uapi/linux/mount.h>
 
 #include "pnode.h"
 #include "internal.h"
@@ -1840,6 +1842,16 @@ struct vfsmount *collect_mounts(const struct path *path)
 	return &tree->mnt;
 }
 
+void dissolve_on_fput(struct vfsmount *mnt)
+{
+	namespace_lock();
+	lock_mount_hash();
+	mntget(mnt);
+	umount_tree(real_mount(mnt), UMOUNT_SYNC);
+	unlock_mount_hash();
+	namespace_unlock();
+}
+
 void drop_collected_mounts(struct vfsmount *mnt)
 {
 	namespace_lock();
@@ -2199,6 +2211,30 @@ static bool has_locked_children(struct mount *mnt, struct dentry *dentry)
 	return false;
 }
 
+static struct mount *__do_loopback(struct path *old_path, int recurse)
+{
+	struct mount *mnt = ERR_PTR(-EINVAL), *old = real_mount(old_path->mnt);
+
+	if (IS_MNT_UNBINDABLE(old))
+		return mnt;
+
+	if (!check_mnt(old) && old_path->dentry->d_op != &ns_dentry_operations)
+		return mnt;
+
+	if (!recurse && has_locked_children(old, old_path->dentry))
+		return mnt;
+
+	if (recurse)
+		mnt = copy_tree(old, old_path->dentry, CL_COPY_MNT_NS_FILE);
+	else
+		mnt = clone_mnt(old, old_path->dentry, 0);
+
+	if (!IS_ERR(mnt))
+		mnt->mnt.mnt_flags &= ~MNT_LOCKED;
+
+	return mnt;
+}
+
 /*
  * do loopback mount.
  */
@@ -2206,7 +2242,7 @@ static int do_loopback(struct path *path, const char *old_name,
 				int recurse)
 {
 	struct path old_path;
-	struct mount *mnt = NULL, *old, *parent;
+	struct mount *mnt = NULL, *parent;
 	struct mountpoint *mp;
 	int err;
 	if (!old_name || !*old_name)
@@ -2220,38 +2256,21 @@ static int do_loopback(struct path *path, const char *old_name,
 		goto out;
 
 	mp = lock_mount(path);
-	err = PTR_ERR(mp);
-	if (IS_ERR(mp))
+	if (IS_ERR(mp)) {
+		err = PTR_ERR(mp);
 		goto out;
+	}
 
-	old = real_mount(old_path.mnt);
 	parent = real_mount(path->mnt);
-
-	err = -EINVAL;
-	if (IS_MNT_UNBINDABLE(old))
-		goto out2;
-
 	if (!check_mnt(parent))
 		goto out2;
 
-	if (!check_mnt(old) && old_path.dentry->d_op != &ns_dentry_operations)
-		goto out2;
-
-	if (!recurse && has_locked_children(old, old_path.dentry))
-		goto out2;
-
-	if (recurse)
-		mnt = copy_tree(old, old_path.dentry, CL_COPY_MNT_NS_FILE);
-	else
-		mnt = clone_mnt(old, old_path.dentry, 0);
-
+	mnt = __do_loopback(&old_path, recurse);
 	if (IS_ERR(mnt)) {
 		err = PTR_ERR(mnt);
 		goto out2;
 	}
 
-	mnt->mnt.mnt_flags &= ~MNT_LOCKED;
-
 	err = graft_tree(mnt, parent, mp);
 	if (err) {
 		lock_mount_hash();
@@ -2265,6 +2284,75 @@ static int do_loopback(struct path *path, const char *old_name,
 	return err;
 }
 
+SYSCALL_DEFINE3(open_tree, int, dfd, const char *, filename, unsigned, flags)
+{
+	struct file *file;
+	struct path path;
+	int lookup_flags = LOOKUP_AUTOMOUNT | LOOKUP_FOLLOW;
+	bool detached = flags & OPEN_TREE_CLONE;
+	int error;
+	int fd;
+
+	BUILD_BUG_ON(OPEN_TREE_CLOEXEC != O_CLOEXEC);
+
+	if (flags & ~(AT_EMPTY_PATH | AT_NO_AUTOMOUNT | AT_RECURSIVE |
+		      AT_SYMLINK_NOFOLLOW | OPEN_TREE_CLONE |
+		      OPEN_TREE_CLOEXEC))
+		return -EINVAL;
+
+	if ((flags & (AT_RECURSIVE | OPEN_TREE_CLONE)) == AT_RECURSIVE)
+		return -EINVAL;
+
+	if (flags & AT_NO_AUTOMOUNT)
+		lookup_flags &= ~LOOKUP_AUTOMOUNT;
+	if (flags & AT_SYMLINK_NOFOLLOW)
+		lookup_flags &= ~LOOKUP_FOLLOW;
+	if (flags & AT_EMPTY_PATH)
+		lookup_flags |= LOOKUP_EMPTY;
+
+	if (detached && !may_mount())
+		return -EPERM;
+
+	fd = get_unused_fd_flags(flags & O_CLOEXEC);
+	if (fd < 0)
+		return fd;
+
+	error = user_path_at(dfd, filename, lookup_flags, &path);
+	if (error)
+		goto out;
+
+	if (detached) {
+		struct mount *mnt = __do_loopback(&path, flags & AT_RECURSIVE);
+		if (IS_ERR(mnt)) {
+			error = PTR_ERR(mnt);
+			goto out2;
+		}
+		mntput(path.mnt);
+		path.mnt = &mnt->mnt;
+	}
+
+	file = dentry_open(&path, O_PATH, current_cred());
+	if (IS_ERR(file)) {
+		error = PTR_ERR(file);
+		goto out3;
+	}
+
+	if (detached)
+		file->f_mode |= FMODE_NEED_UNMOUNT;
+	path_put(&path);
+	fd_install(fd, file);
+	return fd;
+
+out3:
+	if (detached)
+		dissolve_on_fput(path.mnt);
+out2:
+	path_put(&path);
+out:
+	put_unused_fd(fd);
+	return error;
+}
+
 static int change_mount_flags(struct vfsmount *mnt, int ms_flags)
 {
 	int error = 0;
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e3a18cddb74e..067f0e31aec7 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -154,6 +154,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File is capable of returning -EAGAIN if I/O will block */
 #define FMODE_NOWAIT	((__force fmode_t)0x8000000)
 
+/* File represents mount that needs unmounting */
+#define FMODE_NEED_UNMOUNT     ((__force fmode_t)0x10000000)
+
 /*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
  * that indicates that they should check the contents of the iovec are
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 73810808cdf2..3cc6b8f8bd2f 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -900,6 +900,7 @@ asmlinkage long sys_statx(int dfd, const char __user *path, unsigned flags,
 			  unsigned mask, struct statx __user *buffer);
 asmlinkage long sys_rseq(struct rseq __user *rseq, uint32_t rseq_len,
 			 int flags, uint32_t sig);
+asmlinkage long sys_open_tree(int dfd, const char __user *path, unsigned flags);
 
 /*
  * Architecture-specific system calls
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index 6448cdd9a350..594b85f7cb86 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -90,5 +90,7 @@
 #define AT_STATX_FORCE_SYNC	0x2000	/* - Force the attributes to be sync'd with the server */
 #define AT_STATX_DONT_SYNC	0x4000	/* - Don't sync attributes with the server */
 
+#define AT_RECURSIVE		0x8000	/* Apply to the entire subtree */
+
 
 #endif /* _UAPI_LINUX_FCNTL_H */
diff --git a/include/uapi/linux/mount.h b/include/uapi/linux/mount.h
new file mode 100644
index 000000000000..e8db2911adca
--- /dev/null
+++ b/include/uapi/linux/mount.h
@@ -0,0 +1,10 @@
+#ifndef _UAPI_LINUX_MOUNT_H
+#define _UAPI_LINUX_MOUNT_H
+
+/*
+ * open_tree() flags.
+ */
+#define OPEN_TREE_CLONE		1		/* Clone the target tree and attach the clone */
+#define OPEN_TREE_CLOEXEC	O_CLOEXEC	/* Close the file on execve() */
+
+#endif /* _UAPI_LINUX_MOUNT_H */

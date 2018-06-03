From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH][RFC] open_tree(2) (was Re: [PATCH 30/32] vfs: Allow cloning
 of a mount tree with open(O_PATH|O_CLONE_MOUNT) [ver #8])
Date: Sun, 3 Jun 2018 01:55:37 +0100
Message-ID: <20180603005532.GZ30522@ZenIV.linux.org.uk>
References: <20180602040434.GW30522@ZenIV.linux.org.uk>
 <20180601063928.GS30522@ZenIV.linux.org.uk>
 <152720672288.9073.9868393448836301272.stgit@warthog.procyon.org.uk>
 <152720691829.9073.10564431140980997005.stgit@warthog.procyon.org.uk>
 <20180601062654.GA32397@infradead.org>
 <7067.1527841663@warthog.procyon.org.uk>
 <20180602030913.GU30522@ZenIV.linux.org.uk>
 <20180602034255.GV30522@ZenIV.linux.org.uk>
 <21804.1527954321@warthog.procyon.org.uk>
 <20180602174957.GX30522@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180602174957.GX30522@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, Jun 02, 2018 at 06:49:58PM +0100, Al Viro wrote:

> > > Hell, might even add AT_UMOUNT for "open root and detach, to be dissolved on
> > > close", incompatible with AT_CLONE.
> > 
> > Cute.  Guess you could do:
> > 
> > 	fd = open_mount(..., OPEN_TREE_DETACH);
> > 	mount_setattr(fd, "",
> > 		      MOUNT_SETATTR_EMPTY_PATH,
> > 		      MOUNT_SETATTR_NOSUID, NULL);
> > 	move_mount(fd, "", ...);

Hadn't added that yet, but as for the rest of open_tree() - see
vfs.git#mount-open_tree.  open() and its flags are not touched at all.
Other changes compared to the previous:
	* may_mount() is required for OPEN_TREE_CLONE
	* sys_ni.c cruft is dropped - those make no sense until and unless
those syscalls become conditional.

Appears to work, combined with move_mount() it yields eqiuvalents of
mount --{move,bind,rbind}.  Combined with mount_setattr(2) (when that
gets added) we'll get mount -o remount,bind,nodev et.al.
(including the currently absent whole-subtree versions) and
mount --make-{r,}{shared,slave,private,unbindable}

It also can be used to get an isolated subtree usable for ....at()
stuff.

The addition of syscall itself is done by the following and I'd really
like linux-abi folks to comment on that puppy

commit 6cfba4dd99b10278c2156c8d4fced2eddedf167f
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Sat Jun 2 19:42:22 2018 -0400

    new syscall: open_tree(2)
    
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

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 14a2f996e543..b2b44ecd2b17 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -397,3 +397,4 @@
 383	i386	statx			sys_statx			__ia32_sys_statx
 384	i386	arch_prctl		sys_arch_prctl			__ia32_compat_sys_arch_prctl
 385	i386	io_pgetevents		sys_io_pgetevents		__ia32_compat_sys_io_pgetevents
+391	i386	open_tree		sys_open_tree			__ia32_sys_open_tree
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index cd36232ab62f..d6f4949378e7 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -342,6 +342,7 @@
 331	common	pkey_free		__x64_sys_pkey_free
 332	common	statx			__x64_sys_statx
 333	common	io_pgetevents		__x64_sys_io_pgetevents
+339	common	open_tree		__x64_sys_open_tree
 
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
index 980d005b21b4..b55575b9b55c 100644
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
index 5f75969adff1..3281fea98cf0 100644
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
@@ -1839,6 +1841,16 @@ struct vfsmount *collect_mounts(const struct path *path)
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
@@ -2198,6 +2210,30 @@ static bool has_locked_children(struct mount *mnt, struct dentry *dentry)
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
@@ -2205,7 +2241,7 @@ static int do_loopback(struct path *path, const char *old_name,
 				int recurse)
 {
 	struct path old_path;
-	struct mount *mnt = NULL, *old, *parent;
+	struct mount *mnt = NULL, *parent;
 	struct mountpoint *mp;
 	int err;
 	if (!old_name || !*old_name)
@@ -2219,38 +2255,21 @@ static int do_loopback(struct path *path, const char *old_name,
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
@@ -2264,6 +2283,75 @@ static int do_loopback(struct path *path, const char *old_name,
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
index 482563fe549c..706b4605bc26 100644
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
index 811172fcb916..925483aba03a 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -896,7 +896,7 @@ asmlinkage long sys_pkey_alloc(unsigned long flags, unsigned long init_val);
 asmlinkage long sys_pkey_free(int pkey);
 asmlinkage long sys_statx(int dfd, const char __user *path, unsigned flags,
 			  unsigned mask, struct statx __user *buffer);
-
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
index 000000000000..b9c3b46210db
--- /dev/null
+++ b/include/uapi/linux/mount.h
@@ -0,0 +1,7 @@
+#ifndef _UAPI_LINUX_MOUNT_H
+#define _UAPI_LINUX_MOUNT_H
+
+#define OPEN_TREE_CLONE 1
+#define OPEN_TREE_CLOEXEC O_CLOEXEC
+
+#endif /* _UAPI_LINUX_MOUNT_H */

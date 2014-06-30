From: David Drysdale <drysdale@google.com>
Subject: [PATCH 10/11] capsicum: invocation of new LSM hooks
Date: Mon, 30 Jun 2014 11:28:10 +0100
Message-ID: <1404124096-21445-11-git-send-email-drysdale@google.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1404124096-21445-1-git-send-email-drysdale@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, linux-api@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Places that call fcheck() to convert a file descriptor into a
struct file need to call the new .file_lookup LSM hook.  The
most important instances of this are in the fget() function,
but there are a few other direct users of fcheck().

If a new file descriptor is created from an existing file
descriptor, then any rights associated with the original FD
need to be propagated to the new FD.  The .file_install LSM
hook takes care of this, by potentially changing the struct
file that is about to be installed into the FD table.  This
affects accept(2) and openat(2); for the latter, the rights
associated with the dfd need to be propagated through the
code in fs/namei.c to allow this.

The path walking code in fs/namei.c is also modified to enable
the O_BENEATH_ONLY flag if the process is in capability mode,
or if the dfd is a Capsicum capability.

Signed-off-by: David Drysdale <drysdale@google.com>
---
 arch/powerpc/platforms/cell/spufs/coredump.c |   2 +
 fs/file.c                                    |   2 +-
 fs/locks.c                                   |   2 +
 fs/namei.c                                   | 217 ++++++++++++++++++++-------
 fs/notify/dnotify/dnotify.c                  |   2 +
 fs/proc/fd.c                                 |  16 +-
 net/socket.c                                 |  10 +-
 7 files changed, 192 insertions(+), 59 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index be6212ddbf06..589fad12c715 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -29,6 +29,7 @@
 #include <linux/syscalls.h>
 #include <linux/coredump.h>
 #include <linux/binfmts.h>
+#include <linux/security.h>
 
 #include <asm/uaccess.h>
 
@@ -101,6 +102,7 @@ static struct spu_context *coredump_next_context(int *fd)
 		return NULL;
 	*fd = n - 1;
 	file = fcheck(*fd);
+	file = security_file_lookup(file, NULL, NULL);
 	return SPUFS_I(file_inode(file))->i_ctx;
 }
 
diff --git a/fs/file.c b/fs/file.c
index 562cc82ba442..5a784234fd3a 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -742,7 +742,7 @@ static struct file *unwrap_file(struct file *orig,
 		return ERR_PTR(-EBADF);
 	if (IS_ERR(orig))
 		return orig;
-	f = orig;  /* TODO: pass to an LSM hook here */
+	f = security_file_lookup(orig, required_rights, actual_rights);
 	if (f != orig && update_refcnt) {
 		/* We're not returning the original, and the calling code
 		 * has already incremented the refcount on it, we need to
diff --git a/fs/locks.c b/fs/locks.c
index 375fac3392b9..fd95ced5ced1 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2121,6 +2121,7 @@ again:
 	 */
 	spin_lock(&current->files->file_lock);
 	f = fcheck(fd);
+	f = security_file_lookup(f, NULL, NULL);
 	spin_unlock(&current->files->file_lock);
 	if (!error && f != filp && flock.l_type != F_UNLCK) {
 		flock.l_type = F_UNLCK;
@@ -2255,6 +2256,7 @@ again:
 	 */
 	spin_lock(&current->files->file_lock);
 	f = fcheck(fd);
+	f = security_file_lookup(f, NULL, NULL);
 	spin_unlock(&current->files->file_lock);
 	if (!error && f != filp && flock.l_type != F_UNLCK) {
 		flock.l_type = F_UNLCK;
diff --git a/fs/namei.c b/fs/namei.c
index c93f7993960e..001baf46b7a5 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -34,6 +34,7 @@
 #include <linux/device_cgroup.h>
 #include <linux/fs_struct.h>
 #include <linux/posix_acl.h>
+#include <linux/capsicum.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -1750,7 +1751,7 @@ static int link_path_walk(const char *name, struct nameidata *nd,
 {
 	struct path next;
 	int err;
-	
+
 	while (*name == '/') {
 		if (flags & LOOKUP_BENEATH_ONLY) {
 			err = -EACCES;
@@ -1836,15 +1837,18 @@ exit:
 	return err;
 }
 
-static int path_init(int dfd, const char *name, unsigned int flags,
-		     struct nameidata *nd, struct file **fp)
+static int path_init(int dfd, const char *name, unsigned int *flags,
+		struct nameidata *nd, struct file **fp,
+		const struct capsicum_rights **dfd_rights,
+		const struct capsicum_rights *rights)
 {
 	int retval = 0;
 
 	nd->last_type = LAST_ROOT; /* if there are only slashes... */
-	nd->flags = flags | LOOKUP_JUMPED;
+	nd->flags = (*flags) | LOOKUP_PARENT | LOOKUP_JUMPED;
 	nd->depth = 0;
-	if (flags & LOOKUP_ROOT) {
+
+	if ((*flags) & LOOKUP_ROOT) {
 		struct dentry *root = nd->root.dentry;
 		struct inode *inode = root->d_inode;
 		if (*name) {
@@ -1856,7 +1860,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		}
 		nd->path = nd->root;
 		nd->inode = inode;
-		if (flags & LOOKUP_RCU) {
+		if ((*flags) & LOOKUP_RCU) {
 			rcu_read_lock();
 			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
 			nd->m_seq = read_seqbegin(&mount_lock);
@@ -1870,9 +1874,11 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 
 	nd->m_seq = read_seqbegin(&mount_lock);
 	if (*name=='/') {
-		if (flags & LOOKUP_BENEATH_ONLY)
+		if ((*flags) & LOOKUP_BENEATH_ONLY)
 			return -EACCES;
-		if (flags & LOOKUP_RCU) {
+		if (dfd_rights)
+			*dfd_rights = NULL;
+		if ((*flags) & LOOKUP_RCU) {
 			rcu_read_lock();
 			set_root_rcu(nd);
 		} else {
@@ -1881,7 +1887,9 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		}
 		nd->path = nd->root;
 	} else if (dfd == AT_FDCWD) {
-		if (flags & LOOKUP_RCU) {
+		if (dfd_rights)
+			*dfd_rights = NULL;
+		if ((*flags) & LOOKUP_RCU) {
 			struct fs_struct *fs = current->fs;
 			unsigned seq;
 
@@ -1897,11 +1905,13 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		}
 	} else {
 		/* Caller must check execute permissions on the starting path component */
-		struct fd f = fdget_raw(dfd);
+		struct fd f = fdget_raw_rights(dfd, dfd_rights, rights);
 		struct dentry *dentry;
 
-		if (!f.file)
-			return -EBADF;
+		if (IS_ERR(f.file))
+			return PTR_ERR(f.file);
+		if (!cap_rights_is_all(*dfd_rights))
+			*flags |= LOOKUP_BENEATH_ONLY;
 
 		dentry = f.file->f_path.dentry;
 
@@ -1913,7 +1923,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		}
 
 		nd->path = f.file->f_path;
-		if (flags & LOOKUP_RCU) {
+		if ((*flags) & LOOKUP_RCU) {
 			if (f.flags & FDPUT_FPUT)
 				*fp = f.file;
 			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
@@ -1938,9 +1948,12 @@ static inline int lookup_last(struct nameidata *nd, struct path *path)
 }
 
 /* Returns 0 and nd will be valid on success; Retuns error, otherwise. */
-static int path_lookupat(int dfd, const char *name,
-				unsigned int flags, struct nameidata *nd)
+static int path_lookupat(int dfd,
+			 const char *name, unsigned int flags,
+			 struct nameidata *nd,
+			 const struct capsicum_rights *rights)
 {
+	const struct capsicum_rights *dfd_rights;
 	struct file *base = NULL;
 	struct path path;
 	int err;
@@ -1959,7 +1972,7 @@ static int path_lookupat(int dfd, const char *name,
 	 * be handled by restarting a traditional ref-walk (which will always
 	 * be able to complete).
 	 */
-	err = path_init(dfd, name, flags | LOOKUP_PARENT, nd, &base);
+	err = path_init(dfd, name, &flags, nd, &base, &dfd_rights, rights);
 
 	if (unlikely(err))
 		return err;
@@ -2004,27 +2017,32 @@ static int path_lookupat(int dfd, const char *name,
 	return err;
 }
 
-static int filename_lookup(int dfd, struct filename *name,
-				unsigned int flags, struct nameidata *nd)
+static int filename_lookup(int dfd,
+			struct filename *name, unsigned int flags,
+			struct nameidata *nd,
+			const struct capsicum_rights *rights)
 {
-	int retval = path_lookupat(dfd, name->name, flags | LOOKUP_RCU, nd);
+	int retval = path_lookupat(dfd, name->name, flags | LOOKUP_RCU, nd,
+				   rights);
 	if (unlikely(retval == -ECHILD))
-		retval = path_lookupat(dfd, name->name, flags, nd);
+		retval = path_lookupat(dfd, name->name, flags, nd, rights);
 	if (unlikely(retval == -ESTALE))
-		retval = path_lookupat(dfd, name->name,
-						flags | LOOKUP_REVAL, nd);
+		retval = path_lookupat(dfd, name->name, flags | LOOKUP_REVAL,
+				       nd, rights);
 
 	if (likely(!retval))
 		audit_inode(name, nd->path.dentry, flags & LOOKUP_PARENT);
 	return retval;
 }
 
-static int do_path_lookup(int dfd, const char *name,
-				unsigned int flags, struct nameidata *nd)
+static int do_path_lookup(int dfd,
+			  const char *name, unsigned int flags,
+			  struct nameidata *nd,
+			  const struct capsicum_rights *rights)
 {
 	struct filename filename = { .name = name };
 
-	return filename_lookup(dfd, &filename, flags, nd);
+	return filename_lookup(dfd, &filename, flags, nd, rights);
 }
 
 /* does lookup, returns the object with parent locked */
@@ -2032,7 +2050,8 @@ struct dentry *kern_path_locked(const char *name, struct path *path)
 {
 	struct nameidata nd;
 	struct dentry *d;
-	int err = do_path_lookup(AT_FDCWD, name, LOOKUP_PARENT, &nd);
+	int err;
+	err = do_path_lookup(AT_FDCWD, name, LOOKUP_PARENT, &nd, NULL);
 	if (err)
 		return ERR_PTR(err);
 	if (nd.last_type != LAST_NORM) {
@@ -2053,7 +2072,8 @@ struct dentry *kern_path_locked(const char *name, struct path *path)
 int kern_path(const char *name, unsigned int flags, struct path *path)
 {
 	struct nameidata nd;
-	int res = do_path_lookup(AT_FDCWD, name, flags, &nd);
+	int res;
+	res = do_path_lookup(AT_FDCWD, name, flags, &nd, NULL);
 	if (!res)
 		*path = nd.path;
 	return res;
@@ -2078,7 +2098,7 @@ int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
 	nd.root.mnt = mnt;
 	BUG_ON(flags & LOOKUP_PARENT);
 	/* the first argument of do_path_lookup() is ignored with LOOKUP_ROOT */
-	err = do_path_lookup(AT_FDCWD, name, flags | LOOKUP_ROOT, &nd);
+	err = do_path_lookup(AT_FDCWD, name, flags | LOOKUP_ROOT, &nd, NULL);
 	if (!err)
 		*path = nd.path;
 	return err;
@@ -2161,8 +2181,7 @@ static int user_path_at_empty_rights(int dfd,
 	if (!IS_ERR(tmp)) {
 
 		BUG_ON(flags & LOOKUP_PARENT);
-
-		err = filename_lookup(dfd, tmp, flags, &nd);
+		err = filename_lookup(dfd, tmp, flags, &nd, rights);
 		putname(tmp);
 		if (!err)
 			*path = nd.path;
@@ -2211,7 +2230,7 @@ int _user_path_atr(int dfd,
  */
 static struct filename *
 user_path_parent(int dfd, const char __user *path, struct nameidata *nd,
-		 unsigned int flags)
+		 unsigned int flags, const struct capsicum_rights *rights)
 {
 	struct filename *s = getname(path);
 	int error;
@@ -2222,7 +2241,7 @@ user_path_parent(int dfd, const char __user *path, struct nameidata *nd,
 	if (IS_ERR(s))
 		return s;
 
-	error = filename_lookup(dfd, s, flags | LOOKUP_PARENT, nd);
+	error = filename_lookup(dfd, s, flags | LOOKUP_PARENT, nd, rights);
 	if (error) {
 		putname(s);
 		return ERR_PTR(error);
@@ -2338,9 +2357,11 @@ path_mountpoint(int dfd, const char *name, struct path *path, unsigned int flags
 {
 	struct file *base = NULL;
 	struct nameidata nd;
+	const struct capsicum_rights *dfd_rights;
 	int err;
 
-	err = path_init(dfd, name, flags | LOOKUP_PARENT, &nd, &base);
+	err = path_init(dfd, name, &flags, &nd, &base,
+			&dfd_rights, &lookup_rights);
 	if (unlikely(err))
 		return err;
 
@@ -3165,8 +3186,9 @@ static int do_tmpfile(int dfd, struct filename *pathname,
 	static const struct qstr name = QSTR_INIT("/", 1);
 	struct dentry *dentry, *child;
 	struct inode *dir;
-	int error = path_lookupat(dfd, pathname->name,
-				  flags | LOOKUP_DIRECTORY, nd);
+	int error;
+	error = path_lookupat(dfd, pathname->name, flags | LOOKUP_DIRECTORY, nd,
+			      &lookup_rights);
 	if (unlikely(error))
 		return error;
 	error = mnt_want_write(nd->path.mnt);
@@ -3218,15 +3240,42 @@ out:
 	return error;
 }
 
+static void openat_primary_rights(struct capsicum_rights *rights,
+				  unsigned int flags)
+{
+	switch (flags & O_ACCMODE) {
+	case O_RDONLY:
+		cap_rights_set(rights, CAP_READ);
+		break;
+	case O_RDWR:
+		cap_rights_set(rights, CAP_READ);
+		/* FALLTHRU */
+	case O_WRONLY:
+		cap_rights_set(rights, CAP_WRITE);
+		if (!(flags & (O_APPEND | O_TRUNC)))
+			cap_rights_set(rights, CAP_SEEK);
+		break;
+	}
+	if (flags & O_CREAT)
+		cap_rights_set(rights, CAP_CREATE);
+	if (flags & O_TRUNC)
+		cap_rights_set(rights, CAP_FTRUNCATE);
+	if (flags & (O_DSYNC|FASYNC))
+		cap_rights_set(rights, CAP_FSYNC);
+}
+
 static struct file *path_openat(int dfd, struct filename *pathname,
 		struct nameidata *nd, const struct open_flags *op, int flags)
 {
+	struct capsicum_rights rights;
+	const struct capsicum_rights *dfd_rights;
 	struct file *base = NULL;
 	struct file *file;
 	struct path path;
 	int opened = 0;
 	int error;
 
+	cap_rights_init(&rights, CAP_LOOKUP);
 	file = get_empty_filp();
 	if (IS_ERR(file))
 		return file;
@@ -3238,7 +3287,9 @@ static struct file *path_openat(int dfd, struct filename *pathname,
 		goto out;
 	}
 
-	error = path_init(dfd, pathname->name, flags | LOOKUP_PARENT, nd, &base);
+	openat_primary_rights(&rights, file->f_flags);
+	error = path_init(dfd, pathname->name, &flags, nd, &base,
+			  &dfd_rights, &rights);
 	if (unlikely(error))
 		goto out;
 
@@ -3268,6 +3319,16 @@ static struct file *path_openat(int dfd, struct filename *pathname,
 		error = do_last(nd, &path, file, op, &opened, pathname);
 		put_link(nd, &link, cookie);
 	}
+	if (!error) {
+		struct file *install_file;
+		install_file = security_file_install(dfd_rights, file);
+		if (IS_ERR(install_file)) {
+			error = PTR_ERR(install_file);
+			goto out;
+		} else {
+			file = install_file;
+		}
+	}
 out:
 	if (nd->root.mnt && !(nd->flags & LOOKUP_ROOT))
 		path_put(&nd->root);
@@ -3326,8 +3387,12 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
 	return file;
 }
 
-struct dentry *kern_path_create(int dfd, const char *pathname,
-				struct path *path, unsigned int lookup_flags)
+static struct dentry *
+kern_path_create_rights(int dfd,
+			const char *pathname,
+			struct path *path,
+			unsigned int lookup_flags,
+			const struct capsicum_rights *rights)
 {
 	struct dentry *dentry = ERR_PTR(-EEXIST);
 	struct nameidata nd;
@@ -3341,7 +3406,8 @@ struct dentry *kern_path_create(int dfd, const char *pathname,
 	 */
 	lookup_flags &= LOOKUP_REVAL;
 
-	error = do_path_lookup(dfd, pathname, LOOKUP_PARENT|lookup_flags, &nd);
+	error = do_path_lookup(dfd, pathname, LOOKUP_PARENT|lookup_flags, &nd,
+			       rights);
 	if (error)
 		return ERR_PTR(error);
 
@@ -3395,6 +3461,13 @@ out:
 	path_put(&nd.path);
 	return dentry;
 }
+
+struct dentry *kern_path_create(int dfd, const char *pathname,
+				struct path *path, unsigned int lookup_flags)
+{
+	return kern_path_create_rights(dfd, pathname, path, lookup_flags,
+				       &lookup_rights);
+}
 EXPORT_SYMBOL(kern_path_create);
 
 void done_path_create(struct path *path, struct dentry *dentry)
@@ -3406,17 +3479,29 @@ void done_path_create(struct path *path, struct dentry *dentry)
 }
 EXPORT_SYMBOL(done_path_create);
 
-struct dentry *user_path_create(int dfd, const char __user *pathname,
-				struct path *path, unsigned int lookup_flags)
+static struct dentry *
+user_path_create_rights(int dfd,
+			const char __user *pathname,
+			struct path *path,
+			unsigned int lookup_flags,
+			const struct capsicum_rights *rights)
 {
 	struct filename *tmp = getname(pathname);
 	struct dentry *res;
 	if (IS_ERR(tmp))
 		return ERR_CAST(tmp);
-	res = kern_path_create(dfd, tmp->name, path, lookup_flags);
+	res = kern_path_create_rights(dfd, tmp->name, path, lookup_flags,
+				      rights);
 	putname(tmp);
 	return res;
 }
+
+struct dentry *user_path_create(int dfd, const char __user *pathname,
+				struct path *path, unsigned int lookup_flags)
+{
+	return user_path_create_rights(dfd, pathname, path, lookup_flags,
+				       &lookup_rights);
+}
 EXPORT_SYMBOL(user_path_create);
 
 int vfs_mknod(struct inode *dir, struct dentry *dentry, umode_t mode, dev_t dev)
@@ -3467,16 +3552,28 @@ static int may_mknod(umode_t mode)
 SYSCALL_DEFINE4(mknodat, int, dfd, const char __user *, filename, umode_t, mode,
 		unsigned, dev)
 {
+	struct capsicum_rights rights;
 	struct dentry *dentry;
 	struct path path;
 	int error;
 	unsigned int lookup_flags = 0;
 
+	cap_rights_init(&rights, CAP_LOOKUP);
 	error = may_mknod(mode);
 	if (error)
 		return error;
+
+	switch (mode & S_IFMT) {
+	case S_IFCHR: case S_IFBLK:
+		cap_rights_set(&rights, CAP_MKNODAT);
+		break;
+	case S_IFIFO:
+		cap_rights_set(&rights, CAP_MKFIFOAT);
+		break;
+	}
 retry:
-	dentry = user_path_create(dfd, filename, &path, lookup_flags);
+	dentry = user_path_create_rights(dfd, filename, &path, lookup_flags,
+					 &rights);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
@@ -3543,9 +3640,12 @@ SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, umode_t, mode)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_DIRECTORY;
+	struct capsicum_rights rights;
+	cap_rights_init(&rights, CAP_LOOKUP, CAP_MKDIRAT);
 
 retry:
-	dentry = user_path_create(dfd, pathname, &path, lookup_flags);
+	dentry = user_path_create_rights(dfd, pathname, &path, lookup_flags,
+					 &rights);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
@@ -3636,9 +3736,11 @@ static long do_rmdir(int dfd, const char __user *pathname)
 	struct filename *name;
 	struct dentry *dentry;
 	struct nameidata nd;
+	struct capsicum_rights rights;
 	unsigned int lookup_flags = 0;
+	cap_rights_init(&rights, CAP_UNLINKAT);
 retry:
-	name = user_path_parent(dfd, pathname, &nd, lookup_flags);
+	name = user_path_parent(dfd, pathname, &nd, lookup_flags, &rights);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
@@ -3763,8 +3865,10 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	struct inode *inode = NULL;
 	struct inode *delegated_inode = NULL;
 	unsigned int lookup_flags = 0;
+	struct capsicum_rights rights;
+	cap_rights_init(&rights, CAP_UNLINKAT);
 retry:
-	name = user_path_parent(dfd, pathname, &nd, lookup_flags);
+	name = user_path_parent(dfd, pathname, &nd, lookup_flags, &rights);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
@@ -3870,12 +3974,15 @@ SYSCALL_DEFINE3(symlinkat, const char __user *, oldname,
 	struct dentry *dentry;
 	struct path path;
 	unsigned int lookup_flags = 0;
+	struct capsicum_rights rights;
 
 	from = getname(oldname);
 	if (IS_ERR(from))
 		return PTR_ERR(from);
+	cap_rights_init(&rights, CAP_SYMLINKAT);
 retry:
-	dentry = user_path_create(newdfd, newname, &path, lookup_flags);
+	dentry = user_path_create_rights(newdfd, newname, &path, lookup_flags,
+					 &rights);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto out_putname;
@@ -3986,6 +4093,7 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	struct dentry *new_dentry;
 	struct path old_path, new_path;
 	struct inode *delegated_inode = NULL;
+	struct capsicum_rights rights;
 	int how = 0;
 	int error;
 
@@ -4004,13 +4112,14 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 
 	if (flags & AT_SYMLINK_FOLLOW)
 		how |= LOOKUP_FOLLOW;
+	cap_rights_init(&rights, CAP_LINKAT);
 retry:
 	error = user_path_at(olddfd, oldname, how, &old_path);
 	if (error)
 		return error;
 
-	new_dentry = user_path_create(newdfd, newname, &new_path,
-					(how & LOOKUP_REVAL));
+	new_dentry = user_path_create_rights(newdfd, newname, &new_path,
+					     (how & LOOKUP_REVAL), &rights);
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto out;
@@ -4241,6 +4350,8 @@ SYSCALL_DEFINE5(renameat2, int, olddfd, const char __user *, oldname,
 	struct inode *delegated_inode = NULL;
 	struct filename *from;
 	struct filename *to;
+	struct capsicum_rights old_rights;
+	struct capsicum_rights new_rights;
 	unsigned int lookup_flags = 0;
 	bool should_retry = false;
 	int error;
@@ -4251,14 +4362,18 @@ SYSCALL_DEFINE5(renameat2, int, olddfd, const char __user *, oldname,
 	if ((flags & RENAME_NOREPLACE) && (flags & RENAME_EXCHANGE))
 		return -EINVAL;
 
+	cap_rights_init(&old_rights, CAP_RENAMEAT);
+	cap_rights_init(&new_rights, CAP_LINKAT);
 retry:
-	from = user_path_parent(olddfd, oldname, &oldnd, lookup_flags);
+	from = user_path_parent(olddfd, oldname, &oldnd, lookup_flags,
+				&old_rights);
 	if (IS_ERR(from)) {
 		error = PTR_ERR(from);
 		goto exit;
 	}
 
-	to = user_path_parent(newdfd, newname, &newnd, lookup_flags);
+	to = user_path_parent(newdfd, newname, &newnd, lookup_flags,
+			      &new_rights);
 	if (IS_ERR(to)) {
 		error = PTR_ERR(to);
 		goto exit1;
diff --git a/fs/notify/dnotify/dnotify.c b/fs/notify/dnotify/dnotify.c
index abc8cbcfe90e..33a269166b05 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/fdtable.h>
 #include <linux/fsnotify_backend.h>
+#include <linux/security.h>
 
 int dir_notify_enable __read_mostly = 1;
 
@@ -327,6 +328,7 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 
 	rcu_read_lock();
 	f = fcheck(fd);
+	f = security_file_lookup(f, NULL, NULL);
 	rcu_read_unlock();
 
 	/* if (f != filp) means that we lost a race and another task/thread
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 0788d093f5d8..d260dd1acdee 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -20,6 +20,7 @@ static int seq_show(struct seq_file *m, void *v)
 	struct files_struct *files = NULL;
 	int f_flags = 0, ret = -ENOENT;
 	struct file *file = NULL;
+	struct file *underlying = NULL;
 	struct task_struct *task;
 
 	task = get_proc_task(m->private);
@@ -36,12 +37,13 @@ static int seq_show(struct seq_file *m, void *v)
 		file = fcheck_files(files, fd);
 		if (file) {
 			struct fdtable *fdt = files_fdtable(files);
-
-			f_flags = file->f_flags;
+			underlying = security_file_lookup(file, NULL, NULL);
+			f_flags = underlying->f_flags;
 			if (close_on_exec(fd, fdt))
 				f_flags |= O_CLOEXEC;
 
 			get_file(file);
+			get_file(underlying);
 			ret = 0;
 		}
 		spin_unlock(&files->file_lock);
@@ -50,10 +52,11 @@ static int seq_show(struct seq_file *m, void *v)
 
 	if (!ret) {
 		seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\n",
-			   (long long)file->f_pos, f_flags,
-			   real_mount(file->f_path.mnt)->mnt_id);
+			   (long long)underlying->f_pos, f_flags,
+			   real_mount(underlying->f_path.mnt)->mnt_id);
 		if (file->f_op->show_fdinfo)
 			ret = file->f_op->show_fdinfo(m, file);
+		fput(underlying);
 		fput(file);
 	}
 
@@ -95,7 +98,9 @@ static int tid_fd_revalidate(struct dentry *dentry, unsigned int flags)
 			rcu_read_lock();
 			file = fcheck_files(files, fd);
 			if (file) {
-				unsigned f_mode = file->f_mode;
+				unsigned f_mode;
+				file = security_file_lookup(file, NULL, NULL);
+				f_mode = file->f_mode;
 
 				rcu_read_unlock();
 				put_files_struct(files);
@@ -158,6 +163,7 @@ static int proc_fd_link(struct dentry *dentry, struct path *path)
 		spin_lock(&files->file_lock);
 		fd_file = fcheck_files(files, fd);
 		if (fd_file) {
+			fd_file = security_file_lookup(fd_file, NULL, NULL);
 			*path = fd_file->f_path;
 			path_get(&fd_file->f_path);
 			ret = 0;
diff --git a/net/socket.c b/net/socket.c
index dbc00f0b992a..f635dc3f9a3c 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1669,6 +1669,7 @@ SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
 {
 	struct socket *sock, *newsock;
 	struct file *newfile;
+	struct file *installfile;
 	int err, len, newfd, fput_needed;
 	struct sockaddr_storage address;
 	struct capsicum_rights rights;
@@ -1736,7 +1737,12 @@ SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
 
 	/* File flags are not inherited via accept() unlike another OSes. */
 
-	fd_install(newfd, newfile);
+	installfile = security_file_install(listen_rights, newfile);
+	if (IS_ERR(installfile)) {
+		err = PTR_ERR(installfile);
+		goto out_fd;
+	}
+	fd_install(newfd, installfile);
 	err = newfd;
 
 out_put:
@@ -2115,7 +2121,7 @@ static int ___sys_sendmsg(struct socket *sock_noaddr, struct socket *sock_addr,
 	}
 	sock = (msg_sys->msg_name ? sock_addr : sock_noaddr);
 	if (!sock)
-		return -EBADF;
+		return -ENOTCAPABLE;
 
 	if (msg_sys->msg_iovlen > UIO_FASTIOV) {
 		err = -EMSGSIZE;
-- 
2.0.0.526.g5318336

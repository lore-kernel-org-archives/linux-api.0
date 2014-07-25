From: David Drysdale <drysdale@google.com>
Subject: [PATCH 08/11] capsicum: invoke Capsicum on FD/file conversion
Date: Fri, 25 Jul 2014 14:47:04 +0100
Message-ID: <1406296033-32693-9-git-send-email-drysdale@google.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1406296033-32693-1-git-send-email-drysdale@google.com>
Sender: linux-security-module-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Add calls to Capsicum to intercept FD/file conversion in the following
situations:
 - Any place where a file descriptor is converted to a struct file.
 - Any place where a new file descriptor that is derived from an
   existing file descriptor is installed into the fdtable.

For the first of these, Capsicum checks for a Capsicum capability
wrapper file and unwraps it to the underlying file, provided the
appropriate rights are available (otherwise, ERR_PTR(-ENOTCAPABLE)
is returned).

For the second, Capsicum checks whether the original file has
restricted rights associated with it.  If it does, it is replaced
with a Capsicum capability wrapper file before installation into
the fdtable.  This propagates the rights from the original FD to
the new FD, and particularly affects accept(2) and openat(2).

For openat(2) rights propagation in particular, the rights
associated with the dfd need to make their way through the code
in fs/namei.c to allow this.

The path walking code in fs/namei.c is also modified to enable
the O_BENEATH flag if the dfd is a Capsicum capability.

Signed-off-by: David Drysdale <drysdale@google.com>
---
 arch/powerpc/platforms/cell/spufs/coredump.c |   2 +
 fs/file.c                                    |   7 +-
 fs/locks.c                                   |   3 +
 fs/namei.c                                   | 223 +++++++++++++++++++------
 fs/notify/dnotify/dnotify.c                  |   2 +
 fs/proc/fd.c                                 |  18 +-
 include/linux/capsicum.h                     |  22 +++
 include/uapi/asm-generic/errno.h             |   3 +
 net/socket.c                                 |  10 +-
 security/Makefile                            |   2 +-
 security/capsicum.c                          | 238 +++++++++++++++++++++++++++
 11 files changed, 468 insertions(+), 62 deletions(-)
 create mode 100644 security/capsicum.c

diff --git a/arch/powerpc/platforms/cell/spufs/coredump.c b/arch/powerpc/platforms/cell/spufs/coredump.c
index be6212ddbf06..9dd63b501514 100644
--- a/arch/powerpc/platforms/cell/spufs/coredump.c
+++ b/arch/powerpc/platforms/cell/spufs/coredump.c
@@ -29,6 +29,7 @@
 #include <linux/syscalls.h>
 #include <linux/coredump.h>
 #include <linux/binfmts.h>
+#include <linux/capsicum.h>
 
 #include <asm/uaccess.h>
 
@@ -101,6 +102,7 @@ static struct spu_context *coredump_next_context(int *fd)
 		return NULL;
 	*fd = n - 1;
 	file = fcheck(*fd);
+	file = capsicum_file_lookup(file, NULL, NULL);
 	return SPUFS_I(file_inode(file))->i_ctx;
 }
 
diff --git a/fs/file.c b/fs/file.c
index ae53219d720b..e9befafcc158 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -14,6 +14,7 @@
 #include <linux/time.h>
 #include <linux/sched.h>
 #include <linux/security.h>
+#include <linux/capsicum.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/file.h>
@@ -720,8 +721,8 @@ unsigned long __fdget_pos(unsigned int fd)
 
 #ifdef CONFIG_SECURITY_CAPSICUM
 /*
- * We might want to change the return value of fget() and friends.  This
- * function is called with the intended return value, and fget() will /actually/
+ * Capsicum might want to change the return value of fget() and friends.  This
+ * function is called with the intended return value, and fget() will actually
  * return whatever is returned from here. We adjust the reference counter if
  * necessary.
  */
@@ -736,7 +737,7 @@ static struct file *unwrap_file(struct file *orig,
 		return ERR_PTR(-EBADF);
 	if (IS_ERR(orig))
 		return orig;
-	f = orig;  /* TODO: change the value of f here */
+	f = capsicum_file_lookup(orig, required_rights, actual_rights);
 	if (f != orig && update_refcnt) {
 		/* We're not returning the original, and the calling code
 		 * has already incremented the refcount on it, we need to
diff --git a/fs/locks.c b/fs/locks.c
index fdad193dc4b4..81e57ea0bdb5 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -121,6 +121,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/security.h>
+#include <linux/capsicum.h>
 #include <linux/slab.h>
 #include <linux/syscalls.h>
 #include <linux/time.h>
@@ -2133,6 +2134,7 @@ again:
 	 */
 	spin_lock(&current->files->file_lock);
 	f = fcheck(fd);
+	f = capsicum_file_lookup(f, NULL, NULL);
 	spin_unlock(&current->files->file_lock);
 	if (!error && f != filp && flock.l_type != F_UNLCK) {
 		flock.l_type = F_UNLCK;
@@ -2267,6 +2269,7 @@ again:
 	 */
 	spin_lock(&current->files->file_lock);
 	f = fcheck(fd);
+	f = capsicum_file_lookup(f, NULL, NULL);
 	spin_unlock(&current->files->file_lock);
 	if (!error && f != filp && flock.l_type != F_UNLCK) {
 		flock.l_type = F_UNLCK;
diff --git a/fs/namei.c b/fs/namei.c
index 548e351fade1..fe03a7dd7537 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -34,6 +34,7 @@
 #include <linux/device_cgroup.h>
 #include <linux/fs_struct.h>
 #include <linux/posix_acl.h>
+#include <linux/capsicum.h>
 #include <asm/uaccess.h>
 
 #include "internal.h"
@@ -1751,7 +1752,7 @@ static int link_path_walk(const char *name, struct nameidata *nd,
 {
 	struct path next;
 	int err;
-	
+
 	while (*name == '/') {
 		if (flags & LOOKUP_BENEATH) {
 			err = -EACCES;
@@ -1837,15 +1838,18 @@ exit:
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
@@ -1857,7 +1861,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		}
 		nd->path = nd->root;
 		nd->inode = inode;
-		if (flags & LOOKUP_RCU) {
+		if ((*flags) & LOOKUP_RCU) {
 			rcu_read_lock();
 			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
 			nd->m_seq = read_seqbegin(&mount_lock);
@@ -1871,9 +1875,11 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 
 	nd->m_seq = read_seqbegin(&mount_lock);
 	if (*name=='/') {
-		if (flags & LOOKUP_BENEATH)
+		if ((*flags) & LOOKUP_BENEATH)
 			return -EACCES;
-		if (flags & LOOKUP_RCU) {
+		if (dfd_rights)
+			*dfd_rights = NULL;
+		if ((*flags) & LOOKUP_RCU) {
 			rcu_read_lock();
 			set_root_rcu(nd);
 		} else {
@@ -1882,7 +1888,9 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		}
 		nd->path = nd->root;
 	} else if (dfd == AT_FDCWD) {
-		if (flags & LOOKUP_RCU) {
+		if (dfd_rights)
+			*dfd_rights = NULL;
+		if ((*flags) & LOOKUP_RCU) {
 			struct fs_struct *fs = current->fs;
 			unsigned seq;
 
@@ -1898,11 +1906,13 @@ static int path_init(int dfd, const char *name, unsigned int flags,
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
+			*flags |= LOOKUP_BENEATH;
 
 		dentry = f.file->f_path.dentry;
 
@@ -1914,7 +1924,7 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 		}
 
 		nd->path = f.file->f_path;
-		if (flags & LOOKUP_RCU) {
+		if ((*flags) & LOOKUP_RCU) {
 			if (f.flags & FDPUT_FPUT)
 				*fp = f.file;
 			nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
@@ -1939,9 +1949,12 @@ static inline int lookup_last(struct nameidata *nd, struct path *path)
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
@@ -1960,7 +1973,7 @@ static int path_lookupat(int dfd, const char *name,
 	 * be handled by restarting a traditional ref-walk (which will always
 	 * be able to complete).
 	 */
-	err = path_init(dfd, name, flags | LOOKUP_PARENT, nd, &base);
+	err = path_init(dfd, name, &flags, nd, &base, &dfd_rights, rights);
 
 	if (unlikely(err))
 		return err;
@@ -2005,27 +2018,32 @@ static int path_lookupat(int dfd, const char *name,
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
@@ -2033,7 +2051,9 @@ struct dentry *kern_path_locked(const char *name, struct path *path)
 {
 	struct nameidata nd;
 	struct dentry *d;
-	int err = do_path_lookup(AT_FDCWD, name, LOOKUP_PARENT, &nd);
+	int err;
+
+	err = do_path_lookup(AT_FDCWD, name, LOOKUP_PARENT, &nd, NULL);
 	if (err)
 		return ERR_PTR(err);
 	if (nd.last_type != LAST_NORM) {
@@ -2054,7 +2074,9 @@ struct dentry *kern_path_locked(const char *name, struct path *path)
 int kern_path(const char *name, unsigned int flags, struct path *path)
 {
 	struct nameidata nd;
-	int res = do_path_lookup(AT_FDCWD, name, flags, &nd);
+	int res;
+
+	res = do_path_lookup(AT_FDCWD, name, flags, &nd, NULL);
 	if (!res)
 		*path = nd.path;
 	return res;
@@ -2079,7 +2101,7 @@ int vfs_path_lookup(struct dentry *dentry, struct vfsmount *mnt,
 	nd.root.mnt = mnt;
 	BUG_ON(flags & LOOKUP_PARENT);
 	/* the first argument of do_path_lookup() is ignored with LOOKUP_ROOT */
-	err = do_path_lookup(AT_FDCWD, name, flags | LOOKUP_ROOT, &nd);
+	err = do_path_lookup(AT_FDCWD, name, flags | LOOKUP_ROOT, &nd, NULL);
 	if (!err)
 		*path = nd.path;
 	return err;
@@ -2162,8 +2184,7 @@ static int user_path_at_empty_rights(int dfd,
 	if (!IS_ERR(tmp)) {
 
 		BUG_ON(flags & LOOKUP_PARENT);
-
-		err = filename_lookup(dfd, tmp, flags, &nd);
+		err = filename_lookup(dfd, tmp, flags, &nd, rights);
 		putname(tmp);
 		if (!err)
 			*path = nd.path;
@@ -2213,7 +2234,7 @@ int _user_path_atr(int dfd,
  */
 static struct filename *
 user_path_parent(int dfd, const char __user *path, struct nameidata *nd,
-		 unsigned int flags)
+		 unsigned int flags, const struct capsicum_rights *rights)
 {
 	struct filename *s = getname(path);
 	int error;
@@ -2224,7 +2245,7 @@ user_path_parent(int dfd, const char __user *path, struct nameidata *nd,
 	if (IS_ERR(s))
 		return s;
 
-	error = filename_lookup(dfd, s, flags | LOOKUP_PARENT, nd);
+	error = filename_lookup(dfd, s, flags | LOOKUP_PARENT, nd, rights);
 	if (error) {
 		putname(s);
 		return ERR_PTR(error);
@@ -2340,9 +2361,11 @@ path_mountpoint(int dfd, const char *name, struct path *path, unsigned int flags
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
 
@@ -3167,8 +3190,10 @@ static int do_tmpfile(int dfd, struct filename *pathname,
 	static const struct qstr name = QSTR_INIT("/", 1);
 	struct dentry *dentry, *child;
 	struct inode *dir;
-	int error = path_lookupat(dfd, pathname->name,
-				  flags | LOOKUP_DIRECTORY, nd);
+	int error;
+
+	error = path_lookupat(dfd, pathname->name, flags | LOOKUP_DIRECTORY, nd,
+			      &lookup_rights);
 	if (unlikely(error))
 		return error;
 	error = mnt_want_write(nd->path.mnt);
@@ -3220,15 +3245,42 @@ out:
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
@@ -3240,7 +3292,9 @@ static struct file *path_openat(int dfd, struct filename *pathname,
 		goto out;
 	}
 
-	error = path_init(dfd, pathname->name, flags | LOOKUP_PARENT, nd, &base);
+	openat_primary_rights(&rights, file->f_flags);
+	error = path_init(dfd, pathname->name, &flags, nd, &base,
+			  &dfd_rights, &rights);
 	if (unlikely(error))
 		goto out;
 
@@ -3270,6 +3324,17 @@ static struct file *path_openat(int dfd, struct filename *pathname,
 		error = do_last(nd, &path, file, op, &opened, pathname);
 		put_link(nd, &link, cookie);
 	}
+	if (!error) {
+		struct file *install_file;
+
+		install_file = capsicum_file_install(dfd_rights, file);
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
@@ -3328,8 +3393,12 @@ struct file *do_file_open_root(struct dentry *dentry, struct vfsmount *mnt,
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
@@ -3343,7 +3412,8 @@ struct dentry *kern_path_create(int dfd, const char *pathname,
 	 */
 	lookup_flags &= LOOKUP_REVAL;
 
-	error = do_path_lookup(dfd, pathname, LOOKUP_PARENT|lookup_flags, &nd);
+	error = do_path_lookup(dfd, pathname, LOOKUP_PARENT|lookup_flags, &nd,
+			       rights);
 	if (error)
 		return ERR_PTR(error);
 
@@ -3397,6 +3467,13 @@ out:
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
@@ -3408,17 +3485,29 @@ void done_path_create(struct path *path, struct dentry *dentry)
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
@@ -3469,16 +3558,28 @@ static int may_mknod(umode_t mode)
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
 
@@ -3545,9 +3646,13 @@ SYSCALL_DEFINE3(mkdirat, int, dfd, const char __user *, pathname, umode_t, mode)
 	struct path path;
 	int error;
 	unsigned int lookup_flags = LOOKUP_DIRECTORY;
+	struct capsicum_rights rights;
+
+	cap_rights_init(&rights, CAP_LOOKUP, CAP_MKDIRAT);
 
 retry:
-	dentry = user_path_create(dfd, pathname, &path, lookup_flags);
+	dentry = user_path_create_rights(dfd, pathname, &path, lookup_flags,
+					 &rights);
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
 
@@ -3638,9 +3743,11 @@ static long do_rmdir(int dfd, const char __user *pathname)
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
 
@@ -3765,8 +3872,11 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	struct inode *inode = NULL;
 	struct inode *delegated_inode = NULL;
 	unsigned int lookup_flags = 0;
+	struct capsicum_rights rights;
+
+	cap_rights_init(&rights, CAP_UNLINKAT);
 retry:
-	name = user_path_parent(dfd, pathname, &nd, lookup_flags);
+	name = user_path_parent(dfd, pathname, &nd, lookup_flags, &rights);
 	if (IS_ERR(name))
 		return PTR_ERR(name);
 
@@ -3872,12 +3982,15 @@ SYSCALL_DEFINE3(symlinkat, const char __user *, oldname,
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
@@ -3988,6 +4101,7 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	struct dentry *new_dentry;
 	struct path old_path, new_path;
 	struct inode *delegated_inode = NULL;
+	struct capsicum_rights rights;
 	int how = 0;
 	int error;
 
@@ -4006,13 +4120,14 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 
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
@@ -4243,6 +4358,8 @@ SYSCALL_DEFINE5(renameat2, int, olddfd, const char __user *, oldname,
 	struct inode *delegated_inode = NULL;
 	struct filename *from;
 	struct filename *to;
+	struct capsicum_rights old_rights;
+	struct capsicum_rights new_rights;
 	unsigned int lookup_flags = 0;
 	bool should_retry = false;
 	int error;
@@ -4253,14 +4370,18 @@ SYSCALL_DEFINE5(renameat2, int, olddfd, const char __user *, oldname,
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
index abc8cbcfe90e..fcb228bb7dd6 100644
--- a/fs/notify/dnotify/dnotify.c
+++ b/fs/notify/dnotify/dnotify.c
@@ -25,6 +25,7 @@
 #include <linux/slab.h>
 #include <linux/fdtable.h>
 #include <linux/fsnotify_backend.h>
+#include <linux/capsicum.h>
 
 int dir_notify_enable __read_mostly = 1;
 
@@ -327,6 +328,7 @@ int fcntl_dirnotify(int fd, struct file *filp, unsigned long arg)
 
 	rcu_read_lock();
 	f = fcheck(fd);
+	f = capsicum_file_lookup(f, NULL, NULL);
 	rcu_read_unlock();
 
 	/* if (f != filp) means that we lost a race and another task/thread
diff --git a/fs/proc/fd.c b/fs/proc/fd.c
index 0788d093f5d8..05c367417cb0 100644
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -6,6 +6,7 @@
 #include <linux/namei.h>
 #include <linux/pid.h>
 #include <linux/security.h>
+#include <linux/capsicum.h>
 #include <linux/file.h>
 #include <linux/seq_file.h>
 
@@ -20,6 +21,7 @@ static int seq_show(struct seq_file *m, void *v)
 	struct files_struct *files = NULL;
 	int f_flags = 0, ret = -ENOENT;
 	struct file *file = NULL;
+	struct file *underlying = NULL;
 	struct task_struct *task;
 
 	task = get_proc_task(m->private);
@@ -36,12 +38,13 @@ static int seq_show(struct seq_file *m, void *v)
 		file = fcheck_files(files, fd);
 		if (file) {
 			struct fdtable *fdt = files_fdtable(files);
-
-			f_flags = file->f_flags;
+			underlying = capsicum_file_lookup(file, NULL, NULL);
+			f_flags = underlying->f_flags;
 			if (close_on_exec(fd, fdt))
 				f_flags |= O_CLOEXEC;
 
 			get_file(file);
+			get_file(underlying);
 			ret = 0;
 		}
 		spin_unlock(&files->file_lock);
@@ -50,10 +53,11 @@ static int seq_show(struct seq_file *m, void *v)
 
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
 
@@ -95,7 +99,10 @@ static int tid_fd_revalidate(struct dentry *dentry, unsigned int flags)
 			rcu_read_lock();
 			file = fcheck_files(files, fd);
 			if (file) {
-				unsigned f_mode = file->f_mode;
+				unsigned f_mode;
+
+				file = capsicum_file_lookup(file, NULL, NULL);
+				f_mode = file->f_mode;
 
 				rcu_read_unlock();
 				put_files_struct(files);
@@ -158,6 +165,7 @@ static int proc_fd_link(struct dentry *dentry, struct path *path)
 		spin_lock(&files->file_lock);
 		fd_file = fcheck_files(files, fd);
 		if (fd_file) {
+			fd_file = capsicum_file_lookup(fd_file, NULL, NULL);
 			*path = fd_file->f_path;
 			path_get(&fd_file->f_path);
 			ret = 0;
diff --git a/include/linux/capsicum.h b/include/linux/capsicum.h
index 74f79756097a..24d74dcd5a99 100644
--- a/include/linux/capsicum.h
+++ b/include/linux/capsicum.h
@@ -16,6 +16,13 @@ struct capsicum_rights {
 #define CAP_LIST_END	0ULL
 
 #ifdef CONFIG_SECURITY_CAPSICUM
+/* FD->struct file interception functions */
+struct file *capsicum_file_lookup(struct file *file,
+				  const struct capsicum_rights *required_rights,
+				  const struct capsicum_rights **actual_rights);
+struct file *capsicum_file_install(const struct capsicum_rights *base_rights,
+				   struct file *file);
+
 /* Rights manipulation functions */
 #define cap_rights_init(rights, ...) \
 	_cap_rights_init((rights), __VA_ARGS__, CAP_LIST_END)
@@ -32,6 +39,21 @@ bool cap_rights_is_all(const struct capsicum_rights *rights);
 
 #else
 
+static inline struct file *
+capsicum_file_lookup(struct file *file,
+		     const struct capsicum_rights *required_rights,
+		     const struct capsicum_rights **actual_rights)
+{
+	return file;
+}
+
+static inline struct file *
+capsicum_file_install(const const struct capsicum_rights *base_rights,
+		      struct file *file)
+{
+	return file;
+}
+
 #define cap_rights_init(rights, ...) _cap_rights_noop(rights)
 #define cap_rights_set(rights, ...) _cap_rights_noop(rights)
 #define cap_rights_set_all(rights) _cap_rights_noop(rights)
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
diff --git a/net/socket.c b/net/socket.c
index 2240c2e52927..41322c3c2a4a 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -1671,6 +1671,7 @@ SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
 {
 	struct socket *sock, *newsock;
 	struct file *newfile;
+	struct file *installfile;
 	int err, len, newfd, fput_needed;
 	struct sockaddr_storage address;
 	struct capsicum_rights rights;
@@ -1738,7 +1739,12 @@ SYSCALL_DEFINE4(accept4, int, fd, struct sockaddr __user *, upeer_sockaddr,
 
 	/* File flags are not inherited via accept() unlike another OSes. */
 
-	fd_install(newfd, newfile);
+	installfile = capsicum_file_install(listen_rights, newfile);
+	if (IS_ERR(installfile)) {
+		err = PTR_ERR(installfile);
+		goto out_fd;
+	}
+	fd_install(newfd, installfile);
 	err = newfd;
 
 out_put:
@@ -2117,7 +2123,7 @@ static int ___sys_sendmsg(struct socket *sock_noaddr, struct socket *sock_addr,
 	}
 	sock = (msg_sys->msg_name ? sock_addr : sock_noaddr);
 	if (!sock)
-		return -EBADF;
+		return -ENOTCAPABLE;
 
 	if (msg_sys->msg_iovlen > UIO_FASTIOV) {
 		err = -EMSGSIZE;
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
diff --git a/security/capsicum.c b/security/capsicum.c
new file mode 100644
index 000000000000..4a004829b9c8
--- /dev/null
+++ b/security/capsicum.c
@@ -0,0 +1,238 @@
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
+
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
+#endif
-- 
2.0.0.526.g5318336


From: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/3 v2] fs: allow to use dirfd as root for openat and other
	*at syscalls
Date: Wed, 20 Jul 2016 13:42:56 -0700
Message-ID: <1469047377-13128-3-git-send-email-avagin@openvz.org>
References: <1469047377-13128-1-git-send-email-avagin@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <1469047377-13128-1-git-send-email-avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "J. Bruce Fields" <bfields-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, criu-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

The problem is that a pathname can contain absolute symlinks and now
they are resolved relative to the current root.

But if we want to open a file in another mount namespace and we have
a file descriptor to its root directory, we want that the pathname is
resolved in the target mount namespace and in this case we need these
new flags O_ATROOT or AT_FDROOT.

If O_ATROOT is set for openat() or AT_FDROOT is set for fstatat, linkat,
unlinkat, path_init is executed with the LOOKUP_DFD_ROOT flag.

v2: fix a value of O_ATROOT to not intersect with other constans
Signed-off-by: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 fs/exec.c                        |  4 +++-
 fs/namei.c                       | 26 +++++++++++++++++---------
 fs/open.c                        |  6 +++++-
 fs/stat.c                        |  4 +++-
 fs/utimes.c                      |  4 +++-
 include/uapi/asm-generic/fcntl.h |  4 ++++
 include/uapi/linux/fcntl.h       |  1 +
 7 files changed, 36 insertions(+), 13 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 887c1c9..473b709 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -775,12 +775,14 @@ static struct file *do_open_execat(int fd, struct filename *name, int flags)
 		.lookup_flags = LOOKUP_FOLLOW,
 	};
 
-	if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+	if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH | AT_FDROOT)) != 0)
 		return ERR_PTR(-EINVAL);
 	if (flags & AT_SYMLINK_NOFOLLOW)
 		open_exec_flags.lookup_flags &= ~LOOKUP_FOLLOW;
 	if (flags & AT_EMPTY_PATH)
 		open_exec_flags.lookup_flags |= LOOKUP_EMPTY;
+	if (flags & AT_FDROOT)
+		open_exec_flags.lookup_flags |= LOOKUP_DFD_ROOT;
 
 	file = do_filp_open(fd, name, &open_exec_flags);
 	if (IS_ERR(file))
diff --git a/fs/namei.c b/fs/namei.c
index 17548b1..068c2d2 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2550,7 +2550,8 @@ user_path_parent(int dfd, const char __user *path,
 		 unsigned int flags)
 {
 	/* only LOOKUP_REVAL is allowed in extra flags */
-	return filename_parentat(dfd, getname(path), flags & LOOKUP_REVAL,
+	return filename_parentat(dfd, getname(path),
+				 flags & (LOOKUP_REVAL | LOOKUP_DFD_ROOT),
 				 parent, last, type);
 }
 
@@ -3546,7 +3547,7 @@ static struct dentry *filename_create(int dfd, struct filename *name,
 	 * Note that only LOOKUP_REVAL and LOOKUP_DIRECTORY matter here. Any
 	 * other flags passed in are ignored!
 	 */
-	lookup_flags &= LOOKUP_REVAL;
+	lookup_flags &= LOOKUP_REVAL | LOOKUP_DFD_ROOT;
 
 	name = filename_parentat(dfd, name, lookup_flags, path, &last, &type);
 	if (IS_ERR(name))
@@ -3944,7 +3945,8 @@ EXPORT_SYMBOL(vfs_unlink);
  * writeout happening, and we don't want to prevent access to the directory
  * while waiting on the I/O.
  */
-static long do_unlinkat(int dfd, const char __user *pathname)
+static long do_unlinkat(int dfd, const char __user *pathname,
+					unsigned int lookup_flags)
 {
 	int error;
 	struct filename *name;
@@ -3954,7 +3956,6 @@ static long do_unlinkat(int dfd, const char __user *pathname)
 	int type;
 	struct inode *inode = NULL;
 	struct inode *delegated_inode = NULL;
-	unsigned int lookup_flags = 0;
 retry:
 	name = user_path_parent(dfd, pathname,
 				&path, &last, &type, lookup_flags);
@@ -4019,18 +4020,23 @@ slashes:
 
 SYSCALL_DEFINE3(unlinkat, int, dfd, const char __user *, pathname, int, flag)
 {
-	if ((flag & ~AT_REMOVEDIR) != 0)
+	unsigned int lookup_flags = 0;
+
+	if ((flag & ~(AT_REMOVEDIR | AT_FDROOT)) != 0)
 		return -EINVAL;
 
 	if (flag & AT_REMOVEDIR)
 		return do_rmdir(dfd, pathname);
 
-	return do_unlinkat(dfd, pathname);
+	if (flag & AT_FDROOT)
+		lookup_flags |= LOOKUP_DFD_ROOT;
+
+	return do_unlinkat(dfd, pathname, lookup_flags);
 }
 
 SYSCALL_DEFINE1(unlink, const char __user *, pathname)
 {
-	return do_unlinkat(AT_FDCWD, pathname);
+	return do_unlinkat(AT_FDCWD, pathname, 0);
 }
 
 int vfs_symlink(struct inode *dir, struct dentry *dentry, const char *oldname)
@@ -4181,7 +4187,7 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 	int how = 0;
 	int error;
 
-	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH)) != 0)
+	if ((flags & ~(AT_SYMLINK_FOLLOW | AT_EMPTY_PATH | AT_FDROOT)) != 0)
 		return -EINVAL;
 	/*
 	 * To use null names we require CAP_DAC_READ_SEARCH
@@ -4196,13 +4202,15 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
 
 	if (flags & AT_SYMLINK_FOLLOW)
 		how |= LOOKUP_FOLLOW;
+	if (flags & AT_FDROOT)
+		how |= LOOKUP_DFD_ROOT;
 retry:
 	error = user_path_at(olddfd, oldname, how, &old_path);
 	if (error)
 		return error;
 
 	new_dentry = user_path_create(newdfd, newname, &new_path,
-					(how & LOOKUP_REVAL));
+				(how & (LOOKUP_REVAL | LOOKUP_DFD_ROOT)));
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto out;
diff --git a/fs/open.c b/fs/open.c
index 93ae3cd..e0bc8d0 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -613,12 +613,14 @@ SYSCALL_DEFINE5(fchownat, int, dfd, const char __user *, filename, uid_t, user,
 	int error = -EINVAL;
 	int lookup_flags;
 
-	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH | AT_FDROOT)) != 0)
 		goto out;
 
 	lookup_flags = (flag & AT_SYMLINK_NOFOLLOW) ? 0 : LOOKUP_FOLLOW;
 	if (flag & AT_EMPTY_PATH)
 		lookup_flags |= LOOKUP_EMPTY;
+	if (flag & AT_FDROOT)
+		lookup_flags |= LOOKUP_DFD_ROOT;
 retry:
 	error = user_path_at(dfd, filename, lookup_flags, &path);
 	if (error)
@@ -941,6 +943,8 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		lookup_flags |= LOOKUP_DIRECTORY;
 	if (!(flags & O_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
+	if (flags & O_ATROOT)
+		lookup_flags |= LOOKUP_DFD_ROOT;
 	op->lookup_flags = lookup_flags;
 	return 0;
 }
diff --git a/fs/stat.c b/fs/stat.c
index bc045c7..d71e7f2 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -95,13 +95,15 @@ int vfs_fstatat(int dfd, const char __user *filename, struct kstat *stat,
 	unsigned int lookup_flags = 0;
 
 	if ((flag & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT |
-		      AT_EMPTY_PATH)) != 0)
+		      AT_EMPTY_PATH | AT_FDROOT)) != 0)
 		goto out;
 
 	if (!(flag & AT_SYMLINK_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
 	if (flag & AT_EMPTY_PATH)
 		lookup_flags |= LOOKUP_EMPTY;
+	if (flag & AT_FDROOT)
+		lookup_flags |= LOOKUP_DFD_ROOT;
 retry:
 	error = user_path_at(dfd, filename, lookup_flags, &path);
 	if (error)
diff --git a/fs/utimes.c b/fs/utimes.c
index 85c40f4..78a9eb9 100644
--- a/fs/utimes.c
+++ b/fs/utimes.c
@@ -143,7 +143,7 @@ long do_utimes(int dfd, const char __user *filename, struct timespec *times,
 		goto out;
 	}
 
-	if (flags & ~AT_SYMLINK_NOFOLLOW)
+	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_FDROOT))
 		goto out;
 
 	if (filename == NULL && dfd != AT_FDCWD) {
@@ -165,6 +165,8 @@ long do_utimes(int dfd, const char __user *filename, struct timespec *times,
 
 		if (!(flags & AT_SYMLINK_NOFOLLOW))
 			lookup_flags |= LOOKUP_FOLLOW;
+		if (flags & AT_FDROOT)
+			lookup_flags |= LOOKUP_DFD_ROOT;
 retry:
 		error = user_path_at(dfd, filename, lookup_flags, &path);
 		if (error)
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index e063eff..0436b1d 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -88,6 +88,10 @@
 #define __O_TMPFILE	020000000
 #endif
 
+#ifndef O_ATROOT
+#define O_ATROOT	040000000	/* dfd is a root */
+#endif
+
 /* a horrid kludge trying to make sure that this will fail on old kernels */
 #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
 #define O_TMPFILE_MASK (__O_TMPFILE | O_DIRECTORY | O_CREAT)      
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index beed138..4f3b631 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -62,6 +62,7 @@
 #define AT_SYMLINK_FOLLOW	0x400   /* Follow symbolic links.  */
 #define AT_NO_AUTOMOUNT		0x800	/* Suppress terminal automount traversal */
 #define AT_EMPTY_PATH		0x1000	/* Allow empty relative pathname */
+#define AT_FDROOT		0x2000	/* Resolve a path as if dirfd is root */
 
 
 #endif /* _UAPI_LINUX_FCNTL_H */
-- 
2.5.5

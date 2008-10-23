From: Daniel Gollub <dgollub-l3A5Bk7waGM@public.gmane.org>
Subject: [patch 1/3] [RFC] Change sys_readlink/sys_readlinkat buffer size parameter to size_t (POSIX mismatch)
Date: Thu, 23 Oct 2008 16:50:56 +0200
Message-ID: <20081023150548.447457340@marvin.suse.de>
References: <20081023145054.998439866@marvin.suse.de>
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline; filename=linux-readlink-bufsize-size_t.diff
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ltp-list-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

man-page for readlink syscalls prototype with buffer size as type of size_t:
"ssize_t readlink(const char *path, char *buf, size_t bufsiz);"

Kernel readlink syscall interface has signed buffer size and doesn't match with
man-page described prototype.

POSIX and glibc implementation of the readlink interface have an unsigned buffer size.

This patch changes the syscall interface of sys_readlink and sys_readlinkat, by
changing the buffer size argument type to "size_t".

A buffer size of 0 will end in return value 0. This is _different_ behavior to
original sys_readlink/sys_readlinkat interface. But equal/similar to POSIXs one.


Signed-off-by: Daniel Gollub <dgollub-l3A5Bk7waGM@public.gmane.org>


---

fs/9p/vfs_inode.c        |    4 ++--
 fs/bad_inode.c           |    2 +-
 fs/ecryptfs/inode.c      |    2 +-
 fs/gfs2/ops_inode.c      |    2 +-
 fs/hppfs/hppfs.c         |    2 +-
 fs/namei.c               |    8 ++++----
 fs/ocfs2/symlink.c       |    2 +-
 fs/proc/base.c           |    6 +++---
 fs/stat.c                |    8 ++++----
 include/linux/fs.h       |    8 ++++----
 include/linux/syscalls.h |    4 ++--
 11 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index e83aa5e..dd70525 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -898,7 +898,7 @@ ino_t v9fs_qid2ino(struct p9_qid *qid)
  *
  */
 
-static int v9fs_readlink(struct dentry *dentry, char *buffer, int buflen)
+static int v9fs_readlink(struct dentry *dentry, char *buffer, size_t buflen)
 {
 	int retval;
 
@@ -952,7 +952,7 @@ done:
  */
 
 static int v9fs_vfs_readlink(struct dentry *dentry, char __user * buffer,
-			     int buflen)
+			     size_t buflen)
 {
 	int retval;
 	int ret;
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 5f1538c..5342a55 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -238,7 +238,7 @@ static int bad_inode_rename (struct inode *old_dir, struct dentry *old_dentry,
 }
 
 static int bad_inode_readlink(struct dentry *dentry, char __user *buffer,
-		int buflen)
+		size_t buflen)
 {
 	return -EIO;
 }
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 89209f0..378a1e2 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -602,7 +602,7 @@ out_lock:
 }
 
 static int
-ecryptfs_readlink(struct dentry *dentry, char __user * buf, int bufsiz)
+ecryptfs_readlink(struct dentry *dentry, char __user * buf, size_t bufsiz)
 {
 	int rc;
 	struct dentry *lower_dentry;
diff --git a/fs/gfs2/ops_inode.c b/fs/gfs2/ops_inode.c
index 534e1e2..8680062 100644
--- a/fs/gfs2/ops_inode.c
+++ b/fs/gfs2/ops_inode.c
@@ -894,7 +894,7 @@ out:
  */
 
 static int gfs2_readlink(struct dentry *dentry, char __user *user_buf,
-			 int user_size)
+			 size_t user_size)
 {
 	struct gfs2_inode *ip = GFS2_I(dentry->d_inode);
 	char array[GFS2_FAST_NAME_SIZE], *buf = array;
diff --git a/fs/hppfs/hppfs.c b/fs/hppfs/hppfs.c
index 2b3d182..488f95d 100644
--- a/fs/hppfs/hppfs.c
+++ b/fs/hppfs/hppfs.c
@@ -637,7 +637,7 @@ static const struct super_operations hppfs_sbops = {
 };
 
 static int hppfs_readlink(struct dentry *dentry, char __user *buffer,
-			  int buflen)
+			  size_t buflen)
 {
 	struct dentry *proc_dentry;
 
diff --git a/fs/namei.c b/fs/namei.c
index 4ea63ed..63e01e4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2712,7 +2712,7 @@ asmlinkage long sys_rename(const char __user *oldname, const char __user *newnam
 	return sys_renameat(AT_FDCWD, oldname, AT_FDCWD, newname);
 }
 
-int vfs_readlink(struct dentry *dentry, char __user *buffer, int buflen, const char *link)
+int vfs_readlink(struct dentry *dentry, char __user *buffer, size_t buflen, const char *link)
 {
 	int len;
 
@@ -2721,7 +2721,7 @@ int vfs_readlink(struct dentry *dentry, char __user *buffer, int buflen, const c
 		goto out;
 
 	len = strlen(link);
-	if (len > (unsigned) buflen)
+	if (len > buflen)
 		len = buflen;
 	if (copy_to_user(buffer, link, len))
 		len = -EFAULT;
@@ -2734,7 +2734,7 @@ out:
  * have ->follow_link() touching nd only in nd_set_link().  Using (or not
  * using) it for any given inode is up to filesystem.
  */
-int generic_readlink(struct dentry *dentry, char __user *buffer, int buflen)
+int generic_readlink(struct dentry *dentry, char __user *buffer, size_t buflen)
 {
 	struct nameidata nd;
 	void *cookie;
@@ -2768,7 +2768,7 @@ static char *page_getlink(struct dentry * dentry, struct page **ppage)
 	return kmap(page);
 }
 
-int page_readlink(struct dentry *dentry, char __user *buffer, int buflen)
+int page_readlink(struct dentry *dentry, char __user *buffer, size_t buflen)
 {
 	struct page *page = NULL;
 	char *s = page_getlink(dentry, &page);
diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index cbd03df..3295ff7 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -101,7 +101,7 @@ bail:
 
 static int ocfs2_readlink(struct dentry *dentry,
 			  char __user *buffer,
-			  int buflen)
+			  size_t buflen)
 {
 	int ret;
 	char *link;
diff --git a/fs/proc/base.c b/fs/proc/base.c
index b5918ae..14b90b9 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1333,7 +1333,7 @@ out:
 	return ERR_PTR(error);
 }
 
-static int do_proc_readlink(struct path *path, char __user *buffer, int buflen)
+static int do_proc_readlink(struct path *path, char __user *buffer, size_t buflen)
 {
 	char *tmp = (char*)__get_free_page(GFP_TEMPORARY);
 	char *pathname;
@@ -1357,7 +1357,7 @@ static int do_proc_readlink(struct path *path, char __user *buffer, int buflen)
 	return len;
 }
 
-static int proc_pid_readlink(struct dentry * dentry, char __user * buffer, int buflen)
+static int proc_pid_readlink(struct dentry * dentry, char __user * buffer, size_t buflen)
 {
 	int error = -EACCES;
 	struct inode *inode = dentry->d_inode;
@@ -2246,7 +2246,7 @@ static const struct file_operations proc_coredump_filter_operations = {
  * /proc/self:
  */
 static int proc_self_readlink(struct dentry *dentry, char __user *buffer,
-			      int buflen)
+			      size_t buflen)
 {
 	struct pid_namespace *ns = dentry->d_sb->s_fs_info;
 	pid_t tgid = task_tgid_nr_ns(current, ns);
diff --git a/fs/stat.c b/fs/stat.c
index 7c46fbe..b521674 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -292,13 +292,13 @@ asmlinkage long sys_newfstat(unsigned int fd, struct stat __user *statbuf)
 }
 
 asmlinkage long sys_readlinkat(int dfd, const char __user *pathname,
-				char __user *buf, int bufsiz)
+				char __user *buf, size_t bufsiz)
 {
 	struct path path;
 	int error;
 
-	if (bufsiz <= 0)
-		return -EINVAL;
+	if (unlikely(!bufsiz))
+		return 0;
 
 	error = user_path_at(dfd, pathname, 0, &path);
 	if (!error) {
@@ -319,7 +319,7 @@ asmlinkage long sys_readlinkat(int dfd, const char __user *pathname,
 }
 
 asmlinkage long sys_readlink(const char __user *path, char __user *buf,
-				int bufsiz)
+				size_t bufsiz)
 {
 	return sys_readlinkat(AT_FDCWD, path, buf, bufsiz);
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index a6a625b..816dc29 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1333,7 +1333,7 @@ struct inode_operations {
 	int (*mknod) (struct inode *,struct dentry *,int,dev_t);
 	int (*rename) (struct inode *, struct dentry *,
 			struct inode *, struct dentry *);
-	int (*readlink) (struct dentry *, char __user *,int);
+	int (*readlink) (struct dentry *, char __user *,size_t);
 	void * (*follow_link) (struct dentry *, struct nameidata *);
 	void (*put_link) (struct dentry *, struct nameidata *, void *);
 	void (*truncate) (struct inode *);
@@ -2029,16 +2029,16 @@ extern const struct file_operations generic_ro_fops;
 
 #define special_file(m) (S_ISCHR(m)||S_ISBLK(m)||S_ISFIFO(m)||S_ISSOCK(m))
 
-extern int vfs_readlink(struct dentry *, char __user *, int, const char *);
+extern int vfs_readlink(struct dentry *, char __user *, size_t, const char *);
 extern int vfs_follow_link(struct nameidata *, const char *);
-extern int page_readlink(struct dentry *, char __user *, int);
+extern int page_readlink(struct dentry *, char __user *, size_t);
 extern void *page_follow_link_light(struct dentry *, struct nameidata *);
 extern void page_put_link(struct dentry *, struct nameidata *, void *);
 extern int __page_symlink(struct inode *inode, const char *symname, int len,
 		gfp_t gfp_mask);
 extern int page_symlink(struct inode *inode, const char *symname, int len);
 extern const struct inode_operations page_symlink_inode_operations;
-extern int generic_readlink(struct dentry *, char __user *, int);
+extern int generic_readlink(struct dentry *, char __user *, size_t);
 extern void generic_fillattr(struct inode *, struct kstat *);
 extern int vfs_getattr(struct vfsmount *, struct dentry *, struct kstat *);
 void inode_add_bytes(struct inode *inode, loff_t bytes);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index d6ff145..e9582d1 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -326,7 +326,7 @@ asmlinkage ssize_t sys_sendfile(int out_fd, int in_fd,
 asmlinkage ssize_t sys_sendfile64(int out_fd, int in_fd,
 				loff_t __user *offset, size_t count);
 asmlinkage long sys_readlink(const char __user *path,
-				char __user *buf, int bufsiz);
+				char __user *buf, size_t bufsiz);
 asmlinkage long sys_creat(const char __user *pathname, int mode);
 asmlinkage long sys_open(const char __user *filename,
 				int flags, int mode);
@@ -581,7 +581,7 @@ asmlinkage long sys_newfstatat(int dfd, char __user *filename,
 asmlinkage long sys_fstatat64(int dfd, char __user *filename,
 			       struct stat64 __user *statbuf, int flag);
 asmlinkage long sys_readlinkat(int dfd, const char __user *path, char __user *buf,
-			       int bufsiz);
+			       size_t bufsiz);
 asmlinkage long sys_utimensat(int dfd, char __user *filename,
 				struct timespec __user *utimes, int flags);
 asmlinkage long compat_sys_futimesat(unsigned int dfd, char __user *filename,

--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

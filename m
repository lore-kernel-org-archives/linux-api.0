From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 04/11] capsicum: implement fgetr() and friends
Date: Fri, 25 Jul 2014 14:47:00 +0100
Message-ID: <1406296033-32693-5-git-send-email-drysdale@google.com>
References: <1406296033-32693-1-git-send-email-drysdale@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1406296033-32693-1-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add variants of fget() and related functions where the caller
indicates the operations that will be performed on the file.

If CONFIG_SECURITY_CAPSICUM is defined, these variants build a
struct capsicum_rights instance holding the rights associated
with the file operations; this will allow a future hook to check
whether a rights-restricted file has those specific rights
available.

If CONFIG_SECURITY_CAPSICUM is not defined, these variants expand
to the underlying fget() function, with one difference: failures
are returned as an ERR_PTR value rather than just NULL.

Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 fs/file.c             | 136 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/namei.c            |  50 ++++++++++++++++--
 fs/read_write.c       |   5 --
 include/linux/file.h  | 139 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/namei.h |   9 ++++
 5 files changed, 331 insertions(+), 8 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 66923fe3176e..ae53219d720b 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -13,6 +13,7 @@
 #include <linux/mmzone.h>
 #include <linux/time.h>
 #include <linux/sched.h>
+#include <linux/security.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 #include <linux/file.h>
@@ -717,6 +718,141 @@ unsigned long __fdget_pos(unsigned int fd)
 	return v;
 }
 
+#ifdef CONFIG_SECURITY_CAPSICUM
+/*
+ * We might want to change the return value of fget() and friends.  This
+ * function is called with the intended return value, and fget() will /actually/
+ * return whatever is returned from here. We adjust the reference counter if
+ * necessary.
+ */
+static struct file *unwrap_file(struct file *orig,
+				const struct capsicum_rights *required_rights,
+				const struct capsicum_rights **actual_rights,
+				bool update_refcnt)
+{
+	struct file *f;
+
+	if (orig == NULL)
+		return ERR_PTR(-EBADF);
+	if (IS_ERR(orig))
+		return orig;
+	f = orig;  /* TODO: change the value of f here */
+	if (f != orig && update_refcnt) {
+		/* We're not returning the original, and the calling code
+		 * has already incremented the refcount on it, we need to
+		 * release that reference and obtain a reference to the new
+		 * return value, if any.
+		 */
+		if (!IS_ERR(f) && !atomic_long_inc_not_zero(&f->f_count))
+			f = ERR_PTR(-EBADF);
+		atomic_long_dec(&orig->f_count);
+	}
+
+	return f;
+}
+
+struct file *fget_rights(unsigned int fd, const struct capsicum_rights *rights)
+{
+	return unwrap_file(fget(fd), rights, NULL, true);
+}
+EXPORT_SYMBOL(fget_rights);
+
+struct file *fget_raw_rights(unsigned int fd,
+			     const struct capsicum_rights *rights)
+{
+	return unwrap_file(fget_raw(fd), rights, NULL, true);
+}
+EXPORT_SYMBOL(fget_raw_rights);
+
+struct fd fdget_rights(unsigned int fd, const struct capsicum_rights *rights)
+{
+	struct fd f = fdget(fd);
+
+	f.file = unwrap_file(f.file, rights, NULL, (f.flags & FDPUT_FPUT));
+	return f;
+}
+EXPORT_SYMBOL(fdget_rights);
+
+struct fd fdget_raw_rights(unsigned int fd,
+			   const struct capsicum_rights **actual_rights,
+			   const struct capsicum_rights *rights)
+{
+	struct fd f = fdget_raw(fd);
+
+	f.file = unwrap_file(f.file, rights, actual_rights,
+			     (f.flags & FDPUT_FPUT));
+	return f;
+}
+EXPORT_SYMBOL(fdget_raw_rights);
+
+struct file *_fgetr(unsigned int fd, ...)
+{
+	struct capsicum_rights rights;
+	struct file *f;
+	va_list ap;
+
+	va_start(ap, fd);
+	f = fget_rights(fd, cap_rights_vinit(&rights, ap));
+	va_end(ap);
+	return f;
+}
+EXPORT_SYMBOL(_fgetr);
+
+struct file *_fgetr_raw(unsigned int fd, ...)
+{
+	struct capsicum_rights rights;
+	struct file *f;
+	va_list ap;
+
+	va_start(ap, fd);
+	f = fget_raw_rights(fd, cap_rights_vinit(&rights, ap));
+	va_end(ap);
+	return f;
+}
+EXPORT_SYMBOL(_fgetr_raw);
+
+struct fd _fdgetr(unsigned int fd, ...)
+{
+	struct fd f;
+	struct capsicum_rights rights;
+	va_list ap;
+
+	va_start(ap, fd);
+	f = fdget_rights(fd, cap_rights_vinit(&rights, ap));
+	va_end(ap);
+	return f;
+}
+EXPORT_SYMBOL(_fdgetr);
+
+struct fd _fdgetr_raw(unsigned int fd, ...)
+{
+	struct fd f;
+	struct capsicum_rights rights;
+	va_list ap;
+
+	va_start(ap, fd);
+	f = fdget_raw_rights(fd, NULL, cap_rights_vinit(&rights, ap));
+	va_end(ap);
+	return f;
+}
+EXPORT_SYMBOL(_fdgetr_raw);
+
+struct fd _fdgetr_pos(unsigned int fd, ...)
+{
+	struct fd f;
+	struct capsicum_rights rights;
+	va_list ap;
+
+	f = __to_fd(__fdget_pos(fd));
+	va_start(ap, fd);
+	f.file = unwrap_file(f.file, cap_rights_vinit(&rights, ap), NULL,
+			     (f.flags & FDPUT_FPUT));
+	va_end(ap);
+	return f;
+}
+EXPORT_SYMBOL(_fdgetr_pos);
+#endif
+
 /*
  * We only lock f_pos if we have threads or if the file might be
  * shared with another process. In both cases we'll have an elevated
diff --git a/fs/namei.c b/fs/namei.c
index 165ebb1209d4..548e351fade1 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -647,6 +647,19 @@ static __always_inline void set_root(struct nameidata *nd)
 		get_fs_root(current->fs, &nd->root);
 }
 
+/*
+ * Retrieval of files against a directory file descriptor requires
+ * CAP_LOOKUP. As this is common in this file, set up the required rights once
+ * and for all.
+ */
+static struct capsicum_rights lookup_rights;
+static int __init init_lookup_rights(void)
+{
+	cap_rights_init(&lookup_rights, CAP_LOOKUP);
+	return 0;
+}
+fs_initcall(init_lookup_rights);
+
 static int link_path_walk(const char *, struct nameidata *, unsigned int);
 
 static __always_inline void set_root_rcu(struct nameidata *nd)
@@ -2136,8 +2149,12 @@ struct dentry *lookup_one_len(const char *name, struct dentry *base, int len)
 }
 EXPORT_SYMBOL(lookup_one_len);
 
-int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
-		 struct path *path, int *empty)
+static int user_path_at_empty_rights(int dfd,
+				const char __user *name,
+				unsigned flags,
+				struct path *path,
+				int *empty,
+				const struct capsicum_rights *rights)
 {
 	struct nameidata nd;
 	struct filename *tmp = getname_flags(name, flags, empty);
@@ -2154,13 +2171,40 @@ int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
 	return err;
 }
 
+int user_path_at_empty(int dfd, const char __user *name, unsigned flags,
+		 struct path *path, int *empty)
+{
+	return user_path_at_empty_rights(dfd, name, flags, path, empty,
+					 &lookup_rights);
+}
+
 int user_path_at(int dfd, const char __user *name, unsigned flags,
 		 struct path *path)
 {
-	return user_path_at_empty(dfd, name, flags, path, NULL);
+	return user_path_at_empty_rights(dfd, name, flags, path, NULL,
+					 &lookup_rights);
 }
 EXPORT_SYMBOL(user_path_at);
 
+#ifdef CONFIG_SECURITY_CAPSICUM
+int _user_path_atr(int dfd,
+		   const char __user *name,
+		   unsigned flags,
+		   struct path *path,
+		   ...)
+{
+	struct capsicum_rights rights;
+	int rc;
+	va_list ap;
+
+	va_start(ap, path);
+	rc = user_path_at_empty_rights(dfd, name, flags, path, NULL,
+				       cap_rights_vinit(&rights, ap));
+	va_end(ap);
+	return rc;
+}
+#endif
+
 /*
  * NB: most callers don't do anything directly with the reference to the
  *     to struct filename, but the nd->last pointer points into the name string
diff --git a/fs/read_write.c b/fs/read_write.c
index 009d8542a889..c6e0f20a9f94 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -265,11 +265,6 @@ loff_t vfs_llseek(struct file *file, loff_t offset, int whence)
 }
 EXPORT_SYMBOL(vfs_llseek);
 
-static inline struct fd fdget_pos(int fd)
-{
-	return __to_fd(__fdget_pos(fd));
-}
-
 static inline void fdput_pos(struct fd f)
 {
 	if (f.flags & FDPUT_POS_UNLOCK)
diff --git a/include/linux/file.h b/include/linux/file.h
index 4d69123377a2..8bf7e13365b5 100644
--- a/include/linux/file.h
+++ b/include/linux/file.h
@@ -8,6 +8,8 @@
 #include <linux/compiler.h>
 #include <linux/types.h>
 #include <linux/posix_types.h>
+#include <linux/err.h>
+#include <linux/capsicum.h>
 
 struct file;
 
@@ -39,6 +41,21 @@ static inline void fdput(struct fd fd)
 		fput(fd.file);
 }
 
+/*
+ * The base functions for converting a file descriptor to a struct file are:
+ *  - fget() always increments refcount, doesn't work on O_PATH files.
+ *  - fget_raw() always increments refcount, and does work on O_PATH files.
+ *  - fdget() only increments refcount if needed, doesn't work on O_PATH files.
+ *  - fdget_raw() only increments refcount if needed, works on O_PATH files.
+ *  - fdget_pos() as fdget(), but also locks the file position lock (for
+ *    operations that POSIX requires to be atomic w.r.t file position).
+ * These functions return NULL on failure, and return the actual entry in the
+ * fdtable (which may be a wrapper if the file is a Capsicum capability).
+ *
+ * These functions should normally only be used when a file is being
+ * transferred (e.g. dup(2)) or manipulated as-is; normal users should stick
+ * to the fgetr() variants below.
+ */
 extern struct file *fget(unsigned int fd);
 extern struct file *fget_raw(unsigned int fd);
 extern unsigned long __fdget(unsigned int fd);
@@ -60,6 +77,128 @@ static inline struct fd fdget_raw(unsigned int fd)
 	return __to_fd(__fdget_raw(fd));
 }
 
+static inline struct fd fdget_pos(unsigned int fd)
+{
+	return __to_fd(__fdget_pos(fd));
+}
+
+#ifdef CONFIG_SECURITY_CAPSICUM
+/*
+ * The full unwrapping variant functions are:
+ *  - fget_rights()
+ *  - fget_raw_rights()
+ *  - fdget_rights()
+ *  - fdget_raw_rights()
+ * These versions have the same behavior as the equivalent base functions, but:
+ *  - They also take a struct capsicum_rights argument describing the details
+ *    of the operations to be performed on the file.
+ *  - They remove any Capsicum capability wrapper for the file, returning the
+ *    normal underlying file.
+ *  - They return an ERR_PTR on failure (typically with either -EBADF for an
+ *    unrecognized FD, or -ENOTCAPABLE for a Capsicum capability FD that does
+ *    not have the requisite rights).
+ *
+ * The fdget_raw_rights() function also optionally returns the actual Capsicum
+ * rights associated with the file descriptor; the caller should only access
+ * this structure while it holds a reference to the file.
+ *
+ * These functions should normally only be used:
+ *  - when the operation being performed on the file requires more detailed
+ *    specification (in particular: the ioctl(2) or fcntl(2) command invoked)
+ *  - (for fdget_raw_rights()) when a new file descriptor will be created from
+ *    this file descriptor, and so should potentially inherit its rights (if
+ *    it is a Capsicum capability file descriptor).
+ * Otherwise users should stick to the simpler fgetr() variants below.
+ */
+extern struct file *fget_rights(unsigned int fd,
+				const struct capsicum_rights *rights);
+extern struct file *fget_raw_rights(unsigned int fd,
+				    const struct capsicum_rights *rights);
+extern struct fd fdget_rights(unsigned int fd,
+			      const struct capsicum_rights *rights);
+extern struct fd fdget_raw_rights(unsigned int fd,
+				  const struct capsicum_rights **actual_rights,
+				  const struct capsicum_rights *rights);
+
+/*
+ * The simple unwrapping variant functions are:
+ *  - fgetr()
+ *  - fgetr_raw()
+ *  - fdgetr()
+ *  - fdgetr_raw()
+ *  - fdgetr_pos()
+ * These versions have the same behavior as the equivalent base functions, but:
+ *  - They also take variable arguments indicating the operations to be
+ *    performed on the file.
+ *  - They remove any Capsicum capability wrapper for the file, returning the
+ *    normal underlying file.
+ *  - They return an ERR_PTR on failure (typically with either -EBADF for an
+ *    unrecognized FD, or -ENOTCAPABLE for a Capsicum capability FD that does
+ *    not have the requisite rights).
+ *
+ * These functions should normally be used for FD->file conversion.
+ */
+#define fgetr(fd, ...)		_fgetr((fd), __VA_ARGS__, CAP_LIST_END)
+#define fgetr_raw(fd, ...)	_fgetr_raw((fd), __VA_ARGS__, CAP_LIST_END)
+#define fdgetr(fd, ...)	_fdgetr((fd), __VA_ARGS__, CAP_LIST_END)
+#define fdgetr_raw(fd, ...)	_fdgetr_raw((fd), __VA_ARGS__, CAP_LIST_END)
+#define fdgetr_pos(fd, ...)	_fdgetr_pos((fd), __VA_ARGS__, CAP_LIST_END)
+extern struct file *_fgetr(unsigned int fd, ...);
+extern struct file *_fgetr_raw(unsigned int fd, ...);
+extern struct fd _fdgetr(unsigned int fd, ...);
+extern struct fd _fdgetr_raw(unsigned int fd, ...);
+extern struct fd _fdgetr_pos(unsigned int fd, ...);
+
+#else
+/*
+ * In a non-Capsicum build, all rights-checking fget() variants fall back to the
+ * normal versions (but still return errors as ERR_PTR values not just NULL).
+ */
+static inline struct file *fget_rights(unsigned int fd,
+				       const struct capsicum_rights *rights)
+{
+	return fget(fd) ?: ERR_PTR(-EBADF);
+}
+static inline struct file *fget_raw_rights(unsigned int fd,
+					   const struct capsicum_rights *rights)
+{
+	return fget_raw(fd) ?: ERR_PTR(-EBADF);
+}
+static inline struct fd fdget_rights(unsigned int fd,
+				     const struct capsicum_rights *rights)
+{
+	struct fd f = fdget(fd);
+
+	if (f.file == NULL)
+		f.file = ERR_PTR(-EBADF);
+	return f;
+}
+static inline struct fd
+fdget_raw_rights(unsigned int fd,
+		 const struct capsicum_rights **actual_rights,
+		 const struct capsicum_rights *rights)
+{
+	struct fd f = fdget_raw(fd);
+
+	if (f.file == NULL)
+		f.file = ERR_PTR(-EBADF);
+	return f;
+}
+
+#define fgetr(fd, ...)		(fget(fd) ?: ERR_PTR(-EBADF))
+#define fgetr_raw(fd, ...)	(fget_raw(fd) ?: ERR_PTR(-EBADF))
+#define fdgetr(fd, ...)	fdget_rights((fd), NULL)
+#define fdgetr_raw(fd, ...)	fdget_raw_rights((fd), NULL, NULL)
+static inline struct fd fdgetr_pos(int fd, ...)
+{
+	struct fd f = fdget_pos(fd);
+
+	if (f.file == NULL)
+		f.file = ERR_PTR(-EBADF);
+	return f;
+}
+#endif
+
 extern int f_dupfd(unsigned int from, struct file *file, unsigned flags);
 extern int replace_fd(unsigned fd, struct file *file, unsigned flags);
 extern void set_close_on_exec(unsigned int fd, int flag);
diff --git a/include/linux/namei.h b/include/linux/namei.h
index bd0615d1143b..3466f35d7e5d 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -59,6 +59,15 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 
 extern int user_path_at(int, const char __user *, unsigned, struct path *);
 extern int user_path_at_empty(int, const char __user *, unsigned, struct path *, int *empty);
+#ifdef CONFIG_SECURITY_CAPSICUM
+extern int _user_path_atr(int, const char __user *, unsigned,
+			  struct path *, ...);
+#define user_path_atr(f, n, x, p, ...) \
+	_user_path_atr((f), (n), (x), (p), __VA_ARGS__, 0ULL)
+#else
+#define user_path_atr(f, n, x, p, ...) \
+	user_path_at((f), (n), (x), (p))
+#endif
 
 #define user_path(name, path) user_path_at(AT_FDCWD, name, LOOKUP_FOLLOW, path)
 #define user_lpath(name, path) user_path_at(AT_FDCWD, name, 0, path)
-- 
2.0.0.526.g5318336

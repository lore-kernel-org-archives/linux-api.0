From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv4 1/3] fs: add O_BENEATH flag to openat(2)
Date: Thu, 13 Aug 2015 10:32:44 +0100
Message-ID: <1439458366-8223-2-git-send-email-drysdale@google.com>
References: <1439458366-8223-1-git-send-email-drysdale@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439458366-8223-1-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jorge Lucangeli Obes <jorgelo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ricky Zhou <rickyz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lee Campbell <leecam-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Depinet <mdepinet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fstests-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add a new O_BENEATH flag for openat(2) which restricts the
provided path, rejecting (with -EPERM) paths that are not beneath
the provided dfd.  In particular, reject:
 - paths that contain .. components
 - paths that begin with /
 - symlinks that have paths as above.

Also disallow use of nd_jump_link() for following symlinks without
path expansion, when O_BENEATH is set.

Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/alpha/include/uapi/asm/fcntl.h  |  1 +
 arch/parisc/include/uapi/asm/fcntl.h |  1 +
 arch/sparc/include/uapi/asm/fcntl.h  |  1 +
 fs/fcntl.c                           |  4 ++--
 fs/namei.c                           | 12 +++++++++++-
 fs/open.c                            |  4 +++-
 fs/proc/base.c                       |  4 +++-
 fs/proc/namespaces.c                 |  8 ++++++--
 include/linux/namei.h                |  3 ++-
 include/uapi/asm-generic/fcntl.h     |  4 ++++
 10 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/arch/alpha/include/uapi/asm/fcntl.h b/arch/alpha/include/uapi/asm/fcntl.h
index 09f49a6b87d1..76a87038d2c1 100644
--- a/arch/alpha/include/uapi/asm/fcntl.h
+++ b/arch/alpha/include/uapi/asm/fcntl.h
@@ -33,6 +33,7 @@
 
 #define O_PATH		040000000
 #define __O_TMPFILE	0100000000
+#define O_BENEATH	0200000000	/* no / or .. in openat path */
 
 #define F_GETLK		7
 #define F_SETLK		8
diff --git a/arch/parisc/include/uapi/asm/fcntl.h b/arch/parisc/include/uapi/asm/fcntl.h
index 34a46cbc76ed..3adadf72f929 100644
--- a/arch/parisc/include/uapi/asm/fcntl.h
+++ b/arch/parisc/include/uapi/asm/fcntl.h
@@ -21,6 +21,7 @@
 
 #define O_PATH		020000000
 #define __O_TMPFILE	040000000
+#define O_BENEATH	080000000	/* no / or .. in openat path */
 
 #define F_GETLK64	8
 #define F_SETLK64	9
diff --git a/arch/sparc/include/uapi/asm/fcntl.h b/arch/sparc/include/uapi/asm/fcntl.h
index 7e8ace5bf760..ea38f0bd6cec 100644
--- a/arch/sparc/include/uapi/asm/fcntl.h
+++ b/arch/sparc/include/uapi/asm/fcntl.h
@@ -36,6 +36,7 @@
 
 #define O_PATH		0x1000000
 #define __O_TMPFILE	0x2000000
+#define O_BENEATH	0x4000000	/* no / or .. in openat path */
 
 #define F_GETOWN	5	/*  for sockets. */
 #define F_SETOWN	6	/*  for sockets. */
diff --git a/fs/fcntl.c b/fs/fcntl.c
index ee85cd4e136a..3169693e9390 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -740,7 +740,7 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
+	BUILD_BUG_ON(22 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
 		O_TRUNC		| O_APPEND	| /* O_NONBLOCK	| */
@@ -748,7 +748,7 @@ static int __init fcntl_init(void)
 		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
 		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
 		__FMODE_EXEC	| O_PATH	| __O_TMPFILE	|
-		__FMODE_NONOTIFY
+		__FMODE_NONOTIFY| O_BENEATH
 		));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
diff --git a/fs/namei.c b/fs/namei.c
index fbbcf0993312..978f07d91a11 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -827,14 +827,18 @@ static inline void path_to_nameidata(const struct path *path,
  * Helper to directly jump to a known parsed path from ->follow_link,
  * caller must have taken a reference to path beforehand.
  */
-void nd_jump_link(struct path *path)
+int nd_jump_link(struct path *path)
 {
 	struct nameidata *nd = current->nameidata;
+
+	if (nd->flags & LOOKUP_BENEATH)
+		return -EPERM;
 	path_put(&nd->path);
 
 	nd->path = *path;
 	nd->inode = nd->path.dentry->d_inode;
 	nd->flags |= LOOKUP_JUMPED;
+	return 0;
 }
 
 static inline void put_link(struct nameidata *nd)
@@ -1000,6 +1004,8 @@ const char *get_link(struct nameidata *nd)
 		}
 	}
 	if (*res == '/') {
+		if (nd->flags & LOOKUP_BENEATH)
+			return ERR_PTR(-EPERM);
 		if (nd->flags & LOOKUP_RCU) {
 			struct dentry *d;
 			if (!nd->root.mnt)
@@ -1888,6 +1894,8 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 		if (name[0] == '.') switch (hashlen_len(hash_len)) {
 			case 2:
 				if (name[1] == '.') {
+					if (nd->flags & LOOKUP_BENEATH)
+						return -EPERM;
 					type = LAST_DOTDOT;
 					nd->flags |= LOOKUP_JUMPED;
 				}
@@ -2000,6 +2008,8 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 
 	nd->m_seq = read_seqbegin(&mount_lock);
 	if (*s == '/') {
+		if (flags & LOOKUP_BENEATH)
+			return ERR_PTR(-EPERM);
 		if (flags & LOOKUP_RCU) {
 			rcu_read_lock();
 			set_root_rcu(nd);
diff --git a/fs/open.c b/fs/open.c
index e33dab287fa0..29208cd307f7 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -917,7 +917,7 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		 * If we have O_PATH in the open flag. Then we
 		 * cannot have anything other than the below set of flags
 		 */
-		flags &= O_DIRECTORY | O_NOFOLLOW | O_PATH;
+		flags &= O_DIRECTORY | O_NOFOLLOW | O_PATH | O_BENEATH;
 		acc_mode = 0;
 	} else {
 		acc_mode = MAY_OPEN | ACC_MODE(flags);
@@ -948,6 +948,8 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		lookup_flags |= LOOKUP_DIRECTORY;
 	if (!(flags & O_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
+	if (flags & O_BENEATH)
+		lookup_flags |= LOOKUP_BENEATH;
 	op->lookup_flags = lookup_flags;
 	return 0;
 }
diff --git a/fs/proc/base.c b/fs/proc/base.c
index aa50d1ac28fc..281f7a8d8060 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1589,7 +1589,9 @@ static const char *proc_pid_follow_link(struct dentry *dentry, void **cookie)
 	if (error)
 		goto out;
 
-	nd_jump_link(&path);
+	error = nd_jump_link(&path);
+	if (error)
+		goto out;
 	return NULL;
 out:
 	return ERR_PTR(error);
diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index f6e8354b8cea..beb5aa3ad38c 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -36,6 +36,7 @@ static const char *proc_ns_follow_link(struct dentry *dentry, void **cookie)
 	const struct proc_ns_operations *ns_ops = PROC_I(inode)->ns_ops;
 	struct task_struct *task;
 	struct path ns_path;
+	int err;
 	void *error = ERR_PTR(-EACCES);
 
 	task = get_proc_task(inode);
@@ -44,8 +45,11 @@ static const char *proc_ns_follow_link(struct dentry *dentry, void **cookie)
 
 	if (ptrace_may_access(task, PTRACE_MODE_READ)) {
 		error = ns_get_path(&ns_path, task, ns_ops);
-		if (!error)
-			nd_jump_link(&ns_path);
+		if (!error) {
+			err = nd_jump_link(&ns_path);
+			if (err)
+				error = ERR_PTR(err);
+		}
 	}
 	put_task_struct(task);
 	return error;
diff --git a/include/linux/namei.h b/include/linux/namei.h
index d8c6334cd150..a5a262c85e49 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -27,6 +27,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_FOLLOW		0x0001
 #define LOOKUP_DIRECTORY	0x0002
 #define LOOKUP_AUTOMOUNT	0x0004
+#define LOOKUP_BENEATH		0x0008
 
 #define LOOKUP_PARENT		0x0010
 #define LOOKUP_REVAL		0x0020
@@ -85,7 +86,7 @@ extern int follow_up(struct path *);
 extern struct dentry *lock_rename(struct dentry *, struct dentry *);
 extern void unlock_rename(struct dentry *, struct dentry *);
 
-extern void nd_jump_link(struct path *path);
+extern int nd_jump_link(struct path *path);
 
 static inline void nd_terminate_link(void *name, size_t len, size_t maxlen)
 {
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index e063effe0cc1..4542bc6a2950 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -92,6 +92,10 @@
 #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
 #define O_TMPFILE_MASK (__O_TMPFILE | O_DIRECTORY | O_CREAT)      
 
+#ifndef O_BENEATH
+#define O_BENEATH	040000000	/* no / or .. in openat path */
+#endif
+
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
-- 
1.9.1

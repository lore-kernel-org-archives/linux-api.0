From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] fs: add O_BENEATH flag to openat(2)
Date: Mon,  3 Nov 2014 11:48:23 +0000
Message-ID: <1415015305-15494-2-git-send-email-drysdale@google.com>
References: <1415015305-15494-1-git-send-email-drysdale@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415015305-15494-1-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Jorge Lucangeli Obes <jorgelo-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Ricky Zhou <rickyz-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Lee Campbell <leecam-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Julien Tinnes <jln-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mike Depinet <mdepinet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Moore <paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add a new O_BENEATH flag for openat(2) which restricts the
provided path, rejecting (with -EACCES) paths that are not beneath
the provided dfd.  In particular, reject:
 - paths that contain .. components
 - paths that begin with /
 - symlinks that have paths as above.

Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/alpha/include/uapi/asm/fcntl.h  |  1 +
 arch/parisc/include/uapi/asm/fcntl.h |  1 +
 arch/sparc/include/uapi/asm/fcntl.h  |  1 +
 fs/fcntl.c                           |  5 +++--
 fs/namei.c                           | 43 ++++++++++++++++++++++++------------
 fs/open.c                            |  4 +++-
 include/linux/namei.h                |  1 +
 include/uapi/asm-generic/fcntl.h     |  4 ++++
 8 files changed, 43 insertions(+), 17 deletions(-)

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
index 22d1c3df61ac..c07a32efc34b 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -747,14 +747,15 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(20 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
+	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ != HWEIGHT32(
 		O_RDONLY	| O_WRONLY	| O_RDWR	|
 		O_CREAT		| O_EXCL	| O_NOCTTY	|
 		O_TRUNC		| O_APPEND	| /* O_NONBLOCK	| */
 		__O_SYNC	| O_DSYNC	| FASYNC	|
 		O_DIRECT	| O_LARGEFILE	| O_DIRECTORY	|
 		O_NOFOLLOW	| O_NOATIME	| O_CLOEXEC	|
-		__FMODE_EXEC	| O_PATH	| __O_TMPFILE
+		__FMODE_EXEC	| O_PATH	| __O_TMPFILE	|
+		O_BENEATH
 		));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
diff --git a/fs/namei.c b/fs/namei.c
index a7b05bf82d31..2fd547014b6b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -647,7 +647,7 @@ static __always_inline void set_root(struct nameidata *nd)
 	get_fs_root(current->fs, &nd->root);
 }
 
-static int link_path_walk(const char *, struct nameidata *);
+static int link_path_walk(const char *, struct nameidata *, unsigned int);
 
 static __always_inline unsigned set_root_rcu(struct nameidata *nd)
 {
@@ -819,7 +819,8 @@ static int may_linkat(struct path *link)
 }
 
 static __always_inline int
-follow_link(struct path *link, struct nameidata *nd, void **p)
+follow_link(struct path *link, struct nameidata *nd, unsigned int flags,
+	    void **p)
 {
 	struct dentry *dentry = link->dentry;
 	int error;
@@ -867,7 +868,7 @@ follow_link(struct path *link, struct nameidata *nd, void **p)
 			nd->flags |= LOOKUP_JUMPED;
 		}
 		nd->inode = nd->path.dentry->d_inode;
-		error = link_path_walk(s, nd);
+		error = link_path_walk(s, nd, flags);
 		if (unlikely(error))
 			put_link(nd, link, *p);
 	}
@@ -1585,7 +1586,8 @@ out_err:
  * Without that kind of total limit, nasty chains of consecutive
  * symlinks can cause almost arbitrarily long lookups.
  */
-static inline int nested_symlink(struct path *path, struct nameidata *nd)
+static inline int nested_symlink(struct path *path, struct nameidata *nd,
+				 unsigned int flags)
 {
 	int res;
 
@@ -1603,7 +1605,7 @@ static inline int nested_symlink(struct path *path, struct nameidata *nd)
 		struct path link = *path;
 		void *cookie;
 
-		res = follow_link(&link, nd, &cookie);
+		res = follow_link(&link, nd, flags, &cookie);
 		if (res)
 			break;
 		res = walk_component(nd, path, LOOKUP_FOLLOW);
@@ -1739,13 +1741,19 @@ static inline u64 hash_name(const char *name)
  * Returns 0 and nd will have valid dentry and mnt on success.
  * Returns error and drops reference to input namei data on failure.
  */
-static int link_path_walk(const char *name, struct nameidata *nd)
+static int link_path_walk(const char *name, struct nameidata *nd,
+			  unsigned int flags)
 {
 	struct path next;
 	int err;
 	
-	while (*name=='/')
+	while (*name == '/') {
+		if (flags & LOOKUP_BENEATH) {
+			err = -EACCES;
+			goto exit;
+		}
 		name++;
+	}
 	if (!*name)
 		return 0;
 
@@ -1764,6 +1772,10 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 		if (name[0] == '.') switch (hashlen_len(hash_len)) {
 			case 2:
 				if (name[1] == '.') {
+					if (flags & LOOKUP_BENEATH) {
+						err = -EACCES;
+						goto exit;
+					}
 					type = LAST_DOTDOT;
 					nd->flags |= LOOKUP_JUMPED;
 				}
@@ -1806,7 +1818,7 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 			return err;
 
 		if (err) {
-			err = nested_symlink(&next, nd);
+			err = nested_symlink(&next, nd, flags);
 			if (err)
 				return err;
 		}
@@ -1815,6 +1827,7 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 			break;
 		}
 	}
+exit:
 	terminate_walk(nd);
 	return err;
 }
@@ -1853,6 +1866,8 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 
 	nd->m_seq = read_seqbegin(&mount_lock);
 	if (*name=='/') {
+		if (flags & LOOKUP_BENEATH)
+			return -EACCES;
 		if (flags & LOOKUP_RCU) {
 			rcu_read_lock();
 			nd->seq = set_root_rcu(nd);
@@ -1953,7 +1968,7 @@ static int path_lookupat(int dfd, const char *name,
 		return err;
 
 	current->total_link_count = 0;
-	err = link_path_walk(name, nd);
+	err = link_path_walk(name, nd, flags);
 
 	if (!err && !(flags & LOOKUP_PARENT)) {
 		err = lookup_last(nd, &path);
@@ -1964,7 +1979,7 @@ static int path_lookupat(int dfd, const char *name,
 			if (unlikely(err))
 				break;
 			nd->flags |= LOOKUP_PARENT;
-			err = follow_link(&link, nd, &cookie);
+			err = follow_link(&link, nd, flags, &cookie);
 			if (err)
 				break;
 			err = lookup_last(nd, &path);
@@ -2304,7 +2319,7 @@ path_mountpoint(int dfd, const char *name, struct path *path, unsigned int flags
 		return err;
 
 	current->total_link_count = 0;
-	err = link_path_walk(name, &nd);
+	err = link_path_walk(name, &nd, flags);
 	if (err)
 		goto out;
 
@@ -2316,7 +2331,7 @@ path_mountpoint(int dfd, const char *name, struct path *path, unsigned int flags
 		if (unlikely(err))
 			break;
 		nd.flags |= LOOKUP_PARENT;
-		err = follow_link(&link, &nd, &cookie);
+		err = follow_link(&link, &nd, flags, &cookie);
 		if (err)
 			break;
 		err = mountpoint_last(&nd, path);
@@ -3202,7 +3217,7 @@ static struct file *path_openat(int dfd, struct filename *pathname,
 		goto out;
 
 	current->total_link_count = 0;
-	error = link_path_walk(pathname->name, nd);
+	error = link_path_walk(pathname->name, nd, flags);
 	if (unlikely(error))
 		goto out;
 
@@ -3221,7 +3236,7 @@ static struct file *path_openat(int dfd, struct filename *pathname,
 			break;
 		nd->flags |= LOOKUP_PARENT;
 		nd->flags &= ~(LOOKUP_OPEN|LOOKUP_CREATE|LOOKUP_EXCL);
-		error = follow_link(&link, nd, &cookie);
+		error = follow_link(&link, nd, flags, &cookie);
 		if (unlikely(error))
 			break;
 		error = do_last(nd, &path, file, op, &opened, pathname);
diff --git a/fs/open.c b/fs/open.c
index d6fd3acde134..8afca5b87a0b 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -874,7 +874,7 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		 * If we have O_PATH in the open flag. Then we
 		 * cannot have anything other than the below set of flags
 		 */
-		flags &= O_DIRECTORY | O_NOFOLLOW | O_PATH;
+		flags &= O_DIRECTORY | O_NOFOLLOW | O_PATH | O_BENEATH;
 		acc_mode = 0;
 	} else {
 		acc_mode = MAY_OPEN | ACC_MODE(flags);
@@ -905,6 +905,8 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		lookup_flags |= LOOKUP_DIRECTORY;
 	if (!(flags & O_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
+	if (flags & O_BENEATH)
+		lookup_flags |= LOOKUP_BENEATH;
 	op->lookup_flags = lookup_flags;
 	return 0;
 }
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 492de72560fa..bd0615d1143b 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -39,6 +39,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_FOLLOW		0x0001
 #define LOOKUP_DIRECTORY	0x0002
 #define LOOKUP_AUTOMOUNT	0x0004
+#define LOOKUP_BENEATH		0x0008
 
 #define LOOKUP_PARENT		0x0010
 #define LOOKUP_REVAL		0x0020
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 7543b3e51331..f63aa749a4fb 100644
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
2.1.0.rc2.206.gedb03e5

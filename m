From: David Drysdale <drysdale@google.com>
Subject: [PATCH 01/11] fs: add O_BENEATH_ONLY flag to openat(2)
Date: Mon, 30 Jun 2014 11:28:01 +0100
Message-ID: <1404124096-21445-2-git-send-email-drysdale@google.com>
References: <1404124096-21445-1-git-send-email-drysdale@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1404124096-21445-1-git-send-email-drysdale@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, Kees Cook <keescook@chromium.org>, James Morris <james.l.morris@oracle.com>, linux-api@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Add a new O_BENEATH_ONLY flag for openat(2) which restricts the
provided path, rejecting (with -EACCES) paths that are not beneath
the provided dfd.  In particular, reject:
 - paths that contain .. components
 - paths that begin with /
 - symlinks that have paths as above.

Signed-off-by: David Drysdale <drysdale@google.com>
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
index 09f49a6b87d1..b3e0b00ff9ed 100644
--- a/arch/alpha/include/uapi/asm/fcntl.h
+++ b/arch/alpha/include/uapi/asm/fcntl.h
@@ -33,6 +33,7 @@
 
 #define O_PATH		040000000
 #define __O_TMPFILE	0100000000
+#define O_BENEATH_ONLY	0200000000	/* no / or .. in openat path */
 
 #define F_GETLK		7
 #define F_SETLK		8
diff --git a/arch/parisc/include/uapi/asm/fcntl.h b/arch/parisc/include/uapi/asm/fcntl.h
index 34a46cbc76ed..da4447775f87 100644
--- a/arch/parisc/include/uapi/asm/fcntl.h
+++ b/arch/parisc/include/uapi/asm/fcntl.h
@@ -21,6 +21,7 @@
 
 #define O_PATH		020000000
 #define __O_TMPFILE	040000000
+#define O_BENEATH_ONLY	080000000	/* no / or .. in openat path */
 
 #define F_GETLK64	8
 #define F_SETLK64	9
diff --git a/arch/sparc/include/uapi/asm/fcntl.h b/arch/sparc/include/uapi/asm/fcntl.h
index 7e8ace5bf760..9f2635197cf0 100644
--- a/arch/sparc/include/uapi/asm/fcntl.h
+++ b/arch/sparc/include/uapi/asm/fcntl.h
@@ -36,6 +36,7 @@
 
 #define O_PATH		0x1000000
 #define __O_TMPFILE	0x2000000
+#define O_BENEATH_ONLY	0x4000000	/* no / or .. in openat path */
 
 #define F_GETOWN	5	/*  for sockets. */
 #define F_SETOWN	6	/*  for sockets. */
diff --git a/fs/fcntl.c b/fs/fcntl.c
index 72c82f69b01b..79f9b09fa46b 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -742,14 +742,15 @@ static int __init fcntl_init(void)
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
+		O_BENEATH_ONLY
 		));
 
 	fasync_cache = kmem_cache_create("fasync_cache",
diff --git a/fs/namei.c b/fs/namei.c
index 80168273396b..e6b72531dfc7 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -646,7 +646,7 @@ static __always_inline void set_root(struct nameidata *nd)
 		get_fs_root(current->fs, &nd->root);
 }
 
-static int link_path_walk(const char *, struct nameidata *);
+static int link_path_walk(const char *, struct nameidata *, unsigned int);
 
 static __always_inline void set_root_rcu(struct nameidata *nd)
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
@@ -866,7 +867,7 @@ follow_link(struct path *link, struct nameidata *nd, void **p)
 			nd->flags |= LOOKUP_JUMPED;
 		}
 		nd->inode = nd->path.dentry->d_inode;
-		error = link_path_walk(s, nd);
+		error = link_path_walk(s, nd, flags);
 		if (unlikely(error))
 			put_link(nd, link, *p);
 	}
@@ -1573,7 +1574,8 @@ out_err:
  * Without that kind of total limit, nasty chains of consecutive
  * symlinks can cause almost arbitrarily long lookups.
  */
-static inline int nested_symlink(struct path *path, struct nameidata *nd)
+static inline int nested_symlink(struct path *path, struct nameidata *nd,
+				 unsigned int flags)
 {
 	int res;
 
@@ -1591,7 +1593,7 @@ static inline int nested_symlink(struct path *path, struct nameidata *nd)
 		struct path link = *path;
 		void *cookie;
 
-		res = follow_link(&link, nd, &cookie);
+		res = follow_link(&link, nd, flags, &cookie);
 		if (res)
 			break;
 		res = walk_component(nd, path, LOOKUP_FOLLOW);
@@ -1730,13 +1732,19 @@ static inline unsigned long hash_name(const char *name, unsigned int *hashp)
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
+		if (flags & LOOKUP_BENEATH_ONLY) {
+			err = -EACCES;
+			goto exit;
+		}
 		name++;
+	}
 	if (!*name)
 		return 0;
 
@@ -1758,6 +1766,10 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 		if (name[0] == '.') switch (len) {
 			case 2:
 				if (name[1] == '.') {
+					if (flags & LOOKUP_BENEATH_ONLY) {
+						err = -EACCES;
+						goto exit;
+					}
 					type = LAST_DOTDOT;
 					nd->flags |= LOOKUP_JUMPED;
 				}
@@ -1797,7 +1809,7 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 			return err;
 
 		if (err) {
-			err = nested_symlink(&next, nd);
+			err = nested_symlink(&next, nd, flags);
 			if (err)
 				return err;
 		}
@@ -1806,6 +1818,7 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 			break;
 		}
 	}
+exit:
 	terminate_walk(nd);
 	return err;
 }
@@ -1844,6 +1857,8 @@ static int path_init(int dfd, const char *name, unsigned int flags,
 
 	nd->m_seq = read_seqbegin(&mount_lock);
 	if (*name=='/') {
+		if (flags & LOOKUP_BENEATH_ONLY)
+			return -EACCES;
 		if (flags & LOOKUP_RCU) {
 			rcu_read_lock();
 			set_root_rcu(nd);
@@ -1937,7 +1952,7 @@ static int path_lookupat(int dfd, const char *name,
 		return err;
 
 	current->total_link_count = 0;
-	err = link_path_walk(name, nd);
+	err = link_path_walk(name, nd, flags);
 
 	if (!err && !(flags & LOOKUP_PARENT)) {
 		err = lookup_last(nd, &path);
@@ -1948,7 +1963,7 @@ static int path_lookupat(int dfd, const char *name,
 			if (unlikely(err))
 				break;
 			nd->flags |= LOOKUP_PARENT;
-			err = follow_link(&link, nd, &cookie);
+			err = follow_link(&link, nd, flags, &cookie);
 			if (err)
 				break;
 			err = lookup_last(nd, &path);
@@ -2287,7 +2302,7 @@ path_mountpoint(int dfd, const char *name, struct path *path, unsigned int flags
 		return err;
 
 	current->total_link_count = 0;
-	err = link_path_walk(name, &nd);
+	err = link_path_walk(name, &nd, flags);
 	if (err)
 		goto out;
 
@@ -2299,7 +2314,7 @@ path_mountpoint(int dfd, const char *name, struct path *path, unsigned int flags
 		if (unlikely(err))
 			break;
 		nd.flags |= LOOKUP_PARENT;
-		err = follow_link(&link, &nd, &cookie);
+		err = follow_link(&link, &nd, flags, &cookie);
 		if (err)
 			break;
 		err = mountpoint_last(&nd, path);
@@ -3185,7 +3200,7 @@ static struct file *path_openat(int dfd, struct filename *pathname,
 		goto out;
 
 	current->total_link_count = 0;
-	error = link_path_walk(pathname->name, nd);
+	error = link_path_walk(pathname->name, nd, flags);
 	if (unlikely(error))
 		goto out;
 
@@ -3204,7 +3219,7 @@ static struct file *path_openat(int dfd, struct filename *pathname,
 			break;
 		nd->flags |= LOOKUP_PARENT;
 		nd->flags &= ~(LOOKUP_OPEN|LOOKUP_CREATE|LOOKUP_EXCL);
-		error = follow_link(&link, nd, &cookie);
+		error = follow_link(&link, nd, flags, &cookie);
 		if (unlikely(error))
 			break;
 		error = do_last(nd, &path, file, op, &opened, pathname);
diff --git a/fs/open.c b/fs/open.c
index 9d64679cec73..f26c492f3698 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -869,7 +869,7 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		 * If we have O_PATH in the open flag. Then we
 		 * cannot have anything other than the below set of flags
 		 */
-		flags &= O_DIRECTORY | O_NOFOLLOW | O_PATH;
+		flags &= O_DIRECTORY | O_NOFOLLOW | O_PATH | O_BENEATH_ONLY;
 		acc_mode = 0;
 	} else {
 		acc_mode = MAY_OPEN | ACC_MODE(flags);
@@ -900,6 +900,8 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		lookup_flags |= LOOKUP_DIRECTORY;
 	if (!(flags & O_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
+	if (flags & O_BENEATH_ONLY)
+		lookup_flags |= LOOKUP_BENEATH_ONLY;
 	op->lookup_flags = lookup_flags;
 	return 0;
 }
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 492de72560fa..cd56c50109fc 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -39,6 +39,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_FOLLOW		0x0001
 #define LOOKUP_DIRECTORY	0x0002
 #define LOOKUP_AUTOMOUNT	0x0004
+#define LOOKUP_BENEATH_ONLY	0x0008
 
 #define LOOKUP_PARENT		0x0010
 #define LOOKUP_REVAL		0x0020
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 7543b3e51331..e662821c4bc2 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -92,6 +92,10 @@
 #define O_TMPFILE (__O_TMPFILE | O_DIRECTORY)
 #define O_TMPFILE_MASK (__O_TMPFILE | O_DIRECTORY | O_CREAT)      
 
+#ifndef O_BENEATH_ONLY
+#define O_BENEATH_ONLY	040000000	/* no / or .. in openat path */
+#endif
+
 #ifndef O_NDELAY
 #define O_NDELAY	O_NONBLOCK
 #endif
-- 
2.0.0.526.g5318336

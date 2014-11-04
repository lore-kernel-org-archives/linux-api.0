From: David Drysdale <drysdale@google.com>
Subject: [PATCHv2 1/3] fs: add O_BENEATH flag to openat(2)
Date: Tue,  4 Nov 2014 09:54:42 +0000
Message-ID: <1415094884-18349-2-git-send-email-drysdale@google.com>
References: <1415094884-18349-1-git-send-email-drysdale@google.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <1415094884-18349-1-git-send-email-drysdale@google.com>
Sender: linux-security-module-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Meredydd Luff <meredydd@senatehouse.org>, Will Drewry <wad@chromium.org>, Jorge Lucangeli Obes <jorgelo@google.com>, Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>, Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Add a new O_BENEATH flag for openat(2) which restricts the
provided path, rejecting (with -EACCES) paths that are not beneath
the provided dfd.  In particular, reject:
 - paths that contain .. components
 - paths that begin with /
 - symlinks that have paths as above.

Also disallow use of nd_jump_link() for following symlinks without
path expansion, when O_BENEATH is set.

Signed-off-by: David Drysdale <drysdale@google.com>
---
 arch/alpha/include/uapi/asm/fcntl.h  |  1 +
 arch/parisc/include/uapi/asm/fcntl.h |  1 +
 arch/sparc/include/uapi/asm/fcntl.h  |  1 +
 fs/fcntl.c                           |  5 +++--
 fs/namei.c                           | 21 ++++++++++++++++++---
 fs/open.c                            |  4 +++-
 fs/proc/base.c                       |  4 +++-
 fs/proc/namespaces.c                 |  7 ++++++-
 include/linux/namei.h                |  3 ++-
 include/uapi/asm-generic/fcntl.h     |  4 ++++
 10 files changed, 42 insertions(+), 9 deletions(-)

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
index a7b05bf82d31..01d1d97eab3e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -685,13 +685,16 @@ static inline void path_to_nameidata(const struct path *path,
  * Helper to directly jump to a known parsed path from ->follow_link,
  * caller must have taken a reference to path beforehand.
  */
-void nd_jump_link(struct nameidata *nd, struct path *path)
+int nd_jump_link(struct nameidata *nd, struct path *path)
 {
+	if (nd->flags & LOOKUP_BENEATH)
+		return -EPERM;
 	path_put(&nd->path);

 	nd->path = *path;
 	nd->inode = nd->path.dentry->d_inode;
 	nd->flags |= LOOKUP_JUMPED;
+	return 0;
 }

 static inline void put_link(struct nameidata *nd, struct path *link, void *cookie)
@@ -1743,9 +1746,14 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 {
 	struct path next;
 	int err;
-
-	while (*name=='/')
+
+	while (*name == '/') {
+		if (nd->flags & LOOKUP_BENEATH) {
+			err = -EPERM;
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
+					if (nd->flags & LOOKUP_BENEATH) {
+						err = -EPERM;
+						goto exit;
+					}
 					type = LAST_DOTDOT;
 					nd->flags |= LOOKUP_JUMPED;
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
+			return -EPERM;
 		if (flags & LOOKUP_RCU) {
 			rcu_read_lock();
 			nd->seq = set_root_rcu(nd);
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
diff --git a/fs/proc/base.c b/fs/proc/base.c
index baf852b648ad..75d430155f9a 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1410,7 +1410,9 @@ static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
 	if (error)
 		goto out;

-	nd_jump_link(nd, &path);
+	error = nd_jump_link(nd, &path);
+	if (error)
+		goto out;
 	return NULL;
 out:
 	return ERR_PTR(error);
diff --git a/fs/proc/namespaces.c b/fs/proc/namespaces.c
index 89026095f2b5..5cdbe5950756 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -113,6 +113,7 @@ static void *proc_ns_follow_link(struct dentry *dentry, struct nameidata *nd)
 	struct proc_inode *ei = PROC_I(inode);
 	struct task_struct *task;
 	struct path ns_path;
+	int err;
 	void *error = ERR_PTR(-EACCES);

 	task = get_proc_task(inode);
@@ -129,7 +130,11 @@ static void *proc_ns_follow_link(struct dentry *dentry, struct nameidata *nd)
 	}

 	ns_path.mnt = mntget(nd->path.mnt);
-	nd_jump_link(nd, &ns_path);
+	err = nd_jump_link(nd, &ns_path);
+	if (err) {
+		error = ERR_PTR(err);
+		goto out_put_task;
+	}
 	error = NULL;

 out_put_task:
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 492de72560fa..a018cd8219ec 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -39,6 +39,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_FOLLOW		0x0001
 #define LOOKUP_DIRECTORY	0x0002
 #define LOOKUP_AUTOMOUNT	0x0004
+#define LOOKUP_BENEATH		0x0008

 #define LOOKUP_PARENT		0x0010
 #define LOOKUP_REVAL		0x0020
@@ -81,7 +82,7 @@ extern int follow_up(struct path *);
 extern struct dentry *lock_rename(struct dentry *, struct dentry *);
 extern void unlock_rename(struct dentry *, struct dentry *);

-extern void nd_jump_link(struct nameidata *nd, struct path *path);
+extern int nd_jump_link(struct nameidata *nd, struct path *path);

 static inline void nd_set_link(struct nameidata *nd, char *path)
 {
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


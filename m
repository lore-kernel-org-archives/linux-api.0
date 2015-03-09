From: David Drysdale <drysdale@google.com>
Subject: [PATCHv3 1/3] fs: add O_BENEATH flag to openat(2)
Date: Mon,  9 Mar 2015 14:00:10 +0000
Message-ID: <1425909612-28034-2-git-send-email-drysdale@google.com>
References: <1425909612-28034-1-git-send-email-drysdale@google.com>
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <1425909612-28034-1-git-send-email-drysdale@google.com>
Sender: fstests-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Kees Cook <keescook@chromium.org>, "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Meredydd Luff <meredydd@senatehouse.org>, Will Drewry <wad@chromium.org>, Jorge Lucangeli Obes <jorgelo@google.com>, Ricky Zhou <rickyz@google.com>, Lee Campbell <leecam@google.com>, Julien Tinnes <jln@google.com>, Mike Depinet <mdepinet@google.com>, James Morris <james.l.morris@oracle.com>, Andy Lutomirski <luto@amacapital.net>, Paolo Bonzini <pbonzini@redhat.com>, Paul Moore <paul@paul-moore.com>, Christoph Hellwig <hch@infradead.org>, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org, linux-security-module@vger.kernel.org, fstests@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Add a new O_BENEATH flag for openat(2) which restricts the
provided path, rejecting (with -EPERM) paths that are not beneath
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
 fs/fcntl.c                           |  4 ++--
 fs/namei.c                           | 21 ++++++++++++++++++---
 fs/open.c                            |  4 +++-
 fs/proc/base.c                       |  4 +++-
 fs/proc/namespaces.c                 |  8 ++++++--
 include/linux/namei.h                |  3 ++-
 include/uapi/asm-generic/fcntl.h     |  4 ++++
 10 files changed, 41 insertions(+), 10 deletions(-)

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
index c83145af4bfc..67e9a8e27329 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -705,13 +705,16 @@ static inline void path_to_nameidata(const struct path *path,
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

 void nd_set_link(struct nameidata *nd, char *path)
@@ -1775,9 +1778,14 @@ static int link_path_walk(const char *name, struct nameidata *nd)
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

@@ -1796,6 +1804,10 @@ static int link_path_walk(const char *name, struct nameidata *nd)
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
@@ -1847,6 +1859,7 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 			break;
 		}
 	}
+exit:
 	terminate_walk(nd);
 	return err;
 }
@@ -1886,6 +1899,8 @@ static int path_init(int dfd, const char *name, unsigned int flags,

 	nd->m_seq = read_seqbegin(&mount_lock);
 	if (*name=='/') {
+		if (flags & LOOKUP_BENEATH)
+			return -EPERM;
 		if (flags & LOOKUP_RCU) {
 			rcu_read_lock();
 			nd->seq = set_root_rcu(nd);
diff --git a/fs/open.c b/fs/open.c
index 33f9cbf2610b..16e06610ddbb 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -902,7 +902,7 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		 * If we have O_PATH in the open flag. Then we
 		 * cannot have anything other than the below set of flags
 		 */
-		flags &= O_DIRECTORY | O_NOFOLLOW | O_PATH;
+		flags &= O_DIRECTORY | O_NOFOLLOW | O_PATH | O_BENEATH;
 		acc_mode = 0;
 	} else {
 		acc_mode = MAY_OPEN | ACC_MODE(flags);
@@ -933,6 +933,8 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		lookup_flags |= LOOKUP_DIRECTORY;
 	if (!(flags & O_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
+	if (flags & O_BENEATH)
+		lookup_flags |= LOOKUP_BENEATH;
 	op->lookup_flags = lookup_flags;
 	return 0;
 }
diff --git a/fs/proc/base.c b/fs/proc/base.c
index 3f3d7aeb0712..eb8a9926ebb1 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1385,7 +1385,9 @@ static void *proc_pid_follow_link(struct dentry *dentry, struct nameidata *nd)
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
index c9eac4563fa8..8351534dc43b 100644
--- a/fs/proc/namespaces.c
+++ b/fs/proc/namespaces.c
@@ -36,6 +36,7 @@ static void *proc_ns_follow_link(struct dentry *dentry, struct nameidata *nd)
 	const struct proc_ns_operations *ns_ops = PROC_I(inode)->ns_ops;
 	struct task_struct *task;
 	struct path ns_path;
+	int err;
 	void *error = ERR_PTR(-EACCES);

 	task = get_proc_task(inode);
@@ -44,8 +45,11 @@ static void *proc_ns_follow_link(struct dentry *dentry, struct nameidata *nd)

 	if (ptrace_may_access(task, PTRACE_MODE_READ)) {
 		error = ns_get_path(&ns_path, task, ns_ops);
-		if (!error)
-			nd_jump_link(nd, &ns_path);
+		if (!error) {
+			err = nd_jump_link(nd, &ns_path);
+			if (err)
+				error = ERR_PTR(err);
+		}
 	}
 	put_task_struct(task);
 	return error;
diff --git a/include/linux/namei.h b/include/linux/namei.h
index c8990779f0c3..bd656840a271 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -28,6 +28,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_FOLLOW		0x0001
 #define LOOKUP_DIRECTORY	0x0002
 #define LOOKUP_AUTOMOUNT	0x0004
+#define LOOKUP_BENEATH		0x0008

 #define LOOKUP_PARENT		0x0010
 #define LOOKUP_REVAL		0x0020
@@ -70,7 +71,7 @@ extern int follow_up(struct path *);
 extern struct dentry *lock_rename(struct dentry *, struct dentry *);
 extern void unlock_rename(struct dentry *, struct dentry *);

-extern void nd_jump_link(struct nameidata *nd, struct path *path);
+extern int nd_jump_link(struct nameidata *nd, struct path *path);
 extern void nd_set_link(struct nameidata *nd, char *path);
 extern char *nd_get_link(struct nameidata *nd);

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
2.2.0.rc0.207.ga3a616c

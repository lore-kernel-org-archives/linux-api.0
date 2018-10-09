From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v3 1/3] namei: implement O_BENEATH-style AT_* flags
Date: Tue,  9 Oct 2018 18:02:28 +1100
Message-ID: <20181009070230.12884-2-cyphar@cyphar.com>
References: <20181009070230.12884-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009070230.12884-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Eric Biederman <ebiederm@xmission.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Christian Brauner <christian@brauner.io>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add the following flags to allow various restrictions on path
resolution (these affect the *entire* resolution, rather than just the
final path component -- as is the case with most other AT_* flags).

The primary justification for these flags is to allow for programs to be
far more strict about how they want path resolution to handle symlinks,
mountpoint crossings, and paths that escape the dirfd (through an
absolute path or ".." shenanigans).

This is of particular concern to container runtimes that want to be very
careful about malicious root filesystems that a container's init might
have screwed around with (and there is no real way to protect against
this in userspace if you consider potential races against a malicious
container's init). More classical applications (which have their own
potentially buggy userspace path sanitisation code) include web
servers, archive extraction tools, network file servers, and so on.

* AT_XDEV: Disallow mount-point crossing (both *down* into one, or *up*
  from one). The primary "scoping" use is to blocking resolution that
  crosses a bind-mount, which has a similar property to a symlink (in
  the way that it allows for escape from the starting-point). Since it
  is not possible to differentiate bind-mounts However since
  bind-mounting requires privileges (in ways symlinks don't) this has
  been split from LOOKUP_BENEATH. The naming is based on "find -xdev"
  (though find(1) doesn't walk upwards, the semantics seem obvious).

* AT_NO_PROCLINK: Disallows ->get_link "symlink" jumping. This is a very
  specific restriction, and it exists because /proc/$pid/fd/...
  "symlinks" allow for access outside nd->root and pose risk to
  container runtimes that don't want to be tricked into accessing a host
  path (but do want to allow no-funny-business symlink resolution).

* AT_NO_SYMLINK: Disallows symlink jumping *of any kind*. Implies
  AT_NO_PROCLINK (obviously).

* AT_BENEATH: Disallow "escapes" from the starting point of the
  filesystem tree during resolution (you must stay "beneath" the
  starting point at all times). Currently this is done by disallowing
  ".." and absolute paths (either in the given path or found during
  symlink resolution) entirely, as well as all "proclink" jumping.

  The wholesale banning of ".." is because it is currently not safe to
  allow ".." resolution (races can cause the path to be moved outside of
  the root -- this is conceptually similar to historical chroot(2)
  escape attacks). Future patches in this series will address this, and
  will re-enable ".." resolution once it is safe. With those patches,
  ".." resolution will only be allowed if it remains in the root
  throughout resolution (such as "a/../b" not "a/../../outside/b").

  The banning of "proclink" jumping is done because it is not clear
  whether semantically they should be allowed -- while some "proclinks"
  are safe there are many that can cause escapes (and once a resolution
  is outside of the root, AT_BENEATH will no longer detect it). Future
  patches may re-enable "proclink" jumping when such jumps would remain
  inside the root.

The AT_NO_*LINK flags return -ELOOP if path resolution would violates
their requirement, while the others all return -EXDEV. Currently these
are only enabled for openat(2) (which has its own brand of O_* flags
with the same semantics). However the AT_* flags have been reserved for
future support in other *at(2) syscalls (though because of AT_EMPTY_PATH
many *at(2) operations will not need to support these flags directly).

This is a refresh of Al's AT_NO_JUMPS patchset[1] (which was a variation
on David Drysdale's O_BENEATH patchset[2], which in turn was based on
the Capsicum project[3]). Input from Linus and Andy in the AT_NO_JUMPS
thread[4] determined most of the API changes made in this refresh.

[1]: https://lwn.net/Articles/721443/
[2]: https://lwn.net/Articles/619151/
[3]: https://lwn.net/Articles/603929/
[4]: https://lwn.net/Articles/723057/

Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Christian Brauner <christian@brauner.io>
Suggested-by: David Drysdale <drysdale@google.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/fcntl.c                       |   2 +-
 fs/namei.c                       | 174 ++++++++++++++++++++++---------
 fs/open.c                        |   8 ++
 fs/stat.c                        |   4 +-
 include/linux/fcntl.h            |   3 +-
 include/linux/namei.h            |   7 ++
 include/uapi/asm-generic/fcntl.h |  17 +++
 include/uapi/linux/fcntl.h       |   8 ++
 8 files changed, 167 insertions(+), 56 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 4137d96534a6..e343618736f7 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -1031,7 +1031,7 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(21 - 1 /* for O_RDONLY being 0 */ !=
+	BUILD_BUG_ON(25 - 1 /* for O_RDONLY being 0 */ !=
 		HWEIGHT32(
 			(VALID_OPEN_FLAGS & ~(O_NONBLOCK | O_NDELAY)) |
 			__FMODE_EXEC | __FMODE_NONOTIFY));
diff --git a/fs/namei.c b/fs/namei.c
index fb913148d4d1..76eacd3af89b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -845,6 +845,12 @@ static inline void path_to_nameidata(const struct path *path,
 
 static int nd_jump_root(struct nameidata *nd)
 {
+	if (unlikely(nd->flags & LOOKUP_BENEATH))
+		return -EXDEV;
+	if (unlikely(nd->flags & LOOKUP_XDEV)) {
+		if (nd->path.mnt != nd->root.mnt)
+			return -EXDEV;
+	}
 	if (nd->flags & LOOKUP_RCU) {
 		struct dentry *d;
 		nd->path = nd->root;
@@ -1083,14 +1089,23 @@ const char *get_link(struct nameidata *nd)
 		} else {
 			res = get(dentry, inode, &last->done);
 		}
+		/* If we just jumped it was because of a procfs-style link. */
+		if (unlikely(nd->flags & LOOKUP_JUMPED)) {
+			if (unlikely(nd->flags & LOOKUP_NO_PROCLINKS))
+				return ERR_PTR(-ELOOP);
+			/* Not currently safe. */
+			if (unlikely(nd->flags & LOOKUP_BENEATH))
+				return ERR_PTR(-EXDEV);
+		}
 		if (IS_ERR_OR_NULL(res))
 			return res;
 	}
 	if (*res == '/') {
 		if (!nd->root.mnt)
 			set_root(nd);
-		if (unlikely(nd_jump_root(nd)))
-			return ERR_PTR(-ECHILD);
+		error = nd_jump_root(nd);
+		if (unlikely(error))
+			return ERR_PTR(error);
 		while (unlikely(*++res == '/'))
 			;
 	}
@@ -1271,12 +1286,16 @@ static int follow_managed(struct path *path, struct nameidata *nd)
 		break;
 	}
 
-	if (need_mntput && path->mnt == mnt)
-		mntput(path->mnt);
+	if (need_mntput) {
+		if (path->mnt == mnt)
+			mntput(path->mnt);
+		if (unlikely(nd->flags & LOOKUP_XDEV))
+			ret = -EXDEV;
+		else
+			nd->flags |= LOOKUP_JUMPED;
+	}
 	if (ret == -EISDIR || !ret)
 		ret = 1;
-	if (need_mntput)
-		nd->flags |= LOOKUP_JUMPED;
 	if (unlikely(ret < 0))
 		path_put_conditional(path, nd);
 	return ret;
@@ -1333,6 +1352,8 @@ static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
 		mounted = __lookup_mnt(path->mnt, path->dentry);
 		if (!mounted)
 			break;
+		if (unlikely(nd->flags & LOOKUP_XDEV))
+			return false;
 		path->mnt = &mounted->mnt;
 		path->dentry = mounted->mnt.mnt_root;
 		nd->flags |= LOOKUP_JUMPED;
@@ -1353,8 +1374,11 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 	struct inode *inode = nd->inode;
 
 	while (1) {
-		if (path_equal(&nd->path, &nd->root))
+		if (path_equal(&nd->path, &nd->root)) {
+			if (unlikely(nd->flags & LOOKUP_BENEATH))
+				return -EXDEV;
 			break;
+		}
 		if (nd->path.dentry != nd->path.mnt->mnt_root) {
 			struct dentry *old = nd->path.dentry;
 			struct dentry *parent = old->d_parent;
@@ -1379,6 +1403,8 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 				return -ECHILD;
 			if (&mparent->mnt == nd->path.mnt)
 				break;
+			if (unlikely(nd->flags & LOOKUP_XDEV))
+				return -EXDEV;
 			/* we know that mountpoint was pinned */
 			nd->path.dentry = mountpoint;
 			nd->path.mnt = &mparent->mnt;
@@ -1393,6 +1419,8 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 			return -ECHILD;
 		if (!mounted)
 			break;
+		if (unlikely(nd->flags & LOOKUP_XDEV))
+			return -EXDEV;
 		nd->path.mnt = &mounted->mnt;
 		nd->path.dentry = mounted->mnt.mnt_root;
 		inode = nd->path.dentry->d_inode;
@@ -1481,8 +1509,11 @@ static int path_parent_directory(struct path *path)
 static int follow_dotdot(struct nameidata *nd)
 {
 	while(1) {
-		if (path_equal(&nd->path, &nd->root))
+		if (path_equal(&nd->path, &nd->root)) {
+			if (unlikely(nd->flags & LOOKUP_BENEATH))
+				return -EXDEV;
 			break;
+		}
 		if (nd->path.dentry != nd->path.mnt->mnt_root) {
 			int ret = path_parent_directory(&nd->path);
 			if (ret)
@@ -1491,6 +1522,8 @@ static int follow_dotdot(struct nameidata *nd)
 		}
 		if (!follow_up(&nd->path))
 			break;
+		if (unlikely(nd->flags & LOOKUP_XDEV))
+			return -EXDEV;
 	}
 	follow_mount(&nd->path);
 	nd->inode = nd->path.dentry->d_inode;
@@ -1705,6 +1738,12 @@ static inline int may_lookup(struct nameidata *nd)
 static inline int handle_dots(struct nameidata *nd, int type)
 {
 	if (type == LAST_DOTDOT) {
+		/*
+		 * AT_BENEATH resolving ".." is not currently safe -- races can cause
+		 * our parent to have moved outside of the root and us to skip over it.
+		 */
+		if (unlikely(nd->flags & LOOKUP_BENEATH))
+			return -EXDEV;
 		if (!nd->root.mnt)
 			set_root(nd);
 		if (nd->flags & LOOKUP_RCU) {
@@ -1720,6 +1759,8 @@ static int pick_link(struct nameidata *nd, struct path *link,
 {
 	int error;
 	struct saved *last;
+	if (unlikely(nd->flags & LOOKUP_NO_SYMLINKS))
+		return -ELOOP;
 	if (unlikely(nd->total_link_count++ >= MAXSYMLINKS)) {
 		path_to_nameidata(link, nd);
 		return -ELOOP;
@@ -2168,13 +2209,70 @@ static int link_path_walk(const char *name, struct nameidata *nd)
 	}
 }
 
+/*
+ * Configure nd->path based on the nd->dfd. This is only used as part of
+ * path_init().
+ */
+static inline int dirfd_path_init(struct nameidata *nd)
+{
+	if (nd->dfd == AT_FDCWD) {
+		if (nd->flags & LOOKUP_RCU) {
+			struct fs_struct *fs = current->fs;
+			unsigned seq;
+
+			do {
+				seq = read_seqcount_begin(&fs->seq);
+				nd->path = fs->pwd;
+				nd->inode = nd->path.dentry->d_inode;
+				nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
+			} while (read_seqcount_retry(&fs->seq, seq));
+		} else {
+			get_fs_pwd(current->fs, &nd->path);
+			nd->inode = nd->path.dentry->d_inode;
+		}
+	} else {
+		/* Caller must check execute permissions on the starting path component */
+		struct fd f = fdget_raw(nd->dfd);
+		struct dentry *dentry;
+
+		if (!f.file)
+			return -EBADF;
+
+		dentry = f.file->f_path.dentry;
+
+		if (*nd->name->name && unlikely(!d_can_lookup(dentry))) {
+			fdput(f);
+			return -ENOTDIR;
+		}
+
+		nd->path = f.file->f_path;
+		if (nd->flags & LOOKUP_RCU) {
+			nd->inode = nd->path.dentry->d_inode;
+			nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
+		} else {
+			path_get(&nd->path);
+			nd->inode = nd->path.dentry->d_inode;
+		}
+		fdput(f);
+	}
+	if (unlikely(nd->flags & LOOKUP_BENEATH)) {
+		nd->root = nd->path;
+		if (!(nd->flags & LOOKUP_RCU))
+			path_get(&nd->root);
+	}
+	return 0;
+}
+
 /* must be paired with terminate_walk() */
 static const char *path_init(struct nameidata *nd, unsigned flags)
 {
+	int error;
 	const char *s = nd->name->name;
 
 	if (!*s)
 		flags &= ~LOOKUP_RCU;
+	if (flags & LOOKUP_NO_SYMLINKS)
+		flags |= LOOKUP_NO_PROCLINKS;
 	if (flags & LOOKUP_RCU)
 		rcu_read_lock();
 
@@ -2203,53 +2301,25 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 	nd->path.dentry = NULL;
 
 	nd->m_seq = read_seqbegin(&mount_lock);
+	if (unlikely(flags & LOOKUP_XDEV)) {
+		error = dirfd_path_init(nd);
+		if (unlikely(error))
+			return ERR_PTR(error);
+	}
 	if (*s == '/') {
-		set_root(nd);
-		if (likely(!nd_jump_root(nd)))
-			return s;
-		return ERR_PTR(-ECHILD);
-	} else if (nd->dfd == AT_FDCWD) {
-		if (flags & LOOKUP_RCU) {
-			struct fs_struct *fs = current->fs;
-			unsigned seq;
-
-			do {
-				seq = read_seqcount_begin(&fs->seq);
-				nd->path = fs->pwd;
-				nd->inode = nd->path.dentry->d_inode;
-				nd->seq = __read_seqcount_begin(&nd->path.dentry->d_seq);
-			} while (read_seqcount_retry(&fs->seq, seq));
-		} else {
-			get_fs_pwd(current->fs, &nd->path);
-			nd->inode = nd->path.dentry->d_inode;
-		}
-		return s;
-	} else {
-		/* Caller must check execute permissions on the starting path component */
-		struct fd f = fdget_raw(nd->dfd);
-		struct dentry *dentry;
-
-		if (!f.file)
-			return ERR_PTR(-EBADF);
-
-		dentry = f.file->f_path.dentry;
-
-		if (*s && unlikely(!d_can_lookup(dentry))) {
-			fdput(f);
-			return ERR_PTR(-ENOTDIR);
-		}
-
-		nd->path = f.file->f_path;
-		if (flags & LOOKUP_RCU) {
-			nd->inode = nd->path.dentry->d_inode;
-			nd->seq = read_seqcount_begin(&nd->path.dentry->d_seq);
-		} else {
-			path_get(&nd->path);
-			nd->inode = nd->path.dentry->d_inode;
-		}
-		fdput(f);
+		if (likely(!nd->root.mnt))
+			set_root(nd);
+		error = nd_jump_root(nd);
+		if (unlikely(error))
+			s = ERR_PTR(error);
 		return s;
 	}
+	if (likely(!nd->path.mnt)) {
+		error = dirfd_path_init(nd);
+		if (unlikely(error))
+			return ERR_PTR(error);
+	}
+	return s;
 }
 
 static const char *trailing_symlink(struct nameidata *nd)
diff --git a/fs/open.c b/fs/open.c
index 0285ce7dbd51..80f5f566a5ff 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -988,6 +988,14 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		lookup_flags |= LOOKUP_DIRECTORY;
 	if (!(flags & O_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
+	if (flags & O_BENEATH)
+		lookup_flags |= LOOKUP_BENEATH;
+	if (flags & O_XDEV)
+		lookup_flags |= LOOKUP_XDEV;
+	if (flags & O_NOPROCLINKS)
+		lookup_flags |= LOOKUP_NO_PROCLINKS;
+	if (flags & O_NOSYMLINKS)
+		lookup_flags |= LOOKUP_NO_SYMLINKS;
 	op->lookup_flags = lookup_flags;
 	return 0;
 }
diff --git a/fs/stat.c b/fs/stat.c
index f8e6fb2c3657..d319a468c704 100644
--- a/fs/stat.c
+++ b/fs/stat.c
@@ -170,8 +170,8 @@ int vfs_statx(int dfd, const char __user *filename, int flags,
 	int error = -EINVAL;
 	unsigned int lookup_flags = LOOKUP_FOLLOW | LOOKUP_AUTOMOUNT;
 
-	if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT |
-		       AT_EMPTY_PATH | KSTAT_QUERY_FLAGS)) != 0)
+	if (flags & ~(AT_SYMLINK_NOFOLLOW | AT_NO_AUTOMOUNT | AT_EMPTY_PATH |
+		      KSTAT_QUERY_FLAGS))
 		return -EINVAL;
 
 	if (flags & AT_SYMLINK_NOFOLLOW)
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index 27dc7a60693e..ad5bba4b5b12 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -9,7 +9,8 @@
 	(O_RDONLY | O_WRONLY | O_RDWR | O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC | \
 	 O_APPEND | O_NDELAY | O_NONBLOCK | O_NDELAY | __O_SYNC | O_DSYNC | \
 	 FASYNC	| O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW | \
-	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE)
+	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE | O_BENEATH | O_XDEV | \
+	 O_NOPROCLINKS | O_NOSYMLINKS)
 
 #ifndef force_o_largefile
 #define force_o_largefile() (BITS_PER_LONG != 32)
diff --git a/include/linux/namei.h b/include/linux/namei.h
index a78606e8e3df..5ff7f3362d1b 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -47,6 +47,13 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_EMPTY		0x4000
 #define LOOKUP_DOWN		0x8000
 
+/* Scoping flags for lookup. */
+#define LOOKUP_BENEATH		0x010000 /* No escaping from starting point. */
+#define LOOKUP_XDEV		0x020000 /* No mountpoint crossing. */
+#define LOOKUP_NO_PROCLINKS	0x040000 /* No /proc/$pid/fd/ "symlink" crossing. */
+#define LOOKUP_NO_SYMLINKS	0x080000 /* No symlink crossing *at all*.
+					    Implies LOOKUP_NO_PROCLINKS. */
+
 extern int path_pts(struct path *path);
 
 extern int user_path_at_empty(int, const char __user *, unsigned, struct path *, int *empty);
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 9dc0bf0c5a6e..c2bf5983e46a 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -97,6 +97,23 @@
 #define O_NDELAY	O_NONBLOCK
 #endif
 
+/*
+ * These are identical to their AT_* counterparts (which affect the entireity
+ * of path resolution).
+ */
+#ifndef O_BENEATH
+#define O_BENEATH	00040000000 /* *Not* the same as capsicum's O_BENEATH! */
+#endif
+#ifndef O_XDEV
+#define O_XDEV		00100000000
+#endif
+#ifndef O_NOPROCLINKS
+#define O_NOPROCLINKS	00200000000
+#endif
+#ifndef O_NOSYMLINKS
+#define O_NOSYMLINKS	01000000000
+#endif
+
 #define F_DUPFD		0	/* dup */
 #define F_GETFD		1	/* get close_on_exec */
 #define F_SETFD		2	/* set/clear close_on_exec */
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index 594b85f7cb86..551a9e2166a8 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -92,5 +92,13 @@
 
 #define AT_RECURSIVE		0x8000	/* Apply to the entire subtree */
 
+/* Flags which affect path *resolution*, not just last-component handling. */
+#define AT_BENEATH		0x10000	/* No absolute paths or ".." escaping
+					   (in-path or through symlinks) */
+#define AT_XDEV			0x20000 /* No mountpoint crossing. */
+#define AT_NO_PROCLINKS		0x40000 /* No /proc/$pid/fd/... "symlinks". */
+#define AT_NO_SYMLINKS		0x80000 /* No symlinks *at all*.
+					   Implies AT_NO_PROCLINKS. */
+
 
 #endif /* _UAPI_LINUX_FCNTL_H */
-- 
2.19.0

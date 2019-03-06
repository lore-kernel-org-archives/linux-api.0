From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH RESEND v5 2/5] namei: O_BENEATH-style path resolution flags
Date: Thu,  7 Mar 2019 06:12:41 +1100
Message-ID: <20190306191244.8691-3-cyphar@cyphar.com>
References: <20190306191244.8691-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190306191244.8691-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Eric Biederman <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Kees Cook <keescook@chromium.org>, David Drysdale <drysdale@google.com>, Andy Lutomirski <luto@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Jann Horn <jannh@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
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

* O_XDEV: Disallow mount-point crossing (both *down* into one, or *up*
  from one). The primary "scoping" use is to blocking resolution that
  crosses a bind-mount, which has a similar property to a symlink (in
  the way that it allows for escape from the starting-point). Since it
  is not possible to differentiate bind-mounts However since
  bind-mounting requires privileges (in ways symlinks don't) this has
  been split from LOOKUP_BENEATH. The naming is based on "find -xdev"
  (though find(1) doesn't walk upwards, the semantics seem obvious).

* O_NOMAGICLINKS: Disallows ->get_link "symlink" jumping. This is a very
  specific restriction, and it exists because /proc/$pid/fd/...
  "symlinks" allow for access outside nd->root and pose risk to
  container runtimes that don't want to be tricked into accessing a host
  path (but do want to allow no-funny-business symlink resolution).

* O_NOSYMLINKS: Disallows symlink jumping *of any kind*. Implies
  O_NOMAGICLINKS (obviously).

* O_BENEATH: Disallow "escapes" from the starting point of the
  filesystem tree during resolution (you must stay "beneath" the
  starting point at all times). Currently this is done by disallowing
  ".." and absolute paths (either in the given path or found during
  symlink resolution) entirely, as well as all "magic link" jumping.

  The wholesale banning of ".." is because it is currently not safe to
  allow ".." resolution (races can cause the path to be moved outside of
  the root -- this is conceptually similar to historical chroot(2)
  escape attacks). Future patches in this series will address this, and
  will re-enable ".." resolution once it is safe. With those patches,
  ".." resolution will only be allowed if it remains in the root
  throughout resolution (such as "a/../b" not "a/../../outside/b").

  The banning of "magic link" jumping is done because it is not clear
  whether semantically they should be allowed -- while some "magic
  links" are safe there are many that can cause escapes (and once a
  resolution is outside of the root, O_BENEATH will no longer detect
  it). Future patches may re-enable "magic link" jumping when such jumps
  would remain inside the root.

The O_NO*LINK flags return -ELOOP if path resolution would violates
their requirement, while the others all return -EXDEV. Currently these
are only enabled for openat(2). In future it may be necessary to enable
these for *at(2) flags, as well as expanding support for AT_EMPTY_PATH.

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
Cc: Kees Cook <keescook@chromium.org>
Suggested-by: David Drysdale <drysdale@google.com>
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/fcntl.c                       |  2 +-
 fs/namei.c                       | 76 +++++++++++++++++++++++++++-----
 fs/open.c                        | 11 ++++-
 include/linux/fcntl.h            |  3 +-
 include/linux/namei.h            |  7 +++
 include/uapi/asm-generic/fcntl.h | 14 ++++++
 6 files changed, 99 insertions(+), 14 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index 083185174c6d..f782e99700f0 100644
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
index 4fdcb36f7c01..c9a07a8c005a 100644
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
@@ -1053,6 +1059,9 @@ const char *get_link(struct nameidata *nd)
 	int error;
 	const char *res;
 
+	if (unlikely(nd->flags & LOOKUP_NO_SYMLINKS))
+		return ERR_PTR(-ELOOP);
+
 	if (!(nd->flags & LOOKUP_RCU)) {
 		touch_atime(&last->link);
 		cond_resched();
@@ -1083,14 +1092,23 @@ const char *get_link(struct nameidata *nd)
 		} else {
 			res = get(dentry, inode, &last->done);
 		}
+		/* If we just jumped it was because of a procfs-style link. */
+		if (unlikely(nd->flags & LOOKUP_JUMPED)) {
+			if (unlikely(nd->flags & LOOKUP_NO_MAGICLINKS))
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
@@ -1271,12 +1289,16 @@ static int follow_managed(struct path *path, struct nameidata *nd)
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
@@ -1333,6 +1355,8 @@ static bool __follow_mount_rcu(struct nameidata *nd, struct path *path,
 		mounted = __lookup_mnt(path->mnt, path->dentry);
 		if (!mounted)
 			break;
+		if (unlikely(nd->flags & LOOKUP_XDEV))
+			return false;
 		path->mnt = &mounted->mnt;
 		path->dentry = mounted->mnt.mnt_root;
 		nd->flags |= LOOKUP_JUMPED;
@@ -1353,8 +1377,11 @@ static int follow_dotdot_rcu(struct nameidata *nd)
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
@@ -1379,6 +1406,8 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 				return -ECHILD;
 			if (&mparent->mnt == nd->path.mnt)
 				break;
+			if (unlikely(nd->flags & LOOKUP_XDEV))
+				return -EXDEV;
 			/* we know that mountpoint was pinned */
 			nd->path.dentry = mountpoint;
 			nd->path.mnt = &mparent->mnt;
@@ -1393,6 +1422,8 @@ static int follow_dotdot_rcu(struct nameidata *nd)
 			return -ECHILD;
 		if (!mounted)
 			break;
+		if (unlikely(nd->flags & LOOKUP_XDEV))
+			return -EXDEV;
 		nd->path.mnt = &mounted->mnt;
 		nd->path.dentry = mounted->mnt.mnt_root;
 		inode = nd->path.dentry->d_inode;
@@ -1481,8 +1512,11 @@ static int path_parent_directory(struct path *path)
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
@@ -1491,6 +1525,8 @@ static int follow_dotdot(struct nameidata *nd)
 		}
 		if (!follow_up(&nd->path))
 			break;
+		if (unlikely(nd->flags & LOOKUP_XDEV))
+			return -EXDEV;
 	}
 	follow_mount(&nd->path);
 	nd->inode = nd->path.dentry->d_inode;
@@ -1705,6 +1741,13 @@ static inline int may_lookup(struct nameidata *nd)
 static inline int handle_dots(struct nameidata *nd, int type)
 {
 	if (type == LAST_DOTDOT) {
+		/*
+		 * LOOKUP_BENEATH resolving ".." is not currently safe -- races can
+		 * cause our parent to have moved outside of the root and us to skip
+		 * over it.
+		 */
+		if (unlikely(nd->flags & LOOKUP_BENEATH))
+			return -EXDEV;
 		if (!nd->root.mnt)
 			set_root(nd);
 		if (nd->flags & LOOKUP_RCU) {
@@ -2253,6 +2296,15 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 	nd->path.dentry = NULL;
 
 	nd->m_seq = read_seqbegin(&mount_lock);
+
+	if (unlikely(nd->flags & LOOKUP_BENEATH)) {
+		error = dirfd_path_init(nd);
+		if (unlikely(error))
+			return ERR_PTR(error);
+		nd->root = nd->path;
+		if (!(nd->flags & LOOKUP_RCU))
+			path_get(&nd->root);
+	}
 	if (*s == '/') {
 		if (likely(!nd->root.mnt))
 			set_root(nd);
@@ -2261,9 +2313,11 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 			s = ERR_PTR(error);
 		return s;
 	}
-	error = dirfd_path_init(nd);
-	if (unlikely(error))
-		return ERR_PTR(error);
+	if (likely(!nd->path.mnt)) {
+		error = dirfd_path_init(nd);
+		if (unlikely(error))
+			return ERR_PTR(error);
+	}
 	return s;
 }
 
diff --git a/fs/open.c b/fs/open.c
index 0285ce7dbd51..3e73f940f56e 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -959,7 +959,8 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		 * If we have O_PATH in the open flag. Then we
 		 * cannot have anything other than the below set of flags
 		 */
-		flags &= O_DIRECTORY | O_NOFOLLOW | O_PATH;
+		flags &= O_DIRECTORY | O_NOFOLLOW | O_PATH | O_BENEATH |
+			 O_XDEV | O_NOSYMLINKS | O_NOMAGICLINKS;
 		acc_mode = 0;
 	}
 
@@ -988,6 +989,14 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		lookup_flags |= LOOKUP_DIRECTORY;
 	if (!(flags & O_NOFOLLOW))
 		lookup_flags |= LOOKUP_FOLLOW;
+	if (flags & O_BENEATH)
+		lookup_flags |= LOOKUP_BENEATH;
+	if (flags & O_XDEV)
+		lookup_flags |= LOOKUP_XDEV;
+	if (flags & O_NOMAGICLINKS)
+		lookup_flags |= LOOKUP_NO_MAGICLINKS;
+	if (flags & O_NOSYMLINKS)
+		lookup_flags |= LOOKUP_NO_SYMLINKS;
 	op->lookup_flags = lookup_flags;
 	return 0;
 }
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index 27dc7a60693e..864399c2fdd2 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -9,7 +9,8 @@
 	(O_RDONLY | O_WRONLY | O_RDWR | O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC | \
 	 O_APPEND | O_NDELAY | O_NONBLOCK | O_NDELAY | __O_SYNC | O_DSYNC | \
 	 FASYNC	| O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW | \
-	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE)
+	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE | O_BENEATH | O_XDEV | \
+	 O_NOMAGICLINKS | O_NOSYMLINKS)
 
 #ifndef force_o_largefile
 #define force_o_largefile() (BITS_PER_LONG != 32)
diff --git a/include/linux/namei.h b/include/linux/namei.h
index a78606e8e3df..82b5039d27a6 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -47,6 +47,13 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_EMPTY		0x4000
 #define LOOKUP_DOWN		0x8000
 
+/* Scoping flags for lookup. */
+#define LOOKUP_BENEATH		0x010000 /* No escaping from starting point. */
+#define LOOKUP_XDEV		0x020000 /* No mountpoint crossing. */
+#define LOOKUP_NO_MAGICLINKS	0x040000 /* No /proc/$pid/fd/ "symlink" crossing. */
+#define LOOKUP_NO_SYMLINKS	0x080000 /* No symlink crossing *at all*.
+					    Implies LOOKUP_NO_MAGICLINKS. */
+
 extern int path_pts(struct path *path);
 
 extern int user_path_at_empty(int, const char __user *, unsigned, struct path *, int *empty);
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index 9dc0bf0c5a6e..ba53e0836cd4 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -97,6 +97,20 @@
 #define O_NDELAY	O_NONBLOCK
 #endif
 
+/* Type of path-resolution scoping we are applying. */
+#ifndef O_BENEATH
+#define O_BENEATH	00040000000 /* - Block "lexical" trickery like "..", symlinks, absolute paths, etc. */
+#endif
+#ifndef O_XDEV
+#define O_XDEV		00100000000 /* - Block mount-point crossings (includes bind-mounts). */
+#endif
+#ifndef O_NOMAGICLINKS
+#define O_NOMAGICLINKS	00200000000 /* - Block procfs-style "magic" symlinks. */
+#endif
+#ifndef O_NOSYMLINKS
+#define O_NOSYMLINKS	01000000000 /* - Block all symlinks (implies AT_NO_MAGICLINKS). */
+#endif
+
 #define F_DUPFD		0	/* dup */
 #define F_GETFD		1	/* get close_on_exec */
 #define F_SETFD		2	/* set/clear close_on_exec */
-- 
2.21.0

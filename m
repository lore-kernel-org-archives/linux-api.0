From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v3 2/3] namei: implement AT_THIS_ROOT chroot-like path resolution
Date: Tue,  9 Oct 2018 18:02:29 +1100
Message-ID: <20181009070230.12884-3-cyphar@cyphar.com>
References: <20181009070230.12884-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181009070230.12884-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Eric Biederman <ebiederm@xmission.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Christian Brauner <christian@brauner.io>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, Andy Lutomirski <luto@kernel.org>, David Howells <dhowells@redhat.com>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, dev@opencontainers.org, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The primary motivation for the need for this flag is container runtimes
which have to interact with malicious root filesystems in the host
namespaces. One of the first requirements for a container runtime to be
secure against a malicious rootfs is that they correctly scope symlinks
(that is, they should be scoped as though they are chroot(2)ed into the
container's rootfs) and ".."-style paths[*]. The already-existing
AT_XDEV and AT_NO_PROCLINKS[**] help defend against other potential
attacks in a malicious rootfs scenario.

Currently most container runtimes try to do this resolution in
userspace[1], causing many potential race conditions. In addition, the
"obvious" alternative (actually performing a {ch,pivot_}root(2))
requires a fork+exec (for some runtimes) which is *very* costly if
necessary for every filesystem operation involving a container.

[*] At the moment, ".." and "proclink" jumping are disallowed for the
    same reason it is disabled for AT_BENEATH -- currently it is not
    safe to allow it. Future patches may enable it unconditionally once
    we have resolved the possible races (for "..") and semantics (for
    "proclink" jumping).

The most significant openat(2) semantic change with AT_THIS_ROOT is that
absolute pathnames no longer cause dirfd to be ignored completely. The
rationale is that AT_THIS_ROOT must necessarily chroot-scope symlinks
with absolute paths to dirfd, and so doing it for the base path seems to
be the most consistent behaviour (and also avoids foot-gunning users who
want to scope paths that are absolute).

Currently this is only enabled for openat(2) (which has its own flag
O_THISROOT with the same semantics). However the AT_* flags have been
reserved for future support in other *at(2) syscalls (because of
AT_EMPTY_PATH many *at(2) operations do not need to support these flags
directly).

[1]: https://github.com/cyphar/filepath-securejoin

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Christian Brauner <christian@brauner.io>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/fcntl.c                       | 2 +-
 fs/namei.c                       | 8 ++++----
 fs/open.c                        | 2 ++
 include/linux/fcntl.h            | 2 +-
 include/linux/namei.h            | 1 +
 include/uapi/asm-generic/fcntl.h | 3 +++
 include/uapi/linux/fcntl.h       | 2 ++
 7 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index e343618736f7..4c36c5b9fdb9 100644
--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -1031,7 +1031,7 @@ static int __init fcntl_init(void)
 	 * Exceptions: O_NONBLOCK is a two bit define on parisc; O_NDELAY
 	 * is defined as O_NONBLOCK on some platforms and not on others.
 	 */
-	BUILD_BUG_ON(25 - 1 /* for O_RDONLY being 0 */ !=
+	BUILD_BUG_ON(26 - 1 /* for O_RDONLY being 0 */ !=
 		HWEIGHT32(
 			(VALID_OPEN_FLAGS & ~(O_NONBLOCK | O_NDELAY)) |
 			__FMODE_EXEC | __FMODE_NONOTIFY));
diff --git a/fs/namei.c b/fs/namei.c
index 76eacd3af89b..b31aef27df22 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1094,7 +1094,7 @@ const char *get_link(struct nameidata *nd)
 			if (unlikely(nd->flags & LOOKUP_NO_PROCLINKS))
 				return ERR_PTR(-ELOOP);
 			/* Not currently safe. */
-			if (unlikely(nd->flags & LOOKUP_BENEATH))
+			if (unlikely(nd->flags & (LOOKUP_BENEATH | LOOKUP_CHROOT)))
 				return ERR_PTR(-EXDEV);
 		}
 		if (IS_ERR_OR_NULL(res))
@@ -1742,7 +1742,7 @@ static inline int handle_dots(struct nameidata *nd, int type)
 		 * AT_BENEATH resolving ".." is not currently safe -- races can cause
 		 * our parent to have moved outside of the root and us to skip over it.
 		 */
-		if (unlikely(nd->flags & LOOKUP_BENEATH))
+		if (unlikely(nd->flags & (LOOKUP_BENEATH | LOOKUP_CHROOT)))
 			return -EXDEV;
 		if (!nd->root.mnt)
 			set_root(nd);
@@ -2255,7 +2255,7 @@ static inline int dirfd_path_init(struct nameidata *nd)
 		}
 		fdput(f);
 	}
-	if (unlikely(nd->flags & LOOKUP_BENEATH)) {
+	if (unlikely(nd->flags & (LOOKUP_BENEATH | LOOKUP_CHROOT))) {
 		nd->root = nd->path;
 		if (!(nd->flags & LOOKUP_RCU))
 			path_get(&nd->root);
@@ -2301,7 +2301,7 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 	nd->path.dentry = NULL;
 
 	nd->m_seq = read_seqbegin(&mount_lock);
-	if (unlikely(flags & LOOKUP_XDEV)) {
+	if (unlikely(flags & (LOOKUP_CHROOT | LOOKUP_XDEV))) {
 		error = dirfd_path_init(nd);
 		if (unlikely(error))
 			return ERR_PTR(error);
diff --git a/fs/open.c b/fs/open.c
index 80f5f566a5ff..81d148f626cd 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -996,6 +996,8 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		lookup_flags |= LOOKUP_NO_PROCLINKS;
 	if (flags & O_NOSYMLINKS)
 		lookup_flags |= LOOKUP_NO_SYMLINKS;
+	if (flags & O_THISROOT)
+		lookup_flags |= LOOKUP_CHROOT;
 	op->lookup_flags = lookup_flags;
 	return 0;
 }
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index ad5bba4b5b12..95480cd4c09d 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -10,7 +10,7 @@
 	 O_APPEND | O_NDELAY | O_NONBLOCK | O_NDELAY | __O_SYNC | O_DSYNC | \
 	 FASYNC	| O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW | \
 	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE | O_BENEATH | O_XDEV | \
-	 O_NOPROCLINKS | O_NOSYMLINKS)
+	 O_NOPROCLINKS | O_NOSYMLINKS | O_THISROOT)
 
 #ifndef force_o_largefile
 #define force_o_largefile() (BITS_PER_LONG != 32)
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 5ff7f3362d1b..7ec9e2d84649 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -53,6 +53,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_NO_PROCLINKS	0x040000 /* No /proc/$pid/fd/ "symlink" crossing. */
 #define LOOKUP_NO_SYMLINKS	0x080000 /* No symlink crossing *at all*.
 					    Implies LOOKUP_NO_PROCLINKS. */
+#define LOOKUP_CHROOT		0x100000 /* Treat dirfd as %current->fs->root. */
 
 extern int path_pts(struct path *path);
 
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index c2bf5983e46a..11206b0e927c 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -113,6 +113,9 @@
 #ifndef O_NOSYMLINKS
 #define O_NOSYMLINKS	01000000000
 #endif
+#ifndef O_THISROOT
+#define O_THISROOT	02000000000
+#endif
 
 #define F_DUPFD		0	/* dup */
 #define F_GETFD		1	/* get close_on_exec */
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index 551a9e2166a8..ea978457b68f 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -99,6 +99,8 @@
 #define AT_NO_PROCLINKS		0x40000 /* No /proc/$pid/fd/... "symlinks". */
 #define AT_NO_SYMLINKS		0x80000 /* No symlinks *at all*.
 					   Implies AT_NO_PROCLINKS. */
+#define AT_THIS_ROOT		0x100000 /* Path resolution acts as though
+					   it is chroot-ed into dirfd. */
 
 
 #endif /* _UAPI_LINUX_FCNTL_H */
-- 
2.19.0

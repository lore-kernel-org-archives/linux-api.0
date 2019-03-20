From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH RESEND v5 3/5] namei: O_THISROOT: chroot-like path resolution
Date: Thu, 21 Mar 2019 01:37:15 +1100
Message-ID: <20190320143717.2523-4-cyphar@cyphar.com>
References: <20190320143717.2523-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190320143717.2523-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Eric Biederman <ebiederm@xmission.com>, Christian Brauner <christian@brauner.io>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Jann Horn <jannh@google.com>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The primary motivation for the need for this flag is container runtimes
which have to interact with malicious root filesystems in the host
namespaces. One of the first requirements for a container runtime to be
secure against a malicious rootfs is that they correctly scope symlinks
(that is, they should be scoped as though they are chroot(2)ed into the
container's rootfs) and ".."-style paths[*]. The already-existing O_XDEV
and O_NOMAGICLINKS[**] help defend against other potential attacks in a
malicious rootfs scenario.

Currently most container runtimes try to do this resolution in
userspace[1], causing many potential race conditions. In addition, the
"obvious" alternative (actually performing a {ch,pivot_}root(2))
requires a fork+exec (for some runtimes) which is *very* costly if
necessary for every filesystem operation involving a container.

[*] At the moment, ".." and "magic link" jumping are disallowed for the
    same reason it is disabled for O_BENEATH -- currently it is not safe
    to allow it. Future patches may enable it unconditionally once we
    have resolved the possible races (for "..") and semantics (for
    "magic link" jumping).

The most significant openat(2) semantic change with O_THISROOT is that
absolute pathnames no longer cause dirfd to be ignored completely. The
rationale is that O_THISROOT must necessarily chroot-scope symlinks with
absolute paths to dirfd, and so doing it for the base path seems to be
the most consistent behaviour (and also avoids foot-gunning users who
want to scope paths that are absolute).

Currently this is only enabled for openat(2), and similar to O_BENEATH
and family requires more discussion about extending it to more *at(2)
syscalls as well as extending AT_EMPTY_PATH support.

[1]: https://github.com/cyphar/filepath-securejoin

Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Christian Brauner <christian@brauner.io>
Cc: Kees Cook <keescook@chromium.org>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/fcntl.c                       | 2 +-
 fs/namei.c                       | 6 +++---
 fs/open.c                        | 4 +++-
 include/linux/fcntl.h            | 2 +-
 include/linux/namei.h            | 1 +
 include/uapi/asm-generic/fcntl.h | 3 +++
 6 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/fcntl.c b/fs/fcntl.c
index f782e99700f0..a6b4565a903d 100644
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
index c9a07a8c005a..798eb1702a0c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1097,7 +1097,7 @@ const char *get_link(struct nameidata *nd)
 			if (unlikely(nd->flags & LOOKUP_NO_MAGICLINKS))
 				return ERR_PTR(-ELOOP);
 			/* Not currently safe. */
-			if (unlikely(nd->flags & LOOKUP_BENEATH))
+			if (unlikely(nd->flags & (LOOKUP_BENEATH | LOOKUP_IN_ROOT)))
 				return ERR_PTR(-EXDEV);
 		}
 		if (IS_ERR_OR_NULL(res))
@@ -1746,7 +1746,7 @@ static inline int handle_dots(struct nameidata *nd, int type)
 		 * cause our parent to have moved outside of the root and us to skip
 		 * over it.
 		 */
-		if (unlikely(nd->flags & LOOKUP_BENEATH))
+		if (unlikely(nd->flags & (LOOKUP_BENEATH | LOOKUP_IN_ROOT)))
 			return -EXDEV;
 		if (!nd->root.mnt)
 			set_root(nd);
@@ -2297,7 +2297,7 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 
 	nd->m_seq = read_seqbegin(&mount_lock);
 
-	if (unlikely(nd->flags & LOOKUP_BENEATH)) {
+	if (unlikely(nd->flags & (LOOKUP_BENEATH | LOOKUP_IN_ROOT))) {
 		error = dirfd_path_init(nd);
 		if (unlikely(error))
 			return ERR_PTR(error);
diff --git a/fs/open.c b/fs/open.c
index 3e73f940f56e..5914aed2fac8 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -960,7 +960,7 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		 * cannot have anything other than the below set of flags
 		 */
 		flags &= O_DIRECTORY | O_NOFOLLOW | O_PATH | O_BENEATH |
-			 O_XDEV | O_NOSYMLINKS | O_NOMAGICLINKS;
+			 O_XDEV | O_NOSYMLINKS | O_NOMAGICLINKS | O_THISROOT;
 		acc_mode = 0;
 	}
 
@@ -997,6 +997,8 @@ static inline int build_open_flags(int flags, umode_t mode, struct open_flags *o
 		lookup_flags |= LOOKUP_NO_MAGICLINKS;
 	if (flags & O_NOSYMLINKS)
 		lookup_flags |= LOOKUP_NO_SYMLINKS;
+	if (flags & O_THISROOT)
+		lookup_flags |= LOOKUP_IN_ROOT;
 	op->lookup_flags = lookup_flags;
 	return 0;
 }
diff --git a/include/linux/fcntl.h b/include/linux/fcntl.h
index 864399c2fdd2..46c92bbfce4a 100644
--- a/include/linux/fcntl.h
+++ b/include/linux/fcntl.h
@@ -10,7 +10,7 @@
 	 O_APPEND | O_NDELAY | O_NONBLOCK | O_NDELAY | __O_SYNC | O_DSYNC | \
 	 FASYNC	| O_DIRECT | O_LARGEFILE | O_DIRECTORY | O_NOFOLLOW | \
 	 O_NOATIME | O_CLOEXEC | O_PATH | __O_TMPFILE | O_BENEATH | O_XDEV | \
-	 O_NOMAGICLINKS | O_NOSYMLINKS)
+	 O_NOMAGICLINKS | O_NOSYMLINKS | O_THISROOT)
 
 #ifndef force_o_largefile
 #define force_o_largefile() (BITS_PER_LONG != 32)
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 82b5039d27a6..0969313b518f 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -53,6 +53,7 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_NO_MAGICLINKS	0x040000 /* No /proc/$pid/fd/ "symlink" crossing. */
 #define LOOKUP_NO_SYMLINKS	0x080000 /* No symlink crossing *at all*.
 					    Implies LOOKUP_NO_MAGICLINKS. */
+#define LOOKUP_IN_ROOT		0x100000 /* Treat dirfd as %current->fs->root. */
 
 extern int path_pts(struct path *path);
 
diff --git a/include/uapi/asm-generic/fcntl.h b/include/uapi/asm-generic/fcntl.h
index ba53e0836cd4..3d0fe0de2ba2 100644
--- a/include/uapi/asm-generic/fcntl.h
+++ b/include/uapi/asm-generic/fcntl.h
@@ -110,6 +110,9 @@
 #ifndef O_NOSYMLINKS
 #define O_NOSYMLINKS	01000000000 /* - Block all symlinks (implies AT_NO_MAGICLINKS). */
 #endif
+#ifndef O_THISROOT
+#define O_THISROOT	02000000000 /* - Scope ".." resolution to dirfd (like chroot(2)). */
+#endif
 
 #define F_DUPFD		0	/* dup */
 #define F_GETFD		1	/* get close_on_exec */
-- 
2.21.0

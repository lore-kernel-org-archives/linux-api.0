From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v15 5/9] namei: LOOKUP_IN_ROOT: chroot-like scoped resolution
Date: Tue,  5 Nov 2019 20:05:49 +1100
Message-ID: <20191105090553.6350-6-cyphar@cyphar.com>
References: <20191105090553.6350-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <libc-alpha-return-106629-glibc-alpha=m.gmane.org@sourceware.org>
List-Unsubscribe: <mailto:libc-alpha-unsubscribe-glibc-alpha=m.gmane.org@sourceware.org>
List-Subscribe: <mailto:libc-alpha-subscribe@sourceware.org>
List-Archive: <http://sourceware.org/ml/libc-alpha/>
List-Post: <mailto:libc-alpha@sourceware.org>
List-Help: <mailto:libc-alpha-help@sourceware.org>, <http://sourceware.org/ml/#faqs>
Sender: libc-alpha-owner@sourceware.org
In-Reply-To: <20191105090553.6350-1-cyphar@cyphar.com>
To: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>, Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Christian Brauner <christian.brauner@ubuntu.com>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Tycho Andersen <tycho@tycho.ws>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>, Christian Brauner <christian@brauner.io>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-alpha@vger.kernel.org, linux-api@vger.kernel.org, libc-alpha@sourceware.org, linux-arch@vger.kerne
List-Id: linux-api@vger.kernel.org

/* Background. */
Container runtimes or other administrative management processes will
often interact with root filesystems while in the host mount namespace,
because the cost of doing a chroot(2) on every operation is too
prohibitive (especially in Go, which cannot safely use vfork). However,
a malicious program can trick the management process into doing
operations on files outside of the root filesystem through careful
crafting of symlinks.

Most programs that need this feature have attempted to make this process
safe, by doing all of the path resolution in userspace (with symlinks
being scoped to the root of the malicious root filesystem).
Unfortunately, this method is prone to foot-guns and usually such
implementations have subtle security bugs.

Thus, what userspace needs is a way to resolve a path as though it were
in a chroot(2) -- with all absolute symlinks being resolved relative to
the dirfd root (and ".." components being stuck under the dirfd root).
It is much simpler and more straight-forward to provide this
functionality in-kernel (because it can be done far more cheaply and
correctly).

More classical applications that also have this problem (which have
their own potentially buggy userspace path sanitisation code) include
web servers, archive extraction tools, network file servers, and so on.

/* Userspace API. */
LOOKUP_IN_ROOT will be exposed to userspace through openat2(2).

/* Semantics. */
Unlike most other LOOKUP flags (most notably LOOKUP_FOLLOW),
LOOKUP_IN_ROOT applies to all components of the path.

With LOOKUP_IN_ROOT, any path component which attempts to cross the
starting point of the pathname lookup (the dirfd passed to openat) will
remain at the starting point. Thus, all absolute paths and symlinks will
be scoped within the starting point.

There is a slight change in behaviour regarding pathnames -- if the
pathname is absolute then the dirfd is still used as the root of
resolution of LOOKUP_IN_ROOT is specified (this is to avoid obvious
foot-guns, at the cost of a minor API inconsistency).

As with LOOKUP_BENEATH, Jann's security concern about ".."[1] applies to
LOOKUP_IN_ROOT -- therefore ".." resolution is blocked. This restriction
will be lifted in a future patch, but requires more work to ensure that
permitting ".." is done safely.

Magic-link jumps are also blocked, because they can beam the path lookup
across the starting point. It would be possible to detect and block
only the "bad" crossings with path_is_under() checks, but it's unclear
whether it makes sense to permit magic-links at all. However, userspace
is recommended to pass LOOKUP_NO_MAGICLINKS if they want to ensure that
magic-link crossing is entirely disabled.

/* Testing. */
LOOKUP_IN_ROOT is tested as part of the openat2(2) selftests.

[1]: https://lore.kernel.org/lkml/CAG48ez1jzNvxB+bfOBnERFGp=oMM0vHWuLD6EULmne3R6xa53w@mail.gmail.com/

Cc: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/namei.c            | 15 ++++++++++++---
 include/linux/namei.h |  3 ++-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 54fdbdfbeb94..a3d199a60708 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2277,12 +2277,20 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 
 	nd->m_seq = read_seqbegin(&mount_lock);
 
-	/* Figure out the starting path and root (if needed). */
-	if (*s == '/') {
+	/* Absolute pathname -- fetch the root. */
+	if (flags & LOOKUP_IN_ROOT) {
+		/* With LOOKUP_IN_ROOT, act as a relative path. */
+		while (*s == '/')
+			s++;
+	} else if (*s == '/') {
 		error = nd_jump_root(nd);
 		if (unlikely(error))
 			return ERR_PTR(error);
-	} else if (nd->dfd == AT_FDCWD) {
+		return s;
+	}
+
+	/* Relative pathname -- get the starting-point it is relative to. */
+	if (nd->dfd == AT_FDCWD) {
 		if (flags & LOOKUP_RCU) {
 			struct fs_struct *fs = current->fs;
 			unsigned seq;
@@ -2322,6 +2330,7 @@ static const char *path_init(struct nameidata *nd, unsigned flags)
 		}
 		fdput(f);
 	}
+
 	/* For scoped-lookups we need to set the root to the dirfd as well. */
 	if (flags & LOOKUP_IS_SCOPED) {
 		nd->root = nd->path;
diff --git a/include/linux/namei.h b/include/linux/namei.h
index 12f4f36835c2..96b374e08230 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -46,8 +46,9 @@ enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT, LAST_BIND};
 #define LOOKUP_NO_MAGICLINKS	0x040000 /* No /proc/$pid/fd/ "symlink" crossing. */
 #define LOOKUP_NO_XDEV		0x080000 /* No mountpoint crossing. */
 #define LOOKUP_BENEATH		0x100000 /* No escaping from starting point. */
+#define LOOKUP_IN_ROOT		0x200000 /* Treat dirfd as %current->fs->root. */
 /* LOOKUP_* flags which do scope-related checks based on the dirfd. */
-#define LOOKUP_IS_SCOPED LOOKUP_BENEATH
+#define LOOKUP_IS_SCOPED (LOOKUP_BENEATH | LOOKUP_IN_ROOT)
 
 extern int path_pts(struct path *path);
 
-- 
2.23.0

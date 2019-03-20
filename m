From: Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH RESEND v5 5/5] binfmt_*: scope path resolution of interpreters
Date: Thu, 21 Mar 2019 01:37:17 +1100
Message-ID: <20190320143717.2523-6-cyphar@cyphar.com>
References: <20190320143717.2523-1-cyphar@cyphar.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190320143717.2523-1-cyphar@cyphar.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, Arnd Bergmann <arnd@arndb.de>, David Howells <dhowells@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>, Eric Biederman <ebiederm@xmission.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexei Starovoitov <ast@kernel.org>, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Christian Brauner <christian@brauner.io>, David Drysdale <drysdale@google.com>, Chanho Min <chanho.min@lge.com>, Oleg Nesterov <oleg@redhat.com>, Aleksa Sarai <asarai@suse.de>, Linus Torvalds <torvalds@linux-foundation.org>, containers@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The need to be able to scope path resolution of interpreters became
clear with one of the possible vectors used in CVE-2019-5736 (which
most major container runtimes were vulnerable to).

Naively, it might seem that openat(2) -- which supports path scoping --
can be combined with execveat(AT_EMPTY_PATH) to trivially scope the
binary being executed. Unfortunately, a "bad binary" (usually a symlink)
could be written as a #!-style script with the symlink target as the
interpreter -- which would be completely missed by just scoping the
openat(2). An example of this being exploitable is CVE-2019-5736.

In order to get around this, we need to pass down to each binfmt_*
implementation the scoping flags requested in execveat(2). In order to
maintain backwards-compatibility we only pass the scoping AT_* flags.

To avoid breaking userspace (in the exceptionally rare cases where you
have #!-scripts with a relative path being execveat(2)-ed with dfd !=
AT_FDCWD), we only pass dfd down to binfmt_* if any of our new flags are
set in execveat(2).

Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
---
 fs/binfmt_elf.c            |  2 +-
 fs/binfmt_elf_fdpic.c      |  2 +-
 fs/binfmt_em86.c           |  4 ++--
 fs/binfmt_misc.c           |  2 +-
 fs/binfmt_script.c         |  2 +-
 fs/exec.c                  | 26 ++++++++++++++++++++++----
 include/linux/binfmts.h    |  1 +
 include/linux/fs.h         |  9 +++++++--
 include/uapi/linux/fcntl.h |  6 ++++++
 9 files changed, 42 insertions(+), 12 deletions(-)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index 54207327f98f..eef86ffa38c8 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -777,7 +777,7 @@ static int load_elf_binary(struct linux_binprm *bprm)
 			if (elf_interpreter[elf_ppnt->p_filesz - 1] != '\0')
 				goto out_free_interp;
 
-			interpreter = open_exec(elf_interpreter);
+			interpreter = openat_exec(bprm->dfd, elf_interpreter, bprm->flags);
 			retval = PTR_ERR(interpreter);
 			if (IS_ERR(interpreter))
 				goto out_free_interp;
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index b53bb3729ac1..c463c6428f77 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -263,7 +263,7 @@ static int load_elf_fdpic_binary(struct linux_binprm *bprm)
 			kdebug("Using ELF interpreter %s", interpreter_name);
 
 			/* replace the program with the interpreter */
-			interpreter = open_exec(interpreter_name);
+			interpreter = openat_exec(bprm->dfd, interpreter_name, bprm->flags);
 			retval = PTR_ERR(interpreter);
 			if (IS_ERR(interpreter)) {
 				interpreter = NULL;
diff --git a/fs/binfmt_em86.c b/fs/binfmt_em86.c
index dd2d3f0cd55d..3ee46b0dc0d4 100644
--- a/fs/binfmt_em86.c
+++ b/fs/binfmt_em86.c
@@ -81,10 +81,10 @@ static int load_em86(struct linux_binprm *bprm)
 
 	/*
 	 * OK, now restart the process with the interpreter's inode.
-	 * Note that we use open_exec() as the name is now in kernel
+	 * Note that we use openat_exec() as the name is now in kernel
 	 * space, and we don't need to copy it.
 	 */
-	file = open_exec(interp);
+	file = openat_exec(binprm->dfd, interp, binprm->flags);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index aa4a7a23ff99..573ef06ff5a1 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -209,7 +209,7 @@ static int load_misc_binary(struct linux_binprm *bprm)
 		if (!IS_ERR(interp_file))
 			deny_write_access(interp_file);
 	} else {
-		interp_file = open_exec(fmt->interpreter);
+		interp_file = openat_exec(bprm->dfd, fmt->interpreter, bprm->flags);
 	}
 	retval = PTR_ERR(interp_file);
 	if (IS_ERR(interp_file))
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index d0078cbb718b..340f63635aac 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -102,7 +102,7 @@ static int load_script(struct linux_binprm *bprm)
 	/*
 	 * OK, now restart the process with the interpreter's dentry.
 	 */
-	file = open_exec(i_name);
+	file = openat_exec(bprm->dfd, i_name, bprm->flags);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
diff --git a/fs/exec.c b/fs/exec.c
index bcf383730bea..e63063b2de23 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -846,12 +846,24 @@ static struct file *do_open_execat(int fd, struct filename *name, int flags)
 		.lookup_flags = LOOKUP_FOLLOW,
 	};
 
-	if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+	if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH | AT_BENEATH |
+		       AT_XDEV | AT_NO_MAGICLINKS | AT_NO_SYMLINKS |
+		       AT_THIS_ROOT)) != 0)
 		return ERR_PTR(-EINVAL);
 	if (flags & AT_SYMLINK_NOFOLLOW)
 		open_exec_flags.lookup_flags &= ~LOOKUP_FOLLOW;
 	if (flags & AT_EMPTY_PATH)
 		open_exec_flags.lookup_flags |= LOOKUP_EMPTY;
+	if (flags & AT_BENEATH)
+		open_exec_flags.lookup_flags |= LOOKUP_BENEATH;
+	if (flags & AT_XDEV)
+		open_exec_flags.lookup_flags |= LOOKUP_XDEV;
+	if (flags & AT_NO_MAGICLINKS)
+		open_exec_flags.lookup_flags |= LOOKUP_NO_MAGICLINKS;
+	if (flags & AT_NO_SYMLINKS)
+		open_exec_flags.lookup_flags |= LOOKUP_NO_SYMLINKS;
+	if (flags & AT_THIS_ROOT)
+		open_exec_flags.lookup_flags |= LOOKUP_IN_ROOT;
 
 	file = do_filp_open(fd, name, &open_exec_flags);
 	if (IS_ERR(file))
@@ -879,18 +891,18 @@ static struct file *do_open_execat(int fd, struct filename *name, int flags)
 	return ERR_PTR(err);
 }
 
-struct file *open_exec(const char *name)
+struct file *openat_exec(int dfd, const char *name, int flags)
 {
 	struct filename *filename = getname_kernel(name);
 	struct file *f = ERR_CAST(filename);
 
 	if (!IS_ERR(filename)) {
-		f = do_open_execat(AT_FDCWD, filename, 0);
+		f = do_open_execat(dfd, filename, flags);
 		putname(filename);
 	}
 	return f;
 }
-EXPORT_SYMBOL(open_exec);
+EXPORT_SYMBOL(openat_exec);
 
 int kernel_read_file(struct file *file, void **buf, loff_t *size,
 		     loff_t max_size, enum kernel_read_file_id id)
@@ -1762,6 +1774,12 @@ static int __do_execve_file(int fd, struct filename *filename,
 
 	sched_exec();
 
+	bprm->flags = flags & (AT_XDEV | AT_NO_MAGICLINKS | AT_NO_SYMLINKS |
+			       AT_THIS_ROOT);
+	bprm->dfd = AT_FDCWD;
+	if (bprm->flags)
+		bprm->dfd = fd;
+
 	bprm->file = file;
 	if (!filename) {
 		bprm->filename = "none";
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 688ab0de7810..e4da2d36e97f 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -50,6 +50,7 @@ struct linux_binprm {
 	unsigned int taso:1;
 #endif
 	unsigned int recursion_depth; /* only for search_binary_handler() */
+	int dfd, flags;		/* passed down to execat_open() */
 	struct file * file;
 	struct cred *cred;	/* new credentials */
 	int unsafe;		/* how unsafe this exec is (mask of LSM_UNSAFE_*) */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3e85cb8e8c20..a82c8dd44ad9 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2937,8 +2937,13 @@ extern int kernel_read_file_from_fd(int, void **, loff_t *, loff_t,
 extern ssize_t kernel_read(struct file *, void *, size_t, loff_t *);
 extern ssize_t kernel_write(struct file *, const void *, size_t, loff_t *);
 extern ssize_t __kernel_write(struct file *, const void *, size_t, loff_t *);
-extern struct file * open_exec(const char *);
- 
+
+extern struct file *openat_exec(int, const char *, int);
+static inline struct file *open_exec(const char *name)
+{
+	return openat_exec(AT_FDCWD, name, 0);
+}
+
 /* fs/dcache.c -- generic fs support functions */
 extern bool is_subdir(struct dentry *, struct dentry *);
 extern bool path_is_under(const struct path *, const struct path *);
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index 6448cdd9a350..607bc98813e3 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -90,5 +90,11 @@
 #define AT_STATX_FORCE_SYNC	0x2000	/* - Force the attributes to be sync'd with the server */
 #define AT_STATX_DONT_SYNC	0x4000	/* - Don't sync attributes with the server */
 
+#define AT_RESOLUTION_TYPE	0xF8000 /* Type of path-resolution scoping we are applying. */
+#define AT_BENEATH		0x08000 /* - Block "lexical" trickery like "..", symlinks, absolute paths, etc. */
+#define AT_XDEV			0x10000 /* - Block mount-point crossings (includes bind-mounts). */
+#define AT_NO_MAGICLINKS	0x20000 /* - Block procfs-style "magic" symlinks. */
+#define AT_NO_SYMLINKS		0x40000 /* - Block all symlinks (implies AT_NO_MAGICLINKS). */
+#define AT_THIS_ROOT		0x80000 /* - Scope ".." resolution to dirfd (like chroot(2)). */
 
 #endif /* _UAPI_LINUX_FCNTL_H */
-- 
2.21.0

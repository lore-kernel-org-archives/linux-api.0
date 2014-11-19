From: David Drysdale <drysdale@google.com>
Subject: [PATCHv9 1/5] syscalls: implement execveat() system call
Date: Wed, 19 Nov 2014 17:27:48 +0000
Message-ID: <1416418072-18639-2-git-send-email-drysdale@google.com>
References: <1416418072-18639-1-git-send-email-drysdale@google.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1416418072-18639-1-git-send-email-drysdale@google.com>
Sender: linux-arch-owner@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>, Andy Lutomirski <luto@amacapital.net>, Alexander Viro <viro@zeniv.linux.org.uk>, Meredydd Luff <meredydd@senatehouse.org>, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, David Miller <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>
Cc: Oleg Nesterov <oleg@redhat.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Rich Felker <dalias@aerifal.cx>, Christoph Hellwig <hch@infradead.org>, x86@kernel.org, linux-arch@vger.kernel.org, linux-api@vger.kernel.org, sparclinux@vger.kernel.org, David Drysdale <drysdale@google.com>
List-Id: linux-api@vger.kernel.org

Add a new execveat(2) system call. execveat() is to execve() as
openat() is to open(): it takes a file descriptor that refers to a
directory, and resolves the filename relative to that.

In addition, if the filename is empty and AT_EMPTY_PATH is specified,
execveat() executes the file to which the file descriptor refers. This
replicates the functionality of fexecve(), which is a system call in
other UNIXen, but in Linux glibc it depends on opening
"/proc/self/fd/<fd>" (and so relies on /proc being mounted).

The filename fed to the executed program as argv[0] (or the name of the
script fed to a script interpreter) will be of the form "/dev/fd/<fd>"
(for an empty filename) or "/dev/fd/<fd>/<filename>", effectively
reflecting how the executable was found.  This does however mean that
execution of a script in a /proc-less environment won't work; also,
script execution via an O_CLOEXEC file descriptor fails (as the file
will not be accessible after exec).

Based on patches by Meredydd Luff <meredydd@senatehouse.org>

Signed-off-by: David Drysdale <drysdale@google.com>
---
 fs/binfmt_em86.c                  |   4 ++
 fs/binfmt_misc.c                  |   4 ++
 fs/binfmt_script.c                |  10 ++++
 fs/exec.c                         | 113 +++++++++++++++++++++++++++++++++-----
 fs/namei.c                        |   2 +-
 include/linux/binfmts.h           |   4 ++
 include/linux/compat.h            |   3 +
 include/linux/fs.h                |   1 +
 include/linux/sched.h             |   4 ++
 include/linux/syscalls.h          |   5 ++
 include/uapi/asm-generic/unistd.h |   4 +-
 kernel/sys_ni.c                   |   3 +
 lib/audit.c                       |   3 +
 13 files changed, 145 insertions(+), 15 deletions(-)

diff --git a/fs/binfmt_em86.c b/fs/binfmt_em86.c
index f37b08cea1f7..490538536cb4 100644
--- a/fs/binfmt_em86.c
+++ b/fs/binfmt_em86.c
@@ -42,6 +42,10 @@ static int load_em86(struct linux_binprm *bprm)
 			return -ENOEXEC;
 	}
 
+	/* Need to be able to load the file after exec */
+	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
+		return -ENOENT;
+
 	allow_write_access(bprm->file);
 	fput(bprm->file);
 	bprm->file = NULL;
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index fd8beb9657a2..85acb8c83a9a 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -142,6 +142,10 @@ static int load_misc_binary(struct linux_binprm *bprm)
 	if (!fmt)
 		goto _ret;
 
+	/* Need to be able to load the file after exec */
+	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
+		return -ENOENT;
+
 	if (!(fmt->flags & MISC_FMT_PRESERVE_ARGV0)) {
 		retval = remove_arg_zero(bprm);
 		if (retval)
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index 5027a3e14922..afdf4e3cafc2 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -24,6 +24,16 @@ static int load_script(struct linux_binprm *bprm)
 
 	if ((bprm->buf[0] != '#') || (bprm->buf[1] != '!'))
 		return -ENOEXEC;
+
+	/*
+	 * If the script filename will be inaccessible after exec, typically
+	 * because it is a "/dev/fd/<fd>/.." path against an O_CLOEXEC fd, give
+	 * up now (on the assumption that the interpreter will want to load
+	 * this file).
+	 */
+	if (bprm->interp_flags & BINPRM_FLAGS_PATH_INACCESSIBLE)
+		return -ENOENT;
+
 	/*
 	 * This section does the #! interpretation.
 	 * Sorta complicated, but hopefully it will work.  -TYT
diff --git a/fs/exec.c b/fs/exec.c
index 7302b75a9820..6ce5cc47a201 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -747,18 +747,25 @@ EXPORT_SYMBOL(setup_arg_pages);
 
 #endif /* CONFIG_MMU */
 
-static struct file *do_open_exec(struct filename *name)
+static struct file *do_open_execat(int fd, struct filename *name, int flags)
 {
 	struct file *file;
 	int err;
-	static const struct open_flags open_exec_flags = {
+	struct open_flags open_exec_flags = {
 		.open_flag = O_LARGEFILE | O_RDONLY | __FMODE_EXEC,
 		.acc_mode = MAY_EXEC | MAY_OPEN,
 		.intent = LOOKUP_OPEN,
 		.lookup_flags = LOOKUP_FOLLOW,
 	};
 
-	file = do_filp_open(AT_FDCWD, name, &open_exec_flags);
+	if ((flags & ~(AT_SYMLINK_NOFOLLOW | AT_EMPTY_PATH)) != 0)
+		return ERR_PTR(-EINVAL);
+	if (flags & AT_SYMLINK_NOFOLLOW)
+		open_exec_flags.lookup_flags &= ~LOOKUP_FOLLOW;
+	if (flags & AT_EMPTY_PATH)
+		open_exec_flags.lookup_flags |= LOOKUP_EMPTY;
+
+	file = do_filp_open(fd, name, &open_exec_flags);
 	if (IS_ERR(file))
 		goto out;
 
@@ -769,12 +776,13 @@ static struct file *do_open_exec(struct filename *name)
 	if (file->f_path.mnt->mnt_flags & MNT_NOEXEC)
 		goto exit;
 
-	fsnotify_open(file);
-
 	err = deny_write_access(file);
 	if (err)
 		goto exit;
 
+	if (name->name[0] != '\0')
+		fsnotify_open(file);
+
 out:
 	return file;
 
@@ -786,7 +794,7 @@ exit:
 struct file *open_exec(const char *name)
 {
 	struct filename tmp = { .name = name };
-	return do_open_exec(&tmp);
+	return do_open_execat(AT_FDCWD, &tmp, 0);
 }
 EXPORT_SYMBOL(open_exec);
 
@@ -1427,10 +1435,12 @@ static int exec_binprm(struct linux_binprm *bprm)
 /*
  * sys_execve() executes a new program.
  */
-static int do_execve_common(struct filename *filename,
-				struct user_arg_ptr argv,
-				struct user_arg_ptr envp)
+static int do_execveat_common(int fd, struct filename *filename,
+			      struct user_arg_ptr argv,
+			      struct user_arg_ptr envp,
+			      int flags)
 {
+	char *pathbuf = NULL;
 	struct linux_binprm *bprm;
 	struct file *file;
 	struct files_struct *displaced;
@@ -1471,7 +1481,7 @@ static int do_execve_common(struct filename *filename,
 	check_unsafe_exec(bprm);
 	current->in_execve = 1;
 
-	file = do_open_exec(filename);
+	file = do_open_execat(fd, filename, flags);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
 		goto out_unmark;
@@ -1479,7 +1489,28 @@ static int do_execve_common(struct filename *filename,
 	sched_exec();
 
 	bprm->file = file;
-	bprm->filename = bprm->interp = filename->name;
+	if (fd == AT_FDCWD || filename->name[0] == '/') {
+		bprm->filename = filename->name;
+	} else {
+		if (filename->name[0] == '\0')
+			pathbuf = kasprintf(GFP_TEMPORARY, "/dev/fd/%d", fd);
+		else
+			pathbuf = kasprintf(GFP_TEMPORARY, "/dev/fd/%d/%s",
+					    fd, filename->name);
+		if (!pathbuf) {
+			retval = -ENOMEM;
+			goto out_unmark;
+		}
+		/*
+		 * Record that a name derived from an O_CLOEXEC fd will be
+		 * inaccessible after exec. Relies on having exclusive access to
+		 * current->files (due to unshare_files above).
+		 */
+		if (close_on_exec(fd, rcu_dereference_raw(current->files->fdt)))
+			bprm->interp_flags |= BINPRM_FLAGS_PATH_INACCESSIBLE;
+		bprm->filename = pathbuf;
+	}
+	bprm->interp = bprm->filename;
 
 	retval = bprm_mm_init(bprm);
 	if (retval)
@@ -1520,6 +1551,7 @@ static int do_execve_common(struct filename *filename,
 	acct_update_integrals(current);
 	task_numa_free(current);
 	free_bprm(bprm);
+	kfree(pathbuf);
 	putname(filename);
 	if (displaced)
 		put_files_struct(displaced);
@@ -1537,6 +1569,7 @@ out_unmark:
 
 out_free:
 	free_bprm(bprm);
+	kfree(pathbuf);
 
 out_files:
 	if (displaced)
@@ -1552,7 +1585,18 @@ int do_execve(struct filename *filename,
 {
 	struct user_arg_ptr argv = { .ptr.native = __argv };
 	struct user_arg_ptr envp = { .ptr.native = __envp };
-	return do_execve_common(filename, argv, envp);
+	return do_execveat_common(AT_FDCWD, filename, argv, envp, 0);
+}
+
+int do_execveat(int fd, struct filename *filename,
+		const char __user *const __user *__argv,
+		const char __user *const __user *__envp,
+		int flags)
+{
+	struct user_arg_ptr argv = { .ptr.native = __argv };
+	struct user_arg_ptr envp = { .ptr.native = __envp };
+
+	return do_execveat_common(fd, filename, argv, envp, flags);
 }
 
 #ifdef CONFIG_COMPAT
@@ -1568,7 +1612,23 @@ static int compat_do_execve(struct filename *filename,
 		.is_compat = true,
 		.ptr.compat = __envp,
 	};
-	return do_execve_common(filename, argv, envp);
+	return do_execveat_common(AT_FDCWD, filename, argv, envp, 0);
+}
+
+static int compat_do_execveat(int fd, struct filename *filename,
+			      const compat_uptr_t __user *__argv,
+			      const compat_uptr_t __user *__envp,
+			      int flags)
+{
+	struct user_arg_ptr argv = {
+		.is_compat = true,
+		.ptr.compat = __argv,
+	};
+	struct user_arg_ptr envp = {
+		.is_compat = true,
+		.ptr.compat = __envp,
+	};
+	return do_execveat_common(fd, filename, argv, envp, flags);
 }
 #endif
 
@@ -1608,6 +1668,20 @@ SYSCALL_DEFINE3(execve,
 {
 	return do_execve(getname(filename), argv, envp);
 }
+
+SYSCALL_DEFINE5(execveat,
+		int, fd, const char __user *, filename,
+		const char __user *const __user *, argv,
+		const char __user *const __user *, envp,
+		int, flags)
+{
+	int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
+
+	return do_execveat(fd,
+			   getname_flags(filename, lookup_flags, NULL),
+			   argv, envp, flags);
+}
+
 #ifdef CONFIG_COMPAT
 COMPAT_SYSCALL_DEFINE3(execve, const char __user *, filename,
 	const compat_uptr_t __user *, argv,
@@ -1615,4 +1689,17 @@ COMPAT_SYSCALL_DEFINE3(execve, const char __user *, filename,
 {
 	return compat_do_execve(getname(filename), argv, envp);
 }
+
+COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
+		       const char __user *, filename,
+		       const compat_uptr_t __user *, argv,
+		       const compat_uptr_t __user *, envp,
+		       int,  flags)
+{
+	int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
+
+	return compat_do_execveat(fd,
+				  getname_flags(filename, lookup_flags, NULL),
+				  argv, envp, flags);
+}
 #endif
diff --git a/fs/namei.c b/fs/namei.c
index db5fe86319e6..ca814165d84c 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -130,7 +130,7 @@ void final_putname(struct filename *name)
 
 #define EMBEDDED_NAME_MAX	(PATH_MAX - sizeof(struct filename))
 
-static struct filename *
+struct filename *
 getname_flags(const char __user *filename, int flags, int *empty)
 {
 	struct filename *result, *err;
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 61f29e5ea840..576e4639ca60 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -53,6 +53,10 @@ struct linux_binprm {
 #define BINPRM_FLAGS_EXECFD_BIT 1
 #define BINPRM_FLAGS_EXECFD (1 << BINPRM_FLAGS_EXECFD_BIT)
 
+/* filename of the binary will be inaccessible after exec */
+#define BINPRM_FLAGS_PATH_INACCESSIBLE_BIT 2
+#define BINPRM_FLAGS_PATH_INACCESSIBLE (1 << BINPRM_FLAGS_PATH_INACCESSIBLE_BIT)
+
 /* Function parameter for binfmt->coredump */
 struct coredump_params {
 	const siginfo_t *siginfo;
diff --git a/include/linux/compat.h b/include/linux/compat.h
index e6494261eaff..7450ca2ac1fc 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -357,6 +357,9 @@ asmlinkage long compat_sys_lseek(unsigned int, compat_off_t, unsigned int);
 
 asmlinkage long compat_sys_execve(const char __user *filename, const compat_uptr_t __user *argv,
 		     const compat_uptr_t __user *envp);
+asmlinkage long compat_sys_execveat(int dfd, const char __user *filename,
+		     const compat_uptr_t __user *argv,
+		     const compat_uptr_t __user *envp, int flags);
 
 asmlinkage long compat_sys_select(int n, compat_ulong_t __user *inp,
 		compat_ulong_t __user *outp, compat_ulong_t __user *exp,
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9ab779e8a63c..133b60b1d4d0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2072,6 +2072,7 @@ extern int vfs_open(const struct path *, struct file *, const struct cred *);
 extern struct file * dentry_open(const struct path *, int, const struct cred *);
 extern int filp_close(struct file *, fl_owner_t id);
 
+extern struct filename *getname_flags(const char __user *, int, int *);
 extern struct filename *getname(const char __user *);
 extern struct filename *getname_kernel(const char *);
 
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 5e344bbe63ec..344163d09efb 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2441,6 +2441,10 @@ extern void do_group_exit(int);
 extern int do_execve(struct filename *,
 		     const char __user * const __user *,
 		     const char __user * const __user *);
+extern int do_execveat(int, struct filename *,
+		       const char __user * const __user *,
+		       const char __user * const __user *,
+		       int);
 extern long do_fork(unsigned long, unsigned long, unsigned long, int __user *, int __user *);
 struct task_struct *fork_idle(int);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index bda9b81357cc..1ff5a4d09693 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -877,4 +877,9 @@ asmlinkage long sys_seccomp(unsigned int op, unsigned int flags,
 asmlinkage long sys_getrandom(char __user *buf, size_t count,
 			      unsigned int flags);
 asmlinkage long sys_bpf(int cmd, union bpf_attr *attr, unsigned int size);
+
+asmlinkage long sys_execveat(int dfd, const char __user *filename,
+			const char __user *const __user *argv,
+			const char __user *const __user *envp, int flags);
+
 #endif
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 22749c134117..e016bd9b1a04 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -707,9 +707,11 @@ __SYSCALL(__NR_getrandom, sys_getrandom)
 __SYSCALL(__NR_memfd_create, sys_memfd_create)
 #define __NR_bpf 280
 __SYSCALL(__NR_bpf, sys_bpf)
+#define __NR_execveat 281
+__SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
 
 #undef __NR_syscalls
-#define __NR_syscalls 281
+#define __NR_syscalls 282
 
 /*
  * All syscalls below here should go away really,
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 02aa4185b17e..832fba6e2eb1 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -224,3 +224,6 @@ cond_syscall(sys_seccomp);
 
 /* access BPF programs and maps */
 cond_syscall(sys_bpf);
+
+/* execveat */
+cond_syscall(sys_execveat);
diff --git a/lib/audit.c b/lib/audit.c
index 1d726a22565b..b8fb5ee81e26 100644
--- a/lib/audit.c
+++ b/lib/audit.c
@@ -54,6 +54,9 @@ int audit_classify_syscall(int abi, unsigned syscall)
 	case __NR_socketcall:
 		return 4;
 #endif
+#ifdef __NR_execveat
+	case __NR_execveat:
+#endif
 	case __NR_execve:
 		return 5;
 	default:
-- 
2.1.0.rc2.206.gedb03e5

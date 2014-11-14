From: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv8 1/4] syscalls,x86: implement execveat() system call
Date: Fri, 14 Nov 2014 16:23:00 +0000
Message-ID: <1415982183-20525-2-git-send-email-drysdale@google.com>
References: <1415982183-20525-1-git-send-email-drysdale@google.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415982183-20525-1-git-send-email-drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
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

Only x86-64, i386 and x32 ABIs are supported in this patch.

Based on patches by Meredydd Luff <meredydd-zPN50pYk8eUaUu29zAJCuw@public.gmane.org>

Signed-off-by: David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/ia32/audit.c             |   1 +
 arch/x86/ia32/ia32entry.S         |   1 +
 arch/x86/kernel/audit_64.c        |   1 +
 arch/x86/kernel/entry_64.S        |  28 ++++++++++
 arch/x86/syscalls/syscall_32.tbl  |   1 +
 arch/x86/syscalls/syscall_64.tbl  |   2 +
 arch/x86/um/sys_call_table_64.c   |   1 +
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
 20 files changed, 180 insertions(+), 15 deletions(-)

diff --git a/arch/x86/ia32/audit.c b/arch/x86/ia32/audit.c
index 5d7b381da692..2eccc8932ae6 100644
--- a/arch/x86/ia32/audit.c
+++ b/arch/x86/ia32/audit.c
@@ -35,6 +35,7 @@ int ia32_classify_syscall(unsigned syscall)
 	case __NR_socketcall:
 		return 4;
 	case __NR_execve:
+	case __NR_execveat:
 		return 5;
 	default:
 		return 1;
diff --git a/arch/x86/ia32/ia32entry.S b/arch/x86/ia32/ia32entry.S
index ffe71228fc10..82e8a1d44658 100644
--- a/arch/x86/ia32/ia32entry.S
+++ b/arch/x86/ia32/ia32entry.S
@@ -480,6 +480,7 @@ GLOBAL(\label)
 	PTREGSCALL stub32_rt_sigreturn, sys32_rt_sigreturn
 	PTREGSCALL stub32_sigreturn, sys32_sigreturn
 	PTREGSCALL stub32_execve, compat_sys_execve
+	PTREGSCALL stub32_execveat, compat_sys_execveat
 	PTREGSCALL stub32_fork, sys_fork
 	PTREGSCALL stub32_vfork, sys_vfork

diff --git a/arch/x86/kernel/audit_64.c b/arch/x86/kernel/audit_64.c
index 06d3e5a14d9d..f3672508b249 100644
--- a/arch/x86/kernel/audit_64.c
+++ b/arch/x86/kernel/audit_64.c
@@ -50,6 +50,7 @@ int audit_classify_syscall(int abi, unsigned syscall)
 	case __NR_openat:
 		return 3;
 	case __NR_execve:
+	case __NR_execveat:
 		return 5;
 	default:
 		return 0;
diff --git a/arch/x86/kernel/entry_64.S b/arch/x86/kernel/entry_64.S
index df088bb03fb3..40d893c60fcc 100644
--- a/arch/x86/kernel/entry_64.S
+++ b/arch/x86/kernel/entry_64.S
@@ -652,6 +652,20 @@ ENTRY(stub_execve)
 	CFI_ENDPROC
 END(stub_execve)

+ENTRY(stub_execveat)
+	CFI_STARTPROC
+	addq $8, %rsp
+	PARTIAL_FRAME 0
+	SAVE_REST
+	FIXUP_TOP_OF_STACK %r11
+	call sys_execveat
+	RESTORE_TOP_OF_STACK %r11
+	movq %rax,RAX(%rsp)
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+	CFI_ENDPROC
+END(stub_execveat)
+
 /*
  * sigreturn is special because it needs to restore all registers on return.
  * This cannot be done with SYSRET, so use the IRET return path instead.
@@ -697,6 +711,20 @@ ENTRY(stub_x32_execve)
 	CFI_ENDPROC
 END(stub_x32_execve)

+ENTRY(stub_x32_execveat)
+	CFI_STARTPROC
+	addq $8, %rsp
+	PARTIAL_FRAME 0
+	SAVE_REST
+	FIXUP_TOP_OF_STACK %r11
+	call compat_sys_execveat
+	RESTORE_TOP_OF_STACK %r11
+	movq %rax,RAX(%rsp)
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+	CFI_ENDPROC
+END(stub_x32_execveat)
+
 #endif

 /*
diff --git a/arch/x86/syscalls/syscall_32.tbl b/arch/x86/syscalls/syscall_32.tbl
index 9fe1b5d002f0..b3560ece1c9f 100644
--- a/arch/x86/syscalls/syscall_32.tbl
+++ b/arch/x86/syscalls/syscall_32.tbl
@@ -364,3 +364,4 @@
 355	i386	getrandom		sys_getrandom
 356	i386	memfd_create		sys_memfd_create
 357	i386	bpf			sys_bpf
+358	i386	execveat		sys_execveat			stub32_execveat
diff --git a/arch/x86/syscalls/syscall_64.tbl b/arch/x86/syscalls/syscall_64.tbl
index 281150b539a2..8d656fbb57aa 100644
--- a/arch/x86/syscalls/syscall_64.tbl
+++ b/arch/x86/syscalls/syscall_64.tbl
@@ -328,6 +328,7 @@
 319	common	memfd_create		sys_memfd_create
 320	common	kexec_file_load		sys_kexec_file_load
 321	common	bpf			sys_bpf
+322	64	execveat		stub_execveat

 #
 # x32-specific system call numbers start at 512 to avoid cache impact
@@ -366,3 +367,4 @@
 542	x32	getsockopt		compat_sys_getsockopt
 543	x32	io_setup		compat_sys_io_setup
 544	x32	io_submit		compat_sys_io_submit
+545	x32	execveat		stub_x32_execveat
diff --git a/arch/x86/um/sys_call_table_64.c b/arch/x86/um/sys_call_table_64.c
index f2f0723070ca..20c3649d0691 100644
--- a/arch/x86/um/sys_call_table_64.c
+++ b/arch/x86/um/sys_call_table_64.c
@@ -31,6 +31,7 @@
 #define stub_fork sys_fork
 #define stub_vfork sys_vfork
 #define stub_execve sys_execve
+#define stub_execveat sys_execveat
 #define stub_rt_sigreturn sys_rt_sigreturn

 #define __SYSCALL_COMMON(nr, sym, compat) __SYSCALL_64(nr, sym, compat)
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

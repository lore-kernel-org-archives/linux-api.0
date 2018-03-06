From: Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH net-next] modules: allow modprobe load regular elf binaries
Date: Mon, 5 Mar 2018 17:34:57 -0800
Message-ID: <20180306013457.1955486-1-ast@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: davem@davemloft.net
Cc: daniel@iogearbox.net, torvalds@linux-foundation.org, gregkh@linuxfoundation.org, mcgrof@kernel.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

As the first step in development of bpfilter project [1] the request_module()
code is extended to allow user mode helpers to be invoked. Idea is that
user mode helpers are built as part of the kernel build and installed as
traditional kernel modules with .ko file extension into distro specified
location, such that from a distribution point of view, they are no different
than regular kernel modules. Thus, allow request_module() logic to load such
user mode helper (umh) modules via:

  request_module("foo") ->
    call_umh("modprobe foo") ->
      sys_finit_module(FD of /lib/modules/.../foo.ko) ->
        call_umh(struct file)

Such approach enables kernel to delegate functionality traditionally done
by kernel modules into user space processes (either root or !root) and
reduces security attack surface of such new code, meaning in case of
potential bugs only the umh would crash but not the kernel. Another
advantage coming with that would be that bpfilter.ko can be debugged and
tested out of user space as well (e.g. opening the possibility to run
all clang sanitizers, fuzzers or test suites for checking translation).
Also, such architecture makes the kernel/user boundary very precise:
control plane is done by the user space while data plane stays in the kernel.

It's easy to distinguish "umh module" from traditional kernel module:

$ readelf -h bld/net/bpfilter/bpfilter.ko|grep Type
  Type:                              EXEC (Executable file)
$ readelf -h bld/net/ipv4/netfilter/iptable_filter.ko |grep Type
  Type:                              REL (Relocatable file)

Since umh can crash, can be oom-ed by the kernel, killed by admin,
the subsystem that uses them (like bpfilter) need to manage life
time of umh on its own, so module infra doesn't do any accounting
of them. They don't appear in "lsmod" and cannot be "rmmod".
Multiple request_module("umh") will load multiple umh.ko processes.

Similar to kernel modules the kernel will be tainted if "umh module"
has invalid signature.

[1] https://lwn.net/Articles/747551/

Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 fs/exec.c               | 40 +++++++++++++++++++++++++++++++---------
 include/linux/binfmts.h |  1 +
 include/linux/umh.h     |  3 +++
 kernel/module.c         | 43 ++++++++++++++++++++++++++++++++++++++-----
 kernel/umh.c            | 24 +++++++++++++++++++++---
 5 files changed, 94 insertions(+), 17 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index 7eb8d21bcab9..0483c438de7d 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -1691,14 +1691,13 @@ static int exec_binprm(struct linux_binprm *bprm)
 /*
  * sys_execve() executes a new program.
  */
-static int do_execveat_common(int fd, struct filename *filename,
-			      struct user_arg_ptr argv,
-			      struct user_arg_ptr envp,
-			      int flags)
+static int __do_execve_file(int fd, struct filename *filename,
+			    struct user_arg_ptr argv,
+			    struct user_arg_ptr envp,
+			    int flags, struct file *file)
 {
 	char *pathbuf = NULL;
 	struct linux_binprm *bprm;
-	struct file *file;
 	struct files_struct *displaced;
 	int retval;
 
@@ -1737,7 +1736,8 @@ static int do_execveat_common(int fd, struct filename *filename,
 	check_unsafe_exec(bprm);
 	current->in_execve = 1;
 
-	file = do_open_execat(fd, filename, flags);
+	if (!file)
+		file = do_open_execat(fd, filename, flags);
 	retval = PTR_ERR(file);
 	if (IS_ERR(file))
 		goto out_unmark;
@@ -1745,7 +1745,9 @@ static int do_execveat_common(int fd, struct filename *filename,
 	sched_exec();
 
 	bprm->file = file;
-	if (fd == AT_FDCWD || filename->name[0] == '/') {
+	if (!filename) {
+		bprm->filename = "/dev/null";
+	} else if (fd == AT_FDCWD || filename->name[0] == '/') {
 		bprm->filename = filename->name;
 	} else {
 		if (filename->name[0] == '\0')
@@ -1811,7 +1813,8 @@ static int do_execveat_common(int fd, struct filename *filename,
 	task_numa_free(current);
 	free_bprm(bprm);
 	kfree(pathbuf);
-	putname(filename);
+	if (filename)
+		putname(filename);
 	if (displaced)
 		put_files_struct(displaced);
 	return retval;
@@ -1834,10 +1837,29 @@ static int do_execveat_common(int fd, struct filename *filename,
 	if (displaced)
 		reset_files_struct(displaced);
 out_ret:
-	putname(filename);
+	if (filename)
+		putname(filename);
 	return retval;
 }
 
+static int do_execveat_common(int fd, struct filename *filename,
+			      struct user_arg_ptr argv,
+			      struct user_arg_ptr envp,
+			      int flags)
+{
+	struct file *file = NULL;
+
+	return __do_execve_file(fd, filename, argv, envp, flags, file);
+}
+
+int do_execve_file(struct file *file, void *__argv, void *__envp)
+{
+	struct user_arg_ptr argv = { .ptr.native = __argv };
+	struct user_arg_ptr envp = { .ptr.native = __envp };
+
+	return __do_execve_file(AT_FDCWD, NULL, argv, envp, 0, file);
+}
+
 int do_execve(struct filename *filename,
 	const char __user *const __user *__argv,
 	const char __user *const __user *__envp)
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index b0abe21d6cc9..c783a7b9f284 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -147,5 +147,6 @@ extern int do_execveat(int, struct filename *,
 		       const char __user * const __user *,
 		       const char __user * const __user *,
 		       int);
+int do_execve_file(struct file *file, void *__argv, void *__envp);
 
 #endif /* _LINUX_BINFMTS_H */
diff --git a/include/linux/umh.h b/include/linux/umh.h
index 244aff638220..2b10d5f70bd9 100644
--- a/include/linux/umh.h
+++ b/include/linux/umh.h
@@ -22,6 +22,7 @@ struct subprocess_info {
 	const char *path;
 	char **argv;
 	char **envp;
+	struct file *file;
 	int wait;
 	int retval;
 	int (*init)(struct subprocess_info *info, struct cred *new);
@@ -38,6 +39,8 @@ call_usermodehelper_setup(const char *path, char **argv, char **envp,
 			  int (*init)(struct subprocess_info *info, struct cred *new),
 			  void (*cleanup)(struct subprocess_info *), void *data);
 
+struct subprocess_info *call_usermodehelper_setup_file(struct file *file);
+
 extern int
 call_usermodehelper_exec(struct subprocess_info *info, int wait);
 
diff --git a/kernel/module.c b/kernel/module.c
index ad2d420024f6..6cfa35795741 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -325,6 +325,7 @@ struct load_info {
 	struct {
 		unsigned int sym, str, mod, vers, info, pcpu;
 	} index;
+	struct file *file;
 };
 
 /*
@@ -2801,6 +2802,15 @@ static int module_sig_check(struct load_info *info, int flags)
 }
 #endif /* !CONFIG_MODULE_SIG */
 
+static int run_umh(struct file *file)
+{
+	struct subprocess_info *sub_info = call_usermodehelper_setup_file(file);
+
+	if (!sub_info)
+		return -ENOMEM;
+	return call_usermodehelper_exec(sub_info, UMH_WAIT_EXEC);
+}
+
 /* Sanity checks against invalid binaries, wrong arch, weird elf version. */
 static int elf_header_check(struct load_info *info)
 {
@@ -2808,7 +2818,6 @@ static int elf_header_check(struct load_info *info)
 		return -ENOEXEC;
 
 	if (memcmp(info->hdr->e_ident, ELFMAG, SELFMAG) != 0
-	    || info->hdr->e_type != ET_REL
 	    || !elf_check_arch(info->hdr)
 	    || info->hdr->e_shentsize != sizeof(Elf_Shdr))
 		return -ENOEXEC;
@@ -2818,6 +2827,11 @@ static int elf_header_check(struct load_info *info)
 		info->len - info->hdr->e_shoff))
 		return -ENOEXEC;
 
+	if (info->hdr->e_type == ET_EXEC)
+		return run_umh(info->file);
+
+	if (info->hdr->e_type != ET_REL)
+		return -ENOEXEC;
 	return 0;
 }
 
@@ -3669,6 +3683,17 @@ static int load_module(struct load_info *info, const char __user *uargs,
 	if (err)
 		goto free_copy;
 
+	if (info->hdr->e_type == ET_EXEC) {
+#ifdef CONFIG_MODULE_SIG
+		if (!info->sig_ok) {
+			pr_notice_once("umh %s verification failed: signature and/or required key missing - tainting kernel\n",
+				       info->file->f_path.dentry->d_name.name);
+			add_taint(TAINT_UNSIGNED_MODULE, LOCKDEP_STILL_OK);
+		}
+#endif
+		return 0;
+	}
+
 	/* Figure out module layout, and allocate all the memory. */
 	mod = layout_and_allocate(info, flags);
 	if (IS_ERR(mod)) {
@@ -3856,6 +3881,7 @@ SYSCALL_DEFINE3(init_module, void __user *, umod,
 SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
 {
 	struct load_info info = { };
+	struct fd f;
 	loff_t size;
 	void *hdr;
 	int err;
@@ -3870,14 +3896,21 @@ SYSCALL_DEFINE3(finit_module, int, fd, const char __user *, uargs, int, flags)
 		      |MODULE_INIT_IGNORE_VERMAGIC))
 		return -EINVAL;
 
-	err = kernel_read_file_from_fd(fd, &hdr, &size, INT_MAX,
-				       READING_MODULE);
+	f = fdget(fd);
+	if (!f.file)
+		return -EBADF;
+
+	err = kernel_read_file(f.file, &hdr, &size, INT_MAX, READING_MODULE);
 	if (err)
-		return err;
+		goto out;
 	info.hdr = hdr;
 	info.len = size;
+	info.file = f.file;
 
-	return load_module(&info, uargs, flags);
+	err = load_module(&info, uargs, flags);
+out:
+	fdput(f);
+	return err;
 }
 
 static inline int within(unsigned long addr, void *start, unsigned long size)
diff --git a/kernel/umh.c b/kernel/umh.c
index 18e5fa4b0e71..4361c694bdb1 100644
--- a/kernel/umh.c
+++ b/kernel/umh.c
@@ -97,9 +97,13 @@ static int call_usermodehelper_exec_async(void *data)
 
 	commit_creds(new);
 
-	retval = do_execve(getname_kernel(sub_info->path),
-			   (const char __user *const __user *)sub_info->argv,
-			   (const char __user *const __user *)sub_info->envp);
+	if (sub_info->file)
+		retval = do_execve_file(sub_info->file,
+					sub_info->argv, sub_info->envp);
+	else
+		retval = do_execve(getname_kernel(sub_info->path),
+				   (const char __user *const __user *)sub_info->argv,
+				   (const char __user *const __user *)sub_info->envp);
 out:
 	sub_info->retval = retval;
 	/*
@@ -393,6 +397,20 @@ struct subprocess_info *call_usermodehelper_setup(const char *path, char **argv,
 }
 EXPORT_SYMBOL(call_usermodehelper_setup);
 
+struct subprocess_info *call_usermodehelper_setup_file(struct file *file)
+{
+	struct subprocess_info *sub_info;
+
+	sub_info = kzalloc(sizeof(struct subprocess_info), GFP_KERNEL);
+	if (!sub_info)
+		return NULL;
+
+	INIT_WORK(&sub_info->work, call_usermodehelper_exec_work);
+	sub_info->path = "/dev/null";
+	sub_info->file = file;
+	return sub_info;
+}
+
 /**
  * call_usermodehelper_exec - start a usermode application
  * @sub_info: information about the subprocessa
-- 
2.9.5

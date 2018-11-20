From: Christian Brauner <christian@brauner.io>
Subject: [PATCH v2] signal: add procfd_signal() syscall
Date: Tue, 20 Nov 2018 11:51:23 +0100
Message-ID: <20181120105124.14733-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: ebiederm@xmission.com, linux-kernel@vger.kernel.org
Cc: serge@hallyn.com, jannh@google.com, luto@kernel.org, akpm@linux-foundation.org, oleg@redhat.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, dancol@google.com, timmurray@google.com, linux-man@vger.kernel.org, Christian Brauner <christian@brauner.io>, Kees Cook <keescook@chromium.org>
List-Id: linux-api@vger.kernel.org

The kill() syscall operates on process identifiers. After a process has
exited its pid can be reused by another process. If a caller sends a signal
to a reused pid it will end up signaling the wrong process. This issue has
often surfaced and there has been a push [1] to address this problem.

This patch uses file descriptors from proc/<pid> as stable handles on
struct pid. Even if a pid is recycled the handle will not change. The file
descriptor can be used to send signals to the referenced process.
Thus, the  new syscall procfd_signal() is introduced to solve this problem.
It operates on a process file descriptor.
The syscall takes an additional siginfo_t and flags argument. If siginfo_t
is NULL then procfd_signal() behaves like kill() if it is not NULL it
behaves like rt_sigqueueinfo.
The flags argument is added to allow for future extensions of this syscall.
It currently needs to be passed as 0.

With this patch a process can be killed via:

 #define _GNU_SOURCE
 #include <errno.h>
 #include <fcntl.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <signal.h>
 #include <sys/stat.h>
 #include <sys/syscall.h>
 #include <sys/types.h>
 #include <unistd.h>

 int main(int argc, char *argv[])
 {
         int ret;
         char buf[1000];

         if (argc < 2)
                 exit(EXIT_FAILURE);

         ret = snprintf(buf, sizeof(buf), "/proc/%s", argv[1]);
         if (ret < 0)
                 exit(EXIT_FAILURE);

         int fd = open(buf, O_DIRECTORY | O_CLOEXEC);
         if (fd < 0) {
                 printf("%s - Failed to open \"%s\"\n", strerror(errno), buf);
                 exit(EXIT_FAILURE);
         }

         ret = syscall(__NR_procfd_signal, fd, SIGKILL, NULL, 0);
         if (ret < 0) {
                 printf("Failed to send SIGKILL \"%s\"\n", strerror(errno));
                 close(fd);
                 exit(EXIT_FAILURE);
         }

         close(fd);

         exit(EXIT_SUCCESS);
 }

[1]: https://lkml.org/lkml/2018/11/18/130

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Serge Hallyn <serge@hallyn.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christian Brauner <christian@brauner.io>
---
Changelog:
v2:
- define __NR_procfd_signal in unistd.h
- wire up compat syscall
- s/proc_is_procfd/proc_is_tgid_procfd/g
- provide stubs when CONFIG_PROC_FS=n
- move proc_pid() to linux/proc_fs.h header
- use proc_pid() to grab struct pid from /proc/<pid> fd
v1:
- patch introduced
---
 arch/x86/entry/syscalls/syscall_32.tbl |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl |   2 +
 fs/proc/base.c                         |  11 ++-
 fs/proc/internal.h                     |   5 -
 include/linux/proc_fs.h                |  12 +++
 include/linux/syscalls.h               |   2 +
 include/uapi/asm-generic/unistd.h      |   4 +-
 kernel/signal.c                        | 127 +++++++++++++++++++++++--
 8 files changed, 151 insertions(+), 13 deletions(-)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 3cf7b533b3d1..3f27ffd8ae87 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -398,3 +398,4 @@
 384	i386	arch_prctl		sys_arch_prctl			__ia32_compat_sys_arch_prctl
 385	i386	io_pgetevents		sys_io_pgetevents		__ia32_compat_sys_io_pgetevents
 386	i386	rseq			sys_rseq			__ia32_sys_rseq
+387	i386	procfd_signal		sys_procfd_signal		__ia32_compat_sys_procfd_signal
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index f0b1709a5ffb..8a30cde82450 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -343,6 +343,7 @@
 332	common	statx			__x64_sys_statx
 333	common	io_pgetevents		__x64_sys_io_pgetevents
 334	common	rseq			__x64_sys_rseq
+335	64	procfd_signal		__x64_sys_procfd_signal
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
@@ -386,3 +387,4 @@
 545	x32	execveat		__x32_compat_sys_execveat/ptregs
 546	x32	preadv2			__x32_compat_sys_preadv64v2
 547	x32	pwritev2		__x32_compat_sys_pwritev64v2
+548	x32	procfd_signal		__x32_compat_sys_procfd_signal
diff --git a/fs/proc/base.c b/fs/proc/base.c
index ce3465479447..771c6bd1cac6 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -716,7 +716,10 @@ static int proc_pid_permission(struct inode *inode, int mask)
 	return generic_permission(inode, mask);
 }
 
-
+struct pid *proc_pid(const struct inode *inode)
+{
+       return PROC_I(inode)->pid;
+}
 
 static const struct inode_operations proc_def_inode_operations = {
 	.setattr	= proc_setattr,
@@ -3038,6 +3041,12 @@ static const struct file_operations proc_tgid_base_operations = {
 	.llseek		= generic_file_llseek,
 };
 
+bool proc_is_tgid_procfd(const struct file *file)
+{
+	return d_is_dir(file->f_path.dentry) &&
+	       (file->f_op == &proc_tgid_base_operations);
+}
+
 static struct dentry *proc_tgid_base_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags)
 {
 	return proc_pident_lookup(dir, dentry,
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index 5185d7f6a51e..eb69afba83f3 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -113,11 +113,6 @@ static inline void *__PDE_DATA(const struct inode *inode)
 	return PDE(inode)->data;
 }
 
-static inline struct pid *proc_pid(const struct inode *inode)
-{
-	return PROC_I(inode)->pid;
-}
-
 static inline struct task_struct *get_proc_task(const struct inode *inode)
 {
 	return get_pid_task(proc_pid(inode), PIDTYPE_PID);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index d0e1f1522a78..96df2fe6311d 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -73,6 +73,8 @@ struct proc_dir_entry *proc_create_net_single_write(const char *name, umode_t mo
 						    int (*show)(struct seq_file *, void *),
 						    proc_write_t write,
 						    void *data);
+extern bool proc_is_tgid_procfd(const struct file *file);
+extern struct pid *proc_pid(const struct inode *inode);
 
 #else /* CONFIG_PROC_FS */
 
@@ -114,6 +116,16 @@ static inline int remove_proc_subtree(const char *name, struct proc_dir_entry *p
 #define proc_create_net(name, mode, parent, state_size, ops) ({NULL;})
 #define proc_create_net_single(name, mode, parent, show, data) ({NULL;})
 
+static inline bool proc_is_tgid_procfd(const struct file *file)
+{
+	return false;
+}
+
+static inline struct pid *proc_pid(const struct inode *inode)
+{
+	return NULL;
+}
+
 #endif /* CONFIG_PROC_FS */
 
 struct net;
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 2ac3d13a915b..a5ca8cb84566 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -907,6 +907,8 @@ asmlinkage long sys_statx(int dfd, const char __user *path, unsigned flags,
 			  unsigned mask, struct statx __user *buffer);
 asmlinkage long sys_rseq(struct rseq __user *rseq, uint32_t rseq_len,
 			 int flags, uint32_t sig);
+asmlinkage long sys_procfd_signal(int fd, int sig, siginfo_t __user *info,
+				  int flags);
 
 /*
  * Architecture-specific system calls
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 538546edbfbd..4dc81a994ad1 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -738,9 +738,11 @@ __SYSCALL(__NR_statx,     sys_statx)
 __SC_COMP(__NR_io_pgetevents, sys_io_pgetevents, compat_sys_io_pgetevents)
 #define __NR_rseq 293
 __SYSCALL(__NR_rseq, sys_rseq)
+#define __NR_procfd_signal 294
+__SC_COMP(__NR_procfd_signal, sys_procfd_signal, compat_sys_procfd_signal)
 
 #undef __NR_syscalls
-#define __NR_syscalls 294
+#define __NR_syscalls 295
 
 /*
  * 32 bit systems traditionally used different
diff --git a/kernel/signal.c b/kernel/signal.c
index 9a32bc2088c9..13695342f150 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -19,7 +19,9 @@
 #include <linux/sched/task.h>
 #include <linux/sched/task_stack.h>
 #include <linux/sched/cputime.h>
+#include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/proc_fs.h>
 #include <linux/tty.h>
 #include <linux/binfmts.h>
 #include <linux/coredump.h>
@@ -3286,6 +3288,16 @@ COMPAT_SYSCALL_DEFINE4(rt_sigtimedwait, compat_sigset_t __user *, uthese,
 }
 #endif
 
+static inline void prepare_kill_siginfo(int sig, struct kernel_siginfo *info)
+{
+	clear_siginfo(info);
+	info->si_signo = sig;
+	info->si_errno = 0;
+	info->si_code = SI_USER;
+	info->si_pid = task_tgid_vnr(current);
+	info->si_uid = from_kuid_munged(current_user_ns(), current_uid());
+}
+
 /**
  *  sys_kill - send a signal to a process
  *  @pid: the PID of the process
@@ -3295,16 +3307,119 @@ SYSCALL_DEFINE2(kill, pid_t, pid, int, sig)
 {
 	struct kernel_siginfo info;
 
-	clear_siginfo(&info);
-	info.si_signo = sig;
-	info.si_errno = 0;
-	info.si_code = SI_USER;
-	info.si_pid = task_tgid_vnr(current);
-	info.si_uid = from_kuid_munged(current_user_ns(), current_uid());
+	prepare_kill_siginfo(sig, &info);
 
 	return kill_something_info(sig, &info, pid);
 }
 
+/*
+ * Verify that the signaler and signalee either are in the same pid namespace
+ * or that the signaler's pid namespace is an ancestor of the signalee's pid
+ * namespace.
+ */
+static bool may_signal_procfd(struct pid *pid)
+{
+	struct pid_namespace *active = task_active_pid_ns(current);
+	struct pid_namespace *p = ns_of_pid(pid);
+
+	for (;;) {
+		if (!p)
+			return false;
+		if (p == active)
+			break;
+		p = p->parent;
+	}
+
+	return true;
+}
+
+static int do_procfd_signal(int fd, int sig, kernel_siginfo_t *kinfo, int flags,
+			    bool had_siginfo)
+{
+	int ret;
+	struct fd f;
+	struct pid *pid;
+
+	/* Enforce flags be set to 0 until we add an extension. */
+	if (flags)
+		return -EINVAL;
+
+	f = fdget_raw(fd);
+	if (!f.file)
+		return -EBADF;
+
+	/* Is this a process file descriptor? */
+	ret = -EINVAL;
+	if (!proc_is_tgid_procfd(f.file))
+		goto err;
+
+	/* Without CONFIG_PROC_FS proc_pid() returns NULL. */
+	pid = proc_pid(file_inode(f.file));
+	if (!pid)
+		goto err;
+
+	if (!may_signal_procfd(pid))
+		goto err;
+
+	if (had_siginfo) {
+		/*
+		 * Not even root can pretend to send signals from the kernel.
+		 * Nor can they impersonate a kill()/tgkill(), which adds
+		 * source info.
+		 */
+		ret = -EPERM;
+		if ((kinfo->si_code >= 0 || kinfo->si_code == SI_TKILL) &&
+		    (task_pid(current) != pid))
+			goto err;
+	} else {
+		prepare_kill_siginfo(sig, kinfo);
+	}
+
+	ret = kill_pid_info(sig, kinfo, pid);
+
+err:
+	fdput(f);
+	return ret;
+}
+
+/**
+ *  sys_procfd_signal - send a signal to a process through a process file
+ *                      descriptor
+ *  @fd: the file descriptor of the process
+ *  @sig: signal to be sent
+ *  @info: the signal info
+ *  @flags: future flags to be passed
+ */
+SYSCALL_DEFINE4(procfd_signal, int, fd, int, sig, siginfo_t __user *, info,
+		int, flags)
+{
+	kernel_siginfo_t kinfo;
+
+	if (info) {
+		int ret = __copy_siginfo_from_user(sig, &kinfo, info);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	return do_procfd_signal(fd, sig, &kinfo, flags, !!info);
+}
+
+#ifdef CONFIG_COMPAT
+COMPAT_SYSCALL_DEFINE4(procfd_signal, int, fd, int, sig,
+		       struct compat_siginfo __user *, info, int, flags)
+{
+	kernel_siginfo_t kinfo;
+
+	if (info) {
+		int ret = __copy_siginfo_from_user32(sig, &kinfo, info);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	return do_procfd_signal(fd, sig, &kinfo, flags, !!info);
+}
+#endif
+
 static int
 do_send_specific(pid_t tgid, pid_t pid, int sig, struct kernel_siginfo *info)
 {
-- 
2.19.1

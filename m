From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: [PATCH RFC v2] pidns: introduce syscall getvpid
Date: Thu, 24 Sep 2015 16:53:32 +0300
Message-ID: <20150924135332.27813.21640.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?utf-8?b?U3TDqXBoYW5l?= Graber <stgraber-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

pid_t getvpid(pid_t pid, int source, int target);

This syscall converts pid from source pid-namespace into pid in target
pid-namespace. Namespaces are defined by file descriptors pointing to
namespace entries in proc (/proc/[pid]/ns/pid). If source / target is
negative then current pid namespace is used.

If pid is negative then getvpid() returns pid of parent task for -pid.

If pid is unreachable from target namespace then syscall returns zero.

Errors:
ESRCH    task not found
EBADF    closed file descriptor
EINVAL   not pid-namespace file descriptor

Examples:
getvpid(pid, ns, -1)      -> pid in our pid namespace
getvpid(pid, -1, ns)      -> pid in container
getvpid(1, ns1, ns2) > 0  -> ns1 inside ns2
getvpid(1, ns1, ns2) == 0 -> ns1 outside ns2
getvpid(1, ns, -1)        -> init task of pid-namespace
getvpid(-1, ns, -1)       -> task in parent pid-namespace
getvpid(-pid, -1, -1)     -> get ppid by pid

Signed-off-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>

---

v2:
* use namespace-fd as second/third argument
* add -pid for getting parent pid
* move code into kernel/sys.c next to getppid
* drop ifdef CONFIG_PID_NS
* add generic syscall
---
 arch/x86/entry/syscalls/syscall_32.tbl |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl |    1 +
 include/linux/syscalls.h               |    1 +
 include/uapi/asm-generic/unistd.h      |    4 ++
 kernel/sys.c                           |   63 ++++++++++++++++++++++++++++++++
 5 files changed, 69 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 7663c455b9f6..dadb55d42fc9 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -382,3 +382,4 @@
 373	i386	shutdown		sys_shutdown
 374	i386	userfaultfd		sys_userfaultfd
 375	i386	membarrier		sys_membarrier
+376	i386	getvpid			sys_getvpid
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 278842fdf1f6..0338f2eb3b7c 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -331,6 +331,7 @@
 322	64	execveat		stub_execveat
 323	common	userfaultfd		sys_userfaultfd
 324	common	membarrier		sys_membarrier
+325	common	getvpid			sys_getvpid
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a460e2ef2843..01ac603c8b5c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -222,6 +222,7 @@ asmlinkage long sys_nanosleep(struct timespec __user *rqtp, struct timespec __us
 asmlinkage long sys_alarm(unsigned int seconds);
 asmlinkage long sys_getpid(void);
 asmlinkage long sys_getppid(void);
+asmlinkage long sys_getvpid(pid_t pid, int source, int target);
 asmlinkage long sys_getuid(void);
 asmlinkage long sys_geteuid(void);
 asmlinkage long sys_getgid(void);
diff --git a/include/uapi/asm-generic/unistd.h b/include/uapi/asm-generic/unistd.h
index 8da542a2874d..163df44b23cf 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -711,9 +711,11 @@ __SYSCALL(__NR_bpf, sys_bpf)
 __SC_COMP(__NR_execveat, sys_execveat, compat_sys_execveat)
 #define __NR_membarrier 282
 __SYSCALL(__NR_membarrier, sys_membarrier)
+#define __NR_getvpid 283
+__SYSCALL(__NR_getvpid, sys_getvpid)
 
 #undef __NR_syscalls
-#define __NR_syscalls 283
+#define __NR_syscalls 284
 
 /*
  * All syscalls below here should go away really,
diff --git a/kernel/sys.c b/kernel/sys.c
index fa2f2f671a5c..fbfe938dd9d7 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -46,6 +46,7 @@
 #include <linux/syscalls.h>
 #include <linux/kprobes.h>
 #include <linux/user_namespace.h>
+#include <linux/proc_ns.h>
 #include <linux/binfmts.h>
 
 #include <linux/sched.h>
@@ -855,6 +856,68 @@ SYSCALL_DEFINE0(getppid)
 	return pid;
 }
 
+SYSCALL_DEFINE3(getvpid, pid_t, pid, int, source, int, target)
+{
+	struct file *source_file = NULL, *target_file = NULL;
+	struct pid_namespace *source_ns, *target_ns;
+	struct pid *struct_pid;
+	struct ns_common *ns;
+	pid_t result;
+
+	if (source >= 0) {
+		source_file = proc_ns_fget(source);
+		result = PTR_ERR(source_file);
+		if (IS_ERR(source_file))
+			goto out;
+		ns = get_proc_ns(file_inode(source_file));
+		result = -EINVAL;
+		if (ns->ops->type != CLONE_NEWPID)
+			goto out;
+		source_ns = container_of(ns, struct pid_namespace, ns);
+	} else
+		source_ns = task_active_pid_ns(current);
+
+	if (target >= 0) {
+		target_file = proc_ns_fget(target);
+		result = PTR_ERR(target_file);
+		if (IS_ERR(target_file))
+			goto out;
+		ns = get_proc_ns(file_inode(target_file));
+		result = -EINVAL;
+		if (ns->ops->type != CLONE_NEWPID)
+			goto out;
+		target_ns = container_of(ns, struct pid_namespace, ns);
+	} else
+		target_ns = task_active_pid_ns(current);
+
+	rcu_read_lock();
+	struct_pid = find_pid_ns(abs(pid), source_ns);
+
+	if (struct_pid && pid < 0) {
+		struct task_struct *task;
+
+		task = pid_task(struct_pid, PIDTYPE_PID);
+		if (task)
+			task = rcu_dereference(task->real_parent);
+		struct_pid = task ? task_pid(task) : NULL;
+	}
+
+	if (struct_pid)
+		result = pid_nr_ns(struct_pid, target_ns);
+	else
+		result = -ESRCH;
+	rcu_read_unlock();
+
+out:
+	if (!IS_ERR_OR_NULL(target_file))
+		fput(target_file);
+
+	if (!IS_ERR_OR_NULL(source_file))
+		fput(source_file);
+
+	return result;
+}
+
 SYSCALL_DEFINE0(getuid)
 {
 	/* Only we change this so SMP safe */

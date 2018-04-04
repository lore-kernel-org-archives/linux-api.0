From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC v5] pidns: introduce syscall translate_pid
Date: Wed, 04 Apr 2018 22:11:51 +0300
Message-ID: <152286911105.615669.14053871624892399807.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jann Horn <jannh@google.com>, Serge Hallyn <serge.hallyn@ubuntu.com>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Prakash Sangappa <prakash.sangappa@oracle.com>, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

Each process have different pids, one for each pid namespace it belongs.
When interaction happens within single pid-ns translation isn't required.
More complicated scenarios needs special handling.

For example:
- reading pid-files or logs written inside container with pid namespace
- attaching with ptrace to tasks from different pid namespace
- passing pids across pid namespaces in any kind of API

Currently there are several interfaces that could be used here:

Pid namespaces are identified by inode number of /proc/[pid]/ns/pid.

Pids for nested Pid namespaces are shown in file /proc/[pid]/status.
In some cases conversion pid -> vpid could be easily done using this
information, but backward translation requires scanning all tasks.

Unix socket automatically translates pid attached to SCM_CREDENTIALS.
This requires CAP_SYS_ADMIN for sending arbitrary pids and entering
into pid namespace, this expose process and could be insecure.

This patch adds new syscall for converting pids between pid namespaces:

pid_t translate_pid(pid_t pid, int source_type, int source,
                               int target_type, int target);

@source_type and @target_type defines type of following arguments:

TRANSLATE_PID_CURRENT_PIDNS  - current pid namespace, argument is unused
TRANSLATE_PID_TASK_PIDNS     - task pid-ns, argument is task pid
TRANSLATE_PID_FD_PIDNS       - pidns fd, argument is file descriptor

Syscall returns pid in target pid-ns or zero if task have no pid there.

Error codes:
-EINVAL   - @source or @target couldn't be resolved into pid namespace
-ESRCH    - task with @pid is not found in @source pid-namespace

Other pid namespaces are referenced either by pid of any process who
lives inside it or by file descriptor pointing to /proc/[pid]/ns/pid.
Latter method provides better protection against races but in some
cases requires CAP_SYS_PTRACE.

Translate_pid could breach pid isolation and return pids from outer pid
namespaces iff process already has file descriptor pointing to them.


Examples:

- get pid in current pid namespace

translate_pid(pid, TRANSLATE_PID_FD_PIDNS, ns_fd,
                   TRANSLATE_PID_CURRENT_PIDNS, 0)
or
translate_pid(pid, TRANSLATE_PID_TASK_PIDNS, ns_pid,
                   TRANSLATE_PID_CURRENT_PIDNS, 0)

- get pid in other pid namespace

translate_pid(pid, TRANSLATE_PID_CURRENT_PIDNS, 0,
                   TRANSLATE_PID_FD_PIDNS, ns_fd)
or
translate_pid(pid, TRANSLATE_PID_CURRENT_PIDNS, 0,
                   TRANSLATE_PID_TASK_PIDNS, ns_pid)

- get deepest pid

translate_pid(pid, TRANSLATE_PID_CURRENT_PIDNS, 0,
                   TRANSLATE_PID_TASK_PIDNS, pid)

- get pid of init task for namespace

translate_pid(1, TRANSLATE_PID_FD_PIDNS, ns_fd,
                 TRANSLATE_PID_CURRENT_PIDNS, 0)


This syscall also could be used for checking topology of pid namespaces:

- ns1 nests inside ns2

translate_pid(1, TRANSLATE_PID_FD_PIDNS, ns1_fd,
                 TRANSLATE_PID_FD_PIDNS, ns2_fd) > 1

- task1 lives in same pid-namespace as task2

translate_pid(1, TRANSLATE_PID_TASK_PIDNS, task1_pid,
                 TRANSLATE_PID_TASK_PIDNS, task2_pid) == 1

- task1 is isolated from task2

translate_pid(task1_pid, TRANSLATE_PID_CURRENT_PIDNS, 0,
                         TRANSLATE_PID_TASK_PIDNS, task2_pid) == 0

- pid is reachable from ns

translate_pid(pid, TRANSLATE_PID_CURRENT_PIDNS, 0,
                   TRANSLATE_PID_FD_PIDNS, ns_fd) > 0

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

---

v1: https://lkml.org/lkml/2015/9/15/411
v2: https://lkml.org/lkml/2015/9/24/278
 * use namespace-fd as second/third argument
 * add -pid for getting parent pid
 * move code into kernel/sys.c next to getppid
 * drop ifdef CONFIG_PID_NS
 * add generic syscall
v3: https://lkml.org/lkml/2015/9/28/3
 * use proc_ns_fdget()
 * update description
 * rebase to next-20150925
 * fix conflict with mlock2
v4: https://lkml.org/lkml/2017/10/16/852
 * rename into translate_pid()
 * remove syscall if CONFIG_PID_NS=n
 * drop -pid for parent task
 * drop fget-fdget optimizations
 * add helper get_pid_ns_by_fd()
 * wire only into x86
v5:
 * rewrite commit message
 * resolve pidns by task pid or by pidns fd
 * add arguments source_type and target_type

--- sample tool translate_pid.c ---

#define _GNU_SOURCE
#include <sys/syscall.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sched.h>
#include <fcntl.h>
#include <err.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

#ifndef SYS_translate_pid
#ifdef __x86_64__
#define SYS_translate_pid 333
#endif
#endif

#ifndef TRANSLATE_PID_CURRENT_PIDNS
#define TRANSLATE_PID_CURRENT_PIDNS	0
#define TRANSLATE_PID_TASK_PIDNS	1
#define TRANSLATE_PID_FD_PIDNS		2
#endif

pid_t translate_pid(pid_t pid, int source_type, int source,
			       int target_type, int target) {
	return syscall(SYS_translate_pid, pid, source_type, source,
					       target_type, target);
}

int main(int argc, char **argv) {
	int pid, source, target;
	char buf[64];

	if (argc != 4)
		errx(1, "usage: %s <pid> <source> <traget>", argv[0]);

	pid = atoi(argv[1]);
	int source_type, target_type;
	source = atoi(argv[2]);
	target = atoi(argv[3]);

	if (source < 0) {
		source_type = TRANSLATE_PID_TASK_PIDNS;
		source = -source;
	} else if (source > 0) {
		source_type = TRANSLATE_PID_FD_PIDNS;
		sprintf(buf, "/proc/%d/ns/pid", source);
		source = open(buf, O_RDONLY);
		if (source < 0)
			err(2, "open source %s", buf);
	} else {
		source_type = TRANSLATE_PID_CURRENT_PIDNS;
	}

	if (target < 0) {
		target_type = TRANSLATE_PID_TASK_PIDNS;
		target = -target;
	} else if (target > 0) {
		target_type = TRANSLATE_PID_FD_PIDNS;
		sprintf(buf, "/proc/%d/ns/pid", target);
		target = open(buf, O_RDONLY);
		if (target < 0)
			err(2, "open target %s", buf);
	} else {
		target_type = TRANSLATE_PID_CURRENT_PIDNS;
	}

	pid = translate_pid(pid, source_type, source, target_type, target);
	if (pid < 0)
		err(2, "translate");

	printf("%d\n", pid);
	return 0;
}

---
---
 arch/x86/entry/syscalls/syscall_32.tbl |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl |    1 +
 include/linux/syscalls.h               |    4 ++
 include/uapi/linux/sched.h             |    7 ++++
 kernel/pid_namespace.c                 |   64 ++++++++++++++++++++++++++++++++
 kernel/sys_ni.c                        |    3 ++
 6 files changed, 80 insertions(+)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index c58f75b088c5..aef52c709845 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -391,3 +391,4 @@
 382	i386	pkey_free		sys_pkey_free
 383	i386	statx			sys_statx
 384	i386	arch_prctl		sys_arch_prctl			compat_sys_arch_prctl
+385	i386	translate_pid		sys_translate_pid
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 5aef183e2f85..1ebdab83c6f4 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -339,6 +339,7 @@
 330	common	pkey_alloc		sys_pkey_alloc
 331	common	pkey_free		sys_pkey_free
 332	common	statx			sys_statx
+333	common	translate_pid		sys_translate_pid
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index b961184f597a..d189a1f61160 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -553,6 +553,10 @@ asmlinkage long sys_clock_nanosleep(clockid_t which_clock, int flags,
 /* kernel/printk.c */
 asmlinkage long sys_syslog(int type, char __user *buf, int len);
 
+/* kernel/pid_namespace.c */
+asmlinkage long sys_translate_pid(pid_t pid, int source_type, int source,
+				  int target_type, int target);
+
 /* kernel/ptrace.c */
 asmlinkage long sys_ptrace(long request, long pid, unsigned long addr,
 			   unsigned long data);
diff --git a/include/uapi/linux/sched.h b/include/uapi/linux/sched.h
index 22627f80063e..7c45fd8d33d7 100644
--- a/include/uapi/linux/sched.h
+++ b/include/uapi/linux/sched.h
@@ -55,4 +55,11 @@
 			 SCHED_FLAG_RECLAIM		| \
 			 SCHED_FLAG_DL_OVERRUN)
 
+/*
+ * For translate_pid()
+ */
+#define TRANSLATE_PID_CURRENT_PIDNS	0	/* Current pid namespace */
+#define TRANSLATE_PID_TASK_PIDNS	1	/* Namespace by task pid */
+#define TRANSLATE_PID_FD_PIDNS		2	/* Namespace by pidns fd */
+
 #endif /* _UAPI_LINUX_SCHED_H */
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 2a2ac53d8b8b..84c8b47289d5 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -13,6 +13,7 @@
 #include <linux/user_namespace.h>
 #include <linux/syscalls.h>
 #include <linux/cred.h>
+#include <linux/file.h>
 #include <linux/err.h>
 #include <linux/acct.h>
 #include <linux/slab.h>
@@ -380,6 +381,69 @@ static void pidns_put(struct ns_common *ns)
 	put_pid_ns(to_pid_ns(ns));
 }
 
+/* Under rcu_read_lock(). Returns pointer to pid_namespace or NULL. */
+static struct pid_namespace *resolve_pid_ns(int type, int fd_or_pid)
+{
+	struct pid_namespace *current_ns = task_active_pid_ns(current);
+	struct pid_namespace *pidns = NULL;
+	struct ns_common *ns;
+	struct file *file;
+
+	switch (type) {
+	case TRANSLATE_PID_CURRENT_PIDNS:
+		pidns = current_ns;
+		break;
+	case TRANSLATE_PID_TASK_PIDNS:
+		pidns = ns_of_pid(find_pid_ns(fd_or_pid, current_ns));
+		break;
+	case TRANSLATE_PID_FD_PIDNS:
+		file = proc_ns_fget(fd_or_pid);
+		if (!IS_ERR(file)) {
+			ns = get_proc_ns(file_inode(file));
+			if (ns->ops->type == CLONE_NEWPID)
+				pidns = to_pid_ns(ns);
+			fput(file);
+		}
+		break;
+	}
+
+	return pidns;
+}
+
+/*
+ * translate_pid - convert pid in source pid-ns into target pid-ns.
+ * @pid:    pid for translation
+ * @source_type: one of TRANSLATE_PID_*
+ * @source: depending on @source_type pid-ns fd, pid, or nothing
+ * @target_type: one of TRANSLATE_PID_*
+ * @target: depending on @target_type pid-ns fd, pid, or nothing
+ *
+ * Returns pid in @target pid-ns, zero if task have no pid there,
+ * or -ESRCH if task with @pid does not found in @source pid-ns,
+ * or -EINVAL if @source or @target couldn't be resolved into pid-ns.
+ */
+SYSCALL_DEFINE5(translate_pid, pid_t, pid,
+		int, source_type, int, source,
+		int, target_type, int, target)
+{
+	struct pid_namespace *source_ns, *target_ns;
+	struct pid *struct_pid;
+	pid_t result = -EINVAL;
+
+	rcu_read_lock();
+	source_ns = resolve_pid_ns(source_type, source);
+	if (!source_ns)
+		goto out;
+	target_ns = resolve_pid_ns(target_type, target);
+	if (!target_ns)
+		goto out;
+	struct_pid = find_pid_ns(pid, source_ns);
+	result = struct_pid ? pid_nr_ns(struct_pid, target_ns) : -ESRCH;
+out:
+	rcu_read_unlock();
+	return result;
+}
+
 static int pidns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 {
 	struct pid_namespace *active = task_active_pid_ns(current);
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 6cafc008f6db..777689bce406 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -146,6 +146,9 @@ COND_SYSCALL(delete_module);
 /* kernel/printk.c */
 COND_SYSCALL(syslog);
 
+/* kernel/pid_namespace.c */
+COND_SYSCALL(sys_translate_pid);
+
 /* kernel/ptrace.c */
 
 /* kernel/sched/core.c */

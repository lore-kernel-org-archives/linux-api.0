From: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
Subject: [PATCH RFC v3 2/2] pidns: introduce syscall getvpid
Date: Fri, 25 Sep 2015 16:52:47 +0300
Message-ID: <20150925135247.27620.37109.stgit@buzz>
References: <20150925135246.27620.97496.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20150925135246.27620.97496.stgit@buzz>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Roman Gushchin <klamm-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Chen Fan <chen.fan.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

pid_t getvpid(pid_t pid, int source, int target);

This syscall converts pid from source pid-namespace into pid visible
in target pid-namespace. If pid is unreachable from target namespace
then getvpid() returns zero.

Namespaces are defined by file descriptors pointing to entries in
proc (/proc/[pid]/ns/pid). If argument is negative then current pid
namespace is used.

If pid is negative then getvpid() returns pid of parent task for -pid.

Possible error codes:
ESRCH    - task not found
EBADF    - closed file descriptor
EINVAL   - not pid-namespace file descriptor

Such conversion is required for interaction between processes from
different pid-namespaces. For example system service at host system
who provide access to restricted set of privileged operations for
clients from containers have to convert pids back and forward.

Recent kernels expose virtual pids in /proc/[pid]/status:NSpid, but
this interface works only in one way and even that is non-trivial.

Other option is passing pids with credentials via unix socket, but
this solution requires a lot of preparation and CAP_SYS_ADMIN for
sending arbitrary pids.

This syscall works in both directions, it's fast and simple.

Examples:
getvpid(pid, ns, -1)      - get pid in our pid namespace
getvpid(pid, -1, ns)      - get pid in container
getvpid(pid, -1, ns) > 0  - is pid is reachable from container?
getvpid(1, ns1, ns2) > 0  - is ns1 inside ns2?
getvpid(1, ns1, ns2) == 0 - is ns1 outside ns2?
getvpid(1, ns, -1)        - get init task of pid-namespace
getvpid(-1, ns, -1)       - get reaper of init task in parent pid-namespace
getvpid(-pid, -1, -1)     - get ppid by pid

Signed-off-by: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>

--

v1: https://lkml.org/lkml/2015/9/15/411
v2: https://lkml.org/lkml/2015/9/24/278
v3:
 * use proc_ns_fdget()
 * update description
 * rebase to next-20150925
 * fix conflict with mlock2
---
 arch/x86/entry/syscalls/syscall_32.tbl |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl |    1 +
 include/linux/syscalls.h               |    1 +
 include/uapi/asm-generic/unistd.h      |    4 ++-
 kernel/sys.c                           |   51 ++++++++++++++++++++++++++++++++
 5 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 143ef9f37932..c36c2c65d204 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -383,3 +383,4 @@
 374	i386	userfaultfd		sys_userfaultfd
 375	i386	membarrier		sys_membarrier
 376	i386	mlock2			sys_mlock2
+377	i386	getvpid			sys_getvpid
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 314a90bfc09c..90bbbc7fdbe0 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -332,6 +332,7 @@
 323	common	userfaultfd		sys_userfaultfd
 324	common	membarrier		sys_membarrier
 325	common	mlock2			sys_mlock2
+326	common	getvpid			sys_getvpid
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a156b82dd14c..dbb5638260b5 100644
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
index 1324b0292ec2..2c1123130f90 100644
--- a/include/uapi/asm-generic/unistd.h
+++ b/include/uapi/asm-generic/unistd.h
@@ -715,9 +715,11 @@ __SYSCALL(__NR_userfaultfd, sys_userfaultfd)
 __SYSCALL(__NR_membarrier, sys_membarrier)
 #define __NR_mlock2 284
 __SYSCALL(__NR_mlock2, sys_mlock2)
+#define __NR_mlock2 285
+__SYSCALL(__NR_getvpid, sys_getvpid)
 
 #undef __NR_syscalls
-#define __NR_syscalls 285
+#define __NR_syscalls 286
 
 /*
  * All syscalls below here should go away really,
diff --git a/kernel/sys.c b/kernel/sys.c
index fa2f2f671a5c..1e28a36b84fa 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -46,6 +46,7 @@
 #include <linux/syscalls.h>
 #include <linux/kprobes.h>
 #include <linux/user_namespace.h>
+#include <linux/proc_ns.h>
 #include <linux/binfmts.h>
 
 #include <linux/sched.h>
@@ -855,6 +856,56 @@ SYSCALL_DEFINE0(getppid)
 	return pid;
 }
 
+SYSCALL_DEFINE3(getvpid, pid_t, pid, int, source, int, target)
+{
+	struct pid_namespace *source_ns, *target_ns;
+	struct fd source_fd = {}, target_fd = {};
+	struct pid *struct_pid;
+	struct ns_common *ns;
+	pid_t result;
+
+	if (source >= 0) {
+		ns = proc_ns_fdget(source, CLONE_NEWPID, &source_fd);
+		result = PTR_ERR(ns);
+		if (IS_ERR(ns))
+			goto out;
+		source_ns = container_of(ns, struct pid_namespace, ns);
+	} else
+		source_ns = task_active_pid_ns(current);
+
+	if (target >= 0) {
+		ns = proc_ns_fdget(target, CLONE_NEWPID, &target_fd);
+		result = PTR_ERR(ns);
+		if (IS_ERR(ns))
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
+	fdput(target_fd);
+	fdput(source_fd);
+	return result;
+}
+
 SYSCALL_DEFINE0(getuid)
 {
 	/* Only we change this so SMP safe */

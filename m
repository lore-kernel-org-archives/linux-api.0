From: Christian Brauner <christian@brauner.io>
Subject: [PATCH 2/4] pid: add pidctl()
Date: Mon, 25 Mar 2019 17:20:50 +0100
Message-ID: <20190325162052.28987-3-christian@brauner.io>
References: <20190325162052.28987-1-christian@brauner.io>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190325162052.28987-1-christian@brauner.io>
Sender: linux-kernel-owner@vger.kernel.org
To: jannh@google.com, khlebnikov@yandex-team.ru, luto@kernel.org, dhowells@redhat.com, serge@hallyn.com, ebiederm@xmission.com, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, keescook@chromium.org, adobriyan@gmail.com, tglx@linutronix.de, mtk.manpages@gmail.com, bl0pbl33p@gmail.com, ldv@altlinux.org, akpm@linux-foundation.org, oleg@redhat.com, nagarathnam.muthusamy@oracle.com, cyphar@cyphar.com, viro@zeniv.linux.org.uk, joel@joelfernandes.org, dancol@google.com, Christian Brauner <christian@brauner.io>
List-Id: linux-api@vger.kernel.org

The pidctl() syscalls builds on, extends, and improves translate_pid() [4].
I quote Konstantins original patchset first that has already been acked and
picked up by Eric before and whose functionality is preserved in this
syscall:

"Each process have different pids, one for each pid namespace it belongs.
 When interaction happens within single pid-ns translation isn't required.
 More complicated scenarios needs special handling.

 For example:
 - reading pid-files or logs written inside container with pid namespace
 - writing logs with internal pids outside container for pushing them into
 - attaching with ptrace to tasks from different pid namespace

 Generally speaking, any cross pid-ns API with pids needs translation.

 Currently there are several interfaces that could be used here:

 Pid namespaces are identified by device and inode of /proc/[pid]/ns/pid.

 Pids for nested pid namespaces are shown in file /proc/[pid]/status.
 In some cases pid translation could be easily done using this information.
 Backward translation requires scanning all tasks and becomes really
 complicated for deeper namespace nesting.

 Unix socket automatically translates pid attached to SCM_CREDENTIALS.
 This requires CAP_SYS_ADMIN for sending arbitrary pids and entering
 into pid namespace, this expose process and could be insecure."

The original patchset allowed two distinct operations implicitly:
- discovering whether pid namespaces (pidns) have a parent-child
  relationship
- translating a pid from a source pidns into a target pidns

Both tasks are accomplished in the original patchset by passing a pid
along. If the pid argument is passed as 1 the relationship between two pid
namespaces can be discovered.
The syscall will gain a lot clearer syntax and will be easier to use for
userspace if the task it is asked to perform is passed through a
command argument. Additionally, it allows us to remove an intrinsic race
caused by using the pid argument as a way to discover the relationship
between pid namespaces.
This patch introduces three commands:

/* PIDCMD_QUERY_PID */
PIDCMD_QUERY_PID allows to translate a pid between pid namespaces.
Given a source pid namespace fd return the pid of the process in the target
namespace:
1. pidctl(PIDCMD_QUERY_PID, pid, source_fd, -1, 0)
  - retrieve pidns identified by source_fd
  - retrieve struct pid identifed by pid in pidns identified by source_fd
  - retrieve callers pidns
  - return pid in callers pidns

2. pidctl(PIDCMD_QUERY_PID, pid, -1, target_fd, 0)
  - retrieve callers pidns
  - retrieve struct pid identifed by pid in callers pidns
  - retrieve pidns identified by target_fd
  - return pid in pidns identified by target_fd

3. pidctl(PIDCMD_QUERY_PID, 1, source_fd, -1, 0)
  - retrieve pidns identified by source_fd
  - retrieve struct pid identifed by init task in pidns identified by source_fd
  - retrieve callers pidns
  - return pid of init task of pidns identified by source_fd in callers pidns

4. pidctl(PIDCMD_QUERY_PID, pid, source_fd, target_fd, 0)
  - retrieve pidns identified by source_fd
  - retrieve struct pid identifed by pid in pidns identified by source_fd
  - retrieve pidns identified by target_fd
  - check whether struct pid can be found in pidns identified by target_fd
  - return pid in pidns identified by target_fd

/* PIDCMD_QUERY_PIDNS */
PIDCMD_QUERY_PIDNS allows to determine the relationship between pid
namespaces.
In the original version of the pachset passing pid as 1 would allow to
deterimine the relationship between the pid namespaces. This is inherhently
racy. If pid 1 inside a pid namespace has died it would report false
negatives. For example, if pid 1 inside of the target pid namespace already
died, it would report that the target pid namespace cannot be reached from
the source pid namespace because it couldn't find the pid inside of the
target pid namespace and thus falsely report to the user that the two pid
namespaces are not related. This problem is simple to avoid. In the new
version we simply walk the list of ancestors and check whether the
namespace are related to each other. By doing it this way we can reliably
report what the relationship between two pid namespace file descriptors
looks like.

1. pidctl(PIDCMD_QUERY_PIDNS, 0, ns_fd1, ns_fd1, 0) == 0
   - pidns_of(ns_fd1) and pidns_of(ns_fd2) are unrelated to each other

2. pidctl(PIDCMD_QUERY_PIDNS, 0, ns_fd1, ns_fd2, 0) == 1
   - pidns_of(ns_fd1) == pidns_of(ns_fd2)

3. pidctl(PIDCMD_QUERY_PIDNS, 0, ns_fd1, ns_fd2, 0) == 2
   - pidns_of(ns_fd1) is ancestor of pidns_of(ns_fd2)

4. pidctl(PIDCMD_QUERY_PIDNS, 0, ns_fd1, ns_fd2, 0) == 3
   - pidns_of(ns_fd2) is ancestor of pidns_of(ns_fd1)

These two commands - PIDCMD_QUERY_PID and PIDCMD_QUERY_PIDNS - cover and
improve the functionality expressed implicitly in translate_pid() before.

/* PIDCMD_GET_PIDFD */
This command allows to retrieve file descriptors for processes and removes
the dependency of pidfds and thereby the pidfd_send_signal() syscall on
procfs. First, multiple people have expressed a desire to do this even when
pidfd_send_signal() was merged. It is even recorded in the commit message
for pidfd_send_signal() itself
(cf. commit 3eb39f47934f9d5a3027fe00d906a45fe3a15fad):
Q-06: (Andrew Morton)
      Is there a cleaner way of obtaining the fd? Another syscall perhaps.
A-06: Userspace can already trivially retrieve file descriptors from procfs
      so this is something that we will need to support anyway. Hence,
      there's no immediate need to add another syscalls just to make
      pidfd_send_signal() not dependent on the presence of procfs. However,
      adding a syscalls to get such file descriptors is planned for a
      future patchset).
Alexey made a similar request (cf. [2]).
Additionally, Andy made an additional, idependent argument that we should
go forward with non-proc-dirfd file descriptors for the sake of security
and extensibility (cf. [3]).

The pidfds are not associated with a specific pid namespaces but rather
only with struct pid. What the pidctl() syscall enforces is that when a
caller wants to retrieve a pidfd file descriptor for a pid in a given
target pid namespace the caller needs to proof it has access to a pid
namespace in which the pid he wants a pidfd for a) exists and b) that this
pid namespace is an ancestor of the target pid namespace, i.e. that the pid
can be translated into the target pid namespaces.

1. pidctl(PIDCMD_GET_PIDFD, pid, source_fd, -1, PIDCTL_CLOEXEC)
  - retrieve pidns identified by source_fd
  - retrieve struct pid identifed by pid in pidns identified by source_fd
  - retrieve callers pidns
  - return pidfd

2. pidctl(PIDCMD_GET_PIDFD, pid, -1, target_fd, PIDCTL_CLOEXEC)
  - retrieve callers pidns
  - retrieve struct pid identifed by pid in callers pidns
  - retrieve pidns identified by target_fd
  - return pidfd

3. pidctl(PIDCMD_GET_PIDFD, 1, source_fd, -1, PIDCTL_CLOEXEC)
  - retrieve pidns identified by source_fd
  - retrieve struct pid identifed by init task in pidns identified by
    source_fd
  - retrieve callers pidns
  - return pidfd

4. pidctl(PIDCMD_GET_PIDFD, pid, source_fd, target_fd, PIDCTL_CLOEXEC)
  - retrieve pidns identified by source_fd
  - retrieve struct pid identifed by pid in pidns identified by source_fd
  - retrieve pidns identified by target_fd
  - check whether struct pid can be found in pidns identified by target_fd
  - return pidfd

These pidfds are allocated using anon_inode_getfd() and can be used with
the pidfd_send_signal() syscall. They are not dirfds and as such have the
advantage that we can make them pollable or readable in the future if we
see a need to do so (which I'm pretty sure we will eventually). Currently
they do not support any advanced operations.

/* References */
[1]: https://lore.kernel.org/lkml/20181228233725.722tdfgijxcssg76@brauner.io/
[2]: https://lore.kernel.org/lkml/20190320203910.GA2842@avx2/
[3]: https://lore.kernel.org/lkml/CALCETrXO=V=+qEdLDVPf8eCgLZiB9bOTrUfe0V-U-tUZoeoRDA@mail.gmail.com/
[4]: https://lore.kernel.org/lkml/20181109034919.GA21681@altlinux.org/

Signed-off-by: Christian Brauner <christian@brauner.io>
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by: Serge Hallyn <serge@hallyn.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jann Horn <jannh@google.com
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Jonathan Kowalski <bl0pbl33p@gmail.com>
Cc: "Dmitry V. Levin" <ldv@altlinux.org>
Cc: Andy Lutomirsky <luto@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>
Cc: Aleksa Sarai <cyphar@cyphar.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/x86/entry/syscalls/syscall_32.tbl |   1 +
 arch/x86/entry/syscalls/syscall_64.tbl |   1 +
 include/linux/pid.h                    |   2 +
 include/linux/pid_namespace.h          |   8 ++
 include/linux/syscalls.h               |   2 +
 include/uapi/linux/wait.h              |  17 +++
 kernel/pid.c                           | 162 +++++++++++++++++++++++++
 kernel/pid_namespace.c                 |  25 ++++
 8 files changed, 218 insertions(+)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 1f9607ed087c..afc5a8997140 100644
--- a/arch/x86/entry/syscalls/syscall_32.tbl
+++ b/arch/x86/entry/syscalls/syscall_32.tbl
@@ -433,3 +433,4 @@
 425	i386	io_uring_setup		sys_io_uring_setup		__ia32_sys_io_uring_setup
 426	i386	io_uring_enter		sys_io_uring_enter		__ia32_sys_io_uring_enter
 427	i386	io_uring_register	sys_io_uring_register		__ia32_sys_io_uring_register
+428	i386	pidctl			sys_pidctl			__ia32_sys_pidctl
diff --git a/arch/x86/entry/syscalls/syscall_64.tbl b/arch/x86/entry/syscalls/syscall_64.tbl
index 92ee0b4378d4..8ef25d9a003d 100644
--- a/arch/x86/entry/syscalls/syscall_64.tbl
+++ b/arch/x86/entry/syscalls/syscall_64.tbl
@@ -349,6 +349,7 @@
 425	common	io_uring_setup		__x64_sys_io_uring_setup
 426	common	io_uring_enter		__x64_sys_io_uring_enter
 427	common	io_uring_register	__x64_sys_io_uring_register
+428	common	pidctl			__x64_sys_pidctl
 
 #
 # x32-specific system call numbers start at 512 to avoid cache impact
diff --git a/include/linux/pid.h b/include/linux/pid.h
index b6f4ba16065a..3c8ef5a199ca 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -66,6 +66,8 @@ struct pid
 
 extern struct pid init_struct_pid;
 
+extern const struct file_operations pidfd_fops;
+
 static inline struct pid *get_pid(struct pid *pid)
 {
 	if (pid)
diff --git a/include/linux/pid_namespace.h b/include/linux/pid_namespace.h
index 49538b172483..c5aae8151287 100644
--- a/include/linux/pid_namespace.h
+++ b/include/linux/pid_namespace.h
@@ -64,6 +64,8 @@ extern struct pid_namespace *copy_pid_ns(unsigned long flags,
 extern void zap_pid_ns_processes(struct pid_namespace *pid_ns);
 extern int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd);
 extern void put_pid_ns(struct pid_namespace *ns);
+extern int pidnscmp(struct pid_namespace *ancestor,
+		    struct pid_namespace *descendant);
 
 #else /* !CONFIG_PID_NS */
 #include <linux/err.h>
@@ -94,6 +96,12 @@ static inline int reboot_pid_ns(struct pid_namespace *pid_ns, int cmd)
 {
 	return 0;
 }
+
+static inline int pidnscmp(struct pid_namespace *ancestor,
+			   struct pid_namespace *descendant)
+{
+	return 0;
+}
 #endif /* CONFIG_PID_NS */
 
 extern struct pid_namespace *task_active_pid_ns(struct task_struct *tsk);
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index e446806a561f..a4c8c59f7c8f 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -929,6 +929,8 @@ asmlinkage long sys_clock_adjtime32(clockid_t which_clock,
 				struct old_timex32 __user *tx);
 asmlinkage long sys_syncfs(int fd);
 asmlinkage long sys_setns(int fd, int nstype);
+asmlinkage long sys_pidctl(unsigned int cmd, pid_t pid, int source, int target,
+			   unsigned int flags);
 asmlinkage long sys_sendmmsg(int fd, struct mmsghdr __user *msg,
 			     unsigned int vlen, unsigned flags);
 asmlinkage long sys_process_vm_readv(pid_t pid,
diff --git a/include/uapi/linux/wait.h b/include/uapi/linux/wait.h
index ac49a220cf2a..4f3dfb528b20 100644
--- a/include/uapi/linux/wait.h
+++ b/include/uapi/linux/wait.h
@@ -18,5 +18,22 @@
 #define P_PID		1
 #define P_PGID		2
 
+/* Commands to pass to pidctl() */
+enum pidcmd {
+	PIDCMD_QUERY_PID   = 0, /* Get pid in target pid namespace */
+	PIDCMD_QUERY_PIDNS = 1, /* Determine relationship between pid namespaces */
+	PIDCMD_GET_PIDFD   = 2, /* Get pidfd for a process */
+};
+
+/* Return values of PIDCMD_QUERY_PIDNS */
+enum pidcmd_query_pidns {
+	PIDNS_UNRELATED          = 0, /* The pid namespaces are unrelated */
+	PIDNS_EQUAL              = 1, /* The pid namespaces are equal */
+	PIDNS_SOURCE_IS_ANCESTOR = 2, /* Source pid namespace is ancestor of target pid namespace */
+	PIDNS_TARGET_IS_ANCESTOR = 3, /* Target pid namespace is ancestor of source pid namespace */
+};
+
+/* Flags to pass to pidctl() */
+#define PIDCTL_CLOEXEC 1
 
 #endif /* _UAPI_LINUX_WAIT_H */
diff --git a/kernel/pid.c b/kernel/pid.c
index 20881598bdfa..b3702bd38bdd 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -26,6 +26,7 @@
  *
  */
 
+#include <linux/anon_inodes.h>
 #include <linux/mm.h>
 #include <linux/export.h>
 #include <linux/slab.h>
@@ -40,6 +41,7 @@
 #include <linux/proc_fs.h>
 #include <linux/sched/task.h>
 #include <linux/idr.h>
+#include <linux/wait.h>
 
 struct pid init_struct_pid = {
 	.count 		= ATOMIC_INIT(1),
@@ -451,6 +453,166 @@ struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
 	return idr_get_next(&ns->idr, &nr);
 }
 
+static int pidfd_release(struct inode *inode, struct file *file)
+{
+	struct pid *pid = file->private_data;
+
+	if (pid) {
+		file->private_data = NULL;
+		put_pid(pid);
+	}
+
+	return 0;
+}
+
+const struct file_operations pidfd_fops = {
+	.release = pidfd_release,
+	.llseek	 = no_llseek,
+};
+
+static int pidfd_create_fd(struct pid *pid, unsigned int o_flags)
+{
+	int fd;
+
+	fd = anon_inode_getfd("pidfd", &pidfd_fops, get_pid(pid),
+			      O_RDWR | o_flags);
+	if (fd < 0)
+		put_pid(pid);
+
+	return fd;
+}
+
+static struct pid_namespace *get_pid_ns_by_fd(int fd)
+{
+	struct pid_namespace *pidns = ERR_PTR(-EINVAL);
+
+	if (fd >= 0) {
+#ifdef CONFIG_PID_NS
+		struct ns_common *ns;
+		struct file *file = proc_ns_fget(fd);
+		if (IS_ERR(file))
+			return ERR_CAST(file);
+
+		ns = get_proc_ns(file_inode(file));
+		if (ns->ops->type == CLONE_NEWPID)
+			pidns = get_pid_ns(
+				container_of(ns, struct pid_namespace, ns));
+
+		fput(file);
+#endif
+	} else {
+		pidns = task_active_pid_ns(current);
+	}
+
+	return pidns;
+}
+
+static int pidns_related(struct pid_namespace *source,
+			 struct pid_namespace *target)
+{
+	int query;
+
+	query = pidnscmp(source, target);
+	switch (query) {
+	case 0:
+		return PIDNS_EQUAL;
+	case 1:
+		return PIDNS_SOURCE_IS_ANCESTOR;
+	}
+
+	query = pidnscmp(target, source);
+	if (query == 1)
+		return PIDNS_TARGET_IS_ANCESTOR;
+
+	return PIDNS_UNRELATED;
+}
+
+/*
+ * pidctl - perform operations on pids
+ * @cmd:    command to execute
+ * @pid:    pid for translation
+ * @source: pid-ns file descriptor or -1 for active namespace
+ * @target: pid-ns file descriptor or -1 for active namesapce
+ * @flags:  flags to pass
+ *
+ * If cmd is PIDCMD_QUERY_PID translates pid between pid namespaces
+ * identified by @source and @target. Returns pid if process has pid in
+ * @target, 0 if process has no pid in @target, -ESRCH if process does
+ * not have a pid in @source.
+ *
+ * If cmd is PIDCMD_QUERY_PIDNS determines the relations between two pid
+ * namespaces. Returns 2 if @source is an ancestor pid namespace
+ * of @target, 1 if @source and @target refer to the same pid namespace,
+ * 3 if @target is an ancestor pid namespace of @source, 0 if they have
+ * no parent-child relationship in either direction.
+ *
+ * If cmd is PIDCMD_GET_PIDFD returns pidfd for process in @target pid
+ * namespace. Returns pidfd if process has pid in @target, -ESRCH if
+ * process does not have a pid in @source, -ENOENT if process does not have a
+ * pid in @target pid namespace.
+ *
+ */
+SYSCALL_DEFINE5(pidctl, unsigned int, cmd, pid_t, pid, int, source, int, target,
+		unsigned int, flags)
+{
+	struct pid_namespace *source_ns = NULL, *target_ns = NULL;
+	struct pid *struct_pid;
+	pid_t result;
+
+	switch (cmd) {
+	case PIDCMD_QUERY_PIDNS:
+		if (pid != 0)
+			return -EINVAL;
+		pid = 1;
+		/* fall through */
+	case PIDCMD_QUERY_PID:
+		if (flags != 0)
+			return -EINVAL;
+		break;
+	case PIDCMD_GET_PIDFD:
+		if (flags & ~PIDCTL_CLOEXEC)
+			return -EINVAL;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	source_ns = get_pid_ns_by_fd(source);
+	result = PTR_ERR(source_ns);
+	if (IS_ERR(source_ns))
+		goto err_source;
+
+	target_ns = get_pid_ns_by_fd(target);
+	result = PTR_ERR(target_ns);
+	if (IS_ERR(target_ns))
+		goto err_target;
+
+	if (cmd == PIDCMD_QUERY_PIDNS) {
+		result = pidns_related(source_ns, target_ns);
+	} else {
+		rcu_read_lock();
+		struct_pid = find_pid_ns(pid, source_ns);
+		result = struct_pid ? pid_nr_ns(struct_pid, target_ns) : -ESRCH;
+		rcu_read_unlock();
+
+		if (cmd == PIDCMD_GET_PIDFD) {
+			int cloexec = (flags & PIDCTL_CLOEXEC) ? O_CLOEXEC : 0;
+			if (result > 0)
+				result = pidfd_create_fd(struct_pid, cloexec);
+			else if (result == 0)
+				result = -ENOENT;
+		}
+	}
+
+	if (target)
+		put_pid_ns(target_ns);
+err_target:
+	if (source)
+		put_pid_ns(source_ns);
+err_source:
+	return result;
+}
+
 void __init pid_idr_init(void)
 {
 	/* Verify no one has done anything silly: */
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index aa6e72fb7c08..1c863fb3d55a 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -429,6 +429,31 @@ static struct ns_common *pidns_get_parent(struct ns_common *ns)
 	return &get_pid_ns(pid_ns)->ns;
 }
 
+/**
+ * pidnscmp - Determine if @ancestor is ancestor of @descendant
+ * @ancestor:   pidns suspected to be the ancestor of @descendant
+ * @descendant: pidns suspected to be the descendant of @ancestor
+ *
+ * Returns -1 if @ancestor is not an ancestor of @descendant,
+ * 0 if @ancestor is the same pidns as @descendant, 1 if @ancestor
+ * is an ancestor of @descendant.
+ */
+int pidnscmp(struct pid_namespace *ancestor, struct pid_namespace *descendant)
+{
+	if (ancestor == descendant)
+		return 0;
+
+	for (;;) {
+		if (!descendant)
+			return -1;
+		if (descendant == ancestor)
+			break;
+		descendant = descendant->parent;
+	}
+
+	return 1;
+}
+
 static struct user_namespace *pidns_owner(struct ns_common *ns)
 {
 	return to_pid_ns(ns)->user_ns;
-- 
2.21.0

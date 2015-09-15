From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC] pidns: introduce syscall getvpid
Date: Tue, 15 Sep 2015 15:09:24 +0300
Message-ID: <20150915120924.14818.49490.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, "Eric W. Biederman" <ebiederm@xmission.com>
List-Id: linux-api@vger.kernel.org

pid_t getvpid(pid_t pid, pid_t source, pid_t target);

This syscall converts pid from one pid-ns into pid in another pid-ns:
it takes @pid in namespace of @source task (zero for current) and
returns related pid in namespace of @target task (zero for current too).
If pid is unreachable from target pid-ns then it returns zero.

Such conversion is required for interaction between processes from
different pid-namespaces. For example when system service talks with
client from isolated container via socket about task in container:

getvpid(pid, client_pid, 0)  -> pid in our pid namespace
getvpid(pid, 0, client_pid)  -> pid in client pid namespace

Also service can get pid of init task and match it with container:

getvpid(1, client_pid, 0)    -> pid of init task for client_pid

Seems like gdb and strace could use this too for converting pids of
newly forked tasks (IIRR they get pid from %rax) into pid from
correct namespace for further interaction.

As a bonus syscall getvpid can compare pid namespaces and
test isolation without mounted procfs:

getvpid(1, 0, pid) == 0      -> pid in our sub-pid-namespace
getvpid(1, 0, pid) == 1      -> pid in our pid-namespace
getvpid(1, pid1, pid2) == 0  -> pid1 isolated from pid2
getvpid(1, pid1, pid2) == 1  -> tasks are in one pid-namespace
getvpid(1, pid1, pid2) > 1   -> pid1 is in sub-pidns of pid2

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 arch/x86/entry/syscalls/syscall_32.tbl |    1 +
 arch/x86/entry/syscalls/syscall_64.tbl |    1 +
 include/linux/syscalls.h               |    1 +
 kernel/pid.c                           |   36 ++++++++++++++++++++++++++++++++
 4 files changed, 39 insertions(+)

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
index a460e2ef2843..3405c30999e3 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -222,6 +222,7 @@ asmlinkage long sys_nanosleep(struct timespec __user *rqtp, struct timespec __us
 asmlinkage long sys_alarm(unsigned int seconds);
 asmlinkage long sys_getpid(void);
 asmlinkage long sys_getppid(void);
+asmlinkage long sys_getvpid(pid_t pid, pid_t source, pid_t target);
 asmlinkage long sys_getuid(void);
 asmlinkage long sys_geteuid(void);
 asmlinkage long sys_getgid(void);
diff --git a/kernel/pid.c b/kernel/pid.c
index ca368793808e..caa676ff7364 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -567,6 +567,42 @@ struct pid *find_ge_pid(int nr, struct pid_namespace *ns)
 	return pid;
 }
 
+/**
+ * sys_getvpid - convert pid from one pid-namespace into pid from another
+ *
+ * @pid    - pid of requested task
+ * @source - pid of task in source pid-namespace, zero for current
+ * @target - pid of task in target pid-namespace, zero for current
+ *
+ * Returns pid from target pid-ns or zero if pid is unreachable.
+ * Returns -ESRCH if some of pids are not found.
+ */
+SYSCALL_DEFINE3(getvpid, pid_t, pid, pid_t, source, pid_t, target)
+{
+#ifdef CONFIG_PID_NS
+	struct pid_namespace *current_ns = task_active_pid_ns(current);
+	struct pid_namespace *source_ns = current_ns, *target_ns = current_ns;
+	struct pid *task_pid;
+	pid_t result = -ESRCH;
+
+	rcu_read_lock();
+	if (source)
+		source_ns = ns_of_pid(find_pid_ns(source, current_ns));
+	if (target)
+		target_ns = ns_of_pid(find_pid_ns(target, current_ns));
+	if (source_ns && target_ns) {
+		task_pid = find_pid_ns(pid, source_ns);
+		if (task_pid)
+			result = pid_nr_ns(task_pid, target_ns);
+	}
+	rcu_read_unlock();
+
+	return result;
+#else
+	return pid;
+#endif /* CONFIG_PID_NS */
+}
+
 /*
  * The pid hash table is scaled according to the amount of memory in the
  * machine.  From a minimum of 16 slots up to 4096 slots at one gigabyte or

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH v4] pidns: introduce syscall translate_pid
Date: Fri, 13 Oct 2017 12:26:24 +0300
Message-ID: <150788678482.924140.11785205105514746135.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Serge Hallyn <serge.hallyn@ubuntu.com>, Nagarathnam Muthusamy <nagarathnam.muthusamy@oracle.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>
List-Id: linux-api@vger.kernel.org

pid_t translate_pid(pid_t pid, int source, int target);

This syscall converts pid from source pid-ns into pid in target pid-ns.
If pid is unreachable from target pid-ns it returns zero.

Pid-namespaces are referred file descriptors opened to proc files
/proc/[pid]/ns/pid or /proc/[pid]/ns/pid_for_children. Negative argument
refers to current pid namespace, same as file /proc/self/ns/pid.

Kernel expose virtual pids in /proc/[pid]/status:NSpid, but backward
translation requires scanning all tasks. Also pids could be translated
by sending them through unix socket between namespaces, this method is
slow and insecure because other side is exposed inside pid namespace.

Examples:
translate_pid(pid, ns, -1)      - get pid in our pid namespace
translate_pid(pid, -1, ns)      - get pid in other pid namespace
translate_pid(1, ns, -1)        - get pid of init task for namespace
translate_pid(pid, -1, ns) > 0  - is pid is reachable from ns?
translate_pid(1, ns1, ns2) > 0  - is ns1 inside ns2?
translate_pid(1, ns1, ns2) == 0 - is ns1 outside ns2?
translate_pid(1, ns1, ns2) == 1 - is ns1 equal ns2?

Error codes:
EBADF    - file descriptor is closed
EINVAL   - file descriptor isn't pid-namespace
ESRCH    - task not found in @source namespace

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
v4:
 * rename into translate_pid()
 * remove syscall if CONFIG_PID_NS=n
 * drop -pid for parent task
 * drop fget-fdget optimizations
 * add helper get_pid_ns_by_fd()
 * wire only into x86
---
 arch/x86/entry/syscalls/syscall_32.tbl |    1 
 arch/x86/entry/syscalls/syscall_64.tbl |    1 
 include/linux/syscalls.h               |    1 
 kernel/pid_namespace.c                 |   66 ++++++++++++++++++++++++++++++++
 kernel/sys_ni.c                        |    3 +
 5 files changed, 72 insertions(+)

diff --git a/arch/x86/entry/syscalls/syscall_32.tbl b/arch/x86/entry/syscalls/syscall_32.tbl
index 448ac2161112..257d839b3a91 100644
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
index a78186d826d7..6467ebc847c5 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -901,6 +901,7 @@ asmlinkage long sys_open_by_handle_at(int mountdirfd,
 				      struct file_handle __user *handle,
 				      int flags);
 asmlinkage long sys_setns(int fd, int nstype);
+asmlinkage long sys_translate_pid(pid_t pid, int source, int target);
 asmlinkage long sys_process_vm_readv(pid_t pid,
 				     const struct iovec __user *lvec,
 				     unsigned long liovcnt,
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 4918314893bc..062f35eedd41 100644
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
@@ -406,6 +407,71 @@ static void pidns_put(struct ns_common *ns)
 	put_pid_ns(to_pid_ns(ns));
 }
 
+static struct pid_namespace *get_pid_ns_by_fd(int fd)
+{
+	struct pid_namespace *pidns;
+	struct ns_common *ns;
+	struct file *file;
+
+	file = proc_ns_fget(fd);
+	if (IS_ERR(file))
+		return ERR_CAST(file);
+
+	ns = get_proc_ns(file_inode(file));
+	if (ns->ops->type == CLONE_NEWPID)
+		pidns = get_pid_ns(to_pid_ns(ns));
+	else
+		pidns = ERR_PTR(-EINVAL);
+
+	fput(file);
+	return pidns;
+}
+
+/*
+ * translate_pid - convert pid in source pid-ns into target pid-ns.
+ * @pid:    pid for translation
+ * @source: pid-ns file descriptor or -1 for active namespace
+ * @target: pid-ns file descriptor or -1 for active namesapce
+ *
+ * Returns pid in @target pid-ns, zero if task have no pid there,
+ * or -ESRCH if task with @pid does not found in @source pid-ns.
+ */
+SYSCALL_DEFINE3(translate_pid, pid_t, pid, int, source, int, target)
+{
+	struct pid_namespace *source_ns, *target_ns;
+	struct pid *struct_pid;
+	pid_t result;
+
+	if (source >= 0) {
+		source_ns = get_pid_ns_by_fd(source);
+		result = PTR_ERR(source_ns);
+		if (IS_ERR(source_ns))
+			goto err_source;
+	} else
+		source_ns = task_active_pid_ns(current);
+
+	if (target >= 0) {
+		target_ns = get_pid_ns_by_fd(target);
+		result = PTR_ERR(target_ns);
+		if (IS_ERR(target_ns))
+			goto err_target;
+	} else
+		target_ns = task_active_pid_ns(current);
+
+	rcu_read_lock();
+	struct_pid = find_pid_ns(pid, source_ns);
+	result = struct_pid ? pid_nr_ns(struct_pid, target_ns) : -ESRCH;
+	rcu_read_unlock();
+
+	if (target >= 0)
+		put_pid_ns(target_ns);
+err_target:
+	if (source >= 0)
+		put_pid_ns(source_ns);
+err_source:
+	return result;
+}
+
 static int pidns_install(struct nsproxy *nsproxy, struct ns_common *ns)
 {
 	struct pid_namespace *active = task_active_pid_ns(current);
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 8acef8576ce9..1ca2a4c1eb1d 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -258,3 +258,6 @@ cond_syscall(sys_membarrier);
 cond_syscall(sys_pkey_mprotect);
 cond_syscall(sys_pkey_alloc);
 cond_syscall(sys_pkey_free);
+
+/* pid namespace */
+cond_syscall(sys_translate_pid);

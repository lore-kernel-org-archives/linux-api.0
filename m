From: Djalal Harouni <tixxdz@gmail.com>
Subject: [PATCH v3 2/2] modules:capabilities: add a per-task modules autoload restriction
Date: Thu, 20 Apr 2017 00:20:20 +0200
Message-ID: <1492640420-27345-3-git-send-email-tixxdz@gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, serge@hallyn.com, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org
Cc: Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Ingo Molnar <mingo@kernel.org>, zendyani@gmail.com, Peter Zijlstra <peterz@infradead.org>, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

Previous patches added the global "modules_autoload" restriction. This patch
make it possible to support process trees, containers, and sandboxes by
providing an inherited per-task "modules_autoload" flag that cannot be
re-enabled once disabled. This allows to restrict automatic module
loading without affecting the rest of the system.

Any task can set its "modules_autoload". Once set, this setting is inherited
across fork, clone and execve. With "modules_autoload" set, automatic
module loading will have first to satisfy the per-task access permissions
before attempting to implicitly load the module. For example, automatic
loading of modules that contain bugs or vulnerabilities can be
restricted and untrusted users can no longer abuse such interfaces

To set modules_autoload, use prctl(PR_SET_MODULES_AUTOLOAD, value, 0, 0, 0).

When value is (0), the default, automatic modules loading is allowed.

When value is (1), task must have CAP_SYS_MODULE to be able to trigger a
module auto-load operation, or CAP_NET_ADMIN for modules with a
'netdev-%s' alias.

When value is (2), automatic modules loading is disabled for the current
task.

The 'modules_autoload' value may only be increased, never decreased, thus
ensuring that once applied, processes can never relax their setting.

When a request to a kernel module is denied, the module name with the
corresponding process name and its pid are logged. Administrators can use
such information to explicitly load the appropriate modules.

The per-task "modules_autoload" restriction:

Before:
$ lsmod | grep ipip -
$ sudo ip tunnel add mytun mode ipip remote 10.0.2.100 local 10.0.2.15 ttl 255
$ lsmod | grep ipip -
ipip                   16384  0
tunnel4                16384  1 ipip
ip_tunnel              28672  1 ipip

After:
$ lsmod | grep ipip -
$ ./pr_modules_autoload
$ grep "Modules" /proc/self/status
ModulesAutoload:        2
$ cat /proc/sys/kernel/modules_autoload
0
$ sudo ip tunnel add mytun mode ipip remote 10.0.2.100 local 10.0.2.15 ttl 255
add tunnel "tunl0" failed: No such device
$ lsmod | grep ipip
$ dmesg | tail -3
[   16.363903] virbr0: port 1(virbr0-nic) entered disabled state
[  823.565958] Automatic module loading of netdev-tunl0 by "ip"[1362] was denied
[  823.565967] Automatic module loading of tunl0 by "ip"[1362] was denied

Cc: Serge Hallyn <serge@hallyn.com>
Cc: Andy Lutomirski <luto@kernel.org>
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 Documentation/filesystems/proc.txt       |  3 ++
 Documentation/prctl/modules_autoload.txt | 49 +++++++++++++++++++++++++++++++
 fs/proc/array.c                          |  6 ++++
 include/linux/module.h                   | 48 ++++++++++++++++++++++++++++--
 include/linux/sched.h                    |  5 ++++
 include/linux/security.h                 |  2 +-
 include/uapi/linux/prctl.h               |  8 +++++
 kernel/fork.c                            |  4 +++
 kernel/module.c                          | 17 +++++++----
 security/commoncap.c                     | 50 ++++++++++++++++++++++++++++----
 10 files changed, 178 insertions(+), 14 deletions(-)
 create mode 100644 Documentation/prctl/modules_autoload.txt

diff --git a/Documentation/filesystems/proc.txt b/Documentation/filesystems/proc.txt
index 4cddbce..df4d145 100644
--- a/Documentation/filesystems/proc.txt
+++ b/Documentation/filesystems/proc.txt
@@ -194,6 +194,7 @@ read the file /proc/PID/status:
   CapBnd: ffffffffffffffff
   NoNewPrivs:     0
   Seccomp:        0
+  ModulesAutoload:      0
   voluntary_ctxt_switches:        0
   nonvoluntary_ctxt_switches:     1
 
@@ -267,6 +268,8 @@ Table 1-2: Contents of the status files (as of 4.8)
  CapBnd                      bitmap of capabilities bounding set
  NoNewPrivs                  no_new_privs, like prctl(PR_GET_NO_NEW_PRIV, ...)
  Seccomp                     seccomp mode, like prctl(PR_GET_SECCOMP, ...)
+ ModulesAutoload             modules autoload, like
+                             prctl(PR_GET_MODULES_AUTOLOAD, ...)
  Cpus_allowed                mask of CPUs on which this process may run
  Cpus_allowed_list           Same as previous, but in "list format"
  Mems_allowed                mask of memory nodes allowed to this process
diff --git a/Documentation/prctl/modules_autoload.txt b/Documentation/prctl/modules_autoload.txt
new file mode 100644
index 0000000..242852e
--- /dev/null
+++ b/Documentation/prctl/modules_autoload.txt
@@ -0,0 +1,49 @@
+A request to a kernel feature that is implemented by a module that is
+not loaded may trigger the module auto-load feature, allowing to
+transparently satisfy userspace. In this case an implicit kernel module
+load operation happens.
+
+Usually to load or unload a kernel module, an explicit operation happens
+where programs are required to have some capabilities in order to perform
+such operations. However, with the implicit module loading, no
+capabilities are required, anyone who is able to request a certain kernel
+feature, may also implicitly load its corresponding kernel module. This
+operation can be abused by unprivileged users to expose kernel interfaces
+that maybe privileged users did not want to be made available for various
+reasons: resources, bugs, vulnerabilties, etc. The DCCP vulnerability is
+(CVE-2017-6074) is one real example.
+
+The new per-task "modules_autoload" flag, is a new way to restrict
+automatic module loading, preventing the kernel from exposing more of
+its interface. This particularly useful for containers and sandboxes
+where sandboxed processes should affect the rest of the system.
+
+Any task can set "modules_autoload". Once set, this setting is inherited
+across fork, clone and execve. With "modules_autoload" set, automatic
+module loading will have first to satisfy the per-task access permissions
+before attempting to implicitly load the module. For example, automatic
+loading of modules that contain bugs or vulnerabilities can be
+restricted and imprivileged users can no longer abuse such interfaces.
+
+To set modules_autoload, use prctl(PR_SET_MODULES_AUTOLOAD, value, 0, 0, 0).
+
+When value is (0), the default, automatic modules loading is allowed.
+
+When value is (1), task must have CAP_SYS_MODULE to be able to trigger a
+module auto-load operation, or CAP_NET_ADMIN for modules with a
+'netdev-%s' alias.
+
+When value is (2), automatic modules loading is disabled for the current
+task.
+
+The 'modules_autoload' value may only be increased, never decreased, thus
+ensuring that once applied, processes can never relax their setting.
+
+When a request to a kernel module is denied, the module name with the
+corresponding process name and its pid are logged. Administrators can use
+such information to explicitly load the appropriate modules.
+
+Please note that even if the per-task "modules_autoload" value allows to
+auto-load the corresponding module, automatic module loading may still
+fail due to the global "modules_autoload" sysctl. For more details please
+see "modules_autoload" in Documentation/sysctl/kernel.txt
diff --git a/fs/proc/array.c b/fs/proc/array.c
index 88c3555..cbcf087 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -88,6 +88,7 @@
 #include <linux/string_helpers.h>
 #include <linux/user_namespace.h>
 #include <linux/fs_struct.h>
+#include <linux/module.h>
 
 #include <asm/pgtable.h>
 #include <asm/processor.h>
@@ -346,10 +347,15 @@ static inline void task_cap(struct seq_file *m, struct task_struct *p)
 
 static inline void task_seccomp(struct seq_file *m, struct task_struct *p)
 {
+	int autoload = task_modules_autoload(p);
+
 	seq_put_decimal_ull(m, "NoNewPrivs:\t", task_no_new_privs(p));
 #ifdef CONFIG_SECCOMP
 	seq_put_decimal_ull(m, "\nSeccomp:\t", p->seccomp.mode);
 #endif
+	if (autoload != -ENOSYS)
+		seq_put_decimal_ull(m, "\nModulesAutoload:\t", autoload);
+
 	seq_putc(m, '\n');
 }
 
diff --git a/include/linux/module.h b/include/linux/module.h
index 4b96c10..595800f 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -13,6 +13,7 @@
 #include <linux/kmod.h>
 #include <linux/init.h>
 #include <linux/elf.h>
+#include <linux/sched.h>
 #include <linux/stringify.h>
 #include <linux/kobject.h>
 #include <linux/moduleparam.h>
@@ -506,7 +507,33 @@ bool __is_module_percpu_address(unsigned long addr, unsigned long *can_addr);
 bool is_module_percpu_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);
 
-int modules_autoload_access(char *kmod_name);
+int modules_autoload_access(struct task_struct *task, char *kmod_name);
+
+/* Sets task's modules_autoload */
+static inline int task_set_modules_autoload(struct task_struct *task,
+					    unsigned long value)
+{
+	if (value > MODULES_AUTOLOAD_DISABLED)
+		return -EINVAL;
+	else if (task->modules_autoload > value)
+		return -EPERM;
+	else if (task->modules_autoload < value)
+		task->modules_autoload = value;
+
+	return 0;
+}
+
+/* Returns task's modules_autoload */
+static inline void task_copy_modules_autoload(struct task_struct *dest,
+					      struct task_struct *src)
+{
+	dest->modules_autoload = src->modules_autoload;
+}
+
+static inline int task_modules_autoload(struct task_struct *task)
+{
+	return task->modules_autoload;
+}
 
 static inline bool within_module_core(unsigned long addr,
 				      const struct module *mod)
@@ -652,11 +679,28 @@ static inline bool is_livepatch_module(struct module *mod)
 
 #else /* !CONFIG_MODULES... */
 
-static inline int modules_autoload_access(char *kmod_name)
+static inline int modules_autoload_access(struct task_struct *task,
+					  char *kmod_name)
 {
 	return 0;
 }
 
+static inline int task_set_modules_autoload(struct task_struct *task,
+					    unsigned long value)
+{
+	return -ENOSYS;
+}
+
+static inline void task_copy_modules_autoload(struct task_struct *dest,
+					      struct task_struct *src)
+{
+}
+
+static inline int task_modules_autoload(struct task_struct *task)
+{
+	return -ENOSYS;
+}
+
 static inline struct module *__module_address(unsigned long addr)
 {
 	return NULL;
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 48fb8bc..7264e62 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -613,6 +613,11 @@ struct task_struct {
 
 	struct restart_block		restart_block;
 
+#ifdef CONFIG_MODULES
+	/* per-task modules autoload access */
+	unsigned			modules_autoload:2;
+#endif
+
 	pid_t				pid;
 	pid_t				tgid;
 
diff --git a/include/linux/security.h b/include/linux/security.h
index e274bb11..9581cc5 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -866,7 +866,7 @@ static inline int security_task_create(unsigned long clone_flags)
 static inline int security_task_alloc(struct task_struct *task,
 				      unsigned long clone_flags)
 {
-	return 0;
+	return cap_task_alloc(task, clone_flags);
 }
 
 static inline void security_task_free(struct task_struct *task)
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index a8d0759..0244264 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -197,4 +197,12 @@ struct prctl_mm_map {
 # define PR_CAP_AMBIENT_LOWER		3
 # define PR_CAP_AMBIENT_CLEAR_ALL	4
 
+/*
+ * Control the per-task "modules_autoload" access.
+ *
+ * See Documentation/prctl/modules_autoload.txt for more details.
+ */
+#define PR_SET_MODULES_AUTOLOAD		48
+#define PR_GET_MODULES_AUTOLOAD		49
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/fork.c b/kernel/fork.c
index 81347bd..141e06b 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1695,6 +1695,10 @@ static __latent_entropy struct task_struct *copy_process(
 	p->sequential_io_avg	= 0;
 #endif
 
+#ifdef CONFIG_MODULES
+	p->modules_autoload	= 0;
+#endif
+
 	/* Perform scheduler related setup. Assign this task to a CPU. */
 	retval = sched_fork(clone_flags, p);
 	if (retval)
diff --git a/kernel/module.c b/kernel/module.c
index 54cb6e0..e1eca74 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -4313,19 +4313,24 @@ static int modules_autoload_privileged_access(const char *name)
 }
 
 /**
- * modules_autoload_access - Determine whether a module auto-load is permitted
+ * modules_autoload_access - Determine whether the task is allowed to perform a
+ *			     module auto-load request
+ * @task: The task performing the request
  * @kmod_name: The module name
  *
- * Determine whether a module should be automatically loaded or not. The check
- * uses the sysctl "modules_autoload" value.
+ * Determine whether the task is allowed to perform a module auto-load request.
+ * This checks the per-task "modules_autoload" flag, if the access is not denied,
+ * then the global sysctl "modules_autoload" is evaluated.
  *
  * Returns 0 if the module request is allowed or -EPERM if not.
  */
-int modules_autoload_access(char *kmod_name)
+int modules_autoload_access(struct task_struct *task, char *kmod_name)
 {
-	if (modules_autoload == MODULES_AUTOLOAD_ALLOWED)
+	unsigned int autoload = max_t(unsigned int,
+				      modules_autoload, task->modules_autoload);
+	if (autoload == MODULES_AUTOLOAD_ALLOWED)
 		return 0;
-	else if (modules_autoload == MODULES_AUTOLOAD_PRIVILEGED)
+	else if (autoload == MODULES_AUTOLOAD_PRIVILEGED)
 		return modules_autoload_privileged_access(kmod_name);
 
 	/* MODULES_AUTOLOAD_DISABLED */
diff --git a/security/commoncap.c b/security/commoncap.c
index 67a6cfe..bcc1e09 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -886,6 +886,40 @@ static int cap_prctl_drop(unsigned long cap)
 	return commit_creds(new);
 }
 
+static int pr_set_mod_autoload(unsigned long arg2, unsigned long arg3,
+			       unsigned long arg4, unsigned long arg5)
+{
+	if (arg3 || arg4 || arg5)
+		return -EINVAL;
+
+	return task_set_modules_autoload(current, arg2);
+}
+
+static inline int pr_get_mod_autoload(unsigned long arg2, unsigned long arg3,
+				      unsigned long arg4, unsigned long arg5)
+{
+	if (arg2 || arg3 || arg4 || arg5)
+		return -EINVAL;
+
+	return task_modules_autoload(current);
+}
+
+/**
+ * cap_task_alloc - Implement process context allocation for this security module
+ * @task: task being allocated
+ * @clone_flags: contains the clone flags indicating what should be shared.
+ *
+ * Allocate or initialize the task context for this security module.
+ *
+ * Returns 0.
+ */
+int cap_task_alloc(struct task_struct *task, unsigned long clone_flags)
+{
+	task_copy_modules_autoload(task, current);
+
+	return 0;
+}
+
 /**
  * cap_task_prctl - Implement process control functions for this security module
  * @option: The process control function requested
@@ -1015,6 +1049,11 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 				cap_lower(new->cap_ambient, arg3);
 			return commit_creds(new);
 		}
+	case PR_SET_MODULES_AUTOLOAD:
+		return pr_set_mod_autoload(arg2, arg3, arg4, arg5);
+
+	case PR_GET_MODULES_AUTOLOAD:
+		return pr_get_mod_autoload(arg2, arg3, arg4, arg5);
 
 	default:
 		/* No functionality available - continue with default */
@@ -1070,19 +1109,19 @@ int cap_mmap_file(struct file *file, unsigned long reqprot,
 }
 
 /**
- * cap_kernel_module_request - Determine whether a module auto-load is permitted
+ * cap_kernel_module_request - Determine whether current task is allowed to
+ *			       automatically load the specified module.
  * @kmod_name: The module name
  *
- * Determine whether a module should be automatically loaded due to a request
- * by the current task. Returns 0 if the module request should be allowed
- * -EPERM if not.
+ * Determine whether current task is allowed to automatically load the module.
+ * Returns 0 if current task is allowed to auto-load the module, -EPERM if not.
  */
 int cap_kernel_module_request(char *kmod_name)
 {
 	int ret;
 	char comm[sizeof(current->comm)];
 
-	ret = modules_autoload_access(kmod_name);
+	ret = modules_autoload_access(current, kmod_name);
 	if (ret < 0)
 		pr_notice_ratelimited(
 			"Automatic module loading of %.64s by \"%s\"[%d] was denied\n",
@@ -1106,6 +1145,7 @@ struct security_hook_list capability_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(inode_killpriv, cap_inode_killpriv),
 	LSM_HOOK_INIT(mmap_addr, cap_mmap_addr),
 	LSM_HOOK_INIT(mmap_file, cap_mmap_file),
+	LSM_HOOK_INIT(task_alloc, cap_task_alloc),
 	LSM_HOOK_INIT(task_fix_setuid, cap_task_fix_setuid),
 	LSM_HOOK_INIT(task_prctl, cap_task_prctl),
 	LSM_HOOK_INIT(task_setscheduler, cap_task_setscheduler),
-- 
2.10.2

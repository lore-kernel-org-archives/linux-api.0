From: Djalal Harouni <tixxdz@gmail.com>
Subject: [PATCH v3 1/2] modules:capabilities: automatic module loading restriction
Date: Thu, 20 Apr 2017 00:20:19 +0200
Message-ID: <1492640420-27345-2-git-send-email-tixxdz@gmail.com>
References: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
Return-path: <kernel-hardening-return-7433-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1492640420-27345-1-git-send-email-tixxdz@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, serge@hallyn.com, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org
Cc: Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, Casey Schaufler <casey@schaufler-ca.com>, James Morris <james.l.morris@oracle.com>, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Arnaldo Carvalho de Melo <acme@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Ingo Molnar <mingo@kernel.org>, zendyani@gmail.com, Peter Zijlstra <peterz@infradead.org>, Djalal Harouni <tixxdz@gmail.com>
List-Id: linux-api@vger.kernel.org

Currently, an explicit call to load or unload kernel modules require
CAP_SYS_MODULE capability. However unprivileged users have always been
able to load some modules using the implicit auto-load operation. An
automatic module loading happens when programs request a kernel feature
from a module that is not loaded. In order to satisfy userspace, the
kernel then automatically load all these required modules.

However, some programs may abuse the interface to load vulnerable or
buggy modules where system administrators still did not have a chance to
blacklist these modules. This affects the global state of the machine,
especially with containers where some applications may use it to exploit
the vulnerable parts and escape the container sandbox. Not to mention
that some devices which one may call IoT also started to use containers
semantics as a deployment workflow, but as an isolation tool too where the
base system image can be any generic distro or other root filesystem with
its own kernel. These setups may include unnecessary modules that the
final applications will not need. Untrusted access may abuse the module
auto-load feature to expose those vulnerabilities.

As every code contains bugs or vulnerabilties, the following
vulnerabilities that affected some features that are often compiled as
modules could have been completely blocked, by restricting autoloading
modules if the system does not need them.

Past months:
* DCCP use after free CVE-2017-6074
* n_hldc CVE-2017-2636
* XFRM framework CVE-2017-7184
* L2TPv3 CVE-2016-10200

This patch introduces "modules_autoload" kernel sysctl flag. The flag
controls modules auto-load feature and complements "modules_disabled" which
apply to all modules operations. This new flag allows to control only
automatic module loading and if it is allowed or not. This allows to
align implicit module loading with the explicit one where both now are
covered by capabilities checks.

The "modules_autoload" sysctl was inspired from grsecurity
'GRKERNSEC_MODHARDEN'.

/proc/sys/kernel/modules_autoload takes three values:

*) When set to (0), the default, there are no restrictions.

*) When set to (1), processes must have CAP_SYS_MODULE to be able to
trigger a module auto-load operation, or CAP_NET_ADMIN for modules with
a 'netdev-%s' alias. Maybe in future more capabilities will allow to
load the specific related modules.

*) When set to (2), automatic module loading is disabled for all. Once
set, this value can not be changed.

The patch adds cap_kernel_module_request() as a
security_kernel_module_request() hook in the capabilities subsystem
to enforce the permission checks. Each request_module() call, the
"modules_autoload" value is checked to allow or deny automatic module
loading.

Before:
$ lsmod | grep ipip -
$ sudo ip tunnel add mytun mode ipip remote 10.0.2.100 local 10.0.2.15 ttl 255
$ lsmod | grep ipip -
ipip                   16384  0
tunnel4                16384  1 ipip
ip_tunnel              28672  1 ipip

After:
$ lsmod | grep ipip -
$ sudo ip tunnel add mytun mode ipip remote 10.0.2.100 local 10.0.2.15 ttl 255
add tunnel "tunl0" failed: No such device
$ dmesg | tail -3
[  158.832544] ipip: IPv4 and MPLS over IPv4 tunneling driver
[  416.040569] Automatic module loading of netdev-tunl0 by "ip"[1398] was denied
[  416.040578] Automatic module loading of tunl0 by "ip"[1398] was denied
$ cat /proc/sys/kernel/modules_autoload
2

Cc: Serge Hallyn <serge@hallyn.com>
Cc: Andy Lutomirski <luto@kernel.org>
Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
---
 Documentation/sysctl/kernel.txt | 23 +++++++++++++++++++++++
 include/linux/module.h          | 18 +++++++++++++++++-
 include/linux/security.h        |  3 ++-
 kernel/module.c                 | 36 ++++++++++++++++++++++++++++++++++++
 kernel/sysctl.c                 | 40 ++++++++++++++++++++++++++++++++++++++++
 security/commoncap.c            | 23 +++++++++++++++++++++++
 6 files changed, 141 insertions(+), 2 deletions(-)

diff --git a/Documentation/sysctl/kernel.txt b/Documentation/sysctl/kernel.txt
index bac23c1..318ba30 100644
--- a/Documentation/sysctl/kernel.txt
+++ b/Documentation/sysctl/kernel.txt
@@ -43,6 +43,7 @@ show up in /proc/sys/kernel:
 - l2cr                        [ PPC only ]
 - modprobe                    ==> Documentation/debugging-modules.txt
 - modules_disabled
+- modules_autoload
 - msg_next_id		      [ sysv ipc ]
 - msgmax
 - msgmnb
@@ -411,6 +412,28 @@ to false.  Generally used with the "kexec_load_disabled" toggle.
 
 ==============================================================
 
+modules_autoload:
+
+A sysctl to control if modules auto-load feature is allowed or not.
+This sysctl complements "modules_disabled" which is for all module
+operations where this flag applies only to automatic module loading.
+Automatic module loading happens when programs request a kernel feature
+that is implemented by an unloaded module, the kernel automatically
+runs the program pointed by "modprobe" sysctl in order to load the
+corresponding module.
+
+When modules_autoload is set to (0), the default, there are no
+restrictions.
+
+When modules_autoload is set to (1), processes must have CAP_SYS_MODULE
+to be able to trigger a module auto-load operation, or CAP_NET_ADMIN
+for modules with a 'netdev-%s' alias.
+
+When modules_autoload is set to (2), automatic module loading is
+disabled for all. Once set, this value can not be changed.
+
+==============================================================
+
 msg_next_id, sem_next_id, and shm_next_id:
 
 These three toggles allows to specify desired id for next allocated IPC
diff --git a/include/linux/module.h b/include/linux/module.h
index 9ad6856..4b96c10 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -261,7 +261,16 @@ struct notifier_block;
 
 #ifdef CONFIG_MODULES
 
-extern int modules_disabled; /* for sysctl */
+enum {
+	MODULES_AUTOLOAD_ALLOWED	= 0,
+	MODULES_AUTOLOAD_PRIVILEGED	= 1,
+	MODULES_AUTOLOAD_DISABLED	= 2,
+};
+
+extern int modules_disabled; /* sysctl for explicit module load/unload */
+extern int modules_autoload; /* sysctl for automatic module loading */
+extern const int modules_autoload_max; /* sysctl max value for modules_autoload */
+
 /* Get/put a kernel symbol (calls must be symmetric) */
 void *__symbol_get(const char *symbol);
 void *__symbol_get_gpl(const char *symbol);
@@ -497,6 +506,8 @@ bool __is_module_percpu_address(unsigned long addr, unsigned long *can_addr);
 bool is_module_percpu_address(unsigned long addr);
 bool is_module_text_address(unsigned long addr);
 
+int modules_autoload_access(char *kmod_name);
+
 static inline bool within_module_core(unsigned long addr,
 				      const struct module *mod)
 {
@@ -641,6 +652,11 @@ static inline bool is_livepatch_module(struct module *mod)
 
 #else /* !CONFIG_MODULES... */
 
+static inline int modules_autoload_access(char *kmod_name)
+{
+	return 0;
+}
+
 static inline struct module *__module_address(unsigned long addr)
 {
 	return NULL;
diff --git a/include/linux/security.h b/include/linux/security.h
index af675b5..e274bb11 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -96,6 +96,7 @@ extern int cap_task_setscheduler(struct task_struct *p);
 extern int cap_task_setioprio(struct task_struct *p, int ioprio);
 extern int cap_task_setnice(struct task_struct *p, int nice);
 extern int cap_vm_enough_memory(struct mm_struct *mm, long pages);
+extern int cap_kernel_module_request(char *kmod_name);
 
 struct msghdr;
 struct sk_buff;
@@ -904,7 +905,7 @@ static inline int security_kernel_create_files_as(struct cred *cred,
 
 static inline int security_kernel_module_request(char *kmod_name)
 {
-	return 0;
+	return cap_kernel_module_request(kmod_name);
 }
 
 static inline int security_kernel_read_file(struct file *file,
diff --git a/kernel/module.c b/kernel/module.c
index f953df9..54cb6e0 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -282,6 +282,8 @@ module_param(sig_enforce, bool_enable_only, 0644);
 
 /* Block module loading/unloading? */
 int modules_disabled = 0;
+int modules_autoload = MODULES_AUTOLOAD_ALLOWED;
+const int modules_autoload_max = MODULES_AUTOLOAD_DISABLED;
 core_param(nomodule, modules_disabled, bint, 0);
 
 /* Waiting for a module to finish initializing? */
@@ -4296,6 +4298,40 @@ struct module *__module_text_address(unsigned long addr)
 }
 EXPORT_SYMBOL_GPL(__module_text_address);
 
+/*
+ * Return 0 if CAP_SYS_MODULE or if CAP_NET_ADMIN and the module is
+ * with a 'netdev-%s' alias. Otherwise -EPERM is returned.
+ */
+static int modules_autoload_privileged_access(const char *name)
+{
+	if (capable(CAP_SYS_MODULE))
+		return 0;
+	else if (name && strstr(name, "netdev-") && capable(CAP_NET_ADMIN))
+		return 0;
+
+	return -EPERM;
+}
+
+/**
+ * modules_autoload_access - Determine whether a module auto-load is permitted
+ * @kmod_name: The module name
+ *
+ * Determine whether a module should be automatically loaded or not. The check
+ * uses the sysctl "modules_autoload" value.
+ *
+ * Returns 0 if the module request is allowed or -EPERM if not.
+ */
+int modules_autoload_access(char *kmod_name)
+{
+	if (modules_autoload == MODULES_AUTOLOAD_ALLOWED)
+		return 0;
+	else if (modules_autoload == MODULES_AUTOLOAD_PRIVILEGED)
+		return modules_autoload_privileged_access(kmod_name);
+
+	/* MODULES_AUTOLOAD_DISABLED */
+	return -EPERM;
+}
+
 /* Don't grab lock, we're oopsing. */
 void print_modules(void)
 {
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 3359739..a3f6dfd 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -186,6 +186,11 @@ static int proc_taint(struct ctl_table *table, int write,
 			       void __user *buffer, size_t *lenp, loff_t *ppos);
 #endif
 
+#ifdef CONFIG_MODULES
+static int modules_autoload_dointvec_minmax(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos);
+#endif
+
 #ifdef CONFIG_PRINTK
 static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
 				void __user *buffer, size_t *lenp, loff_t *ppos);
@@ -661,6 +666,16 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &one,
 		.extra2		= &one,
 	},
+	{
+		.procname	= "modules_autoload",
+		.data		= &modules_autoload,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		/* Handle pinning to max value */
+		.proc_handler	= modules_autoload_dointvec_minmax,
+		.extra1		= &zero,
+		.extra2		= (void *)&modules_autoload_max,
+	},
 #endif
 #ifdef CONFIG_UEVENT_HELPER
 	{
@@ -2332,6 +2347,31 @@ static int proc_dointvec_minmax_sysadmin(struct ctl_table *table, int write,
 }
 #endif
 
+#ifdef CONFIG_MODULES
+static int modules_autoload_dointvec_minmax(struct ctl_table *table, int write,
+				void __user *buffer, size_t *lenp, loff_t *ppos)
+{
+	struct ctl_table t;
+
+	/*
+	 * Only CAP_SYS_MODULE in init user namespace are allowed to change this
+	 */
+	if (write && !capable(CAP_SYS_MODULE))
+		return -EPERM;
+
+	t = *table;
+	/*
+	 * If "modules_autoload" already equals max value
+	 * MODULES_AUTOLOAD_DISABLED which means it is disabled,
+	 * then its value can not be changed anymore.
+	 */
+	if (modules_autoload == modules_autoload_max)
+		t.extra1 = t.extra2;
+
+	return proc_dointvec_minmax(&t, write, buffer, lenp, ppos);
+}
+#endif
+
 struct do_proc_dointvec_minmax_conv_param {
 	int *min;
 	int *max;
diff --git a/security/commoncap.c b/security/commoncap.c
index 7abebd7..67a6cfe 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -1069,6 +1069,28 @@ int cap_mmap_file(struct file *file, unsigned long reqprot,
 	return 0;
 }
 
+/**
+ * cap_kernel_module_request - Determine whether a module auto-load is permitted
+ * @kmod_name: The module name
+ *
+ * Determine whether a module should be automatically loaded due to a request
+ * by the current task. Returns 0 if the module request should be allowed
+ * -EPERM if not.
+ */
+int cap_kernel_module_request(char *kmod_name)
+{
+	int ret;
+	char comm[sizeof(current->comm)];
+
+	ret = modules_autoload_access(kmod_name);
+	if (ret < 0)
+		pr_notice_ratelimited(
+			"Automatic module loading of %.64s by \"%s\"[%d] was denied\n",
+			kmod_name, get_task_comm(comm, current), current->pid);
+
+	return ret;
+}
+
 #ifdef CONFIG_SECURITY
 
 struct security_hook_list capability_hooks[] __lsm_ro_after_init = {
@@ -1090,6 +1112,7 @@ struct security_hook_list capability_hooks[] __lsm_ro_after_init = {
 	LSM_HOOK_INIT(task_setioprio, cap_task_setioprio),
 	LSM_HOOK_INIT(task_setnice, cap_task_setnice),
 	LSM_HOOK_INIT(vm_enough_memory, cap_vm_enough_memory),
+	LSM_HOOK_INIT(kernel_module_request, cap_kernel_module_request),
 };
 
 void __init capability_add_hooks(void)
-- 
2.10.2

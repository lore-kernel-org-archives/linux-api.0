From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH RFC v2 2/3] security: add the ModAutoRestrict Linux
 Security Module
Date: Mon, 10 Apr 2017 08:42:07 -0700
Message-ID: <b483ccc8-406c-a620-9f7a-fdcbbc3fdb26@schaufler-ca.com>
References: <1491734530-25002-1-git-send-email-tixxdz@gmail.com>
 <1491734530-25002-3-git-send-email-tixxdz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kernel-hardening-return-7339-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1491734530-25002-3-git-send-email-tixxdz@gmail.com>
To: Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@kernel.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org
Cc: Linux API <linux-api@vger.kernel.org>, Dongsu Park <dpark@posteo.net>, James Morris <james.l.morris@oracle.com>, serge@hallyn.com, Paul Moore <paul@paul-moore.com>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
List-Id: linux-api@vger.kernel.org

On 4/9/2017 3:42 AM, Djalal Harouni wrote:
> This adds the ModAutoRestrict Linux Security Module. The new module
> is a stackable LSM that has been tested with Yama and SELinux, all
> the three modules running.
>
> The module applies restrictions on automatic module loading operations.
> If it is selected, every request to use a kernel feature that is implemented
> by modules that are not loaded will first have to satisfy the access rules
> of ModAutoRestrict LSM. If the access is authorized then the module will
> be automatically loaded. Furthermore, this allows system administrators
> or sandbox mechanisms to prevent loading unneeded modules or abuse the
> interface.
>
> The settings can be applied globally using a sysctl interface which
> completes the core kernel interface "modules_disable" that works only
> on two modes: allow or deny, ignoring that module loading can be either
> an explicit operation or an implicit one via automatic loading. The
> CAP_SYS_MODULE capability can be used to restrict explicit operations,
> however implicit module loading is in general not subject to permission
> checks which allows unprivileged to insert modules.
>
> Using the new ModAutoRestrict settings allow to control if implicit
> operations are allowed or denied.
> This behaviour was inspired from grsecurity's GRKERNSEC_MODHARDEN option.
>
> The feature is also available as a prctl() interface. This allows to
> apply restrictions when sandboxing processes. On embedded Linux systems,
> or containers where only some containers/processes should have the
> right privileges to load modules, this allows to restrict those
> processes from inserting modules through the autoload feature, only
> privileged processes can be allowed to perform so. A more restrictive
> access can be applied where the module autoload feature is completely
> disabled.
> In this schema the access rules are per-process and inherited by
> children created by fork(2) and clone(2), and preserved across execve(2).
>
> Current interface:
>
> *) The per-process prctl() settings are:
>
>  prctl(PR_MOD_AUTO_RESTRICT_OPTS, PR_SET_MOD_AUTO_RESTRICT, value, 0, 0)
>
>  Where value means:
>
>  0 - Classic module auto-load permissions, nothing changes.
>
>  1 - The current process must have CAP_SYS_MODULE to be able to
>      auto-load modules. CAP_NET_ADMIN should allow to auto-load
>      modules with a 'netdev-%s' alias.
>
>  2 - Current process can not auto-load modules. Once set, this prctl
>      value can not be changed.
>
>  The per-process value may only be increased, never decreased, thus ensuring
>  that once applied, processes can never relaxe their setting.
>
> *) The global sysctl setting can be set by writting an integer value to
>    '/proc/sys/kernel/modautorestrict/autoload'
>
>  The valid values are:
>
>  0 - Classic module auto-load permissions, nothing changes.
>
>  1 - Processes must have CAP_SYS_MODULE to be able to auto-load modules.
>      CAP_NET_ADMIN should allow to auto-load modules with a 'netdev-%s'
>      alias.
>
>  2 - Processes can not auto-load modules. Once set, this sysctl value
>      can not be changed.
>
> *) Access rules:
>    First the prctl() settings are checked, if the access is not denied
>    then the global sysctl settings are checked.
>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: James Morris <james.l.morris@oracle.com>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Kees Cook <keescook@chromium.org>
> Signed-off-by: Djalal Harouni <tixxdz@gmail.com>
> ---
>  MAINTAINERS                            |   7 +
>  include/linux/lsm_hooks.h              |   5 +
>  include/uapi/linux/prctl.h             |   5 +
>  security/Kconfig                       |   1 +
>  security/Makefile                      |  16 +-
>  security/modautorestrict/Kconfig       |  15 ++
>  security/modautorestrict/Makefile      |   3 +
>  security/modautorestrict/modauto_lsm.c | 372 +++++++++++++++++++++++++++++++++
>  security/security.c                    |   1 +
>  9 files changed, 418 insertions(+), 7 deletions(-)
>  create mode 100644 security/modautorestrict/Kconfig
>  create mode 100644 security/modautorestrict/Makefile
>  create mode 100644 security/modautorestrict/modauto_lsm.c
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index c45c02b..38d17cd 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -11326,6 +11326,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git yama/tip
>  S:	Supported
>  F:	security/yama/
>  
> +MODAUTORESTRICT SECURITY MODULE
> +M:	Djalal Harouni <tixxdz@gmail.com>
> +L:	kernel-hardening@lists.openwall.com
> +L:	linux-security-module@vger.kernel.org
> +S:	Supported
> +F:	security/modautorestrict/
> +
>  SENSABLE PHANTOM
>  M:	Jiri Slaby <jirislaby@gmail.com>
>  S:	Maintained
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index ca19cdb..679800c 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1950,6 +1950,11 @@ void __init loadpin_add_hooks(void);
>  #else
>  static inline void loadpin_add_hooks(void) { };
>  #endif
> +#ifdef CONFIG_SECURITY_MODAUTORESTRICT
> +extern void modautorestrict_init(void);
> +#else
> +static inline void __init modautorestrict_init(void) { }
> +#endif
>  
>  /*
>   * Per "struct task_struct" security blob is managed using index numbers.
> diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
> index a8d0759..e561ca3 100644
> --- a/include/uapi/linux/prctl.h
> +++ b/include/uapi/linux/prctl.h
> @@ -197,4 +197,9 @@ struct prctl_mm_map {
>  # define PR_CAP_AMBIENT_LOWER		3
>  # define PR_CAP_AMBIENT_CLEAR_ALL	4
>  
> +/* Control ModAutoRestrict LSM options */
> +#define PR_MOD_AUTO_RESTRICT_OPTS	48
> +# define PR_SET_MOD_AUTO_RESTRICT	1
> +# define PR_GET_MOD_AUTO_RESTRICT	2
> +
>  #endif /* _LINUX_PRCTL_H */
> diff --git a/security/Kconfig b/security/Kconfig
> index 3ff1bf9..1e181c3 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -204,6 +204,7 @@ source security/tomoyo/Kconfig
>  source security/apparmor/Kconfig
>  source security/loadpin/Kconfig
>  source security/yama/Kconfig
> +source security/modautorestrict/Kconfig
>  
>  source security/integrity/Kconfig
>  
> diff --git a/security/Makefile b/security/Makefile
> index f2d71cd..4c120f7 100644
> --- a/security/Makefile
> +++ b/security/Makefile
> @@ -2,13 +2,14 @@
>  # Makefile for the kernel security code
>  #
>  
> -obj-$(CONFIG_KEYS)			+= keys/
> -subdir-$(CONFIG_SECURITY_SELINUX)	+= selinux
> -subdir-$(CONFIG_SECURITY_SMACK)		+= smack
> -subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
> -subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
> -subdir-$(CONFIG_SECURITY_YAMA)		+= yama
> -subdir-$(CONFIG_SECURITY_LOADPIN)	+= loadpin
> +obj-$(CONFIG_KEYS)				+= keys/
> +subdir-$(CONFIG_SECURITY_SELINUX)		+= selinux
> +subdir-$(CONFIG_SECURITY_SMACK)			+= smack
> +subdir-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo
> +subdir-$(CONFIG_SECURITY_APPARMOR)		+= apparmor
> +subdir-$(CONFIG_SECURITY_YAMA)			+= yama
> +subdir-$(CONFIG_SECURITY_LOADPIN)		+= loadpin
> +subdir-$(CONFIG_SECURITY_MODAUTORESTRICT)	+= modautorestrict
>  
>  # always enable default capabilities
>  obj-y					+= commoncap.o
> @@ -24,6 +25,7 @@ obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/
>  obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/
>  obj-$(CONFIG_SECURITY_YAMA)		+= yama/
>  obj-$(CONFIG_SECURITY_LOADPIN)		+= loadpin/
> +obj-$(CONFIG_SECURITY_MODAUTORESTRICT)	+= modautorestrict/
>  obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
>  
>  # Object integrity file lists
> diff --git a/security/modautorestrict/Kconfig b/security/modautorestrict/Kconfig
> new file mode 100644
> index 0000000..9678106
> --- /dev/null
> +++ b/security/modautorestrict/Kconfig
> @@ -0,0 +1,15 @@
> +config SECURITY_MODAUTORESTRICT
> +	bool "Automatic Module Loading Restriction"
> +	depends on SECURITY
> +	default n
> +	help
> +	  This selects ModAutoRestrict Linux Security Module which applies
> +          restrictions on automatic module loading operations. If this
> +          option is selected, a request to use a kernel feature that is
> +          implemented by an unloaded module will first have to satisfy the
> +          access rules of MODAUTORESTRICT. Furthermore, this allows system
> +          administrators or sandbox mechanisms to prevent loading unneeded
> +          modules.
> +          Further information can be found in Documentation/security/ModAutoRestrict.txt.
> +
> +	  If you are unsure how to answer this question, answer N.
> diff --git a/security/modautorestrict/Makefile b/security/modautorestrict/Makefile
> new file mode 100644
> index 0000000..a0656a5
> --- /dev/null
> +++ b/security/modautorestrict/Makefile
> @@ -0,0 +1,3 @@
> +obj-$(CONFIG_SECURITY_MODAUTORESTRICT) := modautorestrict.o
> +
> +modautorestrict-y := modauto_lsm.o
> diff --git a/security/modautorestrict/modauto_lsm.c b/security/modautorestrict/modauto_lsm.c
> new file mode 100644
> index 0000000..b3a83b8e
> --- /dev/null
> +++ b/security/modautorestrict/modauto_lsm.c
> @@ -0,0 +1,372 @@
> +/*
> + * ModAutoRestrict Linux Security Module
> + *
> + * Author: Djalal Harouni
> + *
> + * Copyright (C) 2017 Djalal Harouni
> + * Copyright (C) 2017 Endocode AG.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/errno.h>
> +#include <linux/lsm_hooks.h>
> +#include <linux/prctl.h>
> +#include <linux/refcount.h>
> +#include <linux/types.h>
> +#include <linux/sched/mm.h>
> +#include <linux/sched/task.h>
> +#include <linux/sysctl.h>
> +
> +enum {
> +	MOD_AUTOLOAD_ALLOWED	= 0,
> +	MOD_AUTOLOAD_PRIVILEGED	= 1,
> +	MOD_AUTOLOAD_DENIED	= 2,
> +};
> +
> +struct modautoload_task {
> +	bool usage;
> +	u8 flags;
> +};
> +
> +static int autoload_restrict;
> +
> +static int zero;
> +static int max_autoload_restrict = MOD_AUTOLOAD_DENIED;
> +
> +/* Index number of per "struct task_struct" blob for ModAutoRestrict. */
> +u16 modautorestrict_task_security_index __ro_after_init;
> +
> +static inline int modautoload_task_set_flag(struct modautoload_task *modtask,
> +					    unsigned long value)
> +{
> +	int ret = 0;
> +
> +	if (value > MOD_AUTOLOAD_DENIED)
> +		ret = -EINVAL;
> +	else if (modtask->flags > value)
> +		ret = -EPERM;
> +	else if (modtask->flags < value)
> +		modtask->flags = value;
> +
> +	return ret;
> +}
> +
> +static inline struct modautoload_task *modautoload_task_security(struct task_struct *tsk)
> +{
> +	struct modautoload_task *modtask;
> +
> +	modtask = task_security(tsk, modautorestrict_task_security_index);
> +	if (modtask->usage)
> +		return modtask;
> +
> +	return NULL;
> +}
> +
> +static inline struct modautoload_task *init_modautoload_task(struct task_struct *tsk,
> +							     unsigned long flags)
> +{
> +	struct modautoload_task *modtask;
> +
> +	modtask = task_security(tsk, modautorestrict_task_security_index);
> +
> +	modtask->flags = (u8)flags;

I don't think you want to do this cast.

> +	modtask->usage = true;
> +
> +	return modtask;
> +}
> +
> +static inline void clear_modautoload_task(struct task_struct *tsk)
> +{
> +	struct modautoload_task *modtask;
> +
> +	modtask = modautoload_task_security(tsk);
> +	if (modtask) {
> +		modtask->usage = false;
> +		modtask->flags = MOD_AUTOLOAD_ALLOWED;
> +	}
> +}
> +
> +/*
> + * Return 0 if CAP_SYS_MODULE or if CAP_NET_ADMIN and the module is
> + * a netdev-%s module. Otherwise -EPERM is returned.
> + */
> +static int modautoload_privileged_access(const char *name)
> +{
> +	int ret = -EPERM;
> +
> +	if (capable(CAP_SYS_MODULE))
> +		ret = 0;
> +	else if (name && strstr(name, "netdev-") && capable(CAP_NET_ADMIN))
> +		ret = 0;
> +
> +	return ret;
> +}
> +
> +static int modautoload_sysctl_perm(unsigned long op, const char *name)
> +{
> +	int ret = -EINVAL;
> +	struct mm_struct *mm = NULL;
> +
> +	if (op != PR_GET_MOD_AUTO_RESTRICT)
> +		return ret;
> +
> +	switch (autoload_restrict) {
> +	case MOD_AUTOLOAD_ALLOWED:
> +		ret = 0;
> +		break;
> +	case MOD_AUTOLOAD_PRIVILEGED:
> +		/*
> +		 * Are we allowed to sleep here ?
> +		 * Also improve this check here
> +		 */
> +		ret = -EPERM;
> +		mm = get_task_mm(current);
> +		if (mm) {
> +			ret = modautoload_privileged_access(name);
> +			mmput(mm);
> +		}
> +		break;
> +	case MOD_AUTOLOAD_DENIED:
> +		ret = -EPERM;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static int modautoload_task_perm(struct modautoload_task *mtask,
> +				 char *kmod_name)
> +{
> +	int ret = -EINVAL;
> +
> +	switch (mtask->flags) {
> +	case MOD_AUTOLOAD_ALLOWED:
> +		ret = 0;
> +		break;
> +	case MOD_AUTOLOAD_PRIVILEGED:
> +		ret = modautoload_privileged_access(kmod_name);
> +		break;
> +	case MOD_AUTOLOAD_DENIED:
> +		ret = -EPERM;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +/* Set the given option in a modautorestrict task */
> +static int modautoload_set_op_value(struct task_struct *tsk,
> +				    unsigned long value)
> +{
> +	int ret = -EINVAL;
> +	struct modautoload_task *modtask;
> +
> +	if (value > MOD_AUTOLOAD_DENIED)
> +		return ret;
> +
> +	modtask = modautoload_task_security(tsk);
> +	if (!modtask) {
> +		modtask = init_modautoload_task(tsk, value);
> +		return 0;
> +	}
> +
> +	return modautoload_task_set_flag(modtask, value);
> +}
> +
> +static int modautoload_get_op_value(struct task_struct *tsk)
> +{
> +	struct modautoload_task *modtask;
> +
> +	modtask = modautoload_task_security(tsk);
> +	if (!modtask)
> +		return -EINVAL;
> +
> +	return modtask->flags;
> +}
> +
> +/* Copy modautorestrict context from parent to child */
> +int modautoload_task_alloc(struct task_struct *tsk, unsigned long clone_flags)
> +{
> +	struct modautoload_task *modparent;
> +
> +	modparent = modautoload_task_security(current);
> +
> +	/* Parent has a modautorestrict context */
> +	if (modparent)
> +		init_modautoload_task(tsk, modparent->flags);
> +
> +	return 0;
> +}
> +
> +/*
> + * Return 0 on success, -error on error.  -ENOSYS is returned when modautorestrict
> + * does not handle the given option, or -EINVAL if the passed arguments are not
> + * valid.
> + */
> +int modautoload_task_prctl(int option, unsigned long arg2, unsigned long arg3,
> +			   unsigned long arg4, unsigned long arg5)
> +{
> +	int ret = -EINVAL;
> +	struct task_struct *myself = current;
> +
> +	if (option != PR_MOD_AUTO_RESTRICT_OPTS)
> +		return -ENOSYS;
> +
> +	get_task_struct(myself);
> +
> +	switch (arg2) {
> +	case PR_SET_MOD_AUTO_RESTRICT:
> +		if (arg4 || arg5)
> +			goto out;
> +
> +		ret = modautoload_set_op_value(myself, arg3);
> +		break;
> +	case PR_GET_MOD_AUTO_RESTRICT:
> +		if (arg3 || arg4 || arg5)
> +			goto out;
> +
> +		ret = modautoload_get_op_value(myself);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +out:
> +	put_task_struct(myself);
> +	return ret;
> +}
> +
> +void modautoload_task_free(struct task_struct *tsk)
> +{
> +	clear_modautoload_task(tsk);
> +}
> +
> +/*
> + * TODO:
> + * if this is covered entirely by CAP_SYS_MODULE then we should removed it.
> + */
> +static int modautoload_kernel_module_file(struct file *file)
> +{
> +	int ret = 0;
> +	struct modautoload_task *modtask;
> +	struct task_struct *myself = current;
> +
> +	/* First check if the task allows that */
> +	modtask = modautoload_task_security(myself);
> +	if (modtask) {
> +		ret = modautoload_task_perm(modtask, NULL);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return modautoload_sysctl_perm(PR_GET_MOD_AUTO_RESTRICT, NULL);
> +}
> +
> +static int modautoload_kernel_module_request(char *kmod_name)
> +{
> +	int ret = 0;
> +	struct modautoload_task *modtask;
> +	struct task_struct *myself = current;
> +
> +	/* First check if the task allows that */
> +	modtask = modautoload_task_security(myself);
> +	if (modtask) {
> +		ret = modautoload_task_perm(modtask, kmod_name);
> +		if (ret < 0)
> +			return ret;
> +	}
> +
> +	return modautoload_sysctl_perm(PR_GET_MOD_AUTO_RESTRICT, kmod_name);
> +}
> +
> +/*
> + * TODO:
> + * if this is covered entirely by CAP_SYS_MODULE then we should removed it.
> + */
> +static int modautoload_kernel_read_file(struct file *file,
> +					enum kernel_read_file_id id)
> +{
> +	int ret = 0;
> +
> +	switch (id) {
> +	case READING_MODULE:
> +		ret = modautoload_kernel_module_file(file);
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	return ret;
> +}
> +
> +static struct security_hook_list modautoload_hooks[] = {
> +	LSM_HOOK_INIT(kernel_module_request, modautoload_kernel_module_request),
> +	LSM_HOOK_INIT(kernel_read_file, modautoload_kernel_read_file),
> +	LSM_HOOK_INIT(task_alloc, modautoload_task_alloc),
> +	LSM_HOOK_INIT(task_prctl, modautoload_task_prctl),
> +	LSM_HOOK_INIT(task_free, modautoload_task_free),
> +};
> +
> +#ifdef CONFIG_SYSCTL
> +static int modautoload_dointvec_minmax(struct ctl_table *table, int write,
> +				       void __user *buffer, size_t *lenp,
> +				       loff_t *ppos)
> +{
> +	struct ctl_table table_copy;
> +
> +	if (write && !capable(CAP_SYS_MODULE))
> +		return -EPERM;
> +
> +	table_copy = *table;
> +	if (*(int *)table_copy.data == *(int *)table_copy.extra2)

While it's probably doing what you want, I find this
sort of casting disturbing.

> +		table_copy.extra1 = table_copy.extra2;
> +
> +	return proc_dointvec_minmax(&table_copy, write, buffer, lenp, ppos);
> +}
> +
> +struct ctl_path modautoload_sysctl_path[] = {
> +	{ .procname = "kernel", },
> +	{ .procname = "modautorestrict", },
> +	{ }
> +};
> +
> +static struct ctl_table modautoload_sysctl_table[] = {
> +	{
> +		.procname       = "autoload",
> +		.data           = &autoload_restrict,
> +		.maxlen         = sizeof(int),
> +		.mode           = 0644,
> +		.proc_handler   = modautoload_dointvec_minmax,
> +		.extra1         = &zero,
> +		.extra2         = &max_autoload_restrict,
> +	},
> +	{ }
> +};
> +
> +static void __init modautoload_init_sysctl(void)
> +{
> +	if (!register_sysctl_paths(modautoload_sysctl_path, modautoload_sysctl_table))
> +		panic("modautorestrict: sysctl registration failed.\n");
> +}
> +#else
> +static inline void modautoload_init_sysctl(void) { }
> +#endif /* CONFIG_SYSCTL */
> +
> +void __init modautorestrict_init(void)
> +{
> +	modautorestrict_task_security_index =
> +		security_reserve_task_blob_index(sizeof(struct modautoload_task));
> +	security_add_hooks(modautoload_hooks,
> +			   ARRAY_SIZE(modautoload_hooks), "modautorestrict");
> +
> +	modautoload_init_sysctl();
> +	pr_info("ModAutoRestrict LSM:  Initialized\n");
> +}
> diff --git a/security/security.c b/security/security.c
> index 4dc6bca..d8852fe 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -70,6 +70,7 @@ int __init security_init(void)
>  	capability_add_hooks();
>  	yama_add_hooks();
>  	loadpin_add_hooks();
> +	modautorestrict_init();

This should be modautorestrict_add_hooks() if this were
a "minor" module, but as it's using a blob it is a "major"
module. Either way, this is not right.

>  
>  	/*
>  	 * Load all the remaining security modules.

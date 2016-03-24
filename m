From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [RFC v1 05/17] security/seccomp: Add LSM and create arrays of
 syscall metadata
Date: Thu, 24 Mar 2016 09:01:03 -0700
Message-ID: <56F40F3F.90708@schaufler-ca.com>
References: <1458784008-16277-1-git-send-email-mic@digikod.net>
 <1458784008-16277-6-git-send-email-mic@digikod.net>
Reply-To: kernel-hardening@lists.openwall.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <kernel-hardening-return-2851-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
In-Reply-To: <1458784008-16277-6-git-send-email-mic@digikod.net>
To: =?UTF-8?Q?Micka=c3=abl_Sala=c3=bcn?= <mic@digikod.net>, linux-security-module@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Daniel Borkmann <daniel@iogearbox.net>, David Drysdale <drysdale@google.com>, Eric Paris <eparis@redhat.com>, James Morris <james.l.morris@oracle.com>, Jeff Dike <jdike@addtoit.com>, Julien Tinnes <jln@google.com>, Kees Cook <keescook@chromium.org>, Michael Kerrisk <mtk@man7.org>, Paul Moore <pmoore@redhat.com>, Richard Weinberger <richard@nod.at>, "Serge E . Hallyn" <serge@hallyn.com>, Stephen Smalley <sds@tycho.nsa.gov>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, Will Drewry <wad@chromium.org>, linux-api@vger.kernel.org, kernel-hardening@lists.openwall.com
List-Id: linux-api@vger.kernel.org

On 3/23/2016 6:46 PM, Mickaël Salaün wrote:
> To avoid userland to make mistakes by misusing a syscall parameter, the
> kernel check the type of the syscall parameters (e.g. char pointer). At
> compile time we create a memory section (i.e. __syscall_argdesc) with
> syscall metadata. At boot time, this section is used to create an array
> (i.e. seccomp_syscalls_argdesc) usable to check the syscall arguments.
> The same way, another array can be created and used for compat mode.
>
> Signed-off-by: Mickaël Salaün <mic@digikod.net>
> Cc: Andreas Gruenbacher <agruenba@redhat.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Casey Schaufler <casey@schaufler-ca.com>
> Cc: David Drysdale <drysdale@google.com>
> Cc: James Morris <james.l.morris@oracle.com>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Paul Moore <pmoore@redhat.com>
> Cc: Serge E. Hallyn <serge@hallyn.com>
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Cc: Will Drewry <wad@chromium.org>
> ---
>  include/asm-generic/vmlinux.lds.h | 22 ++++++++++
>  include/linux/compat.h            | 10 +++++
>  include/linux/lsm_hooks.h         |  5 +++
>  include/linux/syscalls.h          | 68 ++++++++++++++++++++++++++++++
>  security/Kconfig                  |  1 +
>  security/Makefile                 |  2 +
>  security/seccomp/Kconfig          | 14 +++++++
>  security/seccomp/Makefile         |  3 ++
>  security/seccomp/lsm.c            | 87 +++++++++++++++++++++++++++++++++++++++
>  security/seccomp/lsm.h            | 19 +++++++++
>  security/security.c               |  1 +
>  11 files changed, 232 insertions(+)
>  create mode 100644 security/seccomp/Kconfig
>  create mode 100644 security/seccomp/Makefile
>  create mode 100644 security/seccomp/lsm.c
>  create mode 100644 security/seccomp/lsm.h
>
> diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
> index c4bd0e2c173c..b8792fc083c2 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -153,6 +153,26 @@
>  #define TRACE_SYSCALLS()
>  #endif
>  
> +#ifdef CONFIG_SECURITY_SECCOMP
> +#define ARGDESC_SYSCALLS() . = ALIGN(8);				\
> +			 VMLINUX_SYMBOL(__start_syscalls_argdesc) = .;	\
> +			 *(__syscalls_argdesc)				\
> +			 VMLINUX_SYMBOL(__stop_syscalls_argdesc) = .;
> +
> +#ifdef CONFIG_COMPAT
> +#define COMPAT_ARGDESC_SYSCALLS() . = ALIGN(8);				\
> +		 VMLINUX_SYMBOL(__start_compat_syscalls_argdesc) = .;	\
> +		 *(__compat_syscalls_argdesc)				\
> +		 VMLINUX_SYMBOL(__stop_compat_syscalls_argdesc) = .;
> +#else
> +#define COMPAT_ARGDESC_SYSCALLS()
> +#endif	/* CONFIG_COMPAT */
> +
> +#else
> +#define ARGDESC_SYSCALLS()
> +#define COMPAT_ARGDESC_SYSCALLS()
> +#endif /* CONFIG_SECURITY_SECCOMP */
> +
>  #ifdef CONFIG_SERIAL_EARLYCON
>  #define EARLYCON_TABLE() STRUCT_ALIGN();			\
>  			 VMLINUX_SYMBOL(__earlycon_table) = .;	\
> @@ -511,6 +531,8 @@
>  	MEM_DISCARD(init.data)						\
>  	KERNEL_CTORS()							\
>  	MCOUNT_REC()							\
> +	ARGDESC_SYSCALLS()						\
> +	COMPAT_ARGDESC_SYSCALLS()					\
>  	*(.init.rodata)							\
>  	FTRACE_EVENTS()							\
>  	TRACE_SYSCALLS()						\
> diff --git a/include/linux/compat.h b/include/linux/compat.h
> index a76c9172b2eb..b63579a401e8 100644
> --- a/include/linux/compat.h
> +++ b/include/linux/compat.h
> @@ -15,6 +15,7 @@
>  #include <linux/fs.h>
>  #include <linux/aio_abi.h>	/* for aio_context_t */
>  #include <linux/unistd.h>
> +#include <linux/syscalls.h>	/* for SYSCALL_FILL_ARGDESC_SECTION */
>  
>  #include <asm/compat.h>
>  #include <asm/siginfo.h>
> @@ -28,7 +29,15 @@
>  #define __SC_DELOUSE(t,v) ((t)(unsigned long)(v))
>  #endif
>  
> +#ifdef CONFIG_SECURITY_SECCOMP
> +#define COMPAT_SYSCALL_FILL_ARGDESC(...)	\
> +	SYSCALL_FILL_ARGDESC_SECTION("__compat_syscalls_argdesc", __VA_ARGS__)
> +#else
> +#define COMPAT_SYSCALL_FILL_ARGDESC(...)
> +#endif /* CONFIG_SECURITY_SECCOMP */
> +
>  #define COMPAT_SYSCALL_DEFINE0(name) \
> +	COMPAT_SYSCALL_FILL_ARGDESC(compat_sys_##name, 0)	\
>  	asmlinkage long compat_sys_##name(void)
>  
>  #define COMPAT_SYSCALL_DEFINE1(name, ...) \
> @@ -45,6 +54,7 @@
>  	COMPAT_SYSCALL_DEFINEx(6, _##name, __VA_ARGS__)
>  
>  #define COMPAT_SYSCALL_DEFINEx(x, name, ...)				\
> +	COMPAT_SYSCALL_FILL_ARGDESC(compat_sys##name, x, __VA_ARGS__)	\
>  	asmlinkage long compat_sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))\
>  		__attribute__((alias(__stringify(compat_SyS##name))));  \
>  	static inline long C_SYSC##name(__MAP(x,__SC_DECL,__VA_ARGS__));\
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 71969de4058c..12df41669308 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1892,5 +1892,10 @@ extern void __init yama_add_hooks(void);
>  #else
>  static inline void __init yama_add_hooks(void) { }
>  #endif
> +#ifdef CONFIG_SECURITY_SECCOMP
> +extern void __init seccomp_init(void);
> +#else
> +static inline void __init seccomp_init(void) { }
> +#endif
>  
>  #endif /* ! __LINUX_LSM_HOOKS_H */
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 185815c96433..0f846c408bba 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -79,6 +79,8 @@ union bpf_attr;
>  #include <linux/quota.h>
>  #include <linux/key.h>
>  #include <trace/syscall.h>
> +#include <uapi/asm/unistd.h>
> +#include <linux/seccomp.h>
>  
>  /*
>   * __MAP - apply a macro to syscall arguments
> @@ -98,6 +100,24 @@ union bpf_attr;
>  #define __MAP6(m,t,a,...) m(t,a), __MAP5(m,__VA_ARGS__)
>  #define __MAP(n,...) __MAP##n(__VA_ARGS__)
>  
> +#define __COMPARGS6
> +#define __COMPARGS5 , 0
> +#define __COMPARGS4 , 0, 0
> +#define __COMPARGS3 , 0, 0, 0
> +#define __COMPARGS2 , 0, 0, 0, 0
> +#define __COMPARGS1 , 0, 0, 0, 0, 0
> +#define __COMPARGS0 0, 0, 0, 0, 0, 0
> +#define __COMPARGS(n) __COMPARGS##n
> +
> +#define __COMPDECL6
> +#define __COMPDECL5
> +#define __COMPDECL4
> +#define __COMPDECL3
> +#define __COMPDECL2
> +#define __COMPDECL1
> +#define __COMPDECL0 void
> +#define __COMPDECL(n) __COMPDECL##n
> +
>  #define __SC_DECL(t, a)	t a
>  #define __TYPE_IS_L(t)	(__same_type((t)0, 0L))
>  #define __TYPE_IS_UL(t)	(__same_type((t)0, 0UL))
> @@ -175,8 +195,55 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  #define SYSCALL_METADATA(sname, nb, ...)
>  #endif
>  
> +#ifdef CONFIG_SECURITY_SECCOMP
> +/*
> + * Do not store the symbole name but the syscall symbole address.
> + * FIXME: Handle aliased symboles (i.e. different name but same address)?
> + *
> + * @addr: syscall address
> + * @args: syscall arguments C type (i.e. __SACT__* values)
> + */
> +struct syscall_argdesc {
> +	const void *addr;
> +	u8 args[6];
> +};
> +
> +/* Syscall Argument C Type (none means no argument) */
> +#define __SACT__NONE			0
> +#define __SACT__OTHER			1
> +#define __SACT__CONST_CHAR_PTR		2
> +#define __SACT__CHAR_PTR		3
> +
> +#define __SC_ARGDESC_TYPE(t, a)						\
> +	__builtin_types_compatible_p(typeof(t), const char *) ?		\
> +	__SACT__CONST_CHAR_PTR :					\
> +	__builtin_types_compatible_p(typeof(t), char *) ?		\
> +	__SACT__CHAR_PTR :						\
> +	__SACT__OTHER
> +
> +#define SYSCALL_FILL_ARGDESC_SECTION(_section, sname, nb, ...)		\
> +	asmlinkage long sname(__MAP(nb, __SC_DECL, __VA_ARGS__)		\
> +			__COMPDECL(nb));				\
> +	static struct syscall_argdesc __used				\
> +		__attribute__((section(_section)))			\
> +		syscall_argdesc_##sname = {				\
> +			.addr = sname,					\
> +			.args = {					\
> +				__MAP(nb, __SC_ARGDESC_TYPE, __VA_ARGS__)\
> +				__COMPARGS(nb)				\
> +			},						\
> +		};
> +
> +#define SYSCALL_FILL_ARGDESC(...)	\
> +	SYSCALL_FILL_ARGDESC_SECTION("__syscalls_argdesc", __VA_ARGS__)
> +
> +#else
> +#define SYSCALL_FILL_ARGDESC(...)
> +#endif /* CONFIG_SECURITY_SECCOMP */
> +
>  #define SYSCALL_DEFINE0(sname)					\
>  	SYSCALL_METADATA(_##sname, 0);				\
> +	SYSCALL_FILL_ARGDESC(sys_##sname, 0)			\
>  	asmlinkage long sys_##sname(void)
>  
>  #define SYSCALL_DEFINE1(name, ...) SYSCALL_DEFINEx(1, _##name, __VA_ARGS__)
> @@ -188,6 +255,7 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  
>  #define SYSCALL_DEFINEx(x, sname, ...)				\
>  	SYSCALL_METADATA(sname, x, __VA_ARGS__)			\
> +	SYSCALL_FILL_ARGDESC(sys##sname, x, __VA_ARGS__)	\
>  	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
>  
>  #define __PROTECT(...) asmlinkage_protect(__VA_ARGS__)
> diff --git a/security/Kconfig b/security/Kconfig
> index e45237897b43..c98fe1a924cd 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -123,6 +123,7 @@ source security/smack/Kconfig
>  source security/tomoyo/Kconfig
>  source security/apparmor/Kconfig
>  source security/yama/Kconfig
> +source security/seccomp/Kconfig
>  
>  source security/integrity/Kconfig
>  
> diff --git a/security/Makefile b/security/Makefile
> index c9bfbc84ff50..0e4cdefc4777 100644
> --- a/security/Makefile
> +++ b/security/Makefile
> @@ -8,6 +8,7 @@ subdir-$(CONFIG_SECURITY_SMACK)		+= smack
>  subdir-$(CONFIG_SECURITY_TOMOYO)        += tomoyo
>  subdir-$(CONFIG_SECURITY_APPARMOR)	+= apparmor
>  subdir-$(CONFIG_SECURITY_YAMA)		+= yama
> +subdir-$(CONFIG_SECCOMP_FILTER)		+= seccomp
>  
>  # always enable default capabilities
>  obj-y					+= commoncap.o
> @@ -22,6 +23,7 @@ obj-$(CONFIG_AUDIT)			+= lsm_audit.o
>  obj-$(CONFIG_SECURITY_TOMOYO)		+= tomoyo/
>  obj-$(CONFIG_SECURITY_APPARMOR)		+= apparmor/
>  obj-$(CONFIG_SECURITY_YAMA)		+= yama/
> +obj-$(CONFIG_SECCOMP_FILTER)	+= seccomp/
>  obj-$(CONFIG_CGROUP_DEVICE)		+= device_cgroup.o
>  
>  # Object integrity file lists
> diff --git a/security/seccomp/Kconfig b/security/seccomp/Kconfig
> new file mode 100644
> index 000000000000..7b0fe649ed89
> --- /dev/null
> +++ b/security/seccomp/Kconfig
> @@ -0,0 +1,14 @@
> +config SECURITY_SECCOMP
> +	bool "Seccomp LSM support"
> +	depends on AUDIT
> +	depends on SECCOMP
> +	depends on SECURITY
> +	default y
> +	help
> +	  This selects an extension to the Seccomp BPF to be able to filter
> +	  syscall arguments as kernel objects (e.g. file path).
> +	  This stacked LSM is needed to detect and block race-condition attacks
> +	  against argument evaluation (i.e. TOCTOU). Further information can be
> +	  found in Documentation/prctl/seccomp_filter.txt .
> +
> +	  If you are unsure how to answer this question, answer Y.
> diff --git a/security/seccomp/Makefile b/security/seccomp/Makefile
> new file mode 100644
> index 000000000000..f2e848d81138
> --- /dev/null
> +++ b/security/seccomp/Makefile
> @@ -0,0 +1,3 @@
> +obj-$(CONFIG_SECURITY_SECCOMP) := seccomp.o
> +
> +seccomp-y := lsm.o
> diff --git a/security/seccomp/lsm.c b/security/seccomp/lsm.c
> new file mode 100644
> index 000000000000..93c881724341
> --- /dev/null
> +++ b/security/seccomp/lsm.c
> @@ -0,0 +1,87 @@
> +/*
> + * Seccomp Linux Security Module
> + *
> + * Copyright (C) 2016  Mickaël Salaün <mic@digikod.net>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <asm/syscall.h>	/* sys_call_table */
> +#include <linux/compat.h>
> +#include <linux/slab.h>	/* kcalloc() */
> +#include <linux/syscalls.h>	/* syscall_argdesc */
> +
> +#include "lsm.h"
> +
> +/* TODO: Remove the need for CONFIG_SYSFS dependency */
> +
> +struct syscall_argdesc (*seccomp_syscalls_argdesc)[] = NULL;
> +#ifdef CONFIG_COMPAT
> +struct syscall_argdesc (*compat_seccomp_syscalls_argdesc)[] = NULL;
> +#endif	/* CONFIG_COMPAT */
> +
> +static const struct syscall_argdesc *__init
> +find_syscall_argdesc(const struct syscall_argdesc *start,
> +		const struct syscall_argdesc *stop, const void *addr)
> +{
> +	if (unlikely(!addr || !start || !stop)) {
> +		WARN_ON(1);
> +		return NULL;
> +	}
> +
> +	for (; start < stop; start++) {
> +		if (start->addr == addr)
> +			return start;
> +	}
> +	return NULL;
> +}
> +
> +static inline void __init init_argdesc(void)
> +{
> +	const struct syscall_argdesc *argdesc;
> +	const void *addr;
> +	int i;
> +
> +	seccomp_syscalls_argdesc = kcalloc(NR_syscalls,
> +			sizeof((*seccomp_syscalls_argdesc)[0]), GFP_KERNEL);
> +	if (unlikely(!seccomp_syscalls_argdesc)) {
> +		WARN_ON(1);
> +		return;
> +	}
> +	for (i = 0; i < NR_syscalls; i++) {
> +		addr = sys_call_table[i];
> +		argdesc = find_syscall_argdesc(__start_syscalls_argdesc,
> +				__stop_syscalls_argdesc, addr);
> +		if (!argdesc)
> +			continue;
> +
> +		(*seccomp_syscalls_argdesc)[i] = *argdesc;
> +	}
> +
> +#ifdef CONFIG_COMPAT
> +	compat_seccomp_syscalls_argdesc = kcalloc(IA32_NR_syscalls,
> +			sizeof((*compat_seccomp_syscalls_argdesc)[0]),
> +			GFP_KERNEL);
> +	if (unlikely(!compat_seccomp_syscalls_argdesc)) {
> +		WARN_ON(1);
> +		return;
> +	}
> +	for (i = 0; i < IA32_NR_syscalls; i++) {
> +		addr = ia32_sys_call_table[i];
> +		argdesc = find_syscall_argdesc(__start_compat_syscalls_argdesc,
> +				__stop_compat_syscalls_argdesc, addr);
> +		if (!argdesc)
> +			continue;
> +
> +		(*compat_seccomp_syscalls_argdesc)[i] = *argdesc;
> +	}
> +#endif	/* CONFIG_COMPAT */
> +}
> +
> +void __init seccomp_init(void)
> +{
> +	pr_info("seccomp: Becoming ready for sandboxing\n");
> +	init_argdesc();
> +}

This isn't using the LSM infrastructure at all, is it?
It looks like the only reason you're calling it a security
module is to get the initialization code called in
security_init().

Let me amend my previous comment, which was to change
the name of seccomp_init(). Leave it as is, but add a
comment before it that explains why you've put the
call in the midst of the security module initialization.

> diff --git a/security/seccomp/lsm.h b/security/seccomp/lsm.h
> new file mode 100644
> index 000000000000..ededbd27c225
> --- /dev/null
> +++ b/security/seccomp/lsm.h
> @@ -0,0 +1,19 @@
> +/*
> + * Seccomp Linux Security Module
> + *
> + * Copyright (C) 2016  Mickaël Salaün <mic@digikod.net>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/syscalls.h>	/* syscall_argdesc */
> +
> +extern const struct syscall_argdesc __start_syscalls_argdesc[];
> +extern const struct syscall_argdesc __stop_syscalls_argdesc[];
> +
> +#ifdef CONFIG_COMPAT
> +extern const struct syscall_argdesc __start_compat_syscalls_argdesc[];
> +extern const struct syscall_argdesc __stop_compat_syscalls_argdesc[];
> +#endif	/* CONFIG_COMPAT */
> diff --git a/security/security.c b/security/security.c
> index e8ffd92ae2eb..76e50345cd82 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -60,6 +60,7 @@ int __init security_init(void)
>  	 */
>  	capability_add_hooks();
>  	yama_add_hooks();
> +	seccomp_init();
>  
>  	/*
>  	 * Load all the remaining security modules.

From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 1/4] syscalls: Verify address limit before returning
 to user-mode
Date: Fri, 28 Apr 2017 08:35:25 +0200
Message-ID: <20170428063525.zmkthmhipczfnbgr@gmail.com>
References: <CAJcbSZENjCgn3TNDGzCBBSOXMvbTX8mBO7Trugdb5VRzhxwmHg@mail.gmail.com>
 <20170427144227.113630-1-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170427144227.113630-1-thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-api@vger.kernel.org


* Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> Ensure that a syscall does not return to user-mode with a kernel address
> limit. If that happens, a process can corrupt kernel-mode memory and
> elevate privileges [1].
> 
> The CONFIG_ADDR_LIMIT_CHECK option disables the generic check so each
> architecture can create optimized versions.
> 
> [1] https://bugs.chromium.org/p/project-zero/issues/detail?id=990
> 
> Signed-off-by: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Tested-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
> ---
> Based on next-20170426
> ---
>  arch/s390/Kconfig        |  1 +
>  include/linux/syscalls.h | 27 ++++++++++++++++++++++++++-
>  init/Kconfig             |  6 ++++++
>  kernel/sys.c             | 13 +++++++++++++
>  4 files changed, 46 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index d25435d94b6e..164de1d24e92 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -103,6 +103,7 @@ config S390
>  	select ARCH_INLINE_WRITE_UNLOCK_BH
>  	select ARCH_INLINE_WRITE_UNLOCK_IRQ
>  	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
> +	select ADDR_LIMIT_CHECK
>  	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
>  	select ARCH_SUPPORTS_ATOMIC_RMW
>  	select ARCH_SUPPORTS_DEFERRED_STRUCT_PAGE_INIT
> diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
> index 980c3c9b06f8..ebde64f1622c 100644
> --- a/include/linux/syscalls.h
> +++ b/include/linux/syscalls.h
> @@ -191,6 +191,28 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  	SYSCALL_METADATA(sname, x, __VA_ARGS__)			\
>  	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
>  
> +
> +/*
> + * Called before coming back to user-mode. Returning to user-mode with an
> + * address limit different than USER_DS can allow to overwrite kernel memory.
> + */
> +static inline void addr_limit_check_syscall(void)
> +{
> +	BUG_ON(!segment_eq(get_fs(), USER_DS));
> +}
> +
> +#ifndef CONFIG_ADDR_LIMIT_CHECK
> +#define ADDR_LIMIT_CHECK_PRE() \
> +	bool user_caller = segment_eq(get_fs(), USER_DS)
> +#define ADDR_LIMIT_CHECK_POST() \
> +	if (user_caller) addr_limit_check_syscall()
> +#else
> +#define ADDR_LIMIT_CHECK_PRE()
> +#define ADDR_LIMIT_CHECK_POST()
> +asmlinkage void addr_limit_check_failed(void) __noreturn;
> +#endif
> +
> +
>  #define __PROTECT(...) asmlinkage_protect(__VA_ARGS__)
>  #define __SYSCALL_DEFINEx(x, name, ...)					\
>  	asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))	\
> @@ -199,7 +221,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));	\
>  	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
>  	{								\
> -		long ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));	\
> +		long ret;						\
> +		ADDR_LIMIT_CHECK_PRE();					\
> +		ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));	\
> +		ADDR_LIMIT_CHECK_POST();				\
>  		__MAP(x,__SC_TEST,__VA_ARGS__);				\
>  		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
>  		return ret;						\
> diff --git a/init/Kconfig b/init/Kconfig
> index 42a346b0df43..599d9fe30703 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -1961,6 +1961,12 @@ config PROFILING
>  config TRACEPOINTS
>  	bool
>  
> +config ADDR_LIMIT_CHECK
> +	bool
> +	help
> +	  Disable the generic address limit check. Allow each architecture to
> +	  optimize how and when the verification is done.
> +
>  source "arch/Kconfig"
>  
>  endmenu		# General setup
> diff --git a/kernel/sys.c b/kernel/sys.c
> index 8a94b4eabcaa..a1cbcd715d62 100644
> --- a/kernel/sys.c
> +++ b/kernel/sys.c
> @@ -2458,3 +2458,16 @@ COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
>  	return 0;
>  }
>  #endif /* CONFIG_COMPAT */
> +
> +#ifdef CONFIG_ADDR_LIMIT_CHECK
> +/*
> + * Used when an architecture specific implementation detects an invalid address
> + * limit. This function does not return.
> + */
> +asmlinkage void addr_limit_check_failed(void)
> +{
> +	/* Try to fail on the generic address limit check */
> +	addr_limit_check_syscall();
> +	panic("Invalid address limit before returning to user-mode");
> +}
> +#endif

Ok, this version looks pretty good to me. Could you (re-)send a full series?

I assume some of these changes need to be propagated into the followup patches but 
even if not it's better to pick up a clean series.

Thanks,

	Ingo

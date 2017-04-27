From: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 1/4] syscalls: Verify address limit before returning
 to user-mode
Date: Thu, 27 Apr 2017 08:49:17 +0200
Message-ID: <20170427064917.phwo6yl4v4q43fql@gmail.com>
References: <20170426183425.32158-1-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170426183425.32158-1-thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail-gLCNRsNSrVdVZEhyV+6z5nIPMjoJpjVV@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Eric W . Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pavel Tikhomirov <ptikhomirov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Josh Poimboeuf <jpoimboe@redhat.c>
List-Id: linux-api@vger.kernel.org


* Thomas Garnier <thgarnie-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

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
> +#define __CHECK_USERMODE_SYSCALL() \
> +	bool user_caller = segment_eq(get_fs(), USER_DS)
> +#define __VERIFY_ADDR_LIMIT() \
> +	if (user_caller) addr_limit_check_syscall()
> +#else
> +#define __CHECK_USERMODE_SYSCALL()
> +#define __VERIFY_ADDR_LIMIT()
> +asmlinkage void addr_limit_check_failed(void) __noreturn;
> +#endif

_Please_ harmonize all the externally exposed names and symbols.

There's no reason for this mismash of names:

	CONFIG_ADDR_LIMIT_CHECK

	__CHECK_USERMODE_SYSCALL
	__VERIFY_ADDR_LIMIT

When we could just as easily name them consistently, along the existing pattern:

	CONFIG_ADDR_LIMIT_CHECK

	__SYSCALL_ADDR_LIMIT_CHECK
	__ADDR_LIMIT_CHECK

which should fit into existing nomenclature:

>  #define __SYSCALL_DEFINEx(x, name, ...)					\

But even with that fixed, the whole construct still looks pretty weird:

>  	{								\
> -		long ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));	\
> +		long ret;						\
> +		__CHECK_USERMODE_SYSCALL();				\
> +		ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));	\
> +		__ADDR_LIMIT_CHECK();					\
>  		__MAP(x,__SC_TEST,__VA_ARGS__);				\
>  		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
>  		return ret;						\

I think something like this would be more natural to read:

> +		ADDR_LIMIT_CHECK_PRE();					\
> +		ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));	\
> +		ADDR_LIMIT_CHECK_POST();				\

it's a clear pre/post construct. Also note the lack of double underscores.

BTW., a further simplification would be:

#ifndef ADDR_LIMIT_CHECK_PRE
# define ADDR_LIMIT_CHECK_PRE ...
#endif

This way architectures could override this generic functionality simply by 
defining the helpers. Architectures that don't do that get the generic version. 

Thanks,

	Ingo

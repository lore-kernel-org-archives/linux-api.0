From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 1/4] syscalls: Restore address limit after a syscall
Date: Thu, 9 Mar 2017 09:42:08 +0100
Message-ID: <20170309084208.ims3ehcnieo7uqew@pd.tnic>
References: <20170309012456.5631-1-thgarnie@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <kernel-hardening-return-6960-glkh-kernel-hardening=m.gmane.org@lists.openwall.com>
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
Content-Disposition: inline
In-Reply-To: <20170309012456.5631-1-thgarnie@google.com>
To: Thomas Garnier <thgarnie@google.com>
Cc: David Howells <dhowells@redhat.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Al Viro <viro@zeniv.linux.org.uk>, =?utf-8?B?UmVuw6k=?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "David S . Miller" <davem@davemloft.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Nicolas Pitre <nicolas.pitre@linaro.org>, Petr Mladek <pmladek@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Helge Deller <deller@gmx.de>, Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, Oleg Nesterov <oleg@redhat.com>, John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Fre
List-Id: linux-api@vger.kernel.org

On Wed, Mar 08, 2017 at 05:24:53PM -0800, Thomas Garnier wrote:
> @@ -191,6 +191,22 @@ extern struct trace_event_functions exit_syscall_print_funcs;
>  	SYSCALL_METADATA(sname, x, __VA_ARGS__)			\
>  	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
>  
> +asmlinkage void verify_pre_usermode_state(void);
> +
> +#ifndef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
> +static inline bool has_user_ds(void) {
> +	bool ret = segment_eq(get_fs(), USER_DS);
> +	// Prevent re-ordering the call

This is not the kernel comments style. Use /* */ instead.

> +	barrier();
> +	return ret;
> +}
> +#else
> +static inline bool has_user_ds(void) {
> +	return false;
> +}
> +#endif

... and then you could slim down the ifdeffery a bit:

static inline bool has_user_ds(void) {
	bool ret = false;

#ifndef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
	ret = segment_eq(get_fs(), USER_DS);
	/* Prevent re-ordering the call. */
	barrier();
#endif

	return ret;
}

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.

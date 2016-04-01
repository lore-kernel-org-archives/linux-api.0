From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH] x86: Add a turbo mode sysctl
Date: Fri, 1 Apr 2016 18:05:56 +0200
Message-ID: <20160401160556.GB25391@pd.tnic>
References: <cd6157244ae75145e2529a1d73f6174cd829ac9c.1459525715.git.luto@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cd6157244ae75145e2529a1d73f6174cd829ac9c.1459525715.git.luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Apr 01, 2016 at 08:49:53AM -0700, Andy Lutomirski wrote:
> Sadly, hardware turbo mode buttons are few and far between in these
> degenerate times.  Add a software control at /proc/sys/turbo_mode.
> 
> Unfortunately, Linux graphical environments have become very
> heavy-weight and are essentially unusable on non-Turbo systems.  The
> VT console works very well, though.
> 
> Due to KVM limitations, turbo mode is permanently on in a KVM guest.
> 
> Signed-off-by: Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  arch/x86/mm/pat.c | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 61 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
> index faec01e7a17d..f703d8b1ed20 100644
> --- a/arch/x86/mm/pat.c
> +++ b/arch/x86/mm/pat.c
> @@ -69,6 +69,8 @@ static int __init pat_debug_setup(char *str)
>  }
>  __setup("debugpat", pat_debug_setup);
>  
> +static int turbo_mode = 1;
> +
>  #ifdef CONFIG_X86_PAT
>  /*
>   * X86 PAT uses page flags arch_1 and uncached together to keep track of
> @@ -176,6 +178,62 @@ static enum page_cache_mode pat_get_cache_mode(unsigned pat_val, char *msg)
>  
>  #undef CM
>  
> +#define PAT(x, y)	((u64)PAT_ ## y << ((x)*8))
> +
> +static void update_local_turbo_mode(void *dummy)
> +{
> +	unsigned long cr0 = read_cr0();
> +
> +	/*
> +	 * KVM doesn't properly handle CD.
> +	 *
> +	 * XXX: this may interact poorly with CPU hotplug.
> +	 */
> +
> +	if (turbo_mode)
> +		write_cr0(cr0 & ~X86_CR0_CD);
> +	else
> +		write_cr0(cr0 | X86_CR0_CD);

Good!

> +}
> +
> +static void update_turbo_mode(void)
> +{
> +	on_each_cpu(update_local_turbo_mode, NULL, 1);
> +
> +	if (!turbo_mode)
> +		wbinvd();
> +}
> +
> +static int turbo_mode_handler(struct ctl_table *table, int write,
> +			      void __user *buffer, size_t *lenp,
> +			      loff_t *ppos)
> +{
> +        int error;
> +
> +        error = proc_dointvec_minmax(table, write, buffer, lenp, ppos);
> +        if (error)
> +                return error;
> +
> +        if (write)
> +		update_turbo_mode();
> +
> +        return 0;
> +}
> +
> +static int zero, one = 1;
> +static struct ctl_table turbo_mode_table[] = {
> +	{
> +		.procname	= "turbo_mode",

I'd call that "make_shit_faster". Other than that, ACK!

> +		.data		= &turbo_mode,
> +		.maxlen		= sizeof(int),
> +		.mode		= 0644,
> +		.proc_handler	= turbo_mode_handler,
> +		.extra1		= &zero,
> +		.extra2		= &one,
> +	},
> +	{}
> +};
> +
>  /*
>   * Update the cache mode to pgprot translation tables according to PAT
>   * configuration.
> @@ -196,8 +254,6 @@ void pat_init_cache_modes(u64 pat)
>  	pr_info("x86/PAT: Configuration [0-7]: %s\n", pat_msg);
>  }
>  
> -#define PAT(x, y)	((u64)PAT_ ## y << ((x)*8))
> -
>  static void pat_bsp_init(u64 pat)
>  {
>  	u64 tmp_pat;
> @@ -1096,6 +1152,9 @@ static int __init pat_memtype_list_init(void)
>  		debugfs_create_file("pat_memtype_list", S_IRUSR,
>  				    arch_debugfs_dir, NULL, &memtype_fops);
>  	}
> +
> +	register_sysctl_table(turbo_mode_table);
> +
>  	return 0;
>  }
>  
> -- 
> 2.5.5
> 
> 

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.

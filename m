From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3] seccomp: add ptrace options for suspend/resume
Date: Fri, 5 Jun 2015 23:52:08 +0200
Message-ID: <20150605215208.GA27105@redhat.com>
References: <1433539312-3999-1-git-send-email-tycho.andersen@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433539312-3999-1-git-send-email-tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Tycho,

I hate myself, but I have another nit ;) again, it is not that I think
you should updtate the patch, just fyi...

On 06/05, Tycho Andersen wrote:
>
> --- a/include/linux/seccomp.h
> +++ b/include/linux/seccomp.h
> @@ -95,4 +95,14 @@ static inline void get_seccomp_filter(struct task_struct *tsk)
>  	return;
>  }
>  #endif /* CONFIG_SECCOMP_FILTER */
> +
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +extern bool may_suspend_seccomp(void);
> +#else
> +static inline bool may_suspend_seccomp(void)
> +{
> +	return false;
> +}
> +#endif

This looks wrong. There is no "extern may_suspend_seccomp()" if
CONFIG_SECCOMP=n, kernel/seccomp.c is not compiled. So you need another
ifdef(CONFIG_SECCOMP).

At the same time this does not matter and you do not need the dummy
"inline" version at all:

> @@ -556,6 +557,15 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
>  	if (data & ~(unsigned long)PTRACE_O_MASK)
>  		return -EINVAL;
>  
> +	if (unlikely(data & PTRACE_O_SUSPEND_SECCOMP)) {
> +		if (!config_enabled(CONFIG_CHECKPOINT_RESTORE) ||
> +		    !config_enabled(CONFIG_SECCOMP))
> +			return -EINVAL;
> +
> +		if (!may_suspend_seccomp())
> +			return -EPERM;

gcc will optimize out may_suspend_seccomp() unless both options are
enabled.

Oleg.

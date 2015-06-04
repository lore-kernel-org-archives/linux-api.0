From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] seccomp: add ptrace options for suspend/resume
Date: Thu, 4 Jun 2015 20:31:49 +0200
Message-ID: <20150604183149.GA560@redhat.com>
References: <1433369396-13360-1-git-send-email-tycho.andersen@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433369396-13360-1-git-send-email-tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tycho Andersen <tycho.andersen-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Roland McGrath <roland-/Z5OmTQCD9xF6kxbq+BtvQ@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 06/03, Tycho Andersen wrote:
>
> @@ -556,6 +557,11 @@ static int ptrace_setoptions(struct task_struct *child, unsigned long data)
>  	if (data & ~(unsigned long)PTRACE_O_MASK)
>  		return -EINVAL;
>
> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +	if (data & PTRACE_O_SUSPEND_SECCOMP && !may_suspend_seccomp())
> +		return -EPERM;
> +#endif
> +

Well. This -EPERM doesn't look consistent...

if config_enabled(CONFIG_CHECKPOINT_RESTORE) == F, we return success
but PTRACE_O_SUSPEND_SECCOMP has no effect because of another ifdef in
seccomp.

OTOH, if CONFIG_SECCOMP=n, this option has no effect too but we return
-EPERM even.

Also. Suppose that the tracer sets SUSPEND_SECCOMP and then drops
CAP_SYS_ADMIN. After that it can't set or clear other ptrace options.

So if we really want the security checks (I still think we do not ;)
then we should probably check "flags & SUSPEND_SECCOMP" as well.

> +#ifdef CONFIG_CHECKPOINT_RESTORE
> +bool may_suspend_seccomp(void)
> +{
> +	if (!capable(CAP_SYS_ADMIN))
> +		return false;
> +
> +	if (current->seccomp.mode != SECCOMP_MODE_DISABLED)
> +		return false;

Heh. OK, I won't argue with the new check too ;)

Oleg.

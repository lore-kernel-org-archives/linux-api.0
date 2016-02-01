From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas
 within sighandler
Date: Mon, 1 Feb 2016 17:06:25 +0100
Message-ID: <20160201160625.GA18276@redhat.com>
References: <56AE3369.2090709@list.ru>
 <56AE3626.7080706@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56AE3626.7080706-cmBhpYW9OiY@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Cc: Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Honestly, I am not sure I understand what this patch does and why, and it is
white space damaged, please fix.

On 01/31, Stas Sergeev wrote:
>
> linux implements the sigaltstack() in a way that makes it impossible to
> use with swapcontext(). Per the man page, sigaltstack is allowed to return
> EPERM if the process is altering its sigaltstack while running on
> sigaltstack.
> This is likely needed to consistently return oss->ss_flags, that indicates
> whether the process is being on sigaltstack or not.
> Unfortunately, linux takes that permission to return EPERM too literally:
> it returns EPERM even if you don't want to change to another sigaltstack,
> but only want to temporarily disable sigaltstack with SS_DISABLE.
> You can't use swapcontext() without disabling sigaltstack first, or the
> stack will be re-used and overwritten by a subsequent signal.

So iiuc you want to switch the stack from the signal handler running on the
alt stack, and you need to ensure that another SA_ONSTACK signal won't corrupt
the alt stack in between, right?

Perhaps you can update the changelog to explain why do we want this change.


> @@ -2550,8 +2551,11 @@ static inline int sas_ss_flags(unsigned long sp)
>  {
>      if (!current->sas_ss_size)
>          return SS_DISABLE;
> -
> -    return on_sig_stack(sp) ? SS_ONSTACK : 0;
> +    if (on_sig_stack(sp))
> +        return SS_ONSTACK;
> +    if (current->sas_ss_flags == SS_DISABLE)
> +        return SS_DISABLE;
> +    return 0;

So this always return SS_ONSTACK if on_sig_stack(), see below.

> +        onsigstack = on_sig_stack(sp);
> +        if (ss_size == 0) {
> +            switch (ss_flags) {
> +            case 0:
> +                error = -EPERM;
> +                if (onsigstack)
> +                    goto out;
> +                current->sas_ss_sp = 0;
> +                current->sas_ss_size = 0;
> +                current->sas_ss_flags = SS_DISABLE;
> +                break;
> +            case SS_ONSTACK:
> +                /* re-enable previously disabled sas */
> +                error = -EINVAL;
> +                if (current->sas_ss_size == 0)
> +                    goto out;
> +                break;
> +            default:
> +                break;
> +            }

and iiuc the "default" case allows you to write SS_DISABLE into ->sas_ss_flags
even if on_sig_stack().

So the sequence is

	// running on alt stack

	sigaltstack(SS_DISABLE);

	temporary_run_on_another_stack();

	sigaltstack(SS_ONSTACK);

and SS_DISABLE saves us from another SA_ONSTACK signal, right?

But afaics it can only help after we change the stack. Suppose that SA_ONSTACK signal
comess before temporary_run_on_another_stack(). get_sigframe() should be fine after
your changes (afaics), it won't pick the alt stack after SS_DISABLE.

However, unless I missed something save_altstack_ex() will record SS_ONSTACK in
uc_stack->ss_flags, and after return from signal handler restore_altstack() will
enable alt stack again?

Oleg.

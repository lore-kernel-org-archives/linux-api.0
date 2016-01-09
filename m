From: Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH 2/2] sigaltstack: remove EPERM check to make swapcontext() usable
Date: Fri, 8 Jan 2016 18:03:33 -0800
Message-ID: <CALCETrUAPqhrt9UjKt5=n=R-Ao7g-emDtt34YXZgyhr3TuFu9w@mail.gmail.com>
References: <56905B90.6060505@list.ru> <56905FF0.4040406@list.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56905FF0.4040406@list.ru>
Sender: linux-kernel-owner@vger.kernel.org
To: Stas Sergeev <stsp@list.ru>
Cc: Linux kernel <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Amanieu d'Antras <amanieu@gmail.com>, Richard Weinberger <richard@nod.at>, Palmer Dabbelt <palmer@dabbelt.com>, Vladimir Davydov <vdavydov@parallels.com>
List-Id: linux-api@vger.kernel.org

On Fri, Jan 8, 2016 at 5:18 PM, Stas Sergeev <stsp@list.ru> wrote:
>
> linux implements the sigaltstack() in a way that makes it impossible to
> use with swapcontext(). Per the man page, sigaltstack is allowed to return
> EPERM if the process is altering its sigaltstack while running on
> sigaltstack.
> This is likely needed to consistently return oss->ss_flags, that indicates
> whether the process is being on sigaltstack or not.
> Unfortunately, linux takes that permission to return EPERM too literally:
> it returns EPERM even if you don't want to change to another sigaltstack,
> but only want to disable sigaltstack with SS_DISABLE.
> You can't use swapcontext() without disabling sigaltstack first, or the
> stack will be re-used and overwritten by a subsequent signal.
>
> With this patch, disabling sigaltstack inside a signal handler became
> possible, and the swapcontext() can then be used safely. The oss->ss_flags
> will then return SS_DISABLE, which doesn't seem to contradict the
> (very ambiguous) man page wording, namely:
>        SS_ONSTACK
>               The process is currently executing on the alternate signal
>               stack. (Note that it is not possible to change the alternate
>               signal stack if the process is currently executing on it.)

You're definitely contradicting the "Note" part, though.  POSIX is
quite clear, too:

"Attempts to modify the alternate signal stack while the process is
executing on it fail."

> diff --git a/kernel/signal.c b/kernel/signal.c
> index f3f1f7a..0a6af54 100644
> --- a/kernel/signal.c
> +++ b/kernel/signal.c
> @@ -3111,18 +3111,13 @@ do_sigaltstack (const stack_t __user *uss, stack_t
> __user *uoss, unsigned long s
>          if (error)
>              goto out;
>
> -        error = -EPERM;
> -        if (on_sig_stack(sp))
> -            goto out;
> -
> -        error = -EINVAL;
>          /*
> -         * Note - this code used to test ss_flags incorrectly:
> -         *        old code may have been written using ss_flags==0
> -         *      to mean ss_flags==SS_ONSTACK (as this was the only
> -         *      way that worked) - this fix preserves that older
> -         *      mechanism.
> +         * Note - this code used to test on_sig_stack(sp) and
> +         * return -EPERM. But we need at least SS_DISABLE to
> +         * work while on sigaltstack, so the check was removed.


That old comment was simply incorrect.  POSIX says:

       The ss_flags member specifies the new stack state.
       If it is set to SS_DISABLE, the stack is disabled and ss_sp and ss_size
       are  ignored.  Otherwise, the stack shall be enabled, and the ss_sp and
       ss_size members specify the new address and size of the stack.

Zero is perfectly valid.  That being said, Linux has apparently
rejected non-zero non-SA_ONSTACK values for a long time, so we should
be fine.

I think it would be safer and more posixly correct to change the
behavior differently:

ss_flags == 0 or SS_DISABLE or SS_ONSTACK: preserve old Linux behavior.

ss_flags == SS_DISABLE | SS_FORCE: disable the altstack regardless of
whether we're executing on it.

ss_flags == SS_ONSTACK | SS_FORCE: change the altstack regardless of
whether we're executing on it.

ss_flags == anything else (including SS_FORCE by itself): -EINVAL

This has some benefits.  Mainly, with this change, we're more
POSIX-violating than we were -- any users who didn't get EINVAL before
aren't unaffected.

Users of SS_FORCE are required to be very careful with nested signals.
In particular, changing the altstack using SS_ONSTACK | SS_FORCE is
very dangerous: if a user does that, then gets a signal, and the
signal handler uses SS_ONSTACK | SS_FORCE to change back to the old
altstack, and then another signal is delivered, a crash will result.
The manpage patch should mention that caveat.

--Andy

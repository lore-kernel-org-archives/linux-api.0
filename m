From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 3.17-rc5] Fix confusing PFA_NO_NEW_PRIVS constant.
Date: Sat, 20 Sep 2014 10:19:56 -0700
Message-ID: <CAGXu5jLf3st2WBV5ycEOgCJGk8z5TP1SuvLQcD=sC2cs_4CF8w@mail.gmail.com>
References: <201409192053.IHJ35462.JLOMOSOFFVtQFH@I-love.SAKURA.ne.jp>
	<541D16EA.70407@huawei.com>
	<201409201940.AHG21834.LJOFFHSFQOtVMO@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201409201940.AHG21834.LJOFFHSFQOtVMO-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, James Morris <james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Kerrisk-manpages <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julien Tinnes <jln-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Linux MIPS Mailing List <linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sat, Sep 20, 2014 at 3:40 AM, Tetsuo Handa
<penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org> wrote:
> Can you apply below patch before new PFA_* are defined?
> Cgroups code might want to define PFA_SPREAD_PAGE as 1 and PFA_SPREAD_SLAB as 2.
> ----------------------------------------
> >From 8543e68adb210142fa347d8bc9d83df0bb2c5291 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> Date: Sat, 20 Sep 2014 19:24:23 +0900
> Subject: [PATCH 3.17-rc5] Fix confusing PFA_NO_NEW_PRIVS constant.
>
> Commit 1d4457f99928 ("sched: move no_new_privs into new atomic flags")
> defined PFA_NO_NEW_PRIVS as hexadecimal value, but it is confusing
> because it is used as bit number. Redefine it as decimal bit number.
>
> Signed-off-by: Tetsuo Handa <penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org>
> ---
>  include/linux/sched.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 5c2c885..4557765 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1957,7 +1957,7 @@ static inline void memalloc_noio_restore(unsigned int flags)
>  }
>
>  /* Per-process atomic flags. */
> -#define PFA_NO_NEW_PRIVS 0x00000001    /* May not gain new privileges. */
> +#define PFA_NO_NEW_PRIVS 0     /* May not gain new privileges. */
>
>  static inline bool task_no_new_privs(struct task_struct *p)
>  {

Thanks, good catch.

Acked-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

-Kees

-- 
Kees Cook
Chrome OS Security

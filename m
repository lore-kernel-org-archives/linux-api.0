From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: Re: [PATCH 1/2] sigaltstack: implement SS_AUTODISARM flag
Date: Sun, 6 Mar 2016 23:17:16 +0300
Message-ID: <56DC904C.2060708@list.ru>
References: <1456781345-8243-1-git-send-email-stsp@list.ru>
 <1456781345-8243-2-git-send-email-stsp@list.ru>
 <CALCETrVhtHdiS_W3WuCi1bTH78uoTSCHW2MN9hA36=h56-A3oA@mail.gmail.com>
 <CALCETrW=M1=n6R6dwOj-ks_=+14vf4rz0S3SFty-_GuwFFZU5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrW=M1=n6R6dwOj-ks_=+14vf4rz0S3SFty-_GuwFFZU5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stas Sergeev <stsp-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: linux-api@vger.kernel.org

06.03.2016 23:10, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Sun, Mar 6, 2016 at 12:07 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org=
> wrote:
>> On Mon, Feb 29, 2016 at 1:29 PM, Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org> wrote:
>>> This patch implements the SS_AUTODISARM flag that can be ORed with
>>> SS_ONSTACK when forming ss_flags.
>>> When this flag is set, sigaltstack will be disabled when entering
>>> the signal handler; more precisely, after saving sas to uc_stack.
>>> When leaving the signal handler, the sigaltstack is restored by
>>> uc_stack.
>>> When this flag is used, it is safe to switch from sighandler with
>>> swapcontext(). Without this flag, the subsequent signal will corrup=
t
>>> the state of the switched-away sighandler.
>>>
>>> CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>>> CC: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>
>>> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>>> CC: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> CC: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>>> CC: Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>
>>> CC: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>
>>> CC: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> CC: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> CC: Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>
>>> CC: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
>>> CC: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
>>> CC: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
>>> CC: "Amanieu d'Antras" <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>>> CC: Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> CC: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>>> CC: Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>
>>> CC: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
>>> CC: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>>> CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
>>>
>>> Signed-off-by: Stas Sergeev <stsp-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
>>> ---
>>>   include/linux/sched.h       |  8 ++++++++
>>>   include/linux/signal.h      |  4 +++-
>>>   include/uapi/linux/signal.h |  3 +++
>>>   kernel/fork.c               |  2 +-
>>>   kernel/signal.c             | 23 ++++++++++++-----------
>>>   5 files changed, 27 insertions(+), 13 deletions(-)
>>>
>>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>>> index a10494a..26201cd 100644
>>> --- a/include/linux/sched.h
>>> +++ b/include/linux/sched.h
>>> @@ -1587,6 +1587,7 @@ struct task_struct {
>>>
>>>          unsigned long sas_ss_sp;
>>>          size_t sas_ss_size;
>>> +       unsigned sas_ss_flags;
>>>
>>>          struct callback_head *task_works;
>>>
>>> @@ -2573,6 +2574,13 @@ static inline int sas_ss_flags(unsigned long=
 sp)
>>>          return on_sig_stack(sp) ? SS_ONSTACK : 0;
>>>   }
>>>
>>> +static inline void sas_ss_reset(struct task_struct *p)
>>> +{
>>> +       p->sas_ss_sp =3D 0;
>>> +       p->sas_ss_size =3D 0;
>>> +       p->sas_ss_flags =3D SS_DISABLE;
>>> +}
>>> +
>>>   static inline unsigned long sigsp(unsigned long sp, struct ksigna=
l *ksig)
>>>   {
>>>          if (unlikely((ksig->ka.sa.sa_flags & SA_ONSTACK)) && ! sas=
_ss_flags(sp))
>>> diff --git a/include/linux/signal.h b/include/linux/signal.h
>>> index 92557bb..3fbe814 100644
>>> --- a/include/linux/signal.h
>>> +++ b/include/linux/signal.h
>>> @@ -432,8 +432,10 @@ int __save_altstack(stack_t __user *, unsigned=
 long);
>>>          stack_t __user *__uss =3D uss; \
>>>          struct task_struct *t =3D current; \
>>>          put_user_ex((void __user *)t->sas_ss_sp, &__uss->ss_sp); \
>>> -       put_user_ex(sas_ss_flags(sp), &__uss->ss_flags); \
>>> +       put_user_ex(t->sas_ss_flags, &__uss->ss_flags); \
>>>          put_user_ex(t->sas_ss_size, &__uss->ss_size); \
>>> +       if (t->sas_ss_flags & SS_AUTODISARM) \
>>> +               sas_ss_reset(t); \
>>>   } while (0);
>>>
>>>   #ifdef CONFIG_PROC_FS
>>> diff --git a/include/uapi/linux/signal.h b/include/uapi/linux/signa=
l.h
>>> index e1bd50c2..4691bc5 100644
>>> --- a/include/uapi/linux/signal.h
>>> +++ b/include/uapi/linux/signal.h
>>> @@ -6,5 +6,8 @@
>>>
>>>   #define SS_ONSTACK     1
>>>   #define SS_DISABLE     2
>>> +#define SS_VALMASK     0xf
>> SS_MODE_MASK, perhaps?
> Actually, let's invert that.
>
> #define SS_AUTODISARM (1U << 31)
> #define SS_FLAG_BITS SS_AUTODISARM
>
> ss_mode =3D ss_flags & ~SS_FLAG_BITS;
>
> this way flag bits that are currently undefined will continue to trig=
ger EINVAL.
OK, will do.
Though I am still going to keep SS_AUTODISARM =3D(1 << 4) -
it doesn't matter from what side we add new flags, does it?

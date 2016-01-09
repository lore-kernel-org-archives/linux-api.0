From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: Re: [PATCH 2/2] sigaltstack: remove EPERM check to make swapcontext()
 usable
Date: Sat, 9 Jan 2016 05:49:42 +0300
Message-ID: <56907546.2050706@list.ru>
References: <56905B90.6060505@list.ru> <56905FF0.4040406@list.ru>
 <CALCETrUAPqhrt9UjKt5=n=R-Ao7g-emDtt34YXZgyhr3TuFu9w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUAPqhrt9UjKt5=n=R-Ao7g-emDtt34YXZgyhr3TuFu9w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

09.01.2016 05:03, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Fri, Jan 8, 2016 at 5:18 PM, Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org> wrote:
>> linux implements the sigaltstack() in a way that makes it impossible=
 to
>> use with swapcontext(). Per the man page, sigaltstack is allowed to =
return
>> EPERM if the process is altering its sigaltstack while running on
>> sigaltstack.
>> This is likely needed to consistently return oss->ss_flags, that ind=
icates
>> whether the process is being on sigaltstack or not.
>> Unfortunately, linux takes that permission to return EPERM too liter=
ally:
>> it returns EPERM even if you don't want to change to another sigalts=
tack,
>> but only want to disable sigaltstack with SS_DISABLE.
>> You can't use swapcontext() without disabling sigaltstack first, or =
the
>> stack will be re-used and overwritten by a subsequent signal.
>>
>> With this patch, disabling sigaltstack inside a signal handler becam=
e
>> possible, and the swapcontext() can then be used safely. The oss->ss=
_flags
>> will then return SS_DISABLE, which doesn't seem to contradict the
>> (very ambiguous) man page wording, namely:
>>         SS_ONSTACK
>>                The process is currently executing on the alternate s=
ignal
>>                stack. (Note that it is not possible to change the al=
ternate
>>                signal stack if the process is currently executing on=
 it.)
> You're definitely contradicting the "Note" part, though.  POSIX is
> quite clear, too:
>
> "Attempts to modify the alternate signal stack while the process is
> executing on it fail."
"modify" may not include "disable".
You don't modify the stack's location or size, just temporary disable=20
its use.
So I believe SS_DISABLE should be fine.
Of course this is just one of the possible interpretations.
But it is the one that looks simple and satisfies everyone.

>> diff --git a/kernel/signal.c b/kernel/signal.c
>> index f3f1f7a..0a6af54 100644
>> --- a/kernel/signal.c
>> +++ b/kernel/signal.c
>> @@ -3111,18 +3111,13 @@ do_sigaltstack (const stack_t __user *uss, s=
tack_t
>> __user *uoss, unsigned long s
>>           if (error)
>>               goto out;
>>
>> -        error =3D -EPERM;
>> -        if (on_sig_stack(sp))
>> -            goto out;
>> -
>> -        error =3D -EINVAL;
>>           /*
>> -         * Note - this code used to test ss_flags incorrectly:
>> -         *        old code may have been written using ss_flags=3D=3D=
0
>> -         *      to mean ss_flags=3D=3DSS_ONSTACK (as this was the o=
nly
>> -         *      way that worked) - this fix preserves that older
>> -         *      mechanism.
>> +         * Note - this code used to test on_sig_stack(sp) and
>> +         * return -EPERM. But we need at least SS_DISABLE to
>> +         * work while on sigaltstack, so the check was removed.
>
> That old comment was simply incorrect.  POSIX says:
>
>         The ss_flags member specifies the new stack state.
>         If it is set to SS_DISABLE, the stack is disabled and ss_sp a=
nd ss_size
>         are  ignored.  Otherwise, the stack shall be enabled, and the=
 ss_sp and
>         ss_size members specify the new address and size of the stack=
=2E
>
> Zero is perfectly valid.  That being said, Linux has apparently
> rejected non-zero non-SA_ONSTACK values for a long time, so we should
> be fine.
>
> I think it would be safer and more posixly correct to change the
> behavior differently:
>
> ss_flags =3D=3D 0 or SS_DISABLE or SS_ONSTACK: preserve old Linux beh=
avior.
>
> ss_flags =3D=3D SS_DISABLE | SS_FORCE: disable the altstack regardles=
s of
> whether we're executing on it.
I really dislike the idea of adding SS_FORCE just for SS_DISABLE.
I think it is sane to use SS_DISABLE in a sighandler, and it doesn't
conflict with one of the possible interpretations of posix.
So I wonder what other people think (add Linus to CC).

> ss_flags =3D=3D SS_ONSTACK | SS_FORCE: change the altstack regardless=
 of
> whether we're executing on it.
This is something that no one will likely ever need.
=46or SS_DISABLE there is a clear use-case: swapcontext().
So we _need_ to address the SS_DISABLE case.
But why do we care about SA_ONSTACK in a sighandler's case?
Someone later, if need be, can add it together with the SA_FORCE.

> Users of SS_FORCE are required to be very careful with nested signals=
=2E
> In particular, changing the altstack using SS_ONSTACK | SS_FORCE is
> very dangerous:
So how about just not allowing such SS_ONSTACK until
someone really needs it... This is more difficult to implement,
but possible. Would you really add a new flag for the funtionality
that is both dangerous and useless?

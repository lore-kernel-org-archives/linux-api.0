From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH v8 5/9] seccomp: split mode set routines
Date: Wed, 25 Jun 2014 10:03:42 -0700
Message-ID: <CALCETrVrs8sb19+UUqyFEpAFzTih5dkAwn-WpQjfgPcPJMpP5g@mail.gmail.com>
References: <1403642893-23107-1-git-send-email-keescook@chromium.org>
 <1403642893-23107-6-git-send-email-keescook@chromium.org> <20140625135121.GB7892@redhat.com>
 <CAGXu5jJkFxh4K=40xuh6tu3kUf4oJM8Dry+4upBdRieW3FNLgw@mail.gmail.com>
 <CALCETrUBNmLnpa+LM91om2RSpR6SjupP-EdefzhU1Me4nv3Dfw@mail.gmail.com> <CAGXu5j+J11zJnuFR8bYKAXizAHhCx4R+uJE_QH6zC3q2udkpaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAGXu5j+J11zJnuFR8bYKAXizAHhCx4R+uJE_QH6zC3q2udkpaQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alexei Starovoitov <ast-uqk4Ao+rVK5Wk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Borkmann <dborkman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Drewry <wad-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Julien Tinnes <jln-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Drysdale <drysdale-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-mips-6z/3iImG2C8G8FEW9MqTrA@public.gmane.org, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-security-module <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 25, 2014 at 9:54 AM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> On Wed, Jun 25, 2014 at 9:10 AM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Wed, Jun 25, 2014 at 7:51 AM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
>>> On Wed, Jun 25, 2014 at 6:51 AM, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>>>> On 06/24, Kees Cook wrote:
>>>>>
>>>>> +static inline void seccomp_assign_mode(struct task_struct *task,
>>>>> +                                    unsigned long seccomp_mode)
>>>>> +{
>>>>> +     BUG_ON(!spin_is_locked(&task->sighand->siglock));
>>>>> +
>>>>> +     task->seccomp.mode = seccomp_mode;
>>>>> +     set_tsk_thread_flag(task, TIF_SECCOMP);
>>>>> +}
>>>>
>>>> OK, but unless task == current this can race with secure_computing().
>>>> I think this needs smp_mb__before_atomic() and secure_computing() needs
>>>> rmb() after test_bit(TIF_SECCOMP).
>>>>
>>>> Otherwise, can't __secure_computing() hit BUG() if it sees the old
>>>> mode == SECCOMP_MODE_DISABLED ?
>>>>
>>>> Or seccomp_run_filters() can see ->filters == NULL and WARN(),
>>>> smp_load_acquire() only serializes that LOAD with the subsequent memory
>>>> operations.
>>>
>>> Hm, actually, now I'm worried about smp_load_acquire() being too slow
>>> in run_filters().
>>>
>>> The ordering must be:
>>> - task->seccomp.filter must be valid before
>>> - task->seccomp.mode is set, which must be valid before
>>> - TIF_SECCOMP is set
>>>
>>> But I don't want to impact secure_computing(). What's the best way to
>>> make sure this ordering is respected?
>>
>> Remove the ordering requirement, perhaps?
>>
>> What if you moved mode into seccomp.filter?  Then there would be
>> little reason to check TIF_SECCOMP from secure_computing; instead, you
>> could smp_load_acquire (or read_barrier_depends, maybe) seccomp.filter
>> from secure_computing and pass the result as a parameter to
>> __secure_computing.  Or you could even remove the distinction between
>> secure_computing and __secure_computing -- it's essentially useless
>> anyway to split entry hook approaches like my x86 fastpath prototype.
>
> The TIF_SECCOMP is needed for the syscall entry path. The check in
> secure_computing() is just because the "I am being traced" trigger
> includes a call to secure_computing, which filters out tracing
> reasons.

Right.  I'm suggesting just checking a single indication that seccomp
is on from the process in the seccomp code so that the order doesn't
matter.

IOW, TIF_SECCOMP causes __secure_computing to be invoked, but the race
only seems to matter because of the warning and the BUG.  I think that
both can be fixed if you merge mode into filter so that
__secure_computing atomically checks one condition.

>
> Your fast path work would clean a lot of that up, as you say. But it
> still doesn't change the ordering check here. TIF_SECCOMP indicates
> seccomp.mode must be checked, so that ordering will remain, and if
> mode == FILTER, seccomp.filter must be valid.
>
> Isn't there a way we can force the assignment ordering in seccomp_assign_mode()?

Write the filter, then smp_mb (or maybe a weaker barrier is okay),
then set the bit.

--Andy

>
> -Kees
>
> --
> Kees Cook
> Chrome OS Security



-- 
Andy Lutomirski
AMA Capital Management, LLC

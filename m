From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: Re: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas
 within sighandler
Date: Mon, 1 Feb 2016 02:45:16 +0300
Message-ID: <56AE9C8C.1070405@list.ru>
References: <56AE3369.2090709@list.ru> <56AE3626.7080706@list.ru>
 <CALCETrU1sB4FDkyrGcxY0CrCRr7qyGW0tzmpyaQDwM0UTjCRMw@mail.gmail.com>
 <56AE4567.9000403@list.ru>
 <CALCETrUVODhNRwvbAfC0q3RVJAFw-ZFGhsww2uQsk3UZjLynnQ@mail.gmail.com>
 <56AE69AD.6090005@list.ru>
 <CALCETrXPYLqunBNxjS8bpmpg+jG_MXbSyZtUVK3X3m+pGSQ1Og@mail.gmail.com>
 <56AE8C80.6030408@list.ru>
 <CALCETrU2u7h98oqtMcgvU54j21-bpTfBXUEJNQO9r1w5FHc-HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrU2u7h98oqtMcgvU54j21-bpTfBXUEJNQO9r1w5FHc-HQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

01.02.2016 01:44, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Sun, Jan 31, 2016 at 2:36 PM, Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org> wrote:
>> 31.01.2016 23:11, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>> On Sun, Jan 31, 2016 at 12:08 PM, Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org> wrote=
:
>>>> 31.01.2016 22:03, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>>>> Also, consider a use case like yours but with *two* contexts that=
 use
>>>>> their own altstack.  If you go to context A, enable sigaltstack, =
get a
>>>>> signal, temporarily disable, then swapcontext to B, which tries t=
o
>>>>> re-enable its own sigaltstack, then everything gets confusing wit=
h
>>>>> your patch, because, with your patch, the kernel is only tracking=
 one
>>>>> temporarily disabled sigaltstack.
>>>> Of course the good practice is to set the sigaltstack
>>>> before creating the contexts. Then the above scenario
>>>> should involve switching between 2 signal handlers to get
>>>> into troubles. I think the scenario with switching between
>>>> 2 signal handlers is very-very unrealistic.
>>> Why is it so unrealistic?  You're already using swapcontext, which
>>> means you're doing something like userspace threads (although I
>>> imagine that one of your thread-like things is DOS, but still), and=
,
>>> to me, that suggests that the kernel interface should be agnostic a=
s
>>> to how many thread-like thinks are alive.
>> But you only get into troubles when you switch between 2
>> _active signal handlers_, rather than between 2 normal contexts,
>> or between 2 normal context and 1 sighandler.
>> So I am probably misunderstanding the scenario you describe.
>> Without 2 sighandlers that are active at the same time and you
>> switch between them, how would you get into troubles?
>> You say "then swapcontext to B, which tries to re-enable its own
>> sigaltstack"
>> but there can be only one sigaltstack per thread, so I am quite
>> sure by re-enabling "its own sigaltstack" it will still do the right
>> thing.
> As long as the kernel has a concept of a programmed but disabled
> sigaltstack, something is confused when there is more than one
> user-created inactive sigaltstack.
I simply don't understand how can we have more than one
sigaltstack per thread. Is this supported? If not then I don't
expect the different non-sighandler user contexts trying to
set up the different ones. So you are probably talking about
2 sighandlers switching between each other, right? And that
case is likely broken anyway.

>    So I don't see why you want the
> kernel to remember about disabled altstacks at all.
2 reasons:
- Language-lawyering around POSIX
- Consistently return oss->ss_flags when we are on a signal stack
Restoring the old sas is not among the goals, but allowing the
sighandler to freely install the new sas (as you suggest) is a clear
contradiction to POSIX. So that's why you propose SS_FORCE, yes,
but then the question: will _anyone_ use sigaltstack(SS_ONSTACK)
in a sighandler without SS_FORCE? And the answer is likely "no".
In which case your SS_FORCE erodes to "I run it from sighandler"
but this info the kernel already knows.

>> I don't think this is the problem because only the signal handler
>> should re-enable the sigaltstack, and I don't think we really should
>> switch between 2 active signal handlers. And even if we did, there
>> can be only one sigaltstack per thread, so it will re-enable always
>> the right stack (there is only one).
> Why would there only be one per thread?
If you mean every sighandler installs its own, then I think
switching between such sighandlers is broken anyway.
If you mean the non-sighandler contexts should install multiple
sigaltstacks, then I don't think this is supported or can work.

>>> ISTM it would be simpler if you did:
>>>
>>> sigaltstack(disable, force)
>>> swapcontext() to context using sigaltstack
>>> sigaltstack(set new altstack)
>>>
>>> and then later
>>>
>>> sigaltstack(disable, force)  /* just in case.  save old state, too.=
 */
>>> swapcontext() to context not using sigaltstack
>>> sigaltstack(set new altstack)
>> In the real world you don't even need sigaltstack(set new altstack)
>> because uc_stack does this for you on rt_sigreturn. It is only my
>> test-case that does so.
> That's only the case if swapcontext is implemented using rt_sigreturn=
=2E  Is it?
No, its when you use SA_SIGINFO with sigaction().
Then the sigaltstack will magically restore itself once you
leave the sighandler. That's why I wouldn't suggest to ever
modify the sas inside the sighandler the way you propose:
it will simply not work, uc_stack will set it back. My re-enable
trick is at least in agreement with uc_stack.

>>> If it would be POSIX compliant to allow SS_DISABLE to work even if =
on
>>> the altstack even without a new flag (which is what you're
>>> suggesting), then getting rid of the temporary in-kernel state woul=
d
>>> considerably simplify this patch series.  Just skip the -EPERM chec=
k
>>> in the disable path.
>> Yes, that's why I was suggesting to just remove the EPERM
>> check initially. We can still do exactly that. The only problem I
>> can see with removing EPERM is that it would be hard to emulate
>> the old behaviour if need be. For example if glibc want to return
>> EPERM behaviour, it will have problems doing so because oss->ss_flag=
s
>> doesn't say if we are on a sigaltstack and there is no other way
>> to find out.
> ...which is why I suggested SS_FORCE in the first place.
I understand. With SS_FORCE there is no temptation to emulate
the old behaviour, so there may be a fewer need to look into
oss->sa_flags even when you return it an inconsistent ways.

We probably should make a summary of our findings or they
will be forgotten.
So far I was pointing to a couple of minor problems with SS_FORCE:
- bypasses overflow protection
- prevents from asking the kernel if we are on sigaltstack or not
=2E.. and a few that I consider more important:
- does not bring any value other than to say "I am calling from sighand=
ler"
- allows the programmer to freely modify sas while later it will
still be reset with uc_stack
(and I've likely forgot some already)

There are the upsides compared to just removing EPERM:
- fewer need to look into oss->sa_flags, so its inconsistency
became forgivable
(have I missed something else? please fill in)

There are the upsides compared to remembering the ss_flags:
- simpler code
- slightly better semantic wrt kernel threads (with my approach
restoring the context on a different kernel thread, will require
setting a separate sas there instead of restoring... but I am not
sure this is a considerably bad semantic because whoever messes
with kernel threads this way, should know how to propoerly
set sigaltstacks)

So from that summary I can agree that SS_FORCE may from
some POV be better than simply removing EPERM, as they both
share the downsides, with SS_FORCE providing minor advantages.
But I still don't see it beating my new approach.

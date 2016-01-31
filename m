From: Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org>
Subject: Re: [PATCH 4/4] sigaltstack: allow disabling and re-enabling sas
 within sighandler
Date: Sun, 31 Jan 2016 23:08:13 +0300
Message-ID: <56AE69AD.6090005@list.ru>
References: <56AE3369.2090709@list.ru> <56AE3626.7080706@list.ru>
 <CALCETrU1sB4FDkyrGcxY0CrCRr7qyGW0tzmpyaQDwM0UTjCRMw@mail.gmail.com>
 <56AE4567.9000403@list.ru>
 <CALCETrUVODhNRwvbAfC0q3RVJAFw-ZFGhsww2uQsk3UZjLynnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrUVODhNRwvbAfC0q3RVJAFw-ZFGhsww2uQsk3UZjLynnQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Linux kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Amanieu d'Antras <amanieu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>, Heinrich Schuchardt <xypron.glpk-Mmb7MZpHnFY@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, Paul Moore <pmoore-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Palmer Dabbelt <palmer-96lFi9zoCfxBDgjK7y7TUQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

31.01.2016 22:03, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On Sun, Jan 31, 2016 at 9:33 AM, Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org> wrote:
>> 31.01.2016 20:00, Andy Lutomirski =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
>>> On Sun, Jan 31, 2016 at 8:28 AM, Stas Sergeev <stsp-cmBhpYW9OiY@public.gmane.org> wrote:
>>>> linux implements the sigaltstack() in a way that makes it impossib=
le to
>>>> use with swapcontext(). Per the man page, sigaltstack is allowed t=
o
>>>> return
>>>> EPERM if the process is altering its sigaltstack while running on
>>>> sigaltstack.
>>>> This is likely needed to consistently return oss->ss_flags, that
>>>> indicates
>>>> whether the process is being on sigaltstack or not.
>>>> Unfortunately, linux takes that permission to return EPERM too lit=
erally:
>>>> it returns EPERM even if you don't want to change to another sigal=
tstack,
>>>> but only want to temporarily disable sigaltstack with SS_DISABLE.
>>>> You can't use swapcontext() without disabling sigaltstack first, o=
r the
>>>> stack will be re-used and overwritten by a subsequent signal.
>>>>
>>>> With this patch, disabling sigaltstack inside a signal handler bec=
ame
>>>> possible, and the swapcontext() can then be used safely. After swi=
tching
>>>> back to the sighandler, the app can re-enable the sigatlstack.
>>>> The oss->ss_flags will correctly indicate the current use of sigal=
tstack,
>>>> even if it is temporarily disabled. Any attempt to modify the siga=
ltstack
>>>> (rather than to disable or re-enable it) within the sighandler, wi=
ll
>>>> still
>>>> be punished with EPERM as suggested by POSIX.
>>> This seems considerably more complicated than my previous proposal =
to
>>> add an SS_FORCE flag to say "I know what I'm doing.  Ignore POSIX a=
nd
>>> let me change the sigaltstack configuration even if it's in use".
>>> What's the advantage?
>> To me, the main advantage is to stay POSIX-compatible, rather
>> than adding the linux-specific flag. Please note that this flag does
>> not add any value other than to say "I want to ignore POSIX here"
>> in your interpretation of POSIX, and in my interpretation it doesn't
>> say even this, because in my interpretation the temporary disabling
>> is not prohibited.
> POSIX says nothing about temporary anything.  It says:
>
>         SS_ONSTACK  The process is currently executing on the alterna=
te  signal
>                     stack.  Attempts to modify the alternate signal s=
tack while
>                     the process is executing on it fail. This flag sh=
all not be
>                     modified by processes.
>
> It's a bit ambiguous because "Attempts to modify the alternate signal
> stack while the process is executing on it fail." is under SS_ONSTACK=
,
> so it's not quite clear whether SS_DISABLE is *also* supposed to fail
> if on the stack.
I think you are quoting the discription of the "oss" struct,
i.e. the one that is returned. It is correctly saying that when
SS_ONSTACK is _returned_, you can't modify the alternate
stack. So you likely confuse the above quote with the value
that is being set, not returned.
The ambiguity I am pointing to, is different. Above says you
can't _modify_ the sas. Modify likely means the modification
after which SS_ONSTACK will not be returned any more, i.e.
set to the different location. And I am not modifying it, and
the proof is that SS_ONSTACK is still returned as before.

>> So if it doesn't even fit my interpretation, how would
>> I write a man description for it? I'll have to first clarify the vag=
ue
>> wording to clearly sound your way, and then add the flag to override
>> this. This whole procedure looks very illogical to me. So to find ou=
t
>> if it is just me, I'd like to hear from anyone else supporting the i=
dea
>> of adding this flag. If people think its existence is justified, the=
n fine.
>> But to me this flag is non-portable, while the both sigaltstack() an=
d
>> swapcontext() are portable. So what will I gain with adding a
>> non-portable flag to my apps? A bunch of ifdefs?
>> IMHO as long as both swapcontext() and sigaltstack() are POSIX-compa=
tible,
>> they should be compatible with each other in a POSIX-compatible
>> way. If POSIX needs the linux-specific flags to make them compatible
>> with each other, then POSIX is inconsistent. So lets just don't inte=
rpret
>> it the way that makes it so.
> What do other operating systems do here?  You might be stuck with
> Linux-specific code here no matter what.  If you're causing Linux to
> match FreeBSD, that's a different store.
Likely not.
But the most intuitive way for the programmer is to just
use SS_DISABLE so I wonder if some OSes allow that.
=46reeBSD seems not quite the case though:
http://www.hpdc.syr.edu/~chapin/cis657/FreeBSD_5.2.1_Doxygen/kern__sig_=
8c-source.html
So I don't know how they solve the swapcontext() problem.
Perhaps I should ask them.

>> So in short:
>> Your concern is the patch complexity. Doing things your way will
>> however move the problem to the user: he will have to deal with the
>> linux-specific flags and add ifdefs for just a mere use of a
>> posix-compatible
>> interfaces.
>>
>> There can also be the subtle technical differences.
>> With your approach the nested signal can AFAIU overflow the
>> the disabled sigaltstack because you don't maintain the oss->ss_flag=
s
>> in a consistent way. There is an overflow protection code:
>> ---
>> /*
>>   * If we are on the alternate signal stack and would overflow it, d=
on't.
>>   * Return an always-bogus address instead so we will die with SIGSE=
GV.
>>   */
>>   if (onsigstack && !likely(on_sig_stack(sp)))
>>           return (void __user *)-1L;
>> ---
>> In your approach it will be bypassed.
>> And its not possible for an app to find out if it is running on a
>> sigaltstack now or not, after it is disabled.
> An app can figure out if it's on the altstack the same way the kernel
> does.
With inline asm or register variable, not good for portability.
And only if it knows at the particular place to where was the
alt stack set before.
And if it to ask the kernel via sigaltstack(NULL, &oss), then with your
approach the kernel's reply will contradict with what an app have.

>    In fact, the app needs to be quite careful with this temporary
> disable thing.  If you temporarily disable sigaltstack, then
> swapcontext, then you need to keep track of exactly when you're
> supposed to re-enable it, which involves knowing what's going on with
> the stacks.
My test-case code simply does this in sighandler:

sigaltstack(SS_DISABLE);
swapcontext();
sigaltstack(SS_ENABLE);

which means that only the sighandler context should
manage the sigaltstack, then you are safe. Non-signal
context should never care.

> Also, consider a use case like yours but with *two* contexts that use
> their own altstack.  If you go to context A, enable sigaltstack, get =
a
> signal, temporarily disable, then swapcontext to B, which tries to
> re-enable its own sigaltstack, then everything gets confusing with
> your patch, because, with your patch, the kernel is only tracking one
> temporarily disabled sigaltstack.
Of course the good practice is to set the sigaltstack
before creating the contexts. Then the above scenario
should involve switching between 2 signal handlers to get
into troubles. I think the scenario with switching between
2 signal handlers is very-very unrealistic.

> So that's another argument in favor of my thought that there should
> just be a way to override the permission checks to turn sigaltstack
> all the way off or to reprogram it even if you're running on the
> altstack.
Ok so if you block this approach, I wonder how many people
will block the SS_FORCE approach, esp given that the approach
without any new flags was already released and seen.
Of course if no one else cares, I'll have to do that sooner or later.
Btw, you can do that too; you can even re-use my test case to
save time. :)

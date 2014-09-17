From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [PATCH] x86/vdso: Add prctl to set per-process VDSO load
Date: Tue, 16 Sep 2014 22:00:39 -0700
Message-ID: <CALCETrWj8Pj8d8YjybvOKG-=xmy-XGFo9cGQ9qn0V4t9Oj+dOw@mail.gmail.com>
References: <1410912351-31273-1-git-send-email-rlarocque@google.com>
 <CALCETrXtYV5xKkTxothuqNb7ra80Be7ZXJ-hDnC6p-bfEPZ=Lw@mail.gmail.com> <CABgu+=NC1ZMQkV0J2c9-MD1+TAmTjDm4ACZASPnfX2Fwiu5rMQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABgu+=NC1ZMQkV0J2c9-MD1+TAmTjDm4ACZASPnfX2Fwiu5rMQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Larocque <rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Filipe Brandenburger <filbranden-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michael Davidson <md-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, X86 ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Sep 16, 2014 at 6:18 PM, Richard Larocque <rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> On Tue, Sep 16, 2014 at 5:27 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
>> On Tue, Sep 16, 2014 at 5:05 PM, Richard Larocque <rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>>> Adds new prctl calls to enable or disable VDSO loading for a process
>>> and its children.
>>>
>>> The PR_SET_DISABLE_VDSO call takes one argument, which is interpreted as
>>> a boolean value.  If true, it disables the loading of the VDSO on exec()
>>> for this process and any children created after this call.  A false
>>> value unsets the flag.
>>>
>>> The PR_GET_DISABLE_VDSO option returns a non-negative true value if VDSO
>>> loading has been disabled for this process, zero if it has not been
>>> disabled, and a negative value in case of error.
>>>
>>> These prctl calls are hidden behind a new Kconfig,
>>> CONFIG_VDSO_DISABLE_PRCTL.  This feature is available only on x86.
>>>
>>> The command line option vdso=0 overrides the behavior of
>>> PR_SET_DISABLE_VDSO, however, PR_GET_DISABLE_VDSO will coninue to return
>>> whetever setting was last set with PR_SET_DISABLE_VDSO.
>>>
>>> Signed-off-by: Richard Larocque <rlarocque-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>>> ---
>>> This patch is part of some work to better handle times and CRIU migration.
>>> I suspect that there are other use cases out there, so I'm offering this
>>> patch separately.
>>>
>>> When considering CRIU migration and times, we put some thought into how
>>> to handle the rdtsc instruction.  If we migrate between machines or across
>>> reboots, the migrated process will see values that could break its assumptions
>>> about how rdtsc is supposed to work.
>>
>> I don't get it.
>>
>> If __vdso_clock_gettime returns the wrong value in any scenario, we
>> should fix that.  Simiarly, CRIU *already works*, unless there's
>> something I don't know of.
>
> Right.  As far as I know, there's nothing wrong with the use of RDTSC
> in the vDSO following a migration.  The problem is that some
> applications might use RDTSC outside of the vDSO.  If they save the
> returned values, then compare pre- and post- migration values, bad
> things could happen (in theory).

These applications are broken, full stop.  They will misbehave on VMs,
or older machines, and even on the rather new piece of sh*t MSI
motherboard under my desk.  I think that CRIU is just icing on the
cake.  Also, they'll probably just crash if you turn off RDTSC.

>
> Anything we do to try to trap and handle the use of RDTSC in wider
> userspace will affect its use in the vDSO, too.  In some situations,
> it might be nice to run applications with no vDSO and PR_TSC_SIGSEGV,
> just to make sure they don't have any heavy reliance on the TSC.  It
> would be nice if those applications didn't crash when they called
> clock_gettime().

Agreed.  But let's do it without turning off the vdso.  Also, turning
off the 32-bit vdso could break a lot of things.

>
> Another alternative is to trap and adjust the RDTSC.  That might be a
> viable option for applications that care about reliable RDTSC behavior
> and migration, but don't care about performance.  I think it makes
> sense to disable the vDSO in that case, rather than trap on every call
> that it makes.

Here I disagree.  Let's just tweak the vdso not to use rdtsc in this case.

>
>> That being said, I would like an option to gate off RDTSC for a
>> process and its children in order to make PR_TSC_SIGSEGV more useful.
>> All the prerequisites are there now.
>
> Agreed.  That's what this patch is attempting to do, and that's the
> main reason why I figured it was worth submitting independent of any
> other time-related work.
>
>> What problem are you trying to solve exactly?
>
> Eventually, we'd like to make it so that neither RDTSC nor
> CLOCK_MONOTONIC can go backwards following a migration.
>
> The fix for RDTSC starts here.  Building on this patch as a base, we
> can either ban it from being used entirely, or write some code to
> adjust its value as necessary.
>
> The CLOCK_MONOTONIC fix will be a different patch stack.  We're
> currently hoping to do that without disable the vDSO, but that's
> another discussion.

I think that the patch should instead tweak the vvar mapping to tell
the vdso not to use rdtsc.  It should be based on this:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/log/?h=x86/vsyscall

and I'll talk to hpa tomorrow about about getting that, or something
like it, into the tip tree.  In particular, you'll need this:

https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/vsyscall&id=0cc410a05cb95e073ebfe099c9e03cef48d2be0f

Also, this kind of inheritable restriction may end up requiring
no_new_privs or CAP_SYS_ADMIN to be secure.

--Andy

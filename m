From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH] percpu system call: fast userspace percpu critical sections
Date: Tue, 26 May 2015 14:26:00 -0700
Message-ID: <CALCETrVCQ2M11cJ6rjAw6Gk+OPaH-ZsN=7AJu_STq+EbjdrQhw@mail.gmail.com>
References: <1432219487-13364-1-git-send-email-mathieu.desnoyers@efficios.com>
 <CAHO5Pa0Kok4_QN0v3JNWyzGT=GbZNZcRyLhu02R2npV9hSdt7g@mail.gmail.com>
 <CALCETrUSBqHG3tbOq1yFz33v1_ckEgLNorgAxwLFi7MkjNcwLA@mail.gmail.com>
 <757752240.6470.1432330487312.JavaMail.zimbra@efficios.com>
 <CALCETrUxp-dP-kaTy4prEdciM-=sTXjpqnMbkvk38g5BTEvX0g@mail.gmail.com>
 <1839774559.6579.1432400944032.JavaMail.zimbra@efficios.com>
 <CALCETrWzoFX7hXqvQqDEq=r=7PNaGKVjZeHEBWxPvC28Zi1AKA@mail.gmail.com>
 <1184354091.7499.1432578613872.JavaMail.zimbra@efficios.com>
 <CALCETrW3_Hv0jc3cpiwsHTinBqJzvab_EiPS8BVJhX-xe5D8qw@mail.gmail.com> <20150526212041.GQ19417@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150526212041.GQ19417-1g7Xle2YJi4/4alezvVtWx2eb7JE58TQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Lai Jiangshan <laijs-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 26, 2015 at 2:20 PM, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org> wrote:
>
> I haven't thought too much about it, but doing it in a vdso seems
> reasonable. It would mean that the scheduler hot path would
> need to know about its address though.
>
>> > You appear to summarize the two things that are added to the kernel with
>> > this RFC patch:
>> > - faster getcpu(): 12.7 ns -> 0.3 ns
>>
>> Yeah, I figured that out the second time I read your email and re-read
>> the original message, but I apparently forgot to fix up the email I
>> was typing.
>
> The high speed users seem to have all switched to using LSL directly,
> which is even faster. Since there are already users it cannot be changed
> anymore. Should probably just document this as an official ABI,
> and provide some standard include file with inline code.
>
>> IIRC some other OS's use gs as a userspace per-cpu pointer instead of
>> a per-thread pointer.  Would we want to consider enabling that?
>> This may interact oddly with the WIP wrgsbase stuff.  (Grr, Intel, why
>> couldn't you have made wrgsbase reset the gs selector to zero?  That
>> would have been so much nicer.)
>
> Applications really want the extra address registers. For example
> OpenJDK could free a GPR. And it's needed for the TLS of user space
> threads, which are becoming more and more popular. So there are
> already more important users queued.

This isn't necessarily the end of the world.  They could turn it off
or hopefully repurpose or extend their FS usage instead of requiring
GS.

IOW, I think that ARCH_SET_GS should continue working, as should
wrgsbase.  We could allow a program, strictly as an alternative, to do
ARCH_SET_GS_PERCPU or something.  (If we do that, we should wire up
arch_prctl for x86_32 as well.  We could further consider restricting
the new per-cpu mode to require a specific *nonzero* value for the
selector.  Also, it's really annoying that we'll be forced to assign
some meaning to a non-zero selector with unexpected gsbase during
context switch.)

--Andy

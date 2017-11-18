From: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Subject: Re: [RFC PATCH v3 for 4.15 08/24] Provide cpu_opv system call
Date: Sat, 18 Nov 2017 13:09:20 -0800
Message-ID: <CALCETrXMpvVtNRbfgUBs5cfS7ukEkD5-a3f0tKxSWPE4HO25Pg@mail.gmail.com>
References: <20171114200414.2188-1-mathieu.desnoyers@efficios.com>
 <20171114200414.2188-9-mathieu.desnoyers@efficios.com> <alpine.DEB.2.20.1711162215100.2109@nanos>
 <20171117001410.GG2482@two.firstfloor.org> <alpine.DEB.2.20.1711171107450.1709@nanos>
 <1756446476.17265.1510938872121.JavaMail.zimbra@efficios.com>
 <20171117181839.GH2482@two.firstfloor.org> <alpine.DEB.2.20.1711171922420.2186@nanos>
 <20171117191547.GI2482@two.firstfloor.org> <alpine.DEB.2.20.1711172025320.2186@nanos>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.DEB.2.20.1711172025320.2186@nanos>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 17, 2017 at 12:07 PM, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> On Fri, 17 Nov 2017, Andi Kleen wrote:
>> > The most straight forward is to have a mechanism which forces everything
>> > into the slow path in case of debugging, lack of progress, etc. The slow
>>
>> That's the abort address, right?
>
> Yes.
>
>> For the generic case the fall back path would require disabling preemption
>> unfortunately, for which we don't have a mechanism in user space.
>>
>> I think that is what Mathieu tried to implement here with this call.
>
> Yes. preempt disabled execution of byte code to make sure that the
> transaction succeeds.
>
> But, why is disabling preemption mandatory? If stuff fails due to hitting a
> breakpoint or because it retried a gazillion times without progress, then
> the abort code can detect that and act accordingly. Pseudo code:
>
> abort:
>         if (!slowpath_required() &&
>             !breakpoint_caused_abort() &&
>             !stall_detected()) {
>                 do_the_normal_abort_postprocessing();
>                 goto retry;
>         }
>
>         lock(slowpath_lock[cpu]);
>
>         if (!slowpath_required()) {
>                 unlock(slowpath_lock[cpu]);
>                 goto retry;
>         }
>
>         if (rseq_supported)
>                 set_slow_path();
>
>         /* Same code as inside the actual rseq */
>         do_transaction();
>
>         if (rseq_supported)
>                 unset_slow_path();
>
>         unlock(slowpath_lock[cpu]);

My objection to this approach is that people will get it wrong and not
notice until it's too late.  TSX has two things going for it:

1. It's part of the ISA, so debuggers have very well-defined semantics
to deal with and debuggers will know about it.  rseq is a made-up
Linux thing and debuggers may not know what to do with it.

2. TSX is slow and crappy, so it may not be that widely used.  glibc,
OTOH, will probably start using rseq on all machines if the patches
are merged.

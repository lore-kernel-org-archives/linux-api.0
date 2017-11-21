From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 v12 00/22] Restartable sequences and CPU op
 vector
Date: Tue, 21 Nov 2017 22:05:08 +0000 (UTC)
Message-ID: <740195164.19702.1511301908907.JavaMail.zimbra@efficios.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <20171121172144.GL2482@two.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121172144.GL2482-1g7Xle2YJi4/4alezvVtWx2eb7JE58TQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

----- On Nov 21, 2017, at 12:21 PM, Andi Kleen andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org wrote:

> On Tue, Nov 21, 2017 at 09:18:38AM -0500, Mathieu Desnoyers wrote:
>> Hi,
>> 
>> Following changes based on a thorough coding style and patch changelog
>> review from Thomas Gleixner and Peter Zijlstra, I'm respinning this
>> series for another RFC.
>> 
> My suggestion would be that you also split out the opv system call.
> That seems to be main contention point currently, and the restartable
> sequences should be useful without it.

I consider rseq to be incomplete and a pain to use in various scenarios
without cpu_opv. 

About the contention point you refer to:

Using vDSO as an example of how things should be done is just wrong: the
vDSO interaction with debugger instruction single-stepping is broken,
as I detailed in my previous email.

Thomas' proposal of handling single-stepping with a user-space locking
fallback, which is pretty much what I had in 2016, pushes a lot of
complexity to user-space, requires an extra branch in the fast-path,
as well as additional store-release/load-acquire semantics for consistency.
I don't plan going down that route.

Other than that, I have not received any concrete alternative proposal to
properly handle single-stepping.

The only opposition against cpu_opv is that there *should* be an hypothetical
simpler solution. The rseq idea is not new: it's been presented by Paul Turner
in 2012 at LPC. And so far, cpu_opv is the overall simplest and most
efficient way I encountered to handle single-stepping, and it gives extra
benefits, as described in my changelog.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

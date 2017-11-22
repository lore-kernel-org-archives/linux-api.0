From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 v12 00/22] Restartable sequences and CPU op
 vector
Date: Wed, 22 Nov 2017 16:43:43 +0000 (UTC)
Message-ID: <718035530.20074.1511369023901.JavaMail.zimbra@efficios.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <20171121172144.GL2482@two.firstfloor.org> <740195164.19702.1511301908907.JavaMail.zimbra@efficios.com> <CALCETrX84s-WEa5osP0t6CKh8C4Wj7-ARNMpaSp8Eop1_2ycLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrX84s-WEa5osP0t6CKh8C4Wj7-ARNMpaSp8Eop1_2ycLA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

----- On Nov 22, 2017, at 10:28 AM, Andy Lutomirski luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org wrote:

> On Tue, Nov 21, 2017 at 2:05 PM, Mathieu Desnoyers
> <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> wrote:
>> ----- On Nov 21, 2017, at 12:21 PM, Andi Kleen andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org wrote:
>>
>>> On Tue, Nov 21, 2017 at 09:18:38AM -0500, Mathieu Desnoyers wrote:
>>>> Hi,
>>>>
>>>> Following changes based on a thorough coding style and patch changelog
>>>> review from Thomas Gleixner and Peter Zijlstra, I'm respinning this
>>>> series for another RFC.
>>>>
>>> My suggestion would be that you also split out the opv system call.
>>> That seems to be main contention point currently, and the restartable
>>> sequences should be useful without it.
>>
>> I consider rseq to be incomplete and a pain to use in various scenarios
>> without cpu_opv.
>>
>> About the contention point you refer to:
>>
>> Using vDSO as an example of how things should be done is just wrong: the
>> vDSO interaction with debugger instruction single-stepping is broken,
>> as I detailed in my previous email.
>>
> 
> If anyone ever reports that as a problem, I'll gladly fix it in the
> kernel.  That's doable without an ABI change.  If rseq-like things
> started breaking single-stepping, we can't just fix it in the kernel.

Very true. And rseq does break both line-level and instruction-level
single-stepping.

> 
> Also, there is one and only one vclock_gettime.  Debuggers can easily
> special-case it.  For all I know, they already do.

As my tests demonstrate, they don't. clock_gettime() vDSO currently
breaks instruction-level single-stepping (istep) with gdb. I'll
forward you the writeup I did on that a few days ago.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

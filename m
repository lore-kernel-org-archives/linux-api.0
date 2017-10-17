From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Tue, 17 Oct 2017 17:48:04 +0000 (UTC)
Message-ID: <1630038054.43152.1508262484464.JavaMail.zimbra@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <135399003.40850.1507930608890.JavaMail.zimbra@efficios.com> <165916d7-2f86-445a-9c84-f6444b5e753b@redhat.com> <20171016164600.GO2482@two.firstfloor.org> <21865534.42661.1508192263844.JavaMail.zimbra@efficios.com> <CY4PR15MB168879D6220D976B04FE482CCF4C0@CY4PR15MB1688.namprd15.prod.outlook.com> <1292309161.43101.1508258000235.JavaMail.zimbra@efficios.com> <CY4PR15MB16886FD43FB48592F3F5892FCF4C0@CY4PR15MB1688.namprd15.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR15MB16886FD43FB48592F3F5892FCF4C0-ZVJ2su15u+xeX4ZvlgGe+Yd3EbNNOtPMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, carlos <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Goldblatt <davidgoldblatt-b10kYP2dOMg@public.gmane.org>, Qi Wang <qiwang-b10kYP2dOMg@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell
List-Id: linux-api@vger.kernel.org

----- On Oct 17, 2017, at 12:41 PM, Ben Maurer bmaurer-b10kYP2dOMg@public.gmane.org wrote:

>> I have a use-case for keeping the reference counting in place though. It's
>> use of rseq in signal handlers.
> 
> Would this be solved by saying that the rseq api will return an error if you
> register and there's already a block registered. In this case the signal
> handler would register the rseq abi area just as the non-signal code is trying
> to do the same. The non-signal code would see this error code and realize that
> its job had been done for it and then go on it's way.

Yes, that should work, as long as we return a specific error code, e.g. -EBUSY,
to tell the caller that rseq has actually been registered.

> 
> It would be unsafe for signal handler code to *unregister* the area, but I don't
> think that's necessary.

Right.

> 
> Basically we'd support a refcount of either 0 or 1, but nothing else.

Yep, I'll try this out.

> 
> If a signal handler registers the ABI area, how will it ensure the ABI is
> cleaned up at thread exit? I can't imagine pthread_key is signal safe.

You have a very good point there. This highlights a signal-safety issue
I have in liburcu-bp when used by lttng-ust. pthread_setspecific is
indeed not listed as being signal-safe: it can perform on-demand memory
allocation when a second level array is needed.

I'll have to scratch my head a bit to fix this one.

Thanks!

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

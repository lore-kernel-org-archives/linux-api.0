From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH v9 for 4.15 01/14] Restartable sequences system call
Date: Tue, 17 Oct 2017 16:33:20 +0000 (UTC)
Message-ID: <1292309161.43101.1508258000235.JavaMail.zimbra@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171013205418.GM3521@linux.vnet.ibm.com> <CA+55aFwvNS95ByZJTh1yG25QfaD0K0ZByK3iXeeRU8LafFiGFQ@mail.gmail.com> <135399003.40850.1507930608890.JavaMail.zimbra@efficios.com> <165916d7-2f86-445a-9c84-f6444b5e753b@redhat.com> <20171016164600.GO2482@two.firstfloor.org> <21865534.42661.1508192263844.JavaMail.zimbra@efficios.com> <CY4PR15MB168879D6220D976B04FE482CCF4C0@CY4PR15MB1688.namprd15.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY4PR15MB168879D6220D976B04FE482CCF4C0-ZVJ2su15u+xeX4ZvlgGe+Yd3EbNNOtPMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
Cc: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, carlos <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Goldblatt <davidgoldblatt-b10kYP2dOMg@public.gmane.org>, Qi Wang <qiwang-b10kYP2dOMg@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell
List-Id: linux-api@vger.kernel.org

----- On Oct 17, 2017, at 12:19 PM, Ben Maurer bmaurer-b10kYP2dOMg@public.gmane.org wrote:

> Hey,
> 
>> So far the restrictions I see for libraries using this symbol are:
>> - They should never be unloaded,
>> - They should never be loaded with dlopen RTLD_LOCAL flag.
> 
> We talked a bit about this off-list but I wanted to state publicly that I think
> this model works well for our use case. Specifically,
> 
> (1) It reduces complexity by focusing on the common case -- long term we expect
> glibc to manage the process of using this feature and registering/deregistering
> threads for rseq. Unloading isn't a challenge in these situations, so why add
> the complexity for it?
> 
> (2) This still allows for early adopters to use rseq before there is glibc
> support. I believe the vast majority of real world applications meet these two
> criteria you've listed. If not, they can create a thin shared library that has
> the sole purpose of providing the weak symbol and that never gets unloaded
> 
> (3) This allows for applications to provide the __rseq_abi so that they can
> ensure it uses the initial_exec tls model and optimize in-application assembly
> code for it. This is a good optimization for server applications that tend to
> statically link.

Agreed with all the above,

> 
> If others agree with this, would it make sense to remove the concept of
> reference counting in the system call that defines and redefines the per-thread
> area? Seems like it would remove complexity.

I have a use-case for keeping the reference counting in place though. It's
use of rseq in signal handlers.

If we have two early-adopter libraries trying to lazy-register rseq, and
one of those libraries can be called within a signal handler (e.g. lttng-ust),
we run into a situation where signal handler could nest on top of the
first library lazy-register (test, branch, register), and race against it.
So having reference counting in place allows the kernel to deal with
those multi-lib use-cases atomically wrt signal handlers from a thread
perspective.

And I don't want to require every early-adopter library to disable signals
just in case some _other_ library would be invoked in a signal handler.

Thoughts ?

Thanks,

Mathieu

> 
> -b

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

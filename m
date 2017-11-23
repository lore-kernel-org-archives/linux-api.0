From: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 v3 15/22] rseq: selftests: Provide
 self-tests
Date: Thu, 23 Nov 2017 21:16:52 +0000 (UTC)
Message-ID: <1863234483.21251.1511471812668.JavaMail.zimbra@efficios.com>
References: <20171121141900.18471-1-mathieu.desnoyers@efficios.com> <20171121141900.18471-16-mathieu.desnoyers@efficios.com> <20171122193821.GJ3165@worktop.lehotels.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171122193821.GJ3165-IIpfhp3q70x9+YH6RuovlLjjLBE8jN/0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will>
List-Id: linux-api@vger.kernel.org

----- On Nov 22, 2017, at 2:38 PM, Peter Zijlstra peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org wrote:

> On Tue, Nov 21, 2017 at 09:18:53AM -0500, Mathieu Desnoyers wrote:
>> Implements two basic tests of RSEQ functionality, and one more
>> exhaustive parameterizable test.
>> 
>> The first, "basic_test" only asserts that RSEQ works moderately
>> correctly. E.g. that the CPUID pointer works.
>> 
>> "basic_percpu_ops_test" is a slightly more "realistic" variant,
>> implementing a few simple per-cpu operations and testing their
>> correctness.
>> 
>> "param_test" is a parametrizable restartable sequences test. See
>> the "--help" output for usage.
>> 
>> A run_param_test.sh script runs many variants of the parametrizable
>> tests.
>> 
>> As part of those tests, a helper library "rseq" implements a user-space
>> API around restartable sequences. It uses the cpu_opv system call as
>> fallback when single-stepped by a debugger. It exposes the instruction
>> pointer addresses where the rseq assembly blocks begin and end, as well
>> as the associated abort instruction pointer, in the __rseq_table
>> section. This section allows debuggers may know where to place
>> breakpoints when single-stepping through assembly blocks which may be
>> aborted at any point by the kernel.
> 
> Could I ask you to split this in smaller bits?
> 
> I'd start with just the rseq library, using only the rseq interface.
> Then add the whole cpu_opv fallback stuff.
> Then add the selftests using librseq.
> 
> As is this is a tad much to read in a single go.

Sure, will do! And I plan to change the selftests to use the new
"percpu_*()" API that removes the need to duplicate code in the
caller code.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

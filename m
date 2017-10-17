From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.15 14/14] Restartable sequences: Provide
 self-tests
Date: Tue, 17 Oct 2017 13:50:35 +0000 (UTC)
Message-ID: <1916073216.42952.1508248235963.JavaMail.zimbra@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-15-mathieu.desnoyers@efficios.com> <871sm3n6sy.fsf@concordia.ellerman.id.au> <399058130.42156.1508163782335.JavaMail.zimbra@efficios.com> <87a80qjbyn.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87a80qjbyn.fsf@concordia.ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux>
List-Id: linux-api@vger.kernel.org

----- On Oct 17, 2017, at 6:38 AM, Michael Ellerman mpe@ellerman.id.au wrote:

> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
> 
>> ----- On Oct 15, 2017, at 10:51 PM, Michael Ellerman mpe@ellerman.id.au wrote:
>>
>>> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
>>> 
>>>> Implements two basic tests of RSEQ functionality, and one more
>>>> exhaustive parameterizable test.
>>>>
>>>> The first, "basic_test" only asserts that RSEQ works moderately
>>>> correctly.
>>>> E.g. that:
>>>> - The CPUID pointer works
>>>> - Code infinitely looping within a critical section will eventually be
>>>>   interrupted.
>>>> - Critical sections are interrupted by signals.
>>>>
>>>> "basic_percpu_ops_test" is a slightly more "realistic" variant,
>>>> implementing a few simple per-cpu operations and testing their
>>>> correctness.
>>>>
>>>> "param_test" is a parametrizable restartable sequences test. See
>>>> the "--help" output for usage.
>>> 
>>> Thanks for providing selftests :)
>>> 
>>> The Makefiles could use a little clean up:
>>>  - cpu-opv doesn't need libpthread
>>>  - you don't need to define your own rule just for building
>>>  - use TEST_GEN_PROGS to hook into the right parts of lib.mk
>>>  - .. which means you can use the clean rule in lib.mk
>>> 
>>> 
>>> I notice you didn't add rseq or cpu-opv to the list of TARGETS in
>>> tools/testing/selftests/Makefile, was that deliberate?
>>
>> No, I think I just copied some other selftest which perhaps did
>> not have those rules back then.
> 
> OK. I don't see why these tests shouldn't be part of the default test
> run, so here's a patch to add them.

Perfect, folded that change into my series as well.

Thanks!

Mathieu

> 
> cheers
> 
> 
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index ff805643b5f7..b79ef5915c74 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -3,6 +3,7 @@ TARGETS += breakpoints
> TARGETS += capabilities
> TARGETS += cpufreq
> TARGETS += cpu-hotplug
> +TARGETS += cpu-opv
> TARGETS += efivarfs
> TARGETS += exec
> TARGETS += firmware
> @@ -23,6 +24,7 @@ TARGETS += nsfs
> TARGETS += powerpc
> TARGETS += pstore
> TARGETS += ptrace
> +TARGETS += rseq
> TARGETS += seccomp
> TARGETS += sigaltstack
>  TARGETS += size

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 14/14] Restartable sequences: Provide self-tests
Date: Tue, 17 Oct 2017 21:38:40 +1100
Message-ID: <87a80qjbyn.fsf@concordia.ellerman.id.au>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-15-mathieu.desnoyers@efficios.com> <871sm3n6sy.fsf@concordia.ellerman.id.au> <399058130.42156.1508163782335.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <399058130.42156.1508163782335.JavaMail.zimbra-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Cc: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm@linux>
List-Id: linux-api@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> writes:

> ----- On Oct 15, 2017, at 10:51 PM, Michael Ellerman mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org wrote:
>
>> Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> writes:
>> 
>>> Implements two basic tests of RSEQ functionality, and one more
>>> exhaustive parameterizable test.
>>>
>>> The first, "basic_test" only asserts that RSEQ works moderately
>>> correctly.
>>> E.g. that:
>>> - The CPUID pointer works
>>> - Code infinitely looping within a critical section will eventually be
>>>   interrupted.
>>> - Critical sections are interrupted by signals.
>>>
>>> "basic_percpu_ops_test" is a slightly more "realistic" variant,
>>> implementing a few simple per-cpu operations and testing their
>>> correctness.
>>>
>>> "param_test" is a parametrizable restartable sequences test. See
>>> the "--help" output for usage.
>> 
>> Thanks for providing selftests :)
>> 
>> The Makefiles could use a little clean up:
>>  - cpu-opv doesn't need libpthread
>>  - you don't need to define your own rule just for building
>>  - use TEST_GEN_PROGS to hook into the right parts of lib.mk
>>  - .. which means you can use the clean rule in lib.mk
>> 
>> 
>> I notice you didn't add rseq or cpu-opv to the list of TARGETS in
>> tools/testing/selftests/Makefile, was that deliberate?
>
> No, I think I just copied some other selftest which perhaps did
> not have those rules back then.

OK. I don't see why these tests shouldn't be part of the default test
run, so here's a patch to add them.

cheers


diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index ff805643b5f7..b79ef5915c74 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -3,6 +3,7 @@ TARGETS += breakpoints
 TARGETS += capabilities
 TARGETS += cpufreq
 TARGETS += cpu-hotplug
+TARGETS += cpu-opv
 TARGETS += efivarfs
 TARGETS += exec
 TARGETS += firmware
@@ -23,6 +24,7 @@ TARGETS += nsfs
 TARGETS += powerpc
 TARGETS += pstore
 TARGETS += ptrace
+TARGETS += rseq
 TARGETS += seccomp
 TARGETS += sigaltstack
 TARGETS += size

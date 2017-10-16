From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.15 14/14] Restartable sequences: Provide
 self-tests
Date: Mon, 16 Oct 2017 14:23:02 +0000 (UTC)
Message-ID: <399058130.42156.1508163782335.JavaMail.zimbra@efficios.com>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-15-mathieu.desnoyers@efficios.com> <871sm3n6sy.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <871sm3n6sy.fsf@concordia.ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, linux-kernel <linux-kernel@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux>
List-Id: linux-api@vger.kernel.org

----- On Oct 15, 2017, at 10:51 PM, Michael Ellerman mpe@ellerman.id.au wrote:

> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
> 
>> Implements two basic tests of RSEQ functionality, and one more
>> exhaustive parameterizable test.
>>
>> The first, "basic_test" only asserts that RSEQ works moderately
>> correctly.
>> E.g. that:
>> - The CPUID pointer works
>> - Code infinitely looping within a critical section will eventually be
>>   interrupted.
>> - Critical sections are interrupted by signals.
>>
>> "basic_percpu_ops_test" is a slightly more "realistic" variant,
>> implementing a few simple per-cpu operations and testing their
>> correctness.
>>
>> "param_test" is a parametrizable restartable sequences test. See
>> the "--help" output for usage.
> 
> Thanks for providing selftests :)
> 
> The Makefiles could use a little clean up:
>  - cpu-opv doesn't need libpthread
>  - you don't need to define your own rule just for building
>  - use TEST_GEN_PROGS to hook into the right parts of lib.mk
>  - .. which means you can use the clean rule in lib.mk
> 
> 
> I notice you didn't add rseq or cpu-opv to the list of TARGETS in
> tools/testing/selftests/Makefile, was that deliberate?

No, I think I just copied some other selftest which perhaps did
not have those rules back then.

> 
> Feel free to squash this patch in if you're happy to.
> 
> This still works with:
>  $ make -C tools/testing/selftests TARGETS=rseq
> 
> and:
>  $ cd tools/testing/selftests/rseq; make

Great ! I'll fold this patch in.

Thanks!

Mathieu

> 
> cheers
> 
> diff --git a/tools/testing/selftests/cpu-opv/Makefile
> b/tools/testing/selftests/cpu-opv/Makefile
> index 81d0596824ee..d41670ad5c43 100644
> --- a/tools/testing/selftests/cpu-opv/Makefile
> +++ b/tools/testing/selftests/cpu-opv/Makefile
> @@ -1,13 +1,9 @@
> CFLAGS += -O2 -Wall -g -I./ -I../../../../usr/include/
> -LDFLAGS += -lpthread
> 
> -TESTS = basic_cpu_opv_test
> +TEST_GEN_PROGS = basic_cpu_opv_test
> 
> -all: $(TESTS)
> -%: %.c cpu-op.c cpu-op.h
> -	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
> +all: $(TEST_GEN_PROGS)
> 
> -include ../lib.mk
> +$(TEST_GEN_PROGS): cpu-op.c cpu-op.h
> 
> -clean:
> -	$(RM) $(TESTS)
> +include ../lib.mk
> diff --git a/tools/testing/selftests/rseq/Makefile
> b/tools/testing/selftests/rseq/Makefile
> index 7f0153556b80..9f8257b4ce14 100644
> --- a/tools/testing/selftests/rseq/Makefile
> +++ b/tools/testing/selftests/rseq/Makefile
> @@ -1,13 +1,10 @@
> CFLAGS += -O2 -Wall -g -I./ -I../cpu-opv/ -I../../../../usr/include/
> -LDFLAGS += -lpthread
> +LDLIBS += -lpthread
> 
> -TESTS = basic_test basic_percpu_ops_test param_test
> +TEST_GEN_PROGS = basic_test basic_percpu_ops_test param_test
> 
> -all: $(TESTS)
> -%: %.c rseq.h rseq-*.h rseq.c ../cpu-opv/cpu-op.c ../cpu-opv/cpu-op.h
> -	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)
> +all: $(TEST_GEN_PROGS)
> 
> -include ../lib.mk
> +$(TEST_GEN_PROGS): rseq.h rseq-*.h rseq.c ../cpu-opv/cpu-op.c
> ../cpu-opv/cpu-op.h
> 
> -clean:
> -	$(RM) $(TESTS)
> +include ../lib.mk

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

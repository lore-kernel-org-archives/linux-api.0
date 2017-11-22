From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH update for 4.15 3/3] rseq: selftests: Provide self-tests
 (v4)
Date: Wed, 22 Nov 2017 16:31:51 +0000 (UTC)
Message-ID: <461615779.20063.1511368311925.JavaMail.zimbra@efficios.com>
References: <20171121221933.25959-1-mathieu.desnoyers@efficios.com> <20171121221933.25959-3-mathieu.desnoyers@efficios.com> <c207283b-5256-1507-a1d9-b40e6f326e97@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <c207283b-5256-1507-a1d9-b40e6f326e97@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shuah <shuah@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andrew Hunter <ahh@google.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <cata>
List-Id: linux-api@vger.kernel.org

----- On Nov 22, 2017, at 10:23 AM, shuah shuah@kernel.org wrote:

> On 11/21/2017 03:19 PM, Mathieu Desnoyers wrote:
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
>> 
>> The rseq library expose APIs that present the fast-path operations.
>> The new from userspace is, e.g. for a counter increment:
>> 
>>     cpu = rseq_cpu_start();
>>     ret = rseq_addv(&data->c[cpu].count, 1, cpu);
>>     if (likely(!ret))
>>         return 0;        /* Success. */
>>     do {
>>         cpu = rseq_current_cpu();
>>         ret = cpu_op_addv(&data->c[cpu].count, 1, cpu);
>>         if (likely(!ret))
>>             return 0;    /* Success. */
>>     } while (ret > 0 || errno == EAGAIN);
>>     perror("cpu_op_addv");
>>     return -1;           /* Unexpected error. */
>> 
>> PowerPC tests have been implemented by Boqun Feng.
>> 
>> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>> CC: Russell King <linux@arm.linux.org.uk>
>> CC: Catalin Marinas <catalin.marinas@arm.com>
>> CC: Will Deacon <will.deacon@arm.com>
>> CC: Thomas Gleixner <tglx@linutronix.de>
>> CC: Paul Turner <pjt@google.com>
>> CC: Andrew Hunter <ahh@google.com>
>> CC: Peter Zijlstra <peterz@infradead.org>
>> CC: Andy Lutomirski <luto@amacapital.net>
>> CC: Andi Kleen <andi@firstfloor.org>
>> CC: Dave Watson <davejwatson@fb.com>
>> CC: Chris Lameter <cl@linux.com>
>> CC: Ingo Molnar <mingo@redhat.com>
>> CC: "H. Peter Anvin" <hpa@zytor.com>
>> CC: Ben Maurer <bmaurer@fb.com>
>> CC: Steven Rostedt <rostedt@goodmis.org>
>> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
>> CC: Josh Triplett <josh@joshtriplett.org>
>> CC: Linus Torvalds <torvalds@linux-foundation.org>
>> CC: Andrew Morton <akpm@linux-foundation.org>
>> CC: Boqun Feng <boqun.feng@gmail.com>
>> CC: Shuah Khan <shuah@kernel.org>
>> CC: linux-kselftest@vger.kernel.org
>> CC: linux-api@vger.kernel.org
>> ---
>> Changes since v1:
>> - Provide abort-ip signature: The abort-ip signature is located just
>>   before the abort-ip target. It is currently hardcoded, but a
>>   user-space application could use the __rseq_table to iterate on all
>>   abort-ip targets and use a random value as signature if needed in the
>>   future.
>> - Add rseq_prepare_unload(): Libraries and JIT code using rseq critical
>>   sections need to issue rseq_prepare_unload() on each thread at least
>>   once before reclaim of struct rseq_cs.
>> - Use initial-exec TLS model, non-weak symbol: The initial-exec model is
>>   signal-safe, whereas the global-dynamic model is not.  Remove the
>>   "weak" symbol attribute from the __rseq_abi in rseq.c. The rseq.so
>>   library will have ownership of that symbol, and there is not reason for
>>   an application or user library to try to define that symbol.
>>   The expected use is to link against libreq.so, which owns and provide
>>   that symbol.
>> - Set cpu_id to -2 on register error
>> - Add rseq_len syscall parameter, rseq_cs version
>> - Ensure disassember-friendly signature: x86 32/64 disassembler have a
>>   hard time decoding the instruction stream after a bad instruction. Use
>>   a nopl instruction to encode the signature. Suggested by Andy Lutomirski.
>> - Exercise parametrized tests variants in a shell scripts.
>> - Restartable sequences selftests: Remove use of event counter.
>> - Use cpu_id_start field:  With the cpu_id_start field, the C
>>   preparation phase of the fast-path does not need to compare cpu_id < 0
>>   anymore.
>> - Signal-safe registration and refcounting: Allow libraries using
>>   librseq.so to register it from signal handlers.
>> - Use OVERRIDE_TARGETS in makefile.
>> - Use "m" constraints for rseq_cs field.
>> 
>> Changes since v2:
>> - Update based on Thomas Gleixner's comments.
>> 
>> Changes since v3:
>> - Generate param_test_skip_fastpath and param_test_benchmark with
>>   -DSKIP_FASTPATH and -DBENCHMARK (respectively). Add param_test_fastpath
>>   to run_param_test.sh.
>> ---
>>  MAINTAINERS                                        |    1 +
>>  tools/testing/selftests/Makefile                   |    1 +
>>  tools/testing/selftests/rseq/.gitignore            |    4 +
>>  tools/testing/selftests/rseq/Makefile              |   33 +
>>  .../testing/selftests/rseq/basic_percpu_ops_test.c |  333 +++++
>>  tools/testing/selftests/rseq/basic_test.c          |   55 +
>>  tools/testing/selftests/rseq/param_test.c          | 1285 ++++++++++++++++++++
>>  tools/testing/selftests/rseq/rseq-arm.h            |  535 ++++++++
>>  tools/testing/selftests/rseq/rseq-ppc.h            |  567 +++++++++
>>  tools/testing/selftests/rseq/rseq-x86.h            |  898 ++++++++++++++
>>  tools/testing/selftests/rseq/rseq.c                |  116 ++
>>  tools/testing/selftests/rseq/rseq.h                |  154 +++
>>  tools/testing/selftests/rseq/run_param_test.sh     |  126 ++
>>  13 files changed, 4108 insertions(+)
>>  create mode 100644 tools/testing/selftests/rseq/.gitignore
>>  create mode 100644 tools/testing/selftests/rseq/Makefile
>>  create mode 100644 tools/testing/selftests/rseq/basic_percpu_ops_test.c
>>  create mode 100644 tools/testing/selftests/rseq/basic_test.c
>>  create mode 100644 tools/testing/selftests/rseq/param_test.c
>>  create mode 100644 tools/testing/selftests/rseq/rseq-arm.h
>>  create mode 100644 tools/testing/selftests/rseq/rseq-ppc.h
>>  create mode 100644 tools/testing/selftests/rseq/rseq-x86.h
>>  create mode 100644 tools/testing/selftests/rseq/rseq.c
>>  create mode 100644 tools/testing/selftests/rseq/rseq.h
>>  create mode 100755 tools/testing/selftests/rseq/run_param_test.sh
>> 
> 
> Looks good.
> 
> Acked-by: Shuah Khan <shuahkh@osg.samsung.com>

Thanks the the reviews!

Mathieu

> 
> thanks,
> -- Shuah

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

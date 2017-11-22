From: Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH update for 4.15 3/3] rseq: selftests: Provide self-tests
 (v4)
Date: Wed, 22 Nov 2017 08:23:22 -0700
Message-ID: <c207283b-5256-1507-a1d9-b40e6f326e97@kernel.org>
References: <20171121221933.25959-1-mathieu.desnoyers@efficios.com>
 <20171121221933.25959-3-mathieu.desnoyers@efficios.com>
Reply-To: shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171121221933.25959-3-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E . McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H . Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 11/21/2017 03:19 PM, Mathieu Desnoyers wrote:
> Implements two basic tests of RSEQ functionality, and one more
> exhaustive parameterizable test.
> 
> The first, "basic_test" only asserts that RSEQ works moderately
> correctly. E.g. that the CPUID pointer works.
> 
> "basic_percpu_ops_test" is a slightly more "realistic" variant,
> implementing a few simple per-cpu operations and testing their
> correctness.
> 
> "param_test" is a parametrizable restartable sequences test. See
> the "--help" output for usage.
> 
> A run_param_test.sh script runs many variants of the parametrizable
> tests.
> 
> As part of those tests, a helper library "rseq" implements a user-space
> API around restartable sequences. It uses the cpu_opv system call as
> fallback when single-stepped by a debugger. It exposes the instruction
> pointer addresses where the rseq assembly blocks begin and end, as well
> as the associated abort instruction pointer, in the __rseq_table
> section. This section allows debuggers may know where to place
> breakpoints when single-stepping through assembly blocks which may be
> aborted at any point by the kernel.
> 
> The rseq library expose APIs that present the fast-path operations.
> The new from userspace is, e.g. for a counter increment:
> 
>     cpu = rseq_cpu_start();
>     ret = rseq_addv(&data->c[cpu].count, 1, cpu);
>     if (likely(!ret))
>         return 0;        /* Success. */
>     do {
>         cpu = rseq_current_cpu();
>         ret = cpu_op_addv(&data->c[cpu].count, 1, cpu);
>         if (likely(!ret))
>             return 0;    /* Success. */
>     } while (ret > 0 || errno == EAGAIN);
>     perror("cpu_op_addv");
>     return -1;           /* Unexpected error. */
> 
> PowerPC tests have been implemented by Boqun Feng.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
> CC: Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
> CC: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
> CC: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
> CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> CC: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
> CC: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
> CC: Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>
> CC: Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> CC: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> CC: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
> CC: Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>
> CC: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
> CC: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> CC: Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>
> CC: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> CC: linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
> Changes since v1:
> - Provide abort-ip signature: The abort-ip signature is located just
>   before the abort-ip target. It is currently hardcoded, but a
>   user-space application could use the __rseq_table to iterate on all
>   abort-ip targets and use a random value as signature if needed in the
>   future.
> - Add rseq_prepare_unload(): Libraries and JIT code using rseq critical
>   sections need to issue rseq_prepare_unload() on each thread at least
>   once before reclaim of struct rseq_cs.
> - Use initial-exec TLS model, non-weak symbol: The initial-exec model is
>   signal-safe, whereas the global-dynamic model is not.  Remove the
>   "weak" symbol attribute from the __rseq_abi in rseq.c. The rseq.so
>   library will have ownership of that symbol, and there is not reason for
>   an application or user library to try to define that symbol.
>   The expected use is to link against libreq.so, which owns and provide
>   that symbol.
> - Set cpu_id to -2 on register error
> - Add rseq_len syscall parameter, rseq_cs version
> - Ensure disassember-friendly signature: x86 32/64 disassembler have a
>   hard time decoding the instruction stream after a bad instruction. Use
>   a nopl instruction to encode the signature. Suggested by Andy Lutomirski.
> - Exercise parametrized tests variants in a shell scripts.
> - Restartable sequences selftests: Remove use of event counter.
> - Use cpu_id_start field:  With the cpu_id_start field, the C
>   preparation phase of the fast-path does not need to compare cpu_id < 0
>   anymore.
> - Signal-safe registration and refcounting: Allow libraries using
>   librseq.so to register it from signal handlers.
> - Use OVERRIDE_TARGETS in makefile.
> - Use "m" constraints for rseq_cs field.
> 
> Changes since v2:
> - Update based on Thomas Gleixner's comments.
> 
> Changes since v3:
> - Generate param_test_skip_fastpath and param_test_benchmark with
>   -DSKIP_FASTPATH and -DBENCHMARK (respectively). Add param_test_fastpath
>   to run_param_test.sh.
> ---
>  MAINTAINERS                                        |    1 +
>  tools/testing/selftests/Makefile                   |    1 +
>  tools/testing/selftests/rseq/.gitignore            |    4 +
>  tools/testing/selftests/rseq/Makefile              |   33 +
>  .../testing/selftests/rseq/basic_percpu_ops_test.c |  333 +++++
>  tools/testing/selftests/rseq/basic_test.c          |   55 +
>  tools/testing/selftests/rseq/param_test.c          | 1285 ++++++++++++++++++++
>  tools/testing/selftests/rseq/rseq-arm.h            |  535 ++++++++
>  tools/testing/selftests/rseq/rseq-ppc.h            |  567 +++++++++
>  tools/testing/selftests/rseq/rseq-x86.h            |  898 ++++++++++++++
>  tools/testing/selftests/rseq/rseq.c                |  116 ++
>  tools/testing/selftests/rseq/rseq.h                |  154 +++
>  tools/testing/selftests/rseq/run_param_test.sh     |  126 ++
>  13 files changed, 4108 insertions(+)
>  create mode 100644 tools/testing/selftests/rseq/.gitignore
>  create mode 100644 tools/testing/selftests/rseq/Makefile
>  create mode 100644 tools/testing/selftests/rseq/basic_percpu_ops_test.c
>  create mode 100644 tools/testing/selftests/rseq/basic_test.c
>  create mode 100644 tools/testing/selftests/rseq/param_test.c
>  create mode 100644 tools/testing/selftests/rseq/rseq-arm.h
>  create mode 100644 tools/testing/selftests/rseq/rseq-ppc.h
>  create mode 100644 tools/testing/selftests/rseq/rseq-x86.h
>  create mode 100644 tools/testing/selftests/rseq/rseq.c
>  create mode 100644 tools/testing/selftests/rseq/rseq.h
>  create mode 100755 tools/testing/selftests/rseq/run_param_test.sh
> 

Looks good.

Acked-by: Shuah Khan <shuahkh-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

thanks,
-- Shuah

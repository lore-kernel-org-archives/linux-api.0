From: Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>
Subject: Re: [RFC PATCH for 4.15 14/14] Restartable sequences: Provide self-tests
Date: Mon, 16 Oct 2017 14:00:33 +1100
Message-ID: <87y3oblru6.fsf@concordia.ellerman.id.au>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com> <20171012230326.19984-15-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171012230326.19984-15-mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Boqun Feng <boqun.feng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Hunter <ahh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Dave Watson <davejwatson-b10kYP2dOMg@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>, Chris Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Ben Maurer <bmaurer-b10kYP2dOMg@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Mathieu Desnoyers <mathieu.desnoyers-vg+e7yoeK/dWk0Htik3J/w@public.gmane.org> writes:

> Implements two basic tests of RSEQ functionality, and one more
> exhaustive parameterizable test.
>
> The first, "basic_test" only asserts that RSEQ works moderately
> correctly.
> E.g. that:
> - The CPUID pointer works
> - Code infinitely looping within a critical section will eventually be
>   interrupted.
> - Critical sections are interrupted by signals.
>
> "basic_percpu_ops_test" is a slightly more "realistic" variant,
> implementing a few simple per-cpu operations and testing their
> correctness.
>
> "param_test" is a parametrizable restartable sequences test. See
> the "--help" output for usage.
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
> The following rseq APIs are implemented in this helper library:
> - rseq_register_current_thread()/rseq_unregister_current_thread():
>     register/unregister current thread's use of rseq,
> - rseq_current_cpu_raw():
>     current CPU number,
> - rseq_start():
>     beginning of a restartable sequence,
> - rseq_cpu_at_start():
>     CPU number at start of restartable sequence,
> - rseq_finish():
>     End of restartable sequence made of zero or more loads, completed by
>     a word-sized store,
> - rseq_finish2():
>     End of restartable sequence made of zero or more loads, one
>     speculative word-sized store, completed by a word-sized store,
> - rseq_finish2_release():
>     End of restartable sequence made of zero or more loads, one
>     speculative word-sized store, completed by a word-sized store with
>     release semantic,
> - rseq_finish_memcpy():
>     End of restartable sequence made of zero or more loads, a
>     speculative copy of a variable length memory region, completed by a
>     word-sized store.
> - rseq_finish_memcpy_release():
>     End of restartable sequence made of zero or more loads, a
>     speculative copy of a variable length memory region, completed by a
>     word-sized store with release semantic.
>
> PowerPC tests have been implemented by Boqun Feng.

Hi Boqun,

I'm having trouble testing these, I get:

  ~/linus/tools/testing/selftests/cpu-opv$ ./basic_cpu_opv_test
  Testing test_compare_eq same
  Testing test_compare_eq different
  Testing test_compare_ne same
  Testing test_compare_ne different
  Testing test_2compare_eq index
  Testing test_2compare_ne index
  Testing test_memcpy
  Testing test_memcpy_u32
  Testing test_add
  Testing test_two_add
  Testing test_or
  Testing test_and
  Testing test_xor
  Testing test_lshift
  Testing test_rshift
  Testing test_cmpxchg success
  Testing test_cmpxchg fail
  
  ~/linus/tools/testing/selftests/rseq$ ./basic_test
  testing current cpu
  testing critical section
  testing critical section is interrupted by signal

  ~/linus/tools/testing/selftests/rseq$ ./basic_percpu_ops_test
  ./basic_percpu_ops_test: error while loading shared libraries: R_PPC64_ADDR16_HI re10d8f10a0 for symbol `' out of range
  ~/linus/tools/testing/selftests/rseq$ ./param_test
  ./param_test: error while loading shared libraries: R_PPC64_ADDR16_HI re136251b48 for symbol `' out of range


Any idea what's going on with the last two? I assume you don't see that
in your test setup :)

cheers

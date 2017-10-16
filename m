From: Boqun Feng <boqun.feng@gmail.com>
Subject: Re: [RFC PATCH for 4.15 14/14] Restartable sequences: Provide
 self-tests
Date: Mon, 16 Oct 2017 11:48:03 +0800
Message-ID: <20171016034607.xqebgopn45j3fvf2@tardis>
References: <20171012230326.19984-1-mathieu.desnoyers@efficios.com>
 <20171012230326.19984-15-mathieu.desnoyers@efficios.com>
 <87y3oblru6.fsf@concordia.ellerman.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87y3oblru6.fsf@concordia.ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Josh Triplett <josh@joshtriplett.org>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Linus Torvalds <torvalds@linux-foundation.org>Andrew Morton <a>
List-Id: linux-api@vger.kernel.org

On Mon, Oct 16, 2017 at 02:00:33PM +1100, Michael Ellerman wrote:
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> writes:
>=20
> > Implements two basic tests of RSEQ functionality, and one more
> > exhaustive parameterizable test.
> >
> > The first, "basic_test" only asserts that RSEQ works moderately
> > correctly.
> > E.g. that:
> > - The CPUID pointer works
> > - Code infinitely looping within a critical section will eventually be
> >   interrupted.
> > - Critical sections are interrupted by signals.
> >
> > "basic_percpu_ops_test" is a slightly more "realistic" variant,
> > implementing a few simple per-cpu operations and testing their
> > correctness.
> >
> > "param_test" is a parametrizable restartable sequences test. See
> > the "--help" output for usage.
> >
> > As part of those tests, a helper library "rseq" implements a user-space
> > API around restartable sequences. It uses the cpu_opv system call as
> > fallback when single-stepped by a debugger. It exposes the instruction
> > pointer addresses where the rseq assembly blocks begin and end, as well
> > as the associated abort instruction pointer, in the __rseq_table
> > section. This section allows debuggers may know where to place
> > breakpoints when single-stepping through assembly blocks which may be
> > aborted at any point by the kernel.
> >
> > The following rseq APIs are implemented in this helper library:
> > - rseq_register_current_thread()/rseq_unregister_current_thread():
> >     register/unregister current thread's use of rseq,
> > - rseq_current_cpu_raw():
> >     current CPU number,
> > - rseq_start():
> >     beginning of a restartable sequence,
> > - rseq_cpu_at_start():
> >     CPU number at start of restartable sequence,
> > - rseq_finish():
> >     End of restartable sequence made of zero or more loads, completed by
> >     a word-sized store,
> > - rseq_finish2():
> >     End of restartable sequence made of zero or more loads, one
> >     speculative word-sized store, completed by a word-sized store,
> > - rseq_finish2_release():
> >     End of restartable sequence made of zero or more loads, one
> >     speculative word-sized store, completed by a word-sized store with
> >     release semantic,
> > - rseq_finish_memcpy():
> >     End of restartable sequence made of zero or more loads, a
> >     speculative copy of a variable length memory region, completed by a
> >     word-sized store.
> > - rseq_finish_memcpy_release():
> >     End of restartable sequence made of zero or more loads, a
> >     speculative copy of a variable length memory region, completed by a
> >     word-sized store with release semantic.
> >
> > PowerPC tests have been implemented by Boqun Feng.
>=20
> Hi Boqun,
>=20

Hello Michael,

> I'm having trouble testing these, I get:
>=20
>   ~/linus/tools/testing/selftests/cpu-opv$ ./basic_cpu_opv_test
>   Testing test_compare_eq same
>   Testing test_compare_eq different
>   Testing test_compare_ne same
>   Testing test_compare_ne different
>   Testing test_2compare_eq index
>   Testing test_2compare_ne index
>   Testing test_memcpy
>   Testing test_memcpy_u32
>   Testing test_add
>   Testing test_two_add
>   Testing test_or
>   Testing test_and
>   Testing test_xor
>   Testing test_lshift
>   Testing test_rshift
>   Testing test_cmpxchg success
>   Testing test_cmpxchg fail
>  =20
>   ~/linus/tools/testing/selftests/rseq$ ./basic_test
>   testing current cpu
>   testing critical section
>   testing critical section is interrupted by signal
>=20
>   ~/linus/tools/testing/selftests/rseq$ ./basic_percpu_ops_test
>   ./basic_percpu_ops_test: error while loading shared libraries: R_PPC64_=
ADDR16_HI re10d8f10a0 for symbol `' out of range
>   ~/linus/tools/testing/selftests/rseq$ ./param_test
>   ./param_test: error while loading shared libraries: R_PPC64_ADDR16_HI r=
e136251b48 for symbol `' out of range
>=20

I think this one is due to the same reason as:

	7998eb3dc700 ("powerpc: Fix 64 bit builds with binutils 2.24")

I have made the fix before, but seems forgot to send it to Mathieu...

so would this help?
=09
diff --git a/tools/testing/selftests/rseq/rseq-ppc.h b/tools/testing/selfte=
sts/rseq/rseq-ppc.h
index bc78b4fd72b1..39cbabe89b0e 100644
--- a/tools/testing/selftests/rseq/rseq-ppc.h
+++ b/tools/testing/selftests/rseq/rseq-ppc.h
@@ -74,7 +74,7 @@ do {									\
 		"lis %%r17, (3b)@highest\n\t" \
 		"ori %%r17, %%r17, (3b)@higher\n\t" \
 		"rldicr %%r17, %%r17, 32, 31\n\t" \
-		"oris %%r17, %%r17, (3b)@h\n\t" \
+		"oris %%r17, %%r17, (3b)@high\n\t" \
 		"ori %%r17, %%r17, (3b)@l\n\t" \
 		"std %%r17, 0(%[rseq_cs])\n\t" \
 		RSEQ_INJECT_ASM(2) \

Regards,
Boqun

>=20
> Any idea what's going on with the last two? I assume you don't see that
> in your test setup :)
>=20
> cheers

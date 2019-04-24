From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [RFC PATCH for 5.2 08/10] rseq/selftests: aarch64 code
 signature: handle big-endian environment
Date: Wed, 24 Apr 2019 17:40:33 +0100
Message-ID: <20190424164032.GD21101@lakrids.cambridge.arm.com>
References: <20190424152502.14246-1-mathieu.desnoyers@efficios.com>
 <20190424152502.14246-9-mathieu.desnoyers@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190424152502.14246-9-mathieu.desnoyers@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, Steven Rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm>
List-Id: linux-api@vger.kernel.org

On Wed, Apr 24, 2019 at 11:25:00AM -0400, Mathieu Desnoyers wrote:
> Handle compiling with -mbig-endian on aarch64, which generates binaries
> with mixed code vs data endianness (little endian code, big endian
> data).
> 
> Else mismatch between code endianness for the generated signatures and
> data endianness for the RSEQ_SIG parameter passed to the rseq
> registration will trigger application segmentation faults when the
> kernel try to abort rseq critical sections.
> 
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> CC: Joel Fernandes <joelaf@google.com>
> CC: Catalin Marinas <catalin.marinas@arm.com>
> CC: Dave Watson <davejwatson@fb.com>
> CC: Will Deacon <will.deacon@arm.com>
> CC: Shuah Khan <shuah@kernel.org>
> CC: Andi Kleen <andi@firstfloor.org>
> CC: linux-kselftest@vger.kernel.org
> CC: "H . Peter Anvin" <hpa@zytor.com>
> CC: Chris Lameter <cl@linux.com>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Michael Kerrisk <mtk.manpages@gmail.com>
> CC: "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>
> CC: Paul Turner <pjt@google.com>
> CC: Boqun Feng <boqun.feng@gmail.com>
> CC: Josh Triplett <josh@joshtriplett.org>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Ben Maurer <bmaurer@fb.com>
> CC: linux-api@vger.kernel.org
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Linus Torvalds <torvalds@linux-foundation.org>
> ---
>  tools/testing/selftests/rseq/rseq-arm64.h | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/rseq/rseq-arm64.h b/tools/testing/selftests/rseq/rseq-arm64.h
> index b41a2a48e965..200dae9e4208 100644
> --- a/tools/testing/selftests/rseq/rseq-arm64.h
> +++ b/tools/testing/selftests/rseq/rseq-arm64.h
> @@ -6,7 +6,20 @@
>   * (C) Copyright 2018 - Will Deacon <will.deacon@arm.com>
>   */
>  
> -#define RSEQ_SIG	0xd428bc00	/* BRK #0x45E0 */
> +/*
> + * aarch64 -mbig-endian generates mixed endianness code vs data:
> + * little-endian code and big-endian data. Ensure the RSEQ_SIG signature
> + * matches code endianness.
> + */
> +#define RSEQ_SIG_CODE	0xd428bc00	/* BRK #0x45E0.  */
> +
> +#ifdef __AARCH64EB__
> +#define RSEQ_SIG_DATA	0x00bc28d4	/* BRK #0x45E0.  */
> +#else
> +#define RSEQ_SIG_DATA	RSEQ_SIG_CODE
> +#endif
> +
> +#define RSEQ_SIG	RSEQ_SIG_DATA
>  
>  #define rseq_smp_mb()	__asm__ __volatile__ ("dmb ish" ::: "memory")
>  #define rseq_smp_rmb()	__asm__ __volatile__ ("dmb ishld" ::: "memory")
> @@ -121,7 +134,7 @@ do {										\
>  
>  #define RSEQ_ASM_DEFINE_ABORT(label, abort_label)				\
>  	"	b	222f\n"							\
> -	"	.inst 	"	__rseq_str(RSEQ_SIG) "\n"			\
> +	"	.inst 	"	__rseq_str(RSEQ_SIG_CODE) "\n"			\

I don't think this is right; the .inst directive _should_ emit the value
in the instruction stream endianness (i.e. LE, regardless of the data
endianness).

That's certainly the case with the kernel.org crosstool GCC:

[mark@lakrids:/mnt/data/tests/inst-test]% cat test.c                               
void func(void)
{
        asm volatile(".inst 0xd4000001");
}
[mark@lakrids:/mnt/data/tests/inst-test]% usekorg 8.1.0 aarch64-linux-gcc -c test.c
[mark@lakrids:/mnt/data/tests/inst-test]% usekorg 8.1.0 aarch64-linux-objdump -d test.o

test.o:     file format elf64-littleaarch64


Disassembly of section .text:

0000000000000000 <func>:
   0:   d4000001        svc     #0x0
   4:   d503201f        nop
   8:   d65f03c0        ret
[mark@lakrids:/mnt/data/tests/inst-test]% usekorg 8.1.0 aarch64-linux-gcc -mbig-endian -c test.c
[mark@lakrids:/mnt/data/tests/inst-test]% usekorg 8.1.0 aarch64-linux-objdump -d test.o         

test.o:     file format elf64-bigaarch64


Disassembly of section .text:

0000000000000000 <func>:
   0:   d4000001        svc     #0x0
   4:   d503201f        nop
   8:   d65f03c0        ret



Have you tested this? Is there some toolchain that doesn't get this
right?

Thanks,
Mark.

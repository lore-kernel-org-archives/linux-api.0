From: Will Deacon <will@kernel.org>
Subject: Re: [RFC PATCH 1/1] Revert "rseq/selftests: arm: use udf instruction
 for RSEQ_SIG"
Date: Wed, 26 Jun 2019 19:00:13 +0100
Message-ID: <20190626180012.q6deohrtzwpbhqky@willie-the-truck>
References: <20190617152304.23371-1-mathieu.desnoyers@efficios.com>
 <20190624172429.GA11133@fuggles.cambridge.arm.com>
 <1620037196.377.1561400426591.JavaMail.zimbra@efficios.com>
 <20190625091507.GA13263@fuggles.cambridge.arm.com>
 <795143697.722.1561471732756.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <795143697.722.1561471732756.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Will Deacon <will.deacon@arm.com>, shuah <shuah@kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Joel Fernandes <joelaf@google.com>, Catalin Marinas <catalin.marinas@arm.com>, Dave Watson <davejwatson@fb.com>, Andi Kleen <andi@firstfloor.org>, linux-kselftest <linux-kselftest@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Chris Lameter <cl@linux.com>, Russell King <linux@arm.linux.org.uk>, Michael Kerrisk <mtk.manpages@gmail.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Paul Turner <pjt@google.com>, Boqun Feng <boqun.feng@gmail.com>, Josh Triplett <josh@joshtriplett.org>, rostedt <rostedt@goodmis.org>, Ben Maurer <bmaurer@fb.com>, linux-api <linux-api>
List-Id: linux-api@vger.kernel.org

On Tue, Jun 25, 2019 at 10:08:52AM -0400, Mathieu Desnoyers wrote:
> ----- On Jun 25, 2019, at 5:15 AM, Will Deacon will.deacon@arm.com wrote:
> > On Mon, Jun 24, 2019 at 02:20:26PM -0400, Mathieu Desnoyers wrote:
> >> ----- On Jun 24, 2019, at 1:24 PM, Will Deacon will.deacon@arm.com wrote:
> >> > On Mon, Jun 17, 2019 at 05:23:04PM +0200, Mathieu Desnoyers wrote:
> >> >> -#define RSEQ_SIG_CODE	0xe7f5def3
> >> >> -
> >> >> -#ifndef __ASSEMBLER__
> >> >> -
> >> >> -#define RSEQ_SIG_DATA							\
> >> >> -	({								\
> >> >> -		int sig;						\
> >> >> -		asm volatile ("b 2f\n\t"				\
> >> >> -			      "1: .inst " __rseq_str(RSEQ_SIG_CODE) "\n\t" \
> >> >> -			      "2:\n\t"					\
> >> >> -			      "ldr %[sig], 1b\n\t"			\
> >> >> -			      : [sig] "=r" (sig));			\
> >> >> -		sig;							\
> >> >> -	})
> >> >> -
> >> >> -#define RSEQ_SIG	RSEQ_SIG_DATA
> >> >> -
> >> >> -#endif
> >> >> +#define RSEQ_SIG	0x53053053
> >> > 
> >> > I don't get why you're reverting back to this old signature value, when the
> >> > one we came up with will work well when interpreted as an instruction in the
> >> > *vast* majority of scenarios that people care about (A32/T32 little-endian).
> >> > I think you might be under-estimating just how dead things like BE32 really
> >> > are.
> >> 
> >> My issue is that the current .instr approach is broken for programs or functions
> >> built in Thumb mode, and I received no feedback on the solutions I proposed for
> >> those issues, which led me to propose a patch reverting to a simple .word.
> > 
> > I understand why you're moving from .inst to .word, but I don't understand
> > why that necessitates a change in the value. Why not .word 0xe7f5def3 ? You
> > could also flip the bytes around in case of big-endian, which would keep the
> > instruction coding clean for BE8.
> 
> As long as we state and document that this should not be expected to generate
> valid instructions on big endian prior to ARMv6, I'm OK with that approach, e.g.:
> 
> /*
>  * - ARM little endian
>  *
>  * RSEQ_SIG uses the udf A32 instruction with an uncommon immediate operand
>  * value 0x5de3. This traps if user-space reaches this instruction by mistake,
>  * and the uncommon operand ensures the kernel does not move the instruction
>  * pointer to attacker-controlled code on rseq abort.
>  *
>  * The instruction pattern in the A32 instruction set is:
>  *
>  * e7f5def3    udf    #24035    ; 0x5de3
>  *
>  * This translates to the following instruction pattern in the T16 instruction
>  * set:
>  *
>  * little endian:
>  * def3        udf    #243      ; 0xf3
>  * e7f5        b.n    <7f5>
>  *
>  * - ARMv6+ big endian:

Maybe mention "(BE8)" here...

>  *
>  * ARMv6+ -mbig-endian generates mixed endianness code vs data: little-endian
>  * code and big-endian data. The data value of the signature needs to have its
>  * byte order reversed to generate the trap instruction:
>  *
>  * Data: 0xf3def5e7
>  *
>  * Translates to this A32 instruction pattern:
>  *
>  * e7f5def3    udf    #24035    ; 0x5de3
>  *
>  * Translates to this T16 instruction pattern:
>  *
>  * def3        udf    #243      ; 0xf3
>  * e7f5        b.n    <7f5>
>  *
>  * - Prior to ARMv6 big endian:

... and "(BE32)" here.

With that, this looks fine to me.

Will

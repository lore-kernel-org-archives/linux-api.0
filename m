From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/4] glibc: Perform rseq(2) registration at C startup
 and thread creation (v7)
Date: Thu, 28 Mar 2019 11:42:58 -0400 (EDT)
Message-ID: <37506383.12659.1553787778500.JavaMail.zimbra@efficios.com>
References: <20190212194253.1951-1-mathieu.desnoyers@efficios.com> <20190212194253.1951-2-mathieu.desnoyers@efficios.com> <5166fbe9-cfe0-8554-abc7-4fc844cf2765@redhat.com> <1965431879.7576.1553529272844.JavaMail.zimbra@efficios.com> <20190327101608.77b0de6f@mschwideX1> <4021516e-6a1e-166d-a4f6-e961e6f94cc4@redhat.com> <20190328084948.6486fa67@mschwideX1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190328084948.6486fa67@mschwideX1>
Sender: linux-kernel-owner@vger.kernel.org
To: schwidefsky <schwidefsky@de.ibm.com>
Cc: Carlos O'Donell <codonell@redhat.com>, Paul Burton <paul.burton@mips.com>, Will Deacon <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, heiko carstens <heiko.carstens@de.ibm.com>, gor <gor@linux.ibm.com>, "Russell King, ARM Linux" <linux@armlinux.org.uk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Dave Watson <davejwatso>
List-Id: linux-api@vger.kernel.org

----- On Mar 28, 2019, at 3:49 AM, schwidefsky schwidefsky@de.ibm.com wrote:

> On Wed, 27 Mar 2019 16:38:32 -0400
> "Carlos O'Donell" <codonell@redhat.com> wrote:
> 
>> On 3/27/19 5:16 AM, Martin Schwidefsky wrote:
>> > On Mon, 25 Mar 2019 11:54:32 -0400 (EDT)
>> > Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>> >   
>> >>>> +++ b/sysdeps/unix/sysv/linux/s390/bits/rseq.h
>> >> [...]
>> >>>> +
>> >>>> +/* Signature required before each abort handler code.  */
>> >>>> +#define RSEQ_SIG 0x53053053
>> >>>
>> >>> Why not a s390 specific value here?
>> >>
>> >> s390 also has the abort handler in a __rseq_failure section:
>> >>
>> >> #define RSEQ_ASM_DEFINE_ABORT(label, teardown, abort_label)             \
>> >>                  ".pushsection __rseq_failure, \"ax\"\n\t"               \
>> >>                  ".long " __rseq_str(RSEQ_SIG) "\n\t"                    \
>> >>                  __rseq_str(label) ":\n\t"                               \
>> >>                  teardown                                                \
>> >>                  "j %l[" __rseq_str(abort_label) "]\n\t"                 \
>> >>                  ".popsection\n\t"
>> >>
>> >> Same question applies as powerpc: since disassemblers will try to decode
>> >> that instruction, would it be better to define it as a valid one ?
>> >>
>> >> [...]
>> > 
>> > A 4-byte sequence starting with 0x53 is decoded as a "diebr" instruction.
>> > And please replace that "j %l[...]" with a "jg %l[...]", the branch target
>> > range of the "j" instruction is 64K, not enough for the general case.
>> 
>> Why was this particular operated selected?

The 0x53053053 signature was selected by myself on x86, where it is a
4-byte operand to a no-op instruction. That value looks like "SEQSEQSE"
in hexadecimal. The goal was to have an uncommon code signature value.

Then it has been used as-is on arm and mips within literal pools (which seems
fine), and also on s390 and powerpc where those seem to generate invalid
instruction within a separate code section.

I'm mainly concerned about the choice of this value on s390 and powerpc.

>>   
>> So on s390 the RSEQ_SIG will show up as an unexpected "divide to integer"
>> instruction that can't be reached by any control flow?
>> 
>> Can we use a NOP with a unique value in an immediate operand?
>> 
>> The goal being to have something that won't confuse during a debug
>> session, or that the debugger can ignore (like constant pools on Arm)
> 
> I was looking at the wrong table in regard to opcode 0x53. The pattern
> 0x53...... is not a known instruction as far as the disassembler is
> concerned. As Mathieu pointed out "diebr" is actually 0xb353....
> Sorry about the confusion.
> 
> But why do we need this value in the first place if it can not be reached?

One reason is to help disassemblers in tools like objdump, gdb, and so on.

Another reason for making this a valid instruction is if the CPU speculative
execution can be helped by making this instruction a valid one, even though
it's not reachable through normal execution. (this appears to be important
at least on aarch64)

However, we want that instruction to be an uncommon one, to reduce the chances
that an attacker can use the rseq abort mechanism to redirect execution to
an unrelated code block that would happen to follow that same 4-byte signature.
For instance, I would not use a no-op which is typically generated by compilers
there.

In summary:

* x86: Uses a no-op instruction ending with a 4-byte operand.
* aarch64: Uses a trap instruction which also has a seldom-used operand value.
* arm: The signature is in a literal pool (there is a jump over the signature).
* mips: The signature is in a literal pool (there is a jump over the signature).
* powerpc: the signature is an unreachable invalid(?) instruction within an
  executable section.
* s390: the signature is an unreachable invalid instruction within an executable
  section.

Thanks,

Mathieu



-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

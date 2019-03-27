From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/4] glibc: Perform rseq(2) registration at C startup
 and thread creation (v7)
Date: Wed, 27 Mar 2019 16:01:35 -0400 (EDT)
Message-ID: <1545235218.11875.1553716895944.JavaMail.zimbra@efficios.com>
References: <20190212194253.1951-1-mathieu.desnoyers@efficios.com> <20190212194253.1951-2-mathieu.desnoyers@efficios.com> <5166fbe9-cfe0-8554-abc7-4fc844cf2765@redhat.com> <1965431879.7576.1553529272844.JavaMail.zimbra@efficios.com> <20190327101608.77b0de6f@mschwideX1>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190327101608.77b0de6f@mschwideX1>
Sender: linux-kernel-owner@vger.kernel.org
To: schwidefsky <schwidefsky@de.ibm.com>
Cc: Carlos O'Donell <codonell@redhat.com>, Paul Burton <paul.burton@mips.com>, Will Deacon <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, heiko carstens <heiko.carstens@de.ibm.com>, gor <gor@linux.ibm.com>, "Russell King, ARM Linux" <linux@armlinux.org.uk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Dave Watson <davejwatso>
List-Id: linux-api@vger.kernel.org

----- On Mar 27, 2019, at 5:16 AM, schwidefsky schwidefsky@de.ibm.com wrote:

> On Mon, 25 Mar 2019 11:54:32 -0400 (EDT)
> Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
> 
>> >> +++ b/sysdeps/unix/sysv/linux/s390/bits/rseq.h
>> [...]
>> >> +
>> >> +/* Signature required before each abort handler code.  */
>> >> +#define RSEQ_SIG 0x53053053
>> > 
>> > Why not a s390 specific value here?
>> 
>> s390 also has the abort handler in a __rseq_failure section:
>> 
>> #define RSEQ_ASM_DEFINE_ABORT(label, teardown, abort_label)             \
>>                 ".pushsection __rseq_failure, \"ax\"\n\t"               \
>>                 ".long " __rseq_str(RSEQ_SIG) "\n\t"                    \
>>                 __rseq_str(label) ":\n\t"                               \
>>                 teardown                                                \
>>                 "j %l[" __rseq_str(abort_label) "]\n\t"                 \
>>                 ".popsection\n\t"
>> 
>> Same question applies as powerpc: since disassemblers will try to decode
>> that instruction, would it be better to define it as a valid one ?
>> 
>> [...]
> 
> A 4-byte sequence starting with 0x53 is decoded as a "diebr" instruction.

Based on the z/Architecture reference summary, it appears that the DIEBR
instruction's opcode is B353. So I suspect that just starting with 0x53 is
not sufficient to make it a valid opcode in the instruction set. Is it
something we should care about ?

> And please replace that "j %l[...]" with a "jg %l[...]", the branch target
> range of the "j" instruction is 64K, not enough for the general case.

I'll also need to use "jg" for RSEQ_ASM_DEFINE_CMPFAIL:

#define RSEQ_ASM_DEFINE_CMPFAIL(label, teardown, cmpfail_label)         \
                ".pushsection __rseq_failure, \"ax\"\n\t"               \
                __rseq_str(label) ":\n\t"                               \
                teardown                                                \
                "jg %l[" __rseq_str(cmpfail_label) "]\n\t"              \
                ".popsection\n\t"

I'll prepare a fix for Linux selftests, and I already pushed a fix within
my librseq repository.

Thanks for pointing it out!

Mathieu

> 
> --
> blue skies,
>   Martin.
> 
> "Reality continues to ruin my life." - Calvin.

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

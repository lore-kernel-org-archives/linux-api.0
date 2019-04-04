From: Carlos O'Donell <codonell@redhat.com>
Subject: Re: [PATCH 1/4] glibc: Perform rseq(2) registration at C startup and
 thread creation (v7)
Date: Thu, 4 Apr 2019 16:50:08 -0400
Message-ID: <602718e0-7375-deb7-b6e6-2d17022173c5@redhat.com>
References: <20190212194253.1951-1-mathieu.desnoyers@efficios.com>
 <20190212194253.1951-2-mathieu.desnoyers@efficios.com>
 <5166fbe9-cfe0-8554-abc7-4fc844cf2765@redhat.com>
 <1965431879.7576.1553529272844.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1965431879.7576.1553529272844.JavaMail.zimbra@efficios.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Paul Burton <paul.burton@mips.com>, Will Deacon <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 3/25/19 11:54 AM, Mathieu Desnoyers wrote:
> Hi Carlos,
> 
> ----- On Mar 22, 2019, at 4:09 PM, Carlos O'Donell codonell@redhat.com wrote:
> 
> [...]
> 
> I took care of all your comments for an upcoming round of patches, except the
> following that remain open (see answer inline). I'm adding Linux maintainers
> for ARM, aarch64, MIPS, powerpc, s390, x86 in CC to discuss the choice of
> code signature prior to the abort handler for each of those architectures.

Thank you for kicking off this conversation.

Every architecture should have a reasonable RSEQ_SIG that applies to their
ISA with a comment about why that instruction was chosen. It should be a
conscious choice, without a default.

> * Support for automatically registering threads with the Linux rseq(2)
>    system call has been added.  This system call is implemented starting
>    from Linux 4.18.  The Restartable Sequences ABI accelerates user-space
>    operations on per-cpu data.  It allows user-space to perform updates
>    on per-cpu data without requiring heavy-weight atomic operations. See
>    https://www.efficios.com/blog/2019/02/08/linux-restartable-sequences/
>    for further explanation.
> 
>    In order to be activated, it requires that glibc is built against
>    kernel headers that include this system call, and that glibc detects
>    availability of that system call at runtime.

Suggest:

* Support for automatically registering threads with the Linux rseq(2)
   system call has been added.  This system call is implemented starting
   from Linux 4.18.  The Restartable Sequences ABI accelerates user-space
   operations on per-cpu data.  It allows user-space to perform updates
   on per-cpu data without requiring heavy-weight atomic operations.
   Automatically registering threads allows all libraries, including libc,
   to make immediate use of the rseq(2) support by using the documented ABI.
   See 'man 2 rseq' for the details of the ABI shared between libc and the
   kernel.

> 
> For reference the assembly code I'm pointing at below can be found
> in the Linux selftests under:
> 
> tools/testing/selftests/rseq/rseq-*.h

OK.


>>> +++ b/sysdeps/unix/sysv/linux/arm/bits/rseq.h
> [...]
>>> +
>>> +/* Signature required before each abort handler code.  */
>>> +#define RSEQ_SIG 0x53053053
>>
>> Why isn't this an arm specific op code? Does the user have to mark this
>> up as part of a constant pool when placing it in front of the abort handler
>> to avoid disassembling the constant as code? This was at one point required
>> to get gdb to work properly.
>>
> 
> For arm, the abort is defined as:
> 
> #define __RSEQ_ASM_DEFINE_ABORT(table_label, label, teardown,           \
>                                  abort_label, version, flags,            \
>                                  start_ip, post_commit_offset, abort_ip) \
>                  ".balign 32\n\t"                                        \
>                  __rseq_str(table_label) ":\n\t"                         \
>                  ".word " __rseq_str(version) ", " __rseq_str(flags) "\n\t" \
>                  ".word " __rseq_str(start_ip) ", 0x0, " __rseq_str(post_commit_offset) ", 0x0, " __rseq_str(abort_ip) ", 0x0\n\t" \
>                  ".word " __rseq_str(RSEQ_SIG) "\n\t"                    \
>                  __rseq_str(label) ":\n\t"                               \
>                  teardown                                                \
>                  "b %l[" __rseq_str(abort_label) "]\n\t"
> 
> Which contains a copy of the struct rseq_cs for that critical section
> close to the actual critical section, within the code, followed by the
> signature. The reason why we have a copy of the struct rseq_cs there is
> to speed up entry into the critical section by using the "adr" instruction
> to compute the address to store into __rseq_cs->rseq_cs.
> 
> AFAIU, a literal pool on ARM is defined as something which is always
> jumped over (never executed), which is the case here. We always have
> an unconditional branch instruction ("b") skipping over each
> RSEQ_ASM_DEFINE_ABORT().
> 
> Therefore, given that the signature is part of a literal pool on ARM,
> it can be any value we choose and should not need to be an actual valid
> instruction.
> 
> aarch64 defines the abort as:
> 
> #define RSEQ_ASM_DEFINE_ABORT(label, abort_label)                               \
>          "       b       222f\n"                                                 \
>          "       .inst   "       __rseq_str(RSEQ_SIG) "\n"                       \
>          __rseq_str(label) ":\n"                                                 \
>          "       b       %l[" __rseq_str(abort_label) "]\n"                      \
>          "222:\n"
> 
> Where the signature actually maps to a valid instruction. Considering that
> aarch64 also have literal pools, and we branch over the signature, I wonder
> why it's so important to ensure the signature is a valid trap instruction.
> Perhaps Will Deacon can enlighten us ?

In the event that you accidentally jump to it then you trap?

However, you want an *uncommon* trap insn.

I think the order of preference is:

1.  An uncommon insn (with random immediate values), in a literal pool, that is
     not a useful ROP/JOP sequence (very uncommon)
2a. A uncommon TRAP hopefully with some immediate data encoded (maybe uncommon)
2b. A NOP to avoid affecting speculative execution (maybe uncommon)

With 2a/2b being roughly equivalent depending on speculative execution policy.

>>> +/* Signature required before each abort handler code.  */
>>> +#define RSEQ_SIG 0x53053053
>>
>> Why isn't this a mips-specific op code?
> 
> MIPS also has a literal pool just before the abort handler, and it
> jumps over it. My understanding is that we can use any signature value
> we want, and it does not need to be a valid instruction, similarly to ARM:
> 
> #define __RSEQ_ASM_DEFINE_ABORT(table_label, label, teardown, \
>                                  abort_label, version, flags, \
>                                  start_ip, post_commit_offset, abort_ip) \
>                  ".balign 32\n\t" \
>                  __rseq_str(table_label) ":\n\t" \
>                  ".word " __rseq_str(version) ", " __rseq_str(flags) "\n\t" \
>                  LONG " " U32_U64_PAD(__rseq_str(start_ip)) "\n\t" \
>                  LONG " " U32_U64_PAD(__rseq_str(post_commit_offset)) "\n\t" \
>                  LONG " " U32_U64_PAD(__rseq_str(abort_ip)) "\n\t" \
>                  ".word " __rseq_str(RSEQ_SIG) "\n\t" \
>                  __rseq_str(label) ":\n\t" \
>                  teardown \
>                  "b %l[" __rseq_str(abort_label) "]\n\t"
> 
> Perhaps Paul Burton can confirm this ?

Yes please.

You also want to avoid the value being a valid MIPS insn that's common.

Did you check that?

> [...]
>>> +++ b/sysdeps/unix/sysv/linux/powerpc/bits/rseq.h
> [...]
>>> +/* Signature required before each abort handler code.  */
>>> +#define RSEQ_SIG 0x53053053
>>
>> Why isn't this an opcode specific to power?
> 
> On powerpc 32/64, the abort is placed in a __rseq_failure executable section:
> 
> #define RSEQ_ASM_DEFINE_ABORT(label, abort_label)                               \
>                  ".pushsection __rseq_failure, \"ax\"\n\t"                       \
>                  ".long " __rseq_str(RSEQ_SIG) "\n\t"                            \
>                  __rseq_str(label) ":\n\t"                                       \
>                  "b %l[" __rseq_str(abort_label) "]\n\t"                         \
>                  ".popsection\n\t"
> 
> That section only contains snippets of those trampolines. Arguably, it would be
> good if disassemblers could find valid instructions there. Boqun Feng could perhaps
> shed some light on this signature choice ? Now would be a good time to decide
> once and for all whether a valid instruction would be a better choice.

This seems questionable too.

> [...]
>>> +++ b/sysdeps/unix/sysv/linux/s390/bits/rseq.h
> [...]
>>> +
>>> +/* Signature required before each abort handler code.  */
>>> +#define RSEQ_SIG 0x53053053
>>
>> Why not a s390 specific value here?
> 
> s390 also has the abort handler in a __rseq_failure section:
> 
> #define RSEQ_ASM_DEFINE_ABORT(label, teardown, abort_label)             \
>                  ".pushsection __rseq_failure, \"ax\"\n\t"               \
>                  ".long " __rseq_str(RSEQ_SIG) "\n\t"                    \
>                  __rseq_str(label) ":\n\t"                               \
>                  teardown                                                \
>                  "j %l[" __rseq_str(abort_label) "]\n\t"                 \
>                  ".popsection\n\t"
> 
> Same question applies as powerpc: since disassemblers will try to decode
> that instruction, would it be better to define it as a valid one ?

Yes, I think it needs to be a valid uncommon insn or nop.

> [...]
>>> +++ b/sysdeps/unix/sysv/linux/x86/bits/rseq.h
> [...]
>>> +/* Signature required before each abort handler code.  */
>>> +#define RSEQ_SIG 0x53053053
>>
>> Why not an x86-specific op code?
> 
> On x86, we use this 4-byte signature as operand to a "no-op" instruction
> taking 4-byte immediate operand:

That makes perfect sense. Thanks.

So what is left to audit?

In summary:

- Why does AArch64 choose a trap?

- Is the current choice of 0x53053053 OK for MIPS? Does it map to a valid insn?

- What better choice is there for power? Pick a real uncommon insn or nop?

- What better choice is there for s390? Pick a real uncommon insn or nop?
   - Todays choice could become something special in the future since it's unassigned.

-- 
Cheers,
Carlos.

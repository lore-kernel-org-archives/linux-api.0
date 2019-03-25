From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/4] glibc: Perform rseq(2) registration at C startup
 and thread creation (v7)
Date: Mon, 25 Mar 2019 11:54:32 -0400 (EDT)
Message-ID: <1965431879.7576.1553529272844.JavaMail.zimbra@efficios.com>
References: <20190212194253.1951-1-mathieu.desnoyers@efficios.com> <20190212194253.1951-2-mathieu.desnoyers@efficios.com> <5166fbe9-cfe0-8554-abc7-4fc844cf2765@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5166fbe9-cfe0-8554-abc7-4fc844cf2765@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Carlos O'Donell <codonell@redhat.com>, Paul Burton <paul.burton@mips.com>, Will Deacon <will.deacon@arm.com>, Boqun Feng <boqun.feng@gmail.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>
Cc: carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Joseph Myers <joseph@codesourcery.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hi Carlos,

----- On Mar 22, 2019, at 4:09 PM, Carlos O'Donell codonell@redhat.com wrote:

[...]

I took care of all your comments for an upcoming round of patches, except the
following that remain open (see answer inline). I'm adding Linux maintainers
for ARM, aarch64, MIPS, powerpc, s390, x86 in CC to discuss the choice of
code signature prior to the abort handler for each of those architectures.

[...]

>> diff --git a/NEWS b/NEWS
>> index 912a9bdc0f..0608c60f7d 100644
>> --- a/NEWS
>> +++ b/NEWS
>> @@ -5,6 +5,17 @@ See the end for copying conditions.
>>   Please send GNU C library bug reports via <https://sourceware.org/bugzilla/>
>>   using `glibc' in the "product" field.
>>   
>> +Version 2.30
>> +
>> +Major new features:
>> +
>> +* Support for automatically registering threads with the Linux rseq(2)
>> +  system call has been added. This system call is implemented starting
>> +  from Linux 4.18. In order to be activated, it requires that glibc is built
>> +  against kernel headers that include this system call, and that glibc
>> +  detects availability of that system call at runtime.
> 
> What benefit does the feature have for users? Can you talk about that please?
> Why would a user want to use it. Please feel free to link to an external
> reference.

Would the following text work ?

Version 2.30

Major new features:

* Support for automatically registering threads with the Linux rseq(2)
  system call has been added.  This system call is implemented starting
  from Linux 4.18.  The Restartable Sequences ABI accelerates user-space
  operations on per-cpu data.  It allows user-space to perform updates
  on per-cpu data without requiring heavy-weight atomic operations. See
  https://www.efficios.com/blog/2019/02/08/linux-restartable-sequences/
  for further explanation.

  In order to be activated, it requires that glibc is built against
  kernel headers that include this system call, and that glibc detects
  availability of that system call at runtime.


For reference the assembly code I'm pointing at below can be found
in the Linux selftests under:

tools/testing/selftests/rseq/rseq-*.h

>> +++ b/sysdeps/unix/sysv/linux/arm/bits/rseq.h
[...]
>> +
>> +/* Signature required before each abort handler code.  */
>> +#define RSEQ_SIG 0x53053053
> 
> Why isn't this an arm specific op code? Does the user have to mark this
> up as part of a constant pool when placing it in front of the abort handler
> to avoid disassembling the constant as code? This was at one point required
> to get gdb to work properly.
> 

For arm, the abort is defined as:

#define __RSEQ_ASM_DEFINE_ABORT(table_label, label, teardown,           \
                                abort_label, version, flags,            \
                                start_ip, post_commit_offset, abort_ip) \
                ".balign 32\n\t"                                        \
                __rseq_str(table_label) ":\n\t"                         \
                ".word " __rseq_str(version) ", " __rseq_str(flags) "\n\t" \
                ".word " __rseq_str(start_ip) ", 0x0, " __rseq_str(post_commit_offset) ", 0x0, " __rseq_str(abort_ip) ", 0x0\n\t" \
                ".word " __rseq_str(RSEQ_SIG) "\n\t"                    \
                __rseq_str(label) ":\n\t"                               \
                teardown                                                \
                "b %l[" __rseq_str(abort_label) "]\n\t"

Which contains a copy of the struct rseq_cs for that critical section
close to the actual critical section, within the code, followed by the
signature. The reason why we have a copy of the struct rseq_cs there is
to speed up entry into the critical section by using the "adr" instruction
to compute the address to store into __rseq_cs->rseq_cs.

AFAIU, a literal pool on ARM is defined as something which is always
jumped over (never executed), which is the case here. We always have
an unconditional branch instruction ("b") skipping over each
RSEQ_ASM_DEFINE_ABORT().

Therefore, given that the signature is part of a literal pool on ARM,
it can be any value we choose and should not need to be an actual valid
instruction.

aarch64 defines the abort as:

#define RSEQ_ASM_DEFINE_ABORT(label, abort_label)                               \
        "       b       222f\n"                                                 \
        "       .inst   "       __rseq_str(RSEQ_SIG) "\n"                       \
        __rseq_str(label) ":\n"                                                 \
        "       b       %l[" __rseq_str(abort_label) "]\n"                      \
        "222:\n"

Where the signature actually maps to a valid instruction. Considering that
aarch64 also have literal pools, and we branch over the signature, I wonder
why it's so important to ensure the signature is a valid trap instruction.
Perhaps Will Deacon can enlighten us ?


[...]
>> +++ b/sysdeps/unix/sysv/linux/bits/rseq.h
>> @@ -0,0 +1,24 @@
[...]
>> +
>> +/* Each architecture supporting rseq should define RSEQ_SIG as a 32-bit
>> +   signature inserted before each rseq abort label in the code section.  */
> 
> Needs a huge explanation about RSEQ_SIG and the reasons why it's per-arch.
> 
> Basically cut-and-paste what you wrote to libc-alpha about this.

Updated to:

/* RSEQ_SIG is a signature required before each abort handler code.

   It is a 32-bit value that maps to actual architecture code compiled
   into applications and libraries. It needs to be defined for each
   architecture. When choosing this value, it needs to be taken into
   account that generating invalid instructions may have ill effects on
   tools like objdump, and may also have impact on the CPU speculative
   execution efficiency in some cases.  */


[...]
>> +++ b/sysdeps/unix/sysv/linux/mips/bits/rseq.h
[...]
>> +
>> +/* Signature required before each abort handler code.  */
>> +#define RSEQ_SIG 0x53053053
> 
> Why isn't this a mips-specific op code?

MIPS also has a literal pool just before the abort handler, and it
jumps over it. My understanding is that we can use any signature value
we want, and it does not need to be a valid instruction, similarly to ARM:

#define __RSEQ_ASM_DEFINE_ABORT(table_label, label, teardown, \
                                abort_label, version, flags, \
                                start_ip, post_commit_offset, abort_ip) \
                ".balign 32\n\t" \
                __rseq_str(table_label) ":\n\t" \
                ".word " __rseq_str(version) ", " __rseq_str(flags) "\n\t" \
                LONG " " U32_U64_PAD(__rseq_str(start_ip)) "\n\t" \
                LONG " " U32_U64_PAD(__rseq_str(post_commit_offset)) "\n\t" \
                LONG " " U32_U64_PAD(__rseq_str(abort_ip)) "\n\t" \
                ".word " __rseq_str(RSEQ_SIG) "\n\t" \
                __rseq_str(label) ":\n\t" \
                teardown \
                "b %l[" __rseq_str(abort_label) "]\n\t"

Perhaps Paul Burton can confirm this ?

[...]
>> +++ b/sysdeps/unix/sysv/linux/powerpc/bits/rseq.h
[...]
>> +/* Signature required before each abort handler code.  */
>> +#define RSEQ_SIG 0x53053053
> 
> Why isn't this an opcode specific to power?

On powerpc 32/64, the abort is placed in a __rseq_failure executable section:

#define RSEQ_ASM_DEFINE_ABORT(label, abort_label)                               \
                ".pushsection __rseq_failure, \"ax\"\n\t"                       \
                ".long " __rseq_str(RSEQ_SIG) "\n\t"                            \
                __rseq_str(label) ":\n\t"                                       \
                "b %l[" __rseq_str(abort_label) "]\n\t"                         \
                ".popsection\n\t"

That section only contains snippets of those trampolines. Arguably, it would be
good if disassemblers could find valid instructions there. Boqun Feng could perhaps
shed some light on this signature choice ? Now would be a good time to decide
once and for all whether a valid instruction would be a better choice.

[...]
>> +++ b/sysdeps/unix/sysv/linux/s390/bits/rseq.h
[...]
>> +
>> +/* Signature required before each abort handler code.  */
>> +#define RSEQ_SIG 0x53053053
> 
> Why not a s390 specific value here?

s390 also has the abort handler in a __rseq_failure section:

#define RSEQ_ASM_DEFINE_ABORT(label, teardown, abort_label)             \
                ".pushsection __rseq_failure, \"ax\"\n\t"               \
                ".long " __rseq_str(RSEQ_SIG) "\n\t"                    \
                __rseq_str(label) ":\n\t"                               \
                teardown                                                \
                "j %l[" __rseq_str(abort_label) "]\n\t"                 \
                ".popsection\n\t"

Same question applies as powerpc: since disassemblers will try to decode
that instruction, would it be better to define it as a valid one ?

[...]
>> +++ b/sysdeps/unix/sysv/linux/x86/bits/rseq.h
[...]
>> +/* Signature required before each abort handler code.  */
>> +#define RSEQ_SIG 0x53053053
> 
> Why not an x86-specific op code?

On x86, we use this 4-byte signature as operand to a "no-op" instruction
taking 4-byte immediate operand:

x86-32:

#define RSEQ_ASM_DEFINE_ABORT(label, teardown, abort_label)             \
                ".pushsection __rseq_failure, \"ax\"\n\t"               \
                /* Disassembler-friendly signature: nopl <sig>. */      \
                ".byte 0x0f, 0x1f, 0x05\n\t"                            \
                ".long " __rseq_str(RSEQ_SIG) "\n\t"                    \
                __rseq_str(label) ":\n\t"                               \
                teardown                                                \
                "jmp %l[" __rseq_str(abort_label) "]\n\t"               \
                ".popsection\n\t"


x86-64:

#define RSEQ_ASM_DEFINE_ABORT(label, teardown, abort_label)             \
                ".pushsection __rseq_failure, \"ax\"\n\t"               \
                /* Disassembler-friendly signature: nopl <sig>(%rip). */\
                ".byte 0x0f, 0x1f, 0x05\n\t"                            \
                ".long " __rseq_str(RSEQ_SIG) "\n\t"                    \
                __rseq_str(label) ":\n\t"                               \
                teardown                                                \
                "jmp %l[" __rseq_str(abort_label) "]\n\t"               \
                ".popsection\n\t"

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

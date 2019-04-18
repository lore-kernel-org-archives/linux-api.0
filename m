From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup
 and thread creation (v8)
Date: Thu, 18 Apr 2019 11:41:07 -0400 (EDT)
Message-ID: <1055153722.1072.1555602067220.JavaMail.zimbra@efficios.com>
References: <20190416173216.9028-1-mathieu.desnoyers@efficios.com> <20190416173216.9028-2-mathieu.desnoyers@efficios.com> <364803063.586.1555516769056.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.1904171601540.32123@digraph.polyomino.org.uk> <1770787324.668.1555530989646.JavaMail.zimbra@efficios.com> <1066731871.915.1555593471194.JavaMail.zimbra@efficios.com> <6cbfea7b-9d83-74a5-9cd2-af56a5d68818@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6cbfea7b-9d83-74a5-9cd2-af56a5d68818@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Szabolcs Nagy <Szabolcs.Nagy@arm.com>
Cc: Joseph Myers <joseph@codesourcery.com>, Will Deacon <Will.Deacon@arm.com>, nd <nd@arm.com>, carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Apr 18, 2019, at 11:33 AM, Szabolcs Nagy Szabolcs.Nagy@arm.com wrote:

> On 18/04/2019 14:17, Mathieu Desnoyers wrote:
>> ----- On Apr 17, 2019, at 3:56 PM, Mathieu Desnoyers
>> mathieu.desnoyers@efficios.com wrote:
>>> ----- On Apr 17, 2019, at 12:17 PM, Joseph Myers joseph@codesourcery.com wrote:
>>>> On Wed, 17 Apr 2019, Mathieu Desnoyers wrote:
>>>>
>>>>>> +/* RSEQ_SIG is a signature required before each abort handler code.
>>>>>> +
>>>>>> +   It is a 32-bit value that maps to actual architecture code compiled
>>>>>> +   into applications and libraries. It needs to be defined for each
>>>>>> +   architecture. When choosing this value, it needs to be taken into
>>>>>> +   account that generating invalid instructions may have ill effects on
>>>>>> +   tools like objdump, and may also have impact on the CPU speculative
>>>>>> +   execution efficiency in some cases.  */
>>>>>> +
>>>>>> +#define RSEQ_SIG 0xd428bc00	/* BRK #0x45E0.  */
>>>>>
>>>>> After further investigation, we should probably do the following
>>>>> to handle compiling with -mbig-endian on aarch64, which generates
>>>>> binaries with mixed code vs data endianness (little endian code,
>>>>> big endian data):
>>>>
>>>> First, the comment on RSEQ_SIG should specify whether it is to be
>>>> interpreted in the code or the data endianness.
>>>
>>> Right. The signature passed as argument to the rseq registration
>>> system call needs to be in data endianness (currently exposed kernel
>>> ABI).
>>>
>>> Ideally for userspace, we want to define a signature in code endianness
>>> that happens to nicely match specific code patterns.
> ...
>> For aarch64, I think we can simply do:
>> 
>> /*
>>  * aarch64 -mbig-endian generates mixed endianness code vs data:
>>  * little-endian code and big-endian data. Ensure the RSEQ_SIG signature
>>  * matches code endianness.
>>  */
>> #define RSEQ_SIG_CODE   0xd428bc00      /* BRK #0x45E0.  */
>> 
>> #ifdef __ARM_BIG_ENDIAN
>> #define RSEQ_SIG_DATA   0x00bc28d4      /* BRK #0x45E0.  */
>> #else
>> #define RSEQ_SIG_DATA   RSEQ_SIG_CODE
>> #endif
>> 
>> #define RSEQ_SIG        RSEQ_SIG_DATA
>> 
>> Feedback is most welcome,
> 
> so the RSEQ_SIG value is supposed to be used with .word
> in asm instead of .inst?

We want a .inst so it translates into a valid trap instruction.
It's better to trap in case program execution reaches this
by mistake (makes debugging easier).

> 
> i don't think we use __ARM_* in public headers currently,
> but hopefully aarch64_be compilers implement it.

Can I use #if __BYTE_ORDER__ == __ORDER_BIG_ENDIAN__  then ?

> 
> otherwise this looks ok to me.
> 
> (i think a rare palindrome instruction would work too, e.g.
> 0a5f5f0a 	and	w10, w24, wzr, lsr #23 // shifted 0
> 2a5f5f2a 	orr	w10, w25, wzr, lsr #23
> eb9f9feb 	negs	x11, xzr, asr #39
> c83f3fc8 	stxp	wzr, x8, x15, [x30]  // store to LR ignoring success
> d9ffffd9 	stz2g	x25, [x30, #-16]!    // v8.5 tag+zero 2 granules around LR
> etc. it does not need to be a guaranteed trap)

Unfortunately it's not a trap :/

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

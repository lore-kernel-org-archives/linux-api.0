From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [PATCH 1/5] glibc: Perform rseq(2) registration at C startup
 and thread creation (v8)
Date: Thu, 18 Apr 2019 11:37:14 -0400 (EDT)
Message-ID: <1515751456.1060.1555601834395.JavaMail.zimbra@efficios.com>
References: <20190416173216.9028-1-mathieu.desnoyers@efficios.com> <20190416173216.9028-2-mathieu.desnoyers@efficios.com> <364803063.586.1555516769056.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.1904171601540.32123@digraph.polyomino.org.uk> <1770787324.668.1555530989646.JavaMail.zimbra@efficios.com> <1066731871.915.1555593471194.JavaMail.zimbra@efficios.com> <alpine.DEB.2.21.1904181445550.5356@digraph.polyomino.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1904181445550.5356@digraph.polyomino.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Joseph Myers <joseph@codesourcery.com>
Cc: Will Deacon <will.deacon@arm.com>, carlos <carlos@redhat.com>, Florian Weimer <fweimer@redhat.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>, libc-alpha <libc-alpha@sourceware.org>, Thomas Gleixner <tglx@linutronix.de>, Ben Maurer <bmaurer@fb.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Rich Felker <dalias@libc.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

----- On Apr 18, 2019, at 10:48 AM, Joseph Myers joseph@codesourcery.com wrote:

> On Thu, 18 Apr 2019, Mathieu Desnoyers wrote:
> 
>> The approach above should work for arm32 be8 vs be32 linker weirdness.
>> 
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
> You'll also need __ASSEMBLER__ conditionals in the installed sys/rseq.h
> header so that it only defines constants and doesn't include any C
> declarations in that case, if RSEQ_SIG_CODE is meant to be usable in .S
> files rather than just inline asm in C files.

Good point!

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

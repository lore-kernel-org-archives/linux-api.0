From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Mon, 2 Jul 2018 20:23:11 -0400 (EDT)
Message-ID: <1020760632.10855.1530577391822.JavaMail.zimbra@efficios.com>
References: <20180702223143.4663-1-mathieu.desnoyers@efficios.com> <CA+55aFxrX+wRoe+5HDaTrRXg1K-Qpks4jJ9Buc_OevoG8hoGFw@mail.gmail.com> <415287289.10831.1530572418907.JavaMail.zimbra@efficios.com> <CA+55aFzZYOatOtjrm7fD7878_SzCAmEoEu74n0+pgd7faH-sTQ@mail.gmail.com> <825871008.10839.1530573419561.JavaMail.zimbra@efficios.com> <010001645d81f652-8a506dd2-cd49-47f9-950a-24ef52bda9f7-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <010001645d81f652-8a506dd2-cd49-47f9-950a-24ef52bda9f7-000000@email.amazonses.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Lameter <cl@linux.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Micha
List-Id: linux-api@vger.kernel.org

----- On Jul 2, 2018, at 8:19 PM, Chris Lameter cl@linux.com wrote:

> On Mon, 2 Jul 2018, Mathieu Desnoyers wrote:
> 
>> Are there any kind of guarantees that a __u64 update on a 32-bit architecture
>> won't be torn into something daft like byte-per-byte stores when performed
>> from C code ?
>>
>> I don't worry whether the upper bits get updated or how, but I really care
>> about not having store tearing of the low bits update.
> 
> Platforms with 32 bit word size only guarantee atomicity of a 32 bit
> write or RMV instruction.
> 
> Special instructions may exist on a platform to perform 64 bit atomic
> updates. We use cmpxchg64 f.e. on Intel 32 bit platforms to guarantee
> atomicity8.
> 
> So use the macros that we have to guarantee 64 bit ops and you should be
> fine. See linux/arch/x86/include/asm/atomic64_32.h

We are talking about user-space here. What we need is a single instruction
atomic store, similar to what WRITE_ONCE() does in the kernel. The discussion
is about whether doing the user-space equivalent of a WRITE_ONCE() to a u64
on a 32-bit architecture should be considered to provide single-copy atomicity
on the low 32 bits.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

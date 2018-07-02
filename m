From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Mon, 2 Jul 2018 19:16:59 -0400 (EDT)
Message-ID: <825871008.10839.1530573419561.JavaMail.zimbra@efficios.com>
References: <20180702223143.4663-1-mathieu.desnoyers@efficios.com> <CA+55aFxrX+wRoe+5HDaTrRXg1K-Qpks4jJ9Buc_OevoG8hoGFw@mail.gmail.com> <415287289.10831.1530572418907.JavaMail.zimbra@efficios.com> <CA+55aFzZYOatOtjrm7fD7878_SzCAmEoEu74n0+pgd7faH-sTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFzZYOatOtjrm7fD7878_SzCAmEoEu74n0+pgd7faH-sTQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.ma>
List-Id: linux-api@vger.kernel.org

----- On Jul 2, 2018, at 7:06 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Mon, Jul 2, 2018 at 4:00 PM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> Unfortunately, that rseq->rseq_cs field needs to be updated by user-space
>> with single-copy atomicity. Therefore, we want 32-bit user-space to initialize
>> the padding with 0, and only update the low bits with single-copy atomicity.
> 
> Well... It's actually still single-copy atomicity as a 64-bit value.
> 
> Why? Because it doesn't matter how you write the upper bits. You'll be
> writing the same value to them (zero) anyway.
> 
> So who cares if the write ends up being two instructions, because the
> write to the upper bits doesn't actually *do* anything.
> 
> Hmm?

Are there any kind of guarantees that a __u64 update on a 32-bit architecture
won't be torn into something daft like byte-per-byte stores when performed
from C code ?

I don't worry whether the upper bits get updated or how, but I really care
about not having store tearing of the low bits update.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

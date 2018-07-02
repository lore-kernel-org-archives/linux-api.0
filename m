From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18] rseq: use __u64 for rseq_cs fields,
 validate user inputs
Date: Mon, 2 Jul 2018 19:25:53 -0400 (EDT)
Message-ID: <321013411.10852.1530573953298.JavaMail.zimbra@efficios.com>
References: <20180702223143.4663-1-mathieu.desnoyers@efficios.com> <CA+55aFxrX+wRoe+5HDaTrRXg1K-Qpks4jJ9Buc_OevoG8hoGFw@mail.gmail.com> <415287289.10831.1530572418907.JavaMail.zimbra@efficios.com> <CA+55aFzZYOatOtjrm7fD7878_SzCAmEoEu74n0+pgd7faH-sTQ@mail.gmail.com> <825871008.10839.1530573419561.JavaMail.zimbra@efficios.com> <CA+55aFyQwfXxMnx2WQadfZKAnEfkoT+zomrRRToZz8-uWzUccQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFyQwfXxMnx2WQadfZKAnEfkoT+zomrRRToZz8-uWzUccQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Andy Lutomirski <luto@amacapital.net>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.ma>
List-Id: linux-api@vger.kernel.org

----- On Jul 2, 2018, at 7:22 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Mon, Jul 2, 2018 at 4:17 PM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> Are there any kind of guarantees that a __u64 update on a 32-bit architecture
>> won't be torn into something daft like byte-per-byte stores when performed
>> from C code ?
> 
> Guarantees? No. Not that there are any guarantees that the same won't
> happen for a plain 32-bit value either.
> 
> Will compilers generate that kind of code? I guess some crazy compiler
> could simply be really bad at handling 64-bit values, and just happen
> to handle 32-bit values better. So in that sense a 64-bit entity is
> certainly a bit riskier. But that would be a really bad compiler, I
> have to say.

Given that the only C code updating that field is rseq_prepare_unload()
(the rest is only ever updated from assembly), we could perhaps mandate
that user-space always update it from assembly, and therefore implement
rseq_prepare_unload as an inline asm which clears rseq->rseq_cs.

Does it sound better than the LINUX_FIELD_u32_u64 macro ?

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

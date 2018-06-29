From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: validate rseq_cs fields are <
 TASK_SIZE
Date: Fri, 29 Jun 2018 11:03:42 -0400 (EDT)
Message-ID: <729451355.9702.1530284622326.JavaMail.zimbra@efficios.com>
References: <20180628162359.9054-1-mathieu.desnoyers@efficios.com> <CA+55aFxZrv9koOGKNzpBjcpzwaKQBg9ybqcvQ9u=5d94y1F+mQ@mail.gmail.com> <CALCETrUrXk3wRg8SKhWf98v8jK=HwX9XLvP+Ypi+TktZoNx_Jg@mail.gmail.com> <CA+55aFzxCjkSbfRUeX3W_oXSJ6LMUdRVYB=DR2b3rUNkiixM1A@mail.gmail.com> <9200ED2A-AE4B-4094-81C9-E92240B4840F@amacapital.net> <CA+55aFzpD5xF80iiFNd+EMkJnRQdKPumM5p24Sr+LeBt8Gg=wg@mail.gmail.com> <1706339668.9644.1530281144560.JavaMail.zimbra@efficios.com> <CA+55aFxRJWjbgLeSQ_swi3F5nF1SYgZnC-R7QsOvZdcuSaWeaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxRJWjbgLeSQ_swi3F5nF1SYgZnC-R7QsOvZdcuSaWeaw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deaco>
List-Id: linux-api@vger.kernel.org

----- On Jun 29, 2018, at 10:17 AM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Fri, Jun 29, 2018 at 7:05 AM Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>>
>> What I'm worried about is setting regs->ip of a compat 32-bit task to
>> addresses in the range 0x100000000-0xFFFFFFFFFFFFFFFF.
> 
> Well, they won't have anything mapped in that range, so it really
> shouldn't matter.

It appears that arm64 simply clears the top bits of regs->ip when
returning to 32-bit compat userspace. So this would be inconsistent
between 32-bit kernel and 64-bit kernel with a 32-bit compat task:
a 32-bit kernel would kill the process, but a 64-bit kernel would
silently clear the top bits.

Considering those inconsistencies between architectures (either
the task gets killed, or the top bits are silently cleared), I'm
very much tempted to be restrictive in the inputs accepted by
rseq, and not rely on architectures as providing consistent
validation of the return IP.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

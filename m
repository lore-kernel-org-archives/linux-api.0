From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: validate rseq_cs fields are <
 TASK_SIZE
Date: Fri, 29 Jun 2018 09:55:43 -0400 (EDT)
Message-ID: <820874666.9567.1530280543568.JavaMail.zimbra@efficios.com>
References: <20180628162359.9054-1-mathieu.desnoyers@efficios.com> <CALCETrULo_VP4XHbXcZTevWY5d-6PdHUtrDS8DEF_OaozQOaNg@mail.gmail.com> <CA+55aFxZrv9koOGKNzpBjcpzwaKQBg9ybqcvQ9u=5d94y1F+mQ@mail.gmail.com> <CALCETrUrXk3wRg8SKhWf98v8jK=HwX9XLvP+Ypi+TktZoNx_Jg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrUrXk3wRg8SKhWf98v8jK=HwX9XLvP+Ypi+TktZoNx_Jg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael
List-Id: linux-api@vger.kernel.org

----- On Jun 28, 2018, at 7:29 PM, Andy Lutomirski luto@kernel.org wrote:

> On Thu, Jun 28, 2018 at 2:22 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> On Thu, Jun 28, 2018 at 1:23 PM Andy Lutomirski <luto@kernel.org> wrote:
>>>
>>> This is okay with me for a fix outside the merge window.  Can you do a
>>> followup for the next merge window that fixes it better, though?  In
>>> particular, TASK_SIZE is generally garbage.  I think a better fix
>>> would be something like adding a new arch-overridable helper like:
>>>
>>> static inline unsigned long current_max_user_addr(void) { return TASK_SIZE; }
>>
>> We already have that. It's called "user_addr_max()".
> 
> Nah, that one is more or less equivalent to TASK_SIZE_MAX, except that
> it's different if set_fs() is used.

So which one would be right in this case ? AFAIU we want to ensure we don't
populate regs->ip with a bogus address that would make SYSRET or other return
to userspace instructions explode.

Is that guaranteed by TASK_SIZE or TASK_SIZE_MAX (aliased by user_addr_max()) ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

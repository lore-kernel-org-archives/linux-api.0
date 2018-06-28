From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: validate rseq_cs fields are <
 TASK_SIZE
Date: Thu, 28 Jun 2018 18:29:18 -0400 (EDT)
Message-ID: <1821591223.9479.1530224958939.JavaMail.zimbra@efficios.com>
References: <20180628162359.9054-1-mathieu.desnoyers@efficios.com> <CALCETrULo_VP4XHbXcZTevWY5d-6PdHUtrDS8DEF_OaozQOaNg@mail.gmail.com> <CA+55aFxZrv9koOGKNzpBjcpzwaKQBg9ybqcvQ9u=5d94y1F+mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CA+55aFxZrv9koOGKNzpBjcpzwaKQBg9ybqcvQ9u=5d94y1F+mQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpag>
List-Id: linux-api@vger.kernel.org

----- On Jun 28, 2018, at 5:22 PM, Linus Torvalds torvalds@linux-foundation.org wrote:

> On Thu, Jun 28, 2018 at 1:23 PM Andy Lutomirski <luto@kernel.org> wrote:
>>
>> This is okay with me for a fix outside the merge window.  Can you do a
>> followup for the next merge window that fixes it better, though?  In
>> particular, TASK_SIZE is generally garbage.  I think a better fix
>> would be something like adding a new arch-overridable helper like:
>>
>> static inline unsigned long current_max_user_addr(void) { return TASK_SIZE; }
> 
> We already have that. It's called "user_addr_max()".
> 
> It's the limit we use for user accesses.

Good point. I will simply replace TASK_SIZE with user_addr_max() then.

> That said, I don't see why we should even check the IP. It's not like
> that's done by signal handling either.

The goal stated by Andy and Thomas is to design rseq so it
does not need any compat syscall whatsoever. Considering
that this is a new system call, we should be able to do that.
One thing we want is to provide a consistent behavior when
a 32-bit binary is executed on native 32-bit kernel or on
64-bit kernel in compat mode, even if userspace chooses to
put garbage in the upper 32-bit of padding within 64-bit
fields.

Now let's look at the comparison with signals. If we look
at ia32_setup_frame() for instance, it sets:

  regs->ip = (unsigned long) ksig->ka.sa.sa_handler;

where the sa_handler pointer has been received as input
as a 32-bit pointer by the compat syscall rt_sigaction
through struct compat_sigaction. I agree with you that
it does not appear to validate that it's below
user_addr_max(), but at least it's guaranteed to never be
over 32-bit.

The first big difference between rseq and signals: rseq
does not have a compat structure. The layout is the same
for both 32-bit and 64-bit userspace (see include/uapi/linux/rseq.h).

Another difference between rseq and signals is that rseq
only registers the TLS struct rseq for each thread. Then,
it's up to user-space to update the rseq_cs field of
struct rseq to indicate that it enters a critical section.

So the actual content of (struct rseq *)->rseq_cs is updated
with single-copy atomicity after registration of rseq.
Therefore, the current critical section pointed to by the current
rseq_cs user-space pointer also changes after registration. So we
cannot validate the content of the rseq_cs field, nor of the fields
contained within every possible struct rseq_cs descriptor when
registering rseq through sys_rseq: those need to be read when
returning to user-space. Not just on return from system call, but
also on return from interrupt/trap after a preemption.

This is very much different from registering a sigaction,
where the kernel can validate or truncate the content of
sa_handler at will.

Without validation of the content of e.g. rseq_cs->abort_ip
(read as a 64-bit integer by a 64-bit kernel), we end up setting
the return IP to that address on abort, even though user-space may
have put garbage in the high bits:

   instruction_pointer_set(regs, (unsigned long)rseq_cs.abort_ip);

without any validation or truncation whatsoever.

I'm concerned that some architecture code may not deal so well without
prior validation or truncation of the IP register content upper 32 bits
when returning to a 32-bit compat task.

This is why I'm considering comparison of abort_ip against user_addr_max()
to ensure we're not provided with an incorrect user input.

Thanks,

Mathieu


-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

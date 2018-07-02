From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [RFC PATCH for 4.18 1/2] rseq: validate rseq_cs fields are <
 TASK_SIZE
Date: Mon, 2 Jul 2018 10:32:46 -0400 (EDT)
Message-ID: <1527399163.10673.1530541966296.JavaMail.zimbra@efficios.com>
References: <20180628162359.9054-1-mathieu.desnoyers@efficios.com> <729451355.9702.1530284622326.JavaMail.zimbra@efficios.com> <CA+55aFw==YnFJn7iGnKMW=RbPT74YHNa0QDF96mEdMPA2oX9SA@mail.gmail.com> <CA+55aFwJWxsE_LL=-8WgB7uH_mYeMSu=boWF4N5KdOW673g4hA@mail.gmail.com> <247789350.9741.1530288432573.JavaMail.zimbra@efficios.com> <CA+55aFz8KyVqFsVnp-6g+thz7vmm5nK_FSdRTPSks7gsNVNRdQ@mail.gmail.com> <184287091.10022.1530301738384.JavaMail.zimbra@efficios.com> <CALCETrXqjrCoHX1KyL0iKGBaAZSGJb1cVdNN1gNigJ8DW9LF8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALCETrXqjrCoHX1KyL0iKGBaAZSGJb1cVdNN1gNigJ8DW9LF8w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Lutomirski <luto@amacapital.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, linux-kernel <linux-kernel@vger.kernel.org>, linux-api <linux-api@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Boqun Feng <boqun.feng@gmail.com>, Dave Watson <davejwatson@fb.com>, Paul Turner <pjt@google.com>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <andi@firstfloor.org>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>Will Deacon <w>
List-Id: linux-api@vger.kernel.org

----- On Jun 29, 2018, at 4:39 PM, Andy Lutomirski luto@amacapital.net wrote:

> On Fri, Jun 29, 2018 at 12:48 PM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:
>> There are two aspects I'm concerned about here:
>>
>> 1) security: we don't want 32-bit user-space to feed a 64-bit value over 4GB
>>    as abort_ip that may end up causing OOPSes on architectures that would
>>    lack proper validation of those values on return to userspace.
> 
> I'm not too worried about this.  As long as you're doing it from
> signal-delivery context (which you are AFAICT) you're fine.

No, it's not just signal-delivery context. It's _also_ called from
return to usermode loop, which can by called on return from
interrupt/trap/syscall.

> 
> But I re-read the code and I think I have a really straightforward
> solution.  Two choices:
> 
> (1) Change instruction_pointer_set() to return an error code if the
> address passed in is garbage in a way that could cause unexpected
> behavior (like >=2^32 on x86_64 if regs->cs is 32-bit).  It has very
> very few callers.

This would take care of my security concern wrt abort_ip, but would not
provide consistent behavior for the other fields. Also, perhaps this
kind of change should aim the next merge window ?

> 
> (2) Add instruction_pointer_validate() to go along with
> instruction_pointer_set().
>
> That should be enough to solve the problem, right?

This would only handle the "security" part of the matter, which
is specifically related to rseq->rseq_cs->abort_ip.

What is left is ensuring that we have consistent behavior for
other fields:

[ Note: we have introduced this helper macro: LINUX_FIELD_u32_u64
which defines a field which is 64-bit for 64-bit processes, and 32-bit
with 32-bit of padding for 32-bit processes. ]

* rseq->rseq_cs: (userspace pointer to user-space, updated by user-space
  with single-copy atomicity): current type: LINUX_FIELD_u32_u64,
  cannot be changed to __u64 due to single-copy atomicity requirement,

* rseq->rseq_cs->start_ip: currently a LINUX_FIELD_u32_u64,
  could become a __u64,

* rseq->rseq_cs->post_commit_ip: currently a LINUX_FIELD_u32_u64,
  could become a __u64,

* rseq->rseq_cs->abort_ip: currently a LINUX_FIELD_u32_u64,
  could become a __u64,

For abort_ip, changing the type to __u64 and using the
instruction_pointer_validate() approach you propose would work.

For start_ip and post_commit_ip, we need to decide whether we
want to kill a 32-bit process setting the high bits or if we just
accept and use the full __u64 content on both 32-bit and 64-bit
kernels. Those two fields are only used for arithmetic comparison.
Using the full __u64 content means using 64-bit arithmetic on
32-bit native kernels though.

If we decide to kill the offending process (whether the field type is
__u64 or LINUX_FIELD_u32_u64), we need to be able to figure out if
the process is a compat task when called from signal delivery and from
return to usermode loop (return from irq/trap/syscall).

Comparison with TASK_SIZE solves the issue for abort_ip, post_commit_ip
and start_ip, although nobody seems to like that approach very much.

For rseq->rseq_cs, we cannot use __u64 due to single-copy atomicity
update requirement for 32-bit processes. However, we are using this
field in a copy_from_user(), so it will EFAULT if the high-bits are
set by a compat 32-bit task on a 64-bit kernel. We can therefore check
that the padding is zeroed explicitly on a native 32-bit kernel to
provide a consistent behavior. Specifically because rseq->rseq_cs is
checked with access_ok(), it is therefore enough to check the padding
when __LP64__ is not defined by the preprocessor.

But rather than trying to play games with input validation, I would
favor an approach that would allow rseq to validate all its inputs
straightforwardly. Introducing user_64bit_mode(struct pt_regs *)
across all architectures would allow doing just that. rseq signal
delivery and return to usermode code could then ensure that high bits are
cleared by 32-bit tasks for all fields and thus provide a consistent
behavior for 32-bit tasks running on 32-bit and 64-bit kernels.

Thoughts ?

Thanks,

Mathieu

-- 
Mathieu Desnoyers
EfficiOS Inc.
http://www.efficios.com

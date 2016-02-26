From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v4 1/5] getcpu_cache system call: cache CPU number of running thread
Date: Fri, 26 Feb 2016 15:04:57 -0800
Message-ID: <7096DA23-3908-40DC-A46B-C4CF2252CEE8@zytor.com>
References: <1456270120-7560-1-git-send-email-mathieu.desnoyers@efficios.com> <390571988.7745.1456419326288.JavaMail.zimbra@efficios.com> <20160225170416.GV6356@twins.programming.kicks-ass.net> <2135602720.7810.1456420671941.JavaMail.zimbra@efficios.com> <20160226113304.GA6356@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1602261719440.3638@nanos> <967083634.8940.1456507201156.JavaMail.zimbra@efficios.com> <alpine.DEB.2.11.1602261855100.3638@nanos> <724964987.9217.1456518255392.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <724964987.9217.1456518255392.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Gleixner <tglx@linutronix.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-api@vger.kernel.org

On February 26, 2016 12:24:15 PM PST, Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:
>----- On Feb 26, 2016, at 1:01 PM, Thomas Gleixner tglx@linutronix.de
>wrote:
>
>> On Fri, 26 Feb 2016, Mathieu Desnoyers wrote:
>>> ----- On Feb 26, 2016, at 11:29 AM, Thomas Gleixner
>tglx@linutronix.de wrote:
>>> > Right. There is no point in having two calls and two update
>mechanisms for a
>>> > very similar purpose.
>>> > 
>>> > So let userspace have one struct where cpu/seq and whatever is
>required for
>>> > rseq is located and flag at register time which parts of the
>struct need to be
>>> > updated.
>>> 
>>> If we put both cpu/seq/other in that structure, why not plan ahead
>and make
>>> it extensible then ?
>>> 
>>> That looks very much like the "Thread-local ABI" series I posted
>last year.
>>> See https://lkml.org/lkml/2015/12/22/464
>>> 
>>> Here is why I ended up introducing the specialized "getcpu_cache"
>system call
>>> rather than the "generic" system call (quote from the getcpu_cache
>changelog):
>>> 
>>>     Rationale for the getcpu_cache system call rather than the
>thread-local
>>>     ABI system call proposed earlier:
>>>     
>>>     Rather than doing a "generic" thread-local ABI, specialize this
>system
>>>     call for a cpu number cache only. Anyway, the thread-local ABI
>approach
>>>     would have required that we introduce "feature" flags, which
>would have
>>>     ended up reimplementing multiplexing of features on top of a
>system
>>>     call. It seems better to introduce one system call per feature
>instead.
>>> 
>>> If everyone end up preferring that we introduce a system call that
>implements
>>> many features at once, that's indeed something we can do, but I
>remember
>>> being told in the past that this is generally a bad idea.
>> 
>> It's a bad idea if you mix stuff which does not belong together, but
>if you
>> have stuff which shares a substantial amount of things then it makes
>a lot of
>> sense. Especially if it adds similar stuff into hotpathes.
>> 
>>> For one thing, it would make the interface more cumbersome to deal
>with
>>> from user-space in terms of feature detection: if we want to make
>this
>>> interface extensible, in addition to check -1, errno=ENOSYS,
>userspace
>>> would have to deal with a field containing the length of the
>structure
>>> as expected by user-space and kernel, and feature flags to see the
>common
>>> set of features supported by kernel and user-space.
>>>
>>> Having one system call per feature seems simpler to handle in terms
>of
>>> feature availability detection from a userspace point of view.
>> 
>> That might well be, but that does not justify two fastpath updates,
>two
>> seperate pointers to handle, etc ....
>
>Keeping two separate pointers in the task_struct rather than a single
>one
>might indeed be unwelcome, but I'm not sure I fully grasp the fast path
>argument in this case: getcpu_cache only sets a notifier thread flag
>on thread migration, whereas AFAIU rseq adds code to context switch and
>signal
>delivery, which are prone to have a higher impact.
>
>Indeed both will have their own code in the resume notifier, but is it
>really
>a fast path ?
>
>From my point of view, making it easy for userspace to just enable
>getcpu_cache
>without having the scheduler and signal delivery fast-path overhead of
>rseq seems
>like a good thing. I'm not all that sure that saving an extra pointer
>in
>task_struct justifies the added system call interface complexity.
>
>Thanks,
>
>Mathieu

I think it would be a good idea to make this a general pointer for the kernel to be able to write per thread state to user space, which obviously can't be done with the vDSO.

This means the libc per thread startup should query the kernel for the size of this structure and allocate thread local data accordingly.  We can then grow this structure if needed without making the ABI even more complex.

This is more than a system call: this is an entirely new way for userspace to interact with the kernel.  Therefore we should make it a general facility.
-- 
Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.

From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH v3 1/5] getcpu_cache system call: cache CPU number
 of running thread
Date: Fri, 29 Jan 2016 09:39:53 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1601290934020.3886@nanos>
References: <1454014885-29012-1-git-send-email-mathieu.desnoyers@efficios.com> <1454014885-29012-2-git-send-email-mathieu.desnoyers@efficios.com> <alpine.DEB.2.11.1601282205290.3886@nanos> <950789004.7282.1454021044123.JavaMail.zimbra@efficios.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <950789004.7282.1454021044123.JavaMail.zimbra@efficios.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Paul Turner <pjt@google.com>, Andrew Hunter <ahh@google.com>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, linux-api <linux-api@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Andi Kleen <andi@firstfloor.org>, Dave Watson <davejwatson@fb.com>, Chris Lameter <cl@linux.com>, Ingo Molnar <mingo@redhat.com>, Ben Maurer <bmaurer@fb.com>, rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Russell King <linux@arm.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Michael Kerrisk <mtk.manpages@gmail.com>
List-Id: linux-api@vger.kernel.org

On Thu, 28 Jan 2016, Mathieu Desnoyers wrote:
> ----- On Jan 28, 2016, at 4:52 PM, Thomas Gleixner tglx@linutronix.de wrote:
> >> +		current->cpu_cache = cpu_cache;
> >> +		/*
> >> +		 * Migration checks the getcpu cache to see whether the
> >> +		 * notify_resume flag should be set.
> >> +		 * Therefore, we need to ensure that the scheduler sees
> >> +		 * the getcpu cache pointer update before we update the getcpu
> >> +		 * cache content with the current CPU number.
> >> +		 */
> >> +		barrier();
> > 
> > And how does that barrier ensure this? Not at all. And why would the scheduler
> > care? All the scheduler cares about is tsk->cpu_cache.
> 
> The case I want to ensure never happens is the following:
> 
> Compiler reorders storing the address of current->cpu_cache after
> the getcpu_cache_update() store to *cpu_cache. In between, the
> scheduler preempts and migrates the task, but does not set the
> resume notifier thread flag because it still see a NULL
> current->cpu_cache. We therefore return to userspace with a
> wrong CPU number in the cache.
> 
> The compiler barrier enforces ordering of the current->cpu_cache
> address store before updating the *cpu_cache.

Fair enough. Updating the comment might help.

> > 
> >> +		/*
> >> +		 * Do an initial cpu cache update to ensure we won't hit
> >> +		 * SIGSEGV if put_user() fails in the resume notifier.
> >> +		 */
> > 
> > If you get migrated before that call, then you SIGSEGV nevertheless.
> 
> No, because the SIGSEGV is only triggered when returning to userspace.
> We are still in the system call here. All we care about in the migration
> schedule code is to check the current->cpu_cache to see if we need to
> raise the resume notifier flag. No userspace access there.

True. Should have went to bed instead of staring at that code tired :)
 
> > You need that call here for the case you are NOT migrated before returning to
> > user space because otherwise the variable is not updated.
> 
> This call has two goals: indeed, populating the initial current CPU value,
> but also checking if the address is valid (and -EFAULT on error).

Right. So the comment should mention both.
 
Thanks,

	tglx

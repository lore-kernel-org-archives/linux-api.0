From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 0/6] support "dataplane" mode for nohz_full
Date: Tue, 12 May 2015 06:18:28 -0700
Message-ID: <20150512131828.GK6776@linux.vnet.ibm.com>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
 <20150508141824.797eb0d89d514e39fd30fffe@linux-foundation.org>
 <20150508172210.559830a9@gandalf.local.home>
 <554D428E.6020702@ezchip.com>
 <20150508161909.308d60e21f6b83b897174276@linux-foundation.org>
 <20150509070538.GA9413@gmail.com>
 <CALCETrXavog018+xLacXeBLaMLjWtqk0bMU5fUzZ+pkwgu7Y3A@mail.gmail.com>
 <55510885.9070101@ezchip.com>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55510885.9070101@ezchip.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>, Gilad Ben Yossef <giladb@ezchip.com>, Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Christoph Lameter <cl@linux.com>, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Mon, May 11, 2015 at 03:52:37PM -0400, Chris Metcalf wrote:
> On 05/09/2015 03:19 AM, Andy Lutomirski wrote:
> >Naming aside, I don't think this should be a per-task flag at all.  We
> >already have way too much overhead per syscall in nohz mode, and it
> >would be nice to get the per-syscall overhead as low as possible.  We
> >should strive, for all tasks, to keep syscall overhead down*and*
> >avoid as many interrupts as possible.
> >
> >That being said, I do see a legitimate use for a way to tell the
> >kernel "I'm going to run in userspace for a long time; stay away".
> >But shouldn't that be a single operation, not an ongoing flag?  IOW, I
> >think that we should have a new syscall quiesce() or something rather
> >than a prctl.
> 
> Yes, if all you are concerned about is quiescing the tick, we could
> probably do it as a new syscall.
> 
> I do note that you'd want to try to actually do the quiesce as late as
> possible - in particular, if you just did it in the usual syscall, you
> might miss out on a timer that is set by softirq, or even something
> that happened when you called schedule() on the syscall exit path.
> Doing it as late as we are doing helps to ensure that that doesn't
> happen.  We could still arrange for this semantics by having a new
> quiesce() syscall set a temporary task bit that was cleared on
> return to userspace, but as you pointed out in a different email,
> that gets tricky if you end up doing multiple user_exit() calls on
> your way back to userspace.
> 
> More to the point, I think it's actually important to know when an
> application believes it's in userspace-only mode as an actual state
> bit, rather than just during its transitional moment.  If an
> application calls the kernel at an unexpected time (third-party code
> is the usual culprit for our customers, whether it's syscalls, page
> faults, or other things) we would prefer to have the "quiesce"
> semantics stay in force and cause the third-party code to be
> visibly very slow, rather than cause a totally unexpected and
> hard-to-diagnose interrupt show up later as we are still going
> around the loop that we thought was safely userspace-only.
> 
> And, for debugging the kernel, it's crazy helpful to have that state
> bit in place: see patch 6/6 in the series for how we can diagnose
> things like "a different core just queued an IPI that will hit a
> dataplane core unexpectedly".  Having that state bit makes this sort
> of thing a trivial check in the kernel and relatively easy to debug.

I agree with this!  It is currently a bit painful to debug problems
that might result in multiple tasks runnable on a given CPU.  If you
suspect a problem, you enable tracing and re-run.  Not paricularly
friendly for chasing down intermittent problems, so some sort of
improvement would be a very good thing.

							Thanx, Paul

> Finally, I proposed a "strict" mode in patch 5/6 where we kill the
> process if it voluntarily enters the kernel by mistake after saying it
> wasn't going to any more.  To do this requires a state bit, so
> carrying another state bit for "quiesce on user entry" seems pretty
> reasonable.
> 
> -- 
> Chris Metcalf, EZChip Semiconductor
> http://www.ezchip.com
> 


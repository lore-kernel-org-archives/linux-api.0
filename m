From: Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH v4 1/5] nohz_full: add support for "cpu_isolated" mode
Date: Fri, 24 Jul 2015 16:03:15 +0200
Message-ID: <20150724140308.GB20091@lerouge>
References: <1436817481-8732-1-git-send-email-cmetcalf@ezchip.com>
 <1436817481-8732-2-git-send-email-cmetcalf@ezchip.com>
 <CALCETrWaBe10u1X+AqYM7TsbguL=aF-TyuN3xjqgR5Cg2=FiAA@mail.gmail.com>
 <55A4271B.9040506@ezchip.com>
 <CALCETrUMGx+ZC9rtAAErKaGg-LEtYXMOSVD1dCi7im3b1SMrVg@mail.gmail.com>
 <55AE993E.6040501@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <55AE993E.6040501@ezchip.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Chris Metcalf <cmetcalf@ezchip.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mike Galbraith <umgwanakikbuti@gmail.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 21, 2015 at 03:10:54PM -0400, Chris Metcalf wrote:
> >>If you're arguing that the cpu_isolated semantic is really the only
> >>one that makes sense for nohz_full, my sense is that it might be
> >>surprising to many of the folks who do nohz_full work.  But, I'm happy
> >>to be wrong on this point, and maybe all the nohz_full community is
> >>interested in making the same tradeoffs for nohz_full generally that
> >>I've proposed in this patch series just for cpu_isolated?
> >nohz_full is currently dog slow for no particularly good reasons.  I
> >suspect that the interrupts you're seeing are also there for no
> >particularly good reasons as well.
> >
> >Let's fix them instead of adding new ABIs to work around them.
> 
> Well, in principle if we accepted my proposed patch series
> and then over time came to decide that it was reasonable
> for nohz_full to have these complete cpu isolation
> semantics, the one proposed ABI simply becomes a no-op.
> So it's not as problematic an ABI as some.
> 
> My issue is this: I'm totally happy with submitting a revised
> patch series that does all the stuff for pure nohz_full that
> I'm currently proposing for cpu_isolated.  But, is it what
> the community wants?  Should I propose it and see?
> 
> Frederic, do you have any insight here?  Thanks!

So you guys mean that if nohz_full was implemented fully like
we expect it to, we shouldn't be burdened at all by noise and that
whole patchset would therefore be pointless, right? And that would meet
the requirements for those who want hard isolation (critical noise-free
guarantee) as well as those who want soft isolation (less noise as
possible for performance).

Well first of all nohz is not isolation, it's a significant part of it
but it's not all isolatiion. We really want to separate these things and
not mess up isolation policies in the tick code.

Second, yes perhaps we can eventually have both soft and hard isolation
expectation eventually be implemented the same way through hard isolation.
But that will only work if we don't do that polling for noise-free before
resuming userspace, which might work for hard isolation that is ready to
sacrifice some warm-up before a run to meet guarantees, but it won't
work for soft isolation workloads.

So the only solution is to offline everything we can to housekeeping
CPUs. And if we still have stuff that can't be dealt with that way
and which need to be taken care of with some explicit operation
before resuming to userspace, then we can start to think about splitting
stuff in several isolation configs.

Similarly, offlining everything to housekeepers means that we sacrifice
a CPU that could have been used in performance oriented workloads so that
might not match soft isolation as well. But I think we'll see that all once
we manage to have pure noise-free CPUs (some patches are on the way to be
posted by Vatika Harlalka concerning the residual 1hz tick to kill).

To summarize, lets first split nohz and isolation. Introduce
CONFIG_CPU_ISOLATION and stuff all the isolation policies to
kernel/cpu_isolation.c, lets try to implement hard isolation and see if that
meets soft isolation workload users as well, if not we'll split that later.

And we can keep the prctl to tell the user when hard isolation has been
broken, through SIGKILL or whatever. I think we are doing a similar thing
with SCHED_DEADLINE when the task hasn't met deadline requirement. We might
want to do the same.

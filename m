From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v9 04/13] task_isolation: add initial support
Date: Tue, 5 Jul 2016 12:47:08 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607051244130.1190@east.gentwo.org>
References: <20160130211125.GB7856@lerouge> <56BCDFE9.10200@ezchip.com> <20160304125603.GA23906@lerouge> <56E07BF0.3060509@mellanox.com> <20160408135622.GD24956@lerouge> <5707DDA8.10600@mellanox.com> <20160526010656.GB17245@lerouge>
 <4e96ef87-c254-3357-3c7e-cd97ccb6ce56@mellanox.com> <20160629151810.GA28724@lerouge> <25c4ace1-6903-abb3-59e9-aedc11ac32fc@mellanox.com> <20160705144107.GC5332@lerouge>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160705144107.GC5332@lerouge>
Sender: linux-kernel-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Chris Metcalf <cmetcalf@mellanox.com>, Gilad Ben Yossef <giladb@ezchip.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, 5 Jul 2016, Frederic Weisbecker wrote:

> > >>That's true, but I'd argue the behavior in that case should be that you can
> > >>raise that kind of exception validly (so you can debug), and then you should
> > >>quiesce on return to userspace so the application doesn't see additional
> > >>exceptions.
> > >
> > >I don't see how we can quiesce such things.
> >
> > I'm imagining task A is in dataplane mode, and task B wants to debug
> > it by writing a breakpoint into its text.  When task A hits the
> > breakpoint, it will enter the kernel, and hold there while task B
> > pokes at it with ptrace.  When task A finally is allowed to return to
> > userspace, it should quiesce before entering userspace in case any
> > timer interrupts got scheduled (again, maybe due to softirqs or
> > whatever, or random other kernel activity targeting that core while it
> > was in the kernel, or whatever).  This is just the same kind of
> > quiescing we do on return from the initial prctl().
>
> Well again I think it shouldn't happen. Quiescing should be done once
> and for all.

For debugging something like that would be helpful. And yes for the
realtime use cases quiescing is once and for all (until we end a different
operation mode if requested by the app)


> > >> - Soft mode (I don't think we want this) - like "no signal" except you don't even quiesce
> > >>   on return to userspace, and asynchronous interrupts don't even cause a signal.
> > >>   It's basically "best effort", just nohz_full plus the code that tries to get things
> > >>   like LRU or vmstat to run before returning to userspace.  I think there isn't enough
> > >>   "value add" to make this a separate mode, though.
> > >
> > >I can imagine HPC to be willing this mode.
> >
> > Yes, perhaps.  I'm not convinced we want to target HPC without a much
> > clearer sense of why this is better than nohz_full, though.  I fear
> > people might think "task isolation" is better by definition and not
> > think too much about it, but I'm really not sure it is better for the
> > HPC use case, necessarily.

HPC folks generally like to actually understand what is going on in order
to get the best performance. Just expose the knobs for us please.

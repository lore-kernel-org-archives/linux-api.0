From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: Ping: [PATCH v15 00/13] support "task_isolation" mode
Date: Mon, 12 Sep 2016 23:15:45 +0200
Message-ID: <7820672.sYOlvzebIZ@vostro.rjw.lan>
References: <1471382376-5443-1-git-send-email-cmetcalf@mellanox.com> <909484ad-534d-524a-51db-19b7d013f73e@mellanox.com> <20160912161444.GA5008@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160912161444.GA5008@twins.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Chris Metcalf <cmetcalf@mellanox.com>, Francis Giraldeau <francis.giraldeau@gmail.com>, Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Christoph Lameter <cl@linux.com>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Monday, September 12, 2016 06:14:44 PM Peter Zijlstra wrote:
> On Mon, Sep 12, 2016 at 12:01:58PM -0400, Chris Metcalf wrote:
> > On 9/7/2016 5:11 PM, Francis Giraldeau wrote:
> > >When running only the test_jitter(), the isolation mode is lost:
> > >
> > >     [ 6741.566048] isolation/9515: task_isolation mode lost due to irq_work
> > >
> > >With ftrace (events/workqueue/workqueue_execute_start), I get a bit more info:
> > >
> > >      kworker/1:1-676   [001] ....  6610.097128: workqueue_execute_start: work struct ffff8801a784ca20: function dbs_work_handler
> > >
> > >The governor was ondemand, so I tried to set the frequency scaling
> > >governor to performance, but that does not solve the issue. Is there
> > >a way to suppress this irq_work? Should we run the isolated task with
> > >high real-time priority, such that it never get preempted?
> > 
> > On the tile platform we don't have the frequency scaling stuff to contend with, so
> > I don't know much about it.  I'd be very curious to know what you can figure out
> > on this front.
> 
> Rafael, I'm thinking the performance governor should be able to run
> without sending IPIs. Is there anything we can quickly do about that?

The performance governor doesn't do any IPIs.

At this point I'm not sure what's going on.

Thanks,
Rafael

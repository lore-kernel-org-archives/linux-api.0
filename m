From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: clocksource_watchdog causing scheduling of timers every second
 (was [v13] support "task_isolation" mode)
Date: Fri, 12 Aug 2016 09:19:19 -0700
Message-ID: <20160812161919.GV3482@linux.vnet.ibm.com>
References: <7a3f66f7-5011-7d59-2e0e-f57e4e42e6b6@mellanox.com>
 <alpine.DEB.2.20.1607251133450.25354@east.gentwo.org>
 <alpine.DEB.2.20.1607270847460.24843@east.gentwo.org>
 <20160810221656.GC19757@lerouge>
 <20160811084002.GV30192@twins.programming.kicks-ass.net>
 <20160811160027.GV3482@linux.vnet.ibm.com>
 <alpine.DEB.2.20.1608111801320.8416@east.gentwo.org>
 <20160811234734.GJ3482@linux.vnet.ibm.com>
 <alpine.DEB.2.20.1608120922450.20310@east.gentwo.org>
 <20160812142611.GC5087@lerouge>
Reply-To: paulmck@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160812142611.GC5087@lerouge>
Sender: linux-doc-owner@vger.kernel.org
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Peter Zijlstra <peterz@infradead.org>, Chris Metcalf <cmetcalf@mellanox.com>, Gilad Ben Yossef <giladb@mellanox.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>, Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Viresh Kumar <viresh.kumar@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@amacapital.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Fri, Aug 12, 2016 at 04:26:13PM +0200, Frederic Weisbecker wrote:
> On Fri, Aug 12, 2016 at 09:23:13AM -0500, Christoph Lameter wrote:
> > On Thu, 11 Aug 2016, Paul E. McKenney wrote:
> > 
> > > Heh!  The only really good idea is for clocks to be reliably in sync.
> > >
> > > But if they go out of sync, what do you want to do instead?
> > 
> > For a NOHZ task? Write a message to the syslog and reenable tick.

Fair enough!  Kicking off a low-priority task would achieve the latter
but not necessarily the former.  And of course assumes that the worker
thread is at real-time priority with various scheduler anti-starvation
features disabled.

> Indeed, a strong clocksource is a requirement for a full tickless machine.

No disagrement here!  ;-)

							Thanx, Paul


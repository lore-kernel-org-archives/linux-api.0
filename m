From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: clocksource_watchdog causing scheduling of timers every second
 (was [v13] support "task_isolation" mode)
Date: Sat, 13 Aug 2016 17:39:45 +0200
Message-ID: <20160813153942.GB21154@lerouge>
References: <alpine.DEB.2.20.1607251133450.25354@east.gentwo.org>
 <alpine.DEB.2.20.1607270847460.24843@east.gentwo.org>
 <20160810221656.GC19757@lerouge>
 <20160811084002.GV30192@twins.programming.kicks-ass.net>
 <20160811160027.GV3482@linux.vnet.ibm.com>
 <alpine.DEB.2.20.1608111801320.8416@east.gentwo.org>
 <20160811234734.GJ3482@linux.vnet.ibm.com>
 <alpine.DEB.2.20.1608120922450.20310@east.gentwo.org>
 <20160812142611.GC5087@lerouge>
 <20160812161919.GV3482@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160812161919.GV3482-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Gilad Ben Yossef <giladb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Aug 12, 2016 at 09:19:19AM -0700, Paul E. McKenney wrote:
> On Fri, Aug 12, 2016 at 04:26:13PM +0200, Frederic Weisbecker wrote:
> > On Fri, Aug 12, 2016 at 09:23:13AM -0500, Christoph Lameter wrote:
> > > On Thu, 11 Aug 2016, Paul E. McKenney wrote:
> > > 
> > > > Heh!  The only really good idea is for clocks to be reliably in sync.
> > > >
> > > > But if they go out of sync, what do you want to do instead?
> > > 
> > > For a NOHZ task? Write a message to the syslog and reenable tick.
> 
> Fair enough!  Kicking off a low-priority task would achieve the latter
> but not necessarily the former.  And of course assumes that the worker
> thread is at real-time priority with various scheduler anti-starvation
> features disabled.
> 
> > Indeed, a strong clocksource is a requirement for a full tickless machine.
> 
> No disagrement here!  ;-)

I have a bot in my mind that randomly posts obvious statements about nohz_full
here and then :-)

From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 4/6] nohz: support PR_DATAPLANE_QUIESCE
Date: Tue, 12 May 2015 12:38:05 +0200
Message-ID: <20150512103805.GJ21418@twins.programming.kicks-ass.net>
References: <1431107927-13998-1-git-send-email-cmetcalf@ezchip.com>
 <1431107927-13998-5-git-send-email-cmetcalf@ezchip.com>
 <20150512093349.GH21418@twins.programming.kicks-ass.net>
 <20150512095030.GD11477@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150512095030.GD11477-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, "Srivatsa S. Bhat" <srivatsa.bhat-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, May 12, 2015 at 11:50:30AM +0200, Ingo Molnar wrote:
> 
> * Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> 
> > On Fri, May 08, 2015 at 01:58:45PM -0400, Chris Metcalf wrote:
> > > This prctl() flag for PR_SET_DATAPLANE sets a mode that requires the
> > > kernel to quiesce any pending timer interrupts prior to returning
> > > to userspace.  When running with this mode set, sys calls (and page
> > > faults, etc.) can be inordinately slow.  However, user applications
> > > that want to guarantee that no unexpected interrupts will occur
> > > (even if they call into the kernel) can set this flag to guarantee
> > > that semantics.
> > 
> > Currently people hot-unplug and hot-plug the CPU to do this. 
> > Obviously that's a wee bit horrible :-)
> > 
> > Not sure if a prctl like this is any better though. This is a CPU 
> > properly not a process one.
> 
> So if then a prctl() (or other system call) could be a shortcut to:
> 
>  - move the task to an isolated CPU
>  - make sure there _is_ such an isolated domain available
> 
> I.e. have some programmatic, kernel provided way for an application to 
> be sure it's running in the right environment. Relying on random 
> administration flags here and there won't cut it.

No, we already have sched_setaffinity() and we should not duplicate its
ability to move tasks about.

What this is about is 'clearing' CPU state, its nothing to do with
tasks.

Ideally we'd never have to clear the state because it should be
impossible to get into this predicament in the first place.

The typical example here is a periodic timer that found its way onto the
cpu and stays there. We're actually working on allowing such self arming
timers to migrate, so once we have that sorted this could be fixed
proper I think.

Not sure if there's more pollution that people worry about.

The hotplug hack worked because unplug force migrates the timers away.

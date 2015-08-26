From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 2/6] cpu_isolated: add initial support
Date: Wed, 26 Aug 2015 17:26:52 +0200
Message-ID: <20150826152651.GA11992@lerouge>
References: <1438112980-9981-1-git-send-email-cmetcalf@ezchip.com>
 <1438112980-9981-3-git-send-email-cmetcalf@ezchip.com>
 <20150812160020.GG21542@lerouge>
 <55CB8ED1.6030806@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55CB8ED1.6030806-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Aug 12, 2015 at 02:22:09PM -0400, Chris Metcalf wrote:
> On 08/12/2015 12:00 PM, Frederic Weisbecker wrote:
> >>+#ifdef CONFIG_CPU_ISOLATED
> >>+void cpu_isolated_wait(void)
> >>+{
> >>+	set_current_state(TASK_INTERRUPTIBLE);
> >>+	_cpu_idle();
> >>+	set_current_state(TASK_RUNNING);
> >>+}
> >I'm still uncomfortable with that. A wake up model could work?
> 
> I don't know exactly what you have in mind.  The theory is that
> at this point we're ready to return to user space and we're just
> waiting for a timer tick that is guaranteed to arrive, since there
> is something pending for the timer.

Hmm, ok I'm going to discuss that in the new version. One worry is that
it gets racy and we sleep there for ever.

> 
> And, this is an arch-specific method anyway; the generic method
> is actually checking to see if a signal has been delivered,
> scheduling is needed, etc., each time around the loop, so if
> you're not sure your architecture will do the right thing, just
> don't provide a method that idles while waiting.  For tilegx I'm
> sure it works correctly, so I'm OK providing that method.

Yes but we do busy waiting on all other archs then. And since we can wait
for a while there, it doesn't look sane.

> >>diff --git a/include/linux/sched.h b/include/linux/sched.h
> >>index 04b5ada460b4..0bb248385d88 100644
> >>--- a/include/linux/sched.h
> >>+++ b/include/linux/sched.h
> >>@@ -1776,6 +1776,9 @@ struct task_struct {
> >>  	unsigned long	task_state_change;
> >>  #endif
> >>  	int pagefault_disabled;
> >>+#ifdef CONFIG_CPU_ISOLATED
> >>+	unsigned int	cpu_isolated_flags;
> >>+#endif
> >Can't we add a new flag to tsk->flags? There seem to be some values remaining.
> 
> Yeah, I thought of that, but it seems like a pretty scarce resource,
> and I wasn't sure it was the right thing to do.  Also, I'm not actually
> sure why the lowest two bits aren't apparently being used

Probably they were used but got removed.

> looks
> like PF_EXITING (0x4) is the first bit used.  And there are only three
> more bits higher up in the word that are not assigned.

Which makes room for 5 :)

> 
> Also, right now we are allowing users to customize the signal delivered
> for STRICT violation, and that signal value is stored in the
> cpu_isolated_flags word as well, so we really don't have room in
> tsk->flags for all of that anyway.

Yeah indeed, ok lets keep it that way for now.

Thanks.

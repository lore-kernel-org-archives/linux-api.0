From: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v6 3/6] task_isolation: support PR_TASK_ISOLATION_STRICT
 mode
Date: Wed, 2 Sep 2015 11:13:47 +0100
Message-ID: <20150902101347.GF25720@arm.com>
References: <1440532555-15492-1-git-send-email-cmetcalf@ezchip.com>
 <1440532555-15492-4-git-send-email-cmetcalf@ezchip.com>
 <20150826103651.GA30466@arm.com>
 <55DDD6EA.3070307@ezchip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55DDD6EA.3070307-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-d5a29ZRxExrQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <Catalin.Marinas-5wv7dgnIgG8@public.gmane.org>, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Aug 26, 2015 at 04:10:34PM +0100, Chris Metcalf wrote:
> On 08/26/2015 06:36 AM, Will Deacon wrote:
> > On Tue, Aug 25, 2015 at 08:55:52PM +0100, Chris Metcalf wrote:
> >> diff --git a/arch/arm64/kernel/ptrace.c b/arch/arm64/kernel/ptrace.c
> >> index d882b833dbdb..e3d83a12f3cf 100644
> >> --- a/arch/arm64/kernel/ptrace.c
> >> +++ b/arch/arm64/kernel/ptrace.c
> >> @@ -37,6 +37,7 @@
> >>   #include <linux/regset.h>
> >>   #include <linux/tracehook.h>
> >>   #include <linux/elf.h>
> >> +#include <linux/isolation.h>
> >>   
> >>   #include <asm/compat.h>
> >>   #include <asm/debug-monitors.h>
> >> @@ -1150,6 +1151,10 @@ static void tracehook_report_syscall(struct pt_regs *regs,
> >>   
> >>   asmlinkage int syscall_trace_enter(struct pt_regs *regs)
> >>   {
> >> +	/* Ensure we report task_isolation violations in all circumstances. */
> >> +	if (test_thread_flag(TIF_NOHZ) && task_isolation_strict())
> > This is going to force us to check TIF_NOHZ on the syscall slowpath even
> > when CONFIG_TASK_ISOLATION=n.
> 
> Yes, good catch.  I was thinking the "&& false" would suppress the TIF
> test but I forgot that test_bit() takes a volatile argument, so it gets
> evaluated even though the result isn't actually used.
> 
> But I don't want to just reorder the two tests, because when isolation
> is enabled, testing TIF_NOHZ first is better.  I think probably the right
> solution is just to put an #ifdef CONFIG_TASK_ISOLATION around that
> test, even though that is a little crufty.  The alternative is to provide
> a task_isolation_configured() macro that just returns true or false, and
> make it a three-part "&&" test with that new macro first, but
> that seems a little crufty as well.  Do you have a preference?

Maybe use IS_ENABLED(CONFIG_TASK_ISOLATION) ?

> >> +		task_isolation_syscall(regs->syscallno);
> >> +
> >>   	/* Do the secure computing check first; failures should be fast. */
> > Here we have the usual priority problems with all the subsystems that
> > hook into the syscall path. If a prctl is later rewritten to a different
> > syscall, do you care about catching it? Either way, the comment about
> > doing secure computing "first" needs fixing.
> 
> I admit I am unclear on the utility of rewriting prctl.  My instinct is that
> we are trying to catch userspace invocations of prctl and allow them,
> and fail most everything else, so doing it pre-rewrite seems OK.
> 
> I'm not sure if it makes sense to catch it before or after the
> secure computing check, though.  On reflection maybe doing it
> afterwards makes more sense - what do you think?

I don't have a strong preference (I really hate all these hooks we have
on the syscall entry/exit path), but we do need to make sure that the
behaviour is consistent across architectures.

Will

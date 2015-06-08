From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: [RFC PATCH 09/18] kthread: Make it easier to correctly sleep in
 iterant kthreads
Date: Mon, 8 Jun 2015 13:48:10 -0400
Message-ID: <20150608134810.3abd862b@gandalf.local.home>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
	<1433516477-5153-10-git-send-email-pmladek@suse.cz>
	<20150605161021.GJ19282@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150605161021.GJ19282-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, 5 Jun 2015 18:10:21 +0200
Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:

> On Fri, Jun 05, 2015 at 05:01:08PM +0200, Petr Mladek wrote:
> > Many kthreads go into an interruptible sleep when there is nothing
> > to do. They should check if anyone did not requested the kthread
> > to terminate, freeze, or park in the meantime. It is easy to do
> > it a wrong way.
> 
> INTERRUPTIBLE is the wrong state to idle in for kthreads, use
> TASK_IDLE.
> 
> ---
> 
> commit 80ed87c8a9ca0cad7ca66cf3bbdfb17559a66dcf
> Author: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Date:   Fri May 8 14:23:45 2015 +0200
> 
>     sched/wait: Introduce TASK_NOLOAD and TASK_IDLE
>     
>     Currently people use TASK_INTERRUPTIBLE to idle kthreads and wait for
>     'work' because TASK_UNINTERRUPTIBLE contributes to the loadavg. Having
>     all idle kthreads contribute to the loadavg is somewhat silly.

Not to mention, tasks in TASK_UNINTERRUPTIBLE state for too long will
trigger hung task detection.


>     
>     Now mostly this works OK, because kthreads have all their signals
>     masked. However there's a few sites where this is causing problems and
>     TASK_UNINTERRUPTIBLE should be used, except for that loadavg issue.
>     
>     This patch adds TASK_NOLOAD which, when combined with
>     TASK_UNINTERRUPTIBLE avoids the loadavg accounting.
>     
>     As most of imagined usage sites are loops where a thread wants to
>     idle, waiting for work, a helper TASK_IDLE is introduced.
>     
>     Signed-off-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Acked-by: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>

-- Steve

>     Cc: Julian Anastasov <ja-FgGsKACvmQM@public.gmane.org>
>     Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
>     Cc: NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>
>     Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
>     Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
>     Signed-off-by: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h

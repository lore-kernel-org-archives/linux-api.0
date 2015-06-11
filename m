From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC PATCH 09/18] kthread: Make it easier to correctly sleep in
 iterant kthreads
Date: Thu, 11 Jun 2015 06:28:28 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1506110625010.12753@pobox.suse.cz>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz> <1433516477-5153-10-git-send-email-pmladek@suse.cz> <20150605161021.GJ19282@twins.programming.kicks-ass.net> <20150608134810.3abd862b@gandalf.local.home> <20150610090724.GD3644@twins.programming.kicks-ass.net>
 <20150610100729.6a674c15@gandalf.local.home>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150610100729.6a674c15-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, 10 Jun 2015, Steven Rostedt wrote:

> > Right, and I had not considered that, but it turns out the hung_task
> > detector checks p->state == TASK_UNINTERRUPTIBLE, so TASK_IDLE is indeed
> > safe from that.
> 
> Also, I would assume that TASK_IDLE only makes sense for kernel
> threads, I wonder if we should add an assertion in schedule that
> triggers if a task is scheduling with TASK_IDLE and is not a kernel
> thread (has its own mm?)

For the sake of completnes -- testing for !task_struct->mm is not a 
correct test to find out whether given entity is a kernel thread; kernel 
threads are free to temporarily adopt user struct mm via use_mm() (usually 
for handling AIO on behalf of a particular struct mm).

The correct check is to look at PF_KTHREAD flag in task_struct->flags.

-- 
Jiri Kosina
SUSE Labs

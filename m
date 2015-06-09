From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 06/18] signal/kthread: Initial implementation of
 kthread signal handling
Date: Tue, 9 Jun 2015 16:10:22 +0900
Message-ID: <20150609071022.GX21465@mtj.duckdns.org>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
 <1433516477-5153-7-git-send-email-pmladek@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433516477-5153-7-git-send-email-pmladek-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hello, Petr.

On Fri, Jun 05, 2015 at 05:01:05PM +0200, Petr Mladek wrote:
> Several kthreads already handle signals some way. They do so
> in different ways, search for allow_signal().
> 
> This patch allows to handle the signals in a more uniform way using
> kthread_do_signal().
> 
> The main question is how much it should follow POSIX and the signal
> handling of user space processes. On one hand, we want to be as close
> as possible. On the other hand, we need to be very careful. All signals
> were ignored until now, except for the few kthreads that somehow
> handled them.
> 
> POSIX behavior might cause some surprises and crazy bug reports.
> For example, imagine a home user stopping or killing kswapd because
> it makes the system too busy. It is like shooting in its own leg.
> 
> Also the signals are already used a strange way. For example, klockd
> drops all locks when it gets SIGKILL. This was added before initial
> git commit, so the archaeology was not easy. The most likely explanation
> is that it is used during the system shutdown. It would make sense
> to drop all locks when user space processes are killed and before
> filesystems get unmounted.
> 
> Now, the patch does the following compromise:
> 
>   + defines default actions for SIGSTOP, SIGCONT, and fatal signals
>   + custom actions can be defined by kthread_sigaction()
>   + all signals are still ignored by default
> 
> Well, fatal signals do not terminate the kthread immediately. They just
> set a flag to terminate the kthread, flush all other pending signals,
> and return to the main kthread cycle. The kthread is supposed to check
> the flag, leave the main cycle, do some cleanup actions when necessary
> and return from the kthread.
> 
> Note that kthreads are running in the kernel address space. It makes
> the life much easier. The signal handler can be called directly and
> we do not need any arch-specific code to process it in the userspace.
> Also we do not care about ptrace.
> 
> Finally, kthread_do_signal() is called on a safe place in the main
> iterant kthread cycle. Then we will not need any special code for
> signals when using this kthread API.
> 
> This change does not affect any existing kthread. The plan is to
> use them only in safe kthreads that can be converted into
> the iterant kthread API.

While I agree that it'd be great to consolidate the existing kthread
signal users, I feel quite uncomfortable with doing full-fledged
signal handling for kthreads which try to mimic the userland behavior.
Most of the default behaviors don't make sense for kthreads and it'd
be awful to have different kthreads interpreting arbitrary signals for
differing custom behaviors, which often happens when there's no
default.

While we do have several kthread signal users, they aren't too many
and majority of them use it to allow userland to tell it to shutdown
and there seem to be a couple which use HUP/USR1 to cancel whatever
it's processing / waiting on at the moment.  Hmmm... jffs uses
STOP/CONT too.

I don't know how this should be done but let's please try to

1. Encourage uniform behaviors across the signals.

2. Ultimately discourage usage of signals on kthreads as this closely
   ties implementation detail (use of single kthread) to the userland
   visible interface in a way where we can't easily get back out of.
   For example, what if jffs needs its gc workers to be multi-threaded
   and per-NUMA for high-iops devices later on?

Thanks.

-- 
tejun
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

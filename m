From: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 06/18] signal/kthread: Initial implementation of
	kthread signal handling
Date: Sat, 6 Jun 2015 23:58:16 +0200
Message-ID: <20150606215816.GB15591@redhat.com>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz> <1433516477-5153-7-git-send-email-pmladek@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433516477-5153-7-git-send-email-pmladek-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 06/05, Petr Mladek wrote:
>
> The main question is how much it should follow POSIX and the signal
> handling of user space processes. On one hand, we want to be as close
> as possible.

Why? Let the kthread decide what it should if it gets, say, SIGSTOP.

> Finally, kthread_do_signal() is called on a safe place in the main
> iterant kthread cycle. Then we will not need any special code for
> signals when using this kthread API.

OK, I will not comment other parts of iterant API in this thread.

But as for signal handling, to me a single kthread_iterant->do_signal()
callback looks better. Rather than multiple callbacks passed as
->kthread_sa_handler.

That single callback can deque a signal and decide what it should do.

> +	spin_lock_irqsave(&sighand->siglock, flags);
> +
> +	if (unlikely(signal->flags & SIGNAL_CLD_MASK)) {
> +		WARN(1, "there are no parents for kernel threads\n");
> +		signal->flags &= ~SIGNAL_CLD_MASK;
> +	}
> +
> +	for (;;) {
> +		struct k_sigaction *ka;
> +
> +		signr = dequeue_signal(current, &current->blocked, &ksig.info);
> +
> +		if (!signr)
> +			break;
> +
> +		ka = &sighand->action[signr-1];
> +
> +		/* Do nothing for ignored signals */
> +		if (ka->sa.kthread_sa_handler == KTHREAD_SIG_IGN)
> +			continue;

Again, I agree something like the simple kthread_dequeue_signal() makes
sense. Say, to drop the ignore signal like this code does. Although I
do not think this is really important, SIG_IGN is only possible if this
kthread does something strange. Say, blocks/unblocs the ignored signal.

> +
> +		/* Run the custom handler if any */
> +		if (ka->sa.kthread_sa_handler != KTHREAD_SIG_DFL) {
> +			ksig.ka = *ka;
> +
> +			if (ka->sa.sa_flags & SA_ONESHOT)
> +				ka->sa.kthread_sa_handler = KTHREAD_SIG_DFL;
> +
> +			spin_unlock_irqrestore(&sighand->siglock, flags);
> +			/* could run directly for kthreads */
> +			ksig.ka.sa.kthread_sa_handler(signr);
> +			freezable_cond_resched();
> +			goto relock;

Well. But for what? A simple "switch (signr)" after kthread_dequeue_signal()
can do the same. Or, speaking of kthread_iterant_fn() it can even dequeue the
signal and pass it to kti->whatever(signr).

> +		if (sig_kernel_ignore(signr))
> +			continue;

For what? Why a kthread should unignore (say) SIGWINCH if it is not going
to react?

> +		if (sig_kernel_stop(signr)) {
> +			__set_current_state(TASK_STOPPED);
> +			spin_unlock_irqrestore(&sighand->siglock, flags);
> +			/* Don't run again until woken by SIGCONT or SIGKILL */
> +			freezable_schedule();
> +			goto relock;

Yes this avoids the race with SIGCONT. But as I said we can add another
trivial helper which checks JOBCTL_STOP_DEQUEUED. So a kthread can do
this itself.

To me, SIG_DFL behaviour just makes makes no sense when it comes to
kthreads. I do not even think this can simplify the code. Unlike user-
space task, kthread can happily dequeue SIGSTOP, so why should we mimic
the userspace SIG_DFL logic.


> +		/* Death signals, but try to terminate cleanly */
> +		kthread_stop_current();
> +		__flush_signals(current);
> +		break;

The same.

Oleg.

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

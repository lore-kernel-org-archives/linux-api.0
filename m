From: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC PATCH 06/18] signal/kthread: Initial implementation of
 kthread signal handling
Date: Mon, 15 Jun 2015 15:13:41 +0200
Message-ID: <20150615131341.GN9409@pathway.suse.cz>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
 <1433516477-5153-7-git-send-email-pmladek@suse.cz>
 <20150606215816.GB15591@redhat.com>
 <20150608135107.GB3135@pathway.suse.cz>
 <20150608211336.GB24869@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150608211336.GB24869-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Oleg,

I am sorry for the late reply. I wanted to think more before answering
all the mails.

On Mon 2015-06-08 23:13:36, Oleg Nesterov wrote:
> I do not. Contrary, I think this needs more code in the likely case.
> Anyway, this API won't have too many users, so I don't even this this
> is that important.
> 
> > > > +		if (sig_kernel_stop(signr)) {
> > > > +			__set_current_state(TASK_STOPPED);
> > > > +			spin_unlock_irqrestore(&sighand->siglock, flags);
> > > > +			/* Don't run again until woken by SIGCONT or SIGKILL */
> > > > +			freezable_schedule();
> > > > +			goto relock;
> > >
> > > Yes this avoids the race with SIGCONT. But as I said we can add another
> > > trivial helper which checks JOBCTL_STOP_DEQUEUED. So a kthread can do
> > > this itself.
> >
> > Hmm, the helper would have a strange semantic. You need to take
> > sighand->siglock, dequeue the signal (SIGSTOP), and call
> > __set_current_state(TASK_STOPPED) before you release the lock.
> > But what would happen if the dequeued signal is _not_ SIGSTOP?
> 
> Perhaps I missed your point, but no. If you want to handle SIGSTOP
> you can do
> 

I think that we need to add:

	spin_lock_irq(&sighand->siglock);

> 	signr = kthread_signal_dequeue();
> 	switch (signr) {
> 	case SIGSTOP:
> 		something_else();
> 		kthread_do_signal_stop();
> 	...
> 	}

And if we want to avoid any race, kthread_do_signal_stop() should look like:

void kthread_do_signal_stop(unsigned long flags)
{
	struct sighand_struct *sighand = current->sighand;

	__set_current_state(TASK_STOPPED);
	spin_unlock_irqrestore(&sighand->siglock, flags);
	/* Don't run again until woken by SIGCONT or SIGKILL */
	freezable_schedule();
}

It means that we will have spin_lock() in one function and
spin_unlock() in another one. This is what I meant with
the strange semantic. This is why I think that it might be
cleaner to implement some generic kthread_do_signal() or so
and allow to (re)define/add sigactions via callbacks.

Note that I am not aware of any kthread that would use SIGSTOP
non-standard way.

Anyway, I am going to concentrate on the main structure of the kthread
API and will put the controversial signal handling a side for now.
I will get back to it when converting the few kthreads that use
signals. I will think more about your feedback in the meantime.

Best Regards,
Petr

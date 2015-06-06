From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [RFC PATCH 11/18] jffs2: Convert jffs2_gcd_mtd kthread into the
 iterant API
Date: Sun, 7 Jun 2015 00:44:15 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.1506070034100.12753@pobox.suse.cz>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz> <1433516477-5153-12-git-send-email-pmladek@suse.cz> <20150606211648.GA15591@redhat.com> <alpine.LNX.2.00.1506062322550.12753@pobox.suse.cz> <20150606223001.GA18838@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150606223001.GA18838-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, 7 Jun 2015, Oleg Nesterov wrote:

> > > Still I personally dislike the new kthread_sigaction() API. I agree,
> > > a couple if signal helpers for kthreads make sense. Say,
> > >
> > > 	void kthread_do_signal_stop(void)
> > > 	{
> > > 		spin_lock_irq(&curtent->sighand->siglock);
> > > 		if (current->jobctl & JOBCTL_STOP_DEQUEUED)
> > > 			__set_current_state(TASK_STOPPED);
> > > 		spin_unlock_irq(&current->sighand->siglock);
> > >
> > > 		schedule();
> > > 	}
> >
> > ... not to mention the fact that 'STOP' keyword in relation to kthreads
> > has completely different meaning today, which just contributes to overall
> > confusion; but that's an independent story.
> 
> Yes, agreed.

I BTW think this really needs to be fixed. We have kthread parking and 
kthread stopping at least (and that doesn't include kthreads that actually 
*do* handle SIGSTOP), and the naming is unfortunate and confusing.

> > > But personally I do not think kthread_do_signal() makes a lot of sense...
> >
> > Would it be possible for you to elaborate a little bit more why you think
> > so ... ?
> 
> Please see another email I sent in reply to 06/18.

Yeah, let's just continue more detailed discussion there. I saw your reply 
only after I answered to your original mail.

> > I personally don't see a huge principal difference between 
> > "kthread_signal_dequeue() + kthread_do_signal_{stop,...}" vs. generic 
> > "kthread_do_signal()" that's just basically completely general and 
> > takes care of 'everything necessary'.
> 
> Then why do we need the new API ?

Well, in a nutshell, because of the "it's general and takes care of 
everything" part.

> And I do see the difference. Rightly or not I belive that this API buys
> nothing but makes the kthread && signal interaction more complex and
> confusing. For no reason.

Current situation with kthrads is a mess. Everyone and his grand-son needs 
to put explicit try_to_freeze(), cond_resched() and whatever else checks 
in his private kthreads main loop.

The fact that kthreads are more and more prone to making use of signal 
handling makes this even more complicated, because everyone is reinventing 
his own wheel for this.

It can't be really properly reviewed and - more importantly - it makes the 
whole "how would this particular kthread react to this particular signal?" 
very unpredictable and hard to answer question.

IMO Petr's patchset basically brings some kind order to this all -- it 
"batches" the kthread executions to individual iterations of the main 
loop, and allows to perform actions on the border of the iteration (such 
as, but not limited to, handling of the signals). Signal handling is just 
one of the piggy-backers on top of this general cleanup.

Thanks,

-- 
Jiri Kosina
SUSE Labs

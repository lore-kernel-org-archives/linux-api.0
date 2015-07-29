From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 07/14] mm/huge_page: Convert khugepaged() into
 kthread worker API
Date: Wed, 29 Jul 2015 13:32:49 +0200
Message-ID: <20150729113249.GL2673@pathway.suse.cz>
References: <1438094371-8326-1-git-send-email-pmladek@suse.com>
 <1438094371-8326-8-git-send-email-pmladek@suse.com>
 <20150728173635.GD5322@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150728173635.GD5322-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue 2015-07-28 13:36:35, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jul 28, 2015 at 04:39:24PM +0200, Petr Mladek wrote:
> > -static void khugepaged_wait_work(void)
> > +static void khugepaged_wait_func(struct kthread_work *dummy)
> >  {
> >  	if (khugepaged_has_work()) {
> >  		if (!khugepaged_scan_sleep_millisecs)
> > -			return;
> > +			goto out;
> >  
> >  		wait_event_freezable_timeout(khugepaged_wait,
> > -					     kthread_should_stop(),
> > +					     !khugepaged_enabled(),
> >  			msecs_to_jiffies(khugepaged_scan_sleep_millisecs));
> > -		return;
> > +		goto out;
> >  	}
> >  
> >  	if (khugepaged_enabled())
> >  		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
> > +
> > +out:
> > +	if (khugepaged_enabled())
> > +		queue_kthread_work(&khugepaged_worker,
> > +				   &khugepaged_do_scan_work);
> >  }
> 
> There gotta be a better way to do this.  It's outright weird to
> convert it over to work item based interface and then handle idle
> periods by injecting wait work items.  If there's an external event
> which wakes up the worker, convert that to a queueing event.  If it's
> a timed event, implement a delayed work and queue that with delay.

I am going to give it a try.

Best Regards,
Petr

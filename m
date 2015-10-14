From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC v2 07/18] kthread: Allow to cancel kthread work
Date: Wed, 14 Oct 2015 12:20:22 +0200
Message-ID: <20151014102022.GA2880@pathway.suse.cz>
References: <1442840639-6963-8-git-send-email-pmladek@suse.com>
 <20150922193513.GE17659@mtj.duckdns.org>
 <20150925112617.GA3122@pathway.suse.cz>
 <20150928170314.GF2589@mtj.duckdns.org>
 <20151002154336.GC3122@pathway.suse.cz>
 <20151002192453.GA7564@mtj.duckdns.org>
 <20151005100758.GK9603@pathway.suse.cz>
 <20151005110924.GL9603@pathway.suse.cz>
 <20151007092130.GD3122@pathway.suse.cz>
 <20151007142446.GA2012@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151007142446.GA2012-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 2015-10-07 07:24:46, Tejun Heo wrote:
>  At each turn, you come up with non-issues and declare that it needs to
> be full workqueue-like implementation but the issues you're raising
> seem all rather irrelevant.  Can you please try to take a step back
> and put some distance from the implementation details of workqueue?

JFYI, I do a step back and am trying to convert more kthreads to
the kthread worker API. It helps me to get better insight into
the problematic.

I am still not sure where you see the difference between
workqueues and the kthread worker API. My view is that
the main differences are:

Workqueues			Kthread worker

  + pool of kthreads		  + dedicated kthread

  + kthreads created and	  + kthread created and
    destroyed on demand		    destroyed with the worker

  + can proceed more works	  + one work is proceed at a time
    in parallel from one queue

Otherwise, similar basic set of operations would be useful:

  + create_worker
  + queue_work, queue_delayed_work
  + mod_delayed_work
  + cancel_work, cancel_delayed_work
  + flush_work
  + flush_worker
  + drain_worker
  + destroy_worker

, where queue, mod, cancel operations should work also from IRQ
context.

There are few potentially complicated and sensitive users of the
kthread workers API, e.g. handling nfs callbacks, some kthreads
used for handling network packets, eventually the rcu stuff.
Here the operations need to be secure and rather fast.

IMHO, it would be great if it is easy to convert between the
kthread worker and workqueues API. It will allow to choose
the most effective variant for a given purpose. IMHO, this is
sometimes hard to say without real life testing.

I wonder if I miss some important angle of view.


In each case, it is still not clear if the API will be acceptable
for the affected parties. Therefore I do not want to spend too
much time on perfectionalizing the API implementation at this
point. Is it OK, please?

Thanks for feedback.

Best Regards,
Petr


PS: I am not convinced that all my concerns were non-issues.
For example, I agree that a race when queuing the same work
to more kthread workers might look theoretical. On the other
hand, the API allows it and it might be hard to debug. IMHO,
it might be an acceptable trade off if the implementation is
much easier and more secure in other areas. But my draft
implementation did not suggested this.

For example, there were more situations when I needed to double
check that the work was still connected with the locked worker
after taking the lock. I know that it will not happen when
the API is used a reasonable way but...

Ah, I am back in the details. I have to stop it for now ;-)

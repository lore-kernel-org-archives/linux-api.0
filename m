From: Petr Mladek <pmladek@suse.com>
Subject: Re: [RFC v2 09/18] mm/huge_page: Convert khugepaged() into kthread
 worker API
Date: Wed, 23 Sep 2015 11:50:06 +0200
Message-ID: <20150923095006.GB12406@pathway.suse.cz>
References: <1442840639-6963-1-git-send-email-pmladek@suse.com>
 <1442840639-6963-10-git-send-email-pmladek@suse.com>
 <20150922202604.GG17659@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150922202604.GG17659@mtj.duckdns.org>
Sender: owner-linux-mm@kvack.org
To: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, live-patching@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue 2015-09-22 16:26:04, Tejun Heo wrote:
> Hello,
> 
> On Mon, Sep 21, 2015 at 03:03:50PM +0200, Petr Mladek wrote:
> > +static int khugepaged_has_work(void)
> > +{
> > +	return !list_empty(&khugepaged_scan.mm_head) &&
> > +		khugepaged_enabled();
> > +}
> 
> Hmmm... no biggie but this is a bit bothering.

This function has been there even before and is used on more locations.
I have just moved the definition.

> > @@ -425,7 +447,10 @@ static ssize_t scan_sleep_millisecs_store(struct kobject *kobj,
> >  		return -EINVAL;
> >  
> >  	khugepaged_scan_sleep_millisecs = msecs;
> > -	wake_up_interruptible(&khugepaged_wait);
> > +	if (khugepaged_has_work())
> > +		mod_delayed_kthread_work(khugepaged_worker,
> > +					 &khugepaged_do_scan_work,
> > +					 0);
> 
> What's wrong with just doing the following?
> 
> 	if (khugepaged_enabled())
> 		mod_delayed_kthread_work(...);

It was just an optimization. It does not make sense to queue the work
if there is nothing to do.

Note that the timeout between the scans is there to throttle the work.
If all pages are scanned, the work stops re-queuing until
__khugepaged_enter() adds new job.

Thanks a lot for review. I am going to update the patchset according
to the other comments.

Best Regards,
Petr

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

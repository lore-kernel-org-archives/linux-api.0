From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 07/14] mm/huge_page: Convert khugepaged() into
 kthread worker API
Date: Tue, 28 Jul 2015 13:36:35 -0400
Message-ID: <20150728173635.GD5322@mtj.duckdns.org>
References: <1438094371-8326-1-git-send-email-pmladek@suse.com>
 <1438094371-8326-8-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1438094371-8326-8-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, live-patching@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello,

On Tue, Jul 28, 2015 at 04:39:24PM +0200, Petr Mladek wrote:
> -static void khugepaged_wait_work(void)
> +static void khugepaged_wait_func(struct kthread_work *dummy)
>  {
>  	if (khugepaged_has_work()) {
>  		if (!khugepaged_scan_sleep_millisecs)
> -			return;
> +			goto out;
>  
>  		wait_event_freezable_timeout(khugepaged_wait,
> -					     kthread_should_stop(),
> +					     !khugepaged_enabled(),
>  			msecs_to_jiffies(khugepaged_scan_sleep_millisecs));
> -		return;
> +		goto out;
>  	}
>  
>  	if (khugepaged_enabled())
>  		wait_event_freezable(khugepaged_wait, khugepaged_wait_event());
> +
> +out:
> +	if (khugepaged_enabled())
> +		queue_kthread_work(&khugepaged_worker,
> +				   &khugepaged_do_scan_work);
>  }

There gotta be a better way to do this.  It's outright weird to
convert it over to work item based interface and then handle idle
periods by injecting wait work items.  If there's an external event
which wakes up the worker, convert that to a queueing event.  If it's
a timed event, implement a delayed work and queue that with delay.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

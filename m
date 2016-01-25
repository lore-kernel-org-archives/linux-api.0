From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 04/22] kthread: Add create_kthread_worker*()
Date: Mon, 25 Jan 2016 13:53:39 -0500
Message-ID: <20160125185339.GB3628@mtj.duckdns.org>
References: <1453736711-6703-1-git-send-email-pmladek@suse.com>
 <1453736711-6703-5-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1453736711-6703-5-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon, Jan 25, 2016 at 04:44:53PM +0100, Petr Mladek wrote:
> +struct kthread_worker *
> +create_kthread_worker_on_cpu(int cpu, const char namefmt[])
> +{
> +	if (cpu < 0 || cpu > num_possible_cpus())
> +		return ERR_PTR(-EINVAL);

Comparing cpu ID to num_possible_cpus() doesn't make any sense.  It
should either be testing against cpu_possible_mask or testing against
nr_cpu_ids.  Does this test need to be in this function at all?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

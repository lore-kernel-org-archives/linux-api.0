From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC v2 00/18] kthread: Use kthread worker API more widely
Date: Tue, 22 Sep 2015 16:32:22 -0400
Message-ID: <20150922203222.GH17659@mtj.duckdns.org>
References: <1442840639-6963-1-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1442840639-6963-1-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, live-patching@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hello, Petr.

On Mon, Sep 21, 2015 at 03:03:41PM +0200, Petr Mladek wrote:
> 9th, 12th, 17th patches: convert three kthreads into the new API,
>      namely: khugepaged, ring buffer benchmark, RCU gp kthreads[*]

I haven't gone through each conversion in detail but they generally
look good to me.

Thanks a lot for doing this!

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

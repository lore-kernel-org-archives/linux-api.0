From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 00/20] kthread: Use kthread worker API more widely
Date: Fri, 22 Apr 2016 14:30:40 -0400
Message-ID: <20160422183040.GW7822@mtj.duckdns.org>
References: <1460646879-617-1-git-send-email-pmladek@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1460646879-617-1-git-send-email-pmladek@suse.com>
Sender: linux-pm-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, linux-watchdog@vger.kernel.org, Corey Minyard <minyard@acm.org>, openipmi-developer@lists.sourceforge.net, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org, Maxim Levitsky <maximl>
List-Id: linux-api@vger.kernel.org

Hello, Petr.

On Thu, Apr 14, 2016 at 05:14:19PM +0200, Petr Mladek wrote:
> My intention is to make it easier to manipulate and maintain kthreads.
> Especially, I want to replace all the custom main cycles with a
> generic one. Also I want to make the kthreads sleep in a consistent
> state in a common place when there is no work.
> 
> My first attempt was with a brand new API (iterant kthread), see
> http://thread.gmane.org/gmane.linux.kernel.api/11892 . But I was
> directed to improve the existing kthread worker API. This is
> the 4th iteration of the new direction.
> 
> 1nd..10th patches: improve the existing kthread worker API

I glanced over them and they generally look good to me.  Let's see how
people respond to actual conversions.

Thanks.

-- 
tejun

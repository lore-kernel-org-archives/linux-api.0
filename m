From: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: Re: [PATCH v3 22/22] thermal/intel_powerclamp: Convert the kthread
 to kthread worker API
Date: Tue, 12 Jan 2016 08:20:21 -0800
Message-ID: <20160112082021.6a28dc66@icelake>
References: <1447853127-3461-1-git-send-email-pmladek@suse.com>
	<1447853127-3461-23-git-send-email-pmladek@suse.com>
	<20160107115531.34279a9b@icelake>
	<20160108164931.GT3178@pathway.suse.cz>
	<20160111181718.0ace4a58@yairi>
	<20160112101129.GN731@pathway.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-pm-owner@vger.kernel.org>
In-Reply-To: <20160112101129.GN731@pathway.suse.cz>
Sender: linux-pm-owner@vger.kernel.org
To: Petr Mladek <pmladek@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>, Eduardo Valentin <edubezval@gmail.com>, linux-pm@vger.kernel.org, jacob.jun.pan@linux.intel.com
List-Id: linux-api@vger.kernel.org

On Tue, 12 Jan 2016 11:11:29 +0100
Petr Mladek <pmladek@suse.com> wrote:

> > > BTW: I wonder if the original code correctly handle freezing after
> > > the schedule_timeout(). It does not call try_to_freeze()
> > > there and the forced idle states might block freezing.
> > > I think that the small overhead of kthread works is worth
> > > solving such bugs. It makes it easier to maintain these
> > > sleeping states.  
> > it is in a while loop, so try_to_freeze() gets called. Am I missing
> > something?  
> 
> But it might take some time until try_to_freeze() is called.
> If I get it correctly. try_to_freeze_tasks() wakes freezable
> tasks to get them into the fridge. If clamp_thread() is waken
> from that schedule_timeout_interruptible(), it still might inject
> the idle state before calling try_to_freeze(). It means that freezer
> needs to wait "quite" some time until the kthread ends up in the
> fridge.
> 
> Hmm, even my conversion does not solve this entirely. We might
> need to call freezing(current) in the
> 
>    while (time_before(jiffies, target_jiffies)) {
> 
> cycle. And break injecting the idle state when freezing is requested.

The injection time for each period is very short, default 6ms. While on
the other side the default freeze timeout is 20 sec. So I think task
freeze can wait :)
i.e.
unsigned int __read_mostly freeze_timeout_msecs = 20 * MSEC_PER_SEC;

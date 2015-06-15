From: Petr Mladek <pmladek@suse.cz>
Subject: Re: [RFC PATCH 15/18] ring_buffer: Allow to exit the ring buffer
 benchmark immediately
Date: Mon, 15 Jun 2015 17:54:28 +0200
Message-ID: <20150615155428.GD3135@pathway.suse.cz>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
 <1433516477-5153-16-git-send-email-pmladek@suse.cz>
 <20150608134417.3fb7a811@gandalf.local.home>
 <20150615152313.GC3135@pathway.suse.cz>
 <20150615113343.215bcd43@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150615113343.215bcd43@gandalf.local.home>
Sender: linux-kernel-owner@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Richard Weinberger <richard@nod.at>, David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org, Trond Myklebust <trond.myklebust@primarydata.com>, Anna Schumaker <anna.schumaker@netapp.com>, linux-nfs@vger.kernel.org, Chris Mason <clm@fb.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, live-patching@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon 2015-06-15 11:33:43, Steven Rostedt wrote:
> On Mon, 15 Jun 2015 17:23:13 +0200
> Petr Mladek <pmladek@suse.cz> wrote:
> 
> 
> > Please, find below a version of the patch that can be applied against
> > current Linus tree and also against your for-next branch.
> > 
> 
> Thanks, just on Friday, I was testing ring buffer changes with the
> ringbuffer benchmark, and was bitching about how I had to wait the 10
> seconds before the module would unload ;-)

I am glad that it will be useful.

Please, find below a version with a small typo fix. Heh, I spent a lot
of time with doulbe checking the patch and then decided to do a last
minute change. It produced "only" compilation warning that I missed.
It was not visible with my testing :-(



>From 0049043e740c22bddc4306e448a015a9b8450825 Mon Sep 17 00:00:00 2001
From: Petr Mladek <pmladek@suse.cz>
Date: Mon, 15 Jun 2015 15:53:10 +0200
Subject: [PATCH] ring_buffer: Allow to exit the ring buffer benchmark
 immediately

It takes a while until the ring_buffer_benchmark module is removed
when the ring buffer hammer is running. It is because it takes
few seconds and kthread_should_stop() is not being checked.

This patch adds the check for kthread termination into the producer.
It uses the existing @kill_test flag to finish the kthreads as
cleanly as possible.

It disables printing the "ERROR" message when the kthread is going.

It makes sure that producer does not go into the 10sec sleep
when it is being killed.

Finally, it does not call wait_to_die() when kthread_should_stop()
already returns true.

Signed-off-by: Petr Mladek <pmladek@suse.cz>
---
 kernel/trace/ring_buffer_benchmark.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 1b28df2d9104..c17f9c8d4908 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -263,6 +263,8 @@ static void ring_buffer_producer(void)
 		if (cnt % wakeup_interval)
 			cond_resched();
 #endif
+		if (kthread_should_stop())
+			kill_test = 1;
 
 	} while (ktime_before(end_time, timeout) && !kill_test);
 	trace_printk("End ring buffer hammer\n");
@@ -285,7 +287,7 @@ static void ring_buffer_producer(void)
 	entries = ring_buffer_entries(buffer);
 	overruns = ring_buffer_overruns(buffer);
 
-	if (kill_test)
+	if (kill_test && !kthread_should_stop())
 		trace_printk("ERROR!\n");
 
 	if (!disable_reader) {
@@ -379,7 +381,7 @@ static int ring_buffer_consumer_thread(void *arg)
 	}
 	__set_current_state(TASK_RUNNING);
 
-	if (kill_test)
+	if (!kthread_should_stop())
 		wait_to_die();
 
 	return 0;
@@ -399,13 +401,16 @@ static int ring_buffer_producer_thread(void *arg)
 		}
 
 		ring_buffer_producer();
+		if (kill_test)
+			goto out_kill;
 
 		trace_printk("Sleeping for 10 secs\n");
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(HZ * SLEEP_TIME);
 	}
 
-	if (kill_test)
+out_kill:
+	if (!kthread_should_stop())
 		wait_to_die();
 
 	return 0;
-- 
1.8.5.6

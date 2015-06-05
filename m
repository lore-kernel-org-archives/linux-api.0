From: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
Subject: [RFC PATCH 15/18] ring_buffer: Allow to exit the ring buffer benchmark immediately
Date: Fri,  5 Jun 2015 17:01:14 +0200
Message-ID: <1433516477-5153-16-git-send-email-pmladek@suse.cz>
References: <1433516477-5153-1-git-send-email-pmladek@suse.cz>
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433516477-5153-1-git-send-email-pmladek-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mtd-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <anna.schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Chris Mason <clm-b10kYP2dOMg@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

It takes a while until the ring_buffer_benchmark module is removed
when the ring buffer hammer is running. It is because it takes
few seconds and kthread_should_terminate() is not being checked.

This patch adds the check for kthread termination into the producer.
It uses the existing kill_test flag to finish the kthreads as
cleanly as possible.

It disables printing the "ERROR" message when the kthread is going.

Also it makes sure that producer does not go into the 10sec sleep
when it is being killed.

Signed-off-by: Petr Mladek <pmladek-AlSwsSmVLrQ@public.gmane.org>
---
 kernel/trace/ring_buffer_benchmark.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 2d276b892aea..4ecf7c4567e2 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -270,6 +270,9 @@ static void ring_buffer_producer(void)
 			try_to_freeze();
 		}
 
+		if (kthread_should_stop())
+			kill_test = 1;
+
 	} while (ktime_before(end_time, timeout) && !kill_test);
 	trace_printk("End ring buffer hammer\n");
 
@@ -291,7 +294,7 @@ static void ring_buffer_producer(void)
 	entries = ring_buffer_entries(buffer);
 	overruns = ring_buffer_overruns(buffer);
 
-	if (kill_test)
+	if (kill_test && !kthread_should_stop())
 		trace_printk("ERROR!\n");
 
 	if (!disable_reader) {
@@ -377,10 +380,8 @@ static void ring_buffer_producer_thread_init(void *arg)
 
 static void ring_buffer_producer_thread_func(void *arg)
 {
-	if (kill_test) {
-		set_kthread_iterant_int_sleep();
-		return;
-	}
+	if (kill_test)
+		goto test_killed;
 
 	ring_buffer_reset(buffer);
 
@@ -393,9 +394,16 @@ static void ring_buffer_producer_thread_func(void *arg)
 
 	ring_buffer_producer();
 
+	if (kill_test)
+		goto test_killed;
+
 	trace_printk("Sleeping for 10 secs\n");
 	set_current_state(TASK_INTERRUPTIBLE);
 	schedule_timeout(HZ * SLEEP_TIME);
+	return;
+
+test_killed:
+	set_kthread_iterant_int_sleep();
 }
 
 static int __init ring_buffer_benchmark_init(void)
-- 
1.8.5.6

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

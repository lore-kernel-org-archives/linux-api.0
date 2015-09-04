From: Petr Mladek <pmladek@suse.com>
Subject: Re: [RFC PATCH 10/14] ring_buffer: Fix more races when terminating
 the producer in the benchmark
Date: Fri, 4 Sep 2015 11:38:56 +0200
Message-ID: <20150904093856.GI22739@pathway.suse.cz>
References: <1438094371-8326-1-git-send-email-pmladek@suse.com>
 <1438094371-8326-11-git-send-email-pmladek@suse.com>
 <20150803143323.426ea2fc@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150803143323.426ea2fc@gandalf.local.home>
Sender: owner-linux-mm@kvack.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, live-patching@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Mon 2015-08-03 14:33:23, Steven Rostedt wrote:
> On Tue, 28 Jul 2015 16:39:27 +0200
> Petr Mladek <pmladek@suse.com> wrote:
> 
> > @@ -384,7 +389,7 @@ static int ring_buffer_consumer_thread(void *arg)
> >  
> >  static int ring_buffer_producer_thread(void *arg)
> >  {
> > -	while (!kthread_should_stop() && !kill_test) {
> > +	while (!break_test()) {
> >  		ring_buffer_reset(buffer);
> >  
> >  		if (consumer) {
> > @@ -393,11 +398,15 @@ static int ring_buffer_producer_thread(void *arg)
> >  		}
> >  
> >  		ring_buffer_producer();
> > -		if (kill_test)
> > +		if (break_test())
> >  			goto out_kill;
> >  
> >  		trace_printk("Sleeping for 10 secs\n");
> >  		set_current_state(TASK_INTERRUPTIBLE);
> > +		if (break_test()) {
> > +			__set_current_state(TASK_RUNNING);
> 
> Move the setting of the current state to after the out_kill label.

Please, find below the updated version of this patch.

I also reverted some changes in the consumer code. It never stays
in a loop for too long and it must stay in ring_buffer_producer()
until "reader_finish" variable is set.


>From 7f5b1a5b8cf8248245897b55ffc51a6d74c8e15b Mon Sep 17 00:00:00 2001
From: Petr Mladek <pmladek@suse.com>
Date: Fri, 19 Jun 2015 14:38:36 +0200
Subject: [PATCH 2/2] ring_buffer: Fix more races when terminating the producer
 in the benchmark

The commit b44754d8262d3aab8 ("ring_buffer: Allow to exit the ring
buffer benchmark immediately") added a hack into ring_buffer_producer()
that set @kill_test when kthread_should_stop() returned true. It improved
the situation a lot. It stopped the kthread in most cases because
the producer spent most of the time in the patched while cycle.

But there are still few possible races when kthread_should_stop()
is set outside of the cycle. Then we do not set @kill_test and
some other checks pass.

This patch adds a better fix. It renames @test_kill/TEST_KILL() into
a better descriptive @test_error/TEST_ERROR(). Also it introduces
break_test() function that checks for both @test_error and
kthread_should_stop().

The new function is used in the producer when the check for @test_error
is not enough. It is not used in the consumer because its state
is manipulated by the producer via the "reader_finish" variable.

Also we add a missing check into ring_buffer_producer_thread()
between setting TASK_INTERRUPTIBLE and calling schedule_timeout().
Otherwise, we might miss a wakeup from kthread_stop().

Signed-off-by: Petr Mladek <pmladek@suse.com>
---
 kernel/trace/ring_buffer_benchmark.c | 54 +++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 25 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index 045e0a24c2a0..d1bfe4399e96 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -60,12 +60,12 @@ MODULE_PARM_DESC(consumer_fifo, "fifo prio for consumer");
 
 static int read_events;
 
-static int kill_test;
+static int test_error;
 
-#define KILL_TEST()				\
+#define TEST_ERROR()				\
 	do {					\
-		if (!kill_test) {		\
-			kill_test = 1;		\
+		if (!test_error) {		\
+			test_error = 1;		\
 			WARN_ON(1);		\
 		}				\
 	} while (0)
@@ -75,6 +75,11 @@ enum event_status {
 	EVENT_DROPPED,
 };
 
+static bool break_test(void)
+{
+	return test_error || kthread_should_stop();
+}
+
 static enum event_status read_event(int cpu)
 {
 	struct ring_buffer_event *event;
@@ -87,7 +92,7 @@ static enum event_status read_event(int cpu)
 
 	entry = ring_buffer_event_data(event);
 	if (*entry != cpu) {
-		KILL_TEST();
+		TEST_ERROR();
 		return EVENT_DROPPED;
 	}
 
@@ -115,10 +120,10 @@ static enum event_status read_page(int cpu)
 		rpage = bpage;
 		/* The commit may have missed event flags set, clear them */
 		commit = local_read(&rpage->commit) & 0xfffff;
-		for (i = 0; i < commit && !kill_test; i += inc) {
+		for (i = 0; i < commit && !test_error ; i += inc) {
 
 			if (i >= (PAGE_SIZE - offsetof(struct rb_page, data))) {
-				KILL_TEST();
+				TEST_ERROR();
 				break;
 			}
 
@@ -128,7 +133,7 @@ static enum event_status read_page(int cpu)
 			case RINGBUF_TYPE_PADDING:
 				/* failed writes may be discarded events */
 				if (!event->time_delta)
-					KILL_TEST();
+					TEST_ERROR();
 				inc = event->array[0] + 4;
 				break;
 			case RINGBUF_TYPE_TIME_EXTEND:
@@ -137,12 +142,12 @@ static enum event_status read_page(int cpu)
 			case 0:
 				entry = ring_buffer_event_data(event);
 				if (*entry != cpu) {
-					KILL_TEST();
+					TEST_ERROR();
 					break;
 				}
 				read++;
 				if (!event->array[0]) {
-					KILL_TEST();
+					TEST_ERROR();
 					break;
 				}
 				inc = event->array[0] + 4;
@@ -150,17 +155,17 @@ static enum event_status read_page(int cpu)
 			default:
 				entry = ring_buffer_event_data(event);
 				if (*entry != cpu) {
-					KILL_TEST();
+					TEST_ERROR();
 					break;
 				}
 				read++;
 				inc = ((event->type_len + 1) * 4);
 			}
-			if (kill_test)
+			if (test_error)
 				break;
 
 			if (inc <= 0) {
-				KILL_TEST();
+				TEST_ERROR();
 				break;
 			}
 		}
@@ -185,7 +190,7 @@ static void ring_buffer_consumer(void)
 	while (!READ_ONCE(reader_finish)) {
 		int found = 1;
 
-		while (found && !kill_test) {
+		while (found && !test_error) {
 			int cpu;
 
 			found = 0;
@@ -197,7 +202,7 @@ static void ring_buffer_consumer(void)
 				else
 					stat = read_page(cpu);
 
-				if (kill_test)
+				if (test_error)
 					break;
 
 				if (stat == EVENT_FOUND)
@@ -279,10 +284,7 @@ static void ring_buffer_producer(void)
 		if (cnt % wakeup_interval)
 			cond_resched();
 #endif
-		if (kthread_should_stop())
-			kill_test = 1;
-
-	} while (ktime_before(end_time, timeout) && !kill_test);
+	} while (ktime_before(end_time, timeout) && !break_test());
 	trace_printk("End ring buffer hammer\n");
 
 	if (consumer) {
@@ -303,7 +305,7 @@ static void ring_buffer_producer(void)
 	entries = ring_buffer_entries(buffer);
 	overruns = ring_buffer_overruns(buffer);
 
-	if (kill_test && !kthread_should_stop())
+	if (test_error)
 		trace_printk("ERROR!\n");
 
 	if (!disable_reader) {
@@ -384,15 +386,14 @@ static void wait_to_die(void)
 
 static int ring_buffer_consumer_thread(void *arg)
 {
-	while (!kthread_should_stop() && !kill_test) {
+	while (!break_test()) {
 		complete(&read_start);
 
 		ring_buffer_consumer();
 
 		set_current_state(TASK_INTERRUPTIBLE);
-		if (kthread_should_stop() || kill_test)
+		if (break_test())
 			break;
-
 		schedule();
 	}
 	__set_current_state(TASK_RUNNING);
@@ -405,7 +406,7 @@ static int ring_buffer_consumer_thread(void *arg)
 
 static int ring_buffer_producer_thread(void *arg)
 {
-	while (!kthread_should_stop() && !kill_test) {
+	while (!break_test()) {
 		ring_buffer_reset(buffer);
 
 		if (consumer) {
@@ -414,15 +415,18 @@ static int ring_buffer_producer_thread(void *arg)
 		}
 
 		ring_buffer_producer();
-		if (kill_test)
+		if (break_test())
 			goto out_kill;
 
 		trace_printk("Sleeping for 10 secs\n");
 		set_current_state(TASK_INTERRUPTIBLE);
+		if (break_test())
+			goto out_kill;
 		schedule_timeout(HZ * SLEEP_TIME);
 	}
 
 out_kill:
+	__set_current_state(TASK_RUNNING);
 	if (!kthread_should_stop())
 		wait_to_die();
 
-- 
1.8.5.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

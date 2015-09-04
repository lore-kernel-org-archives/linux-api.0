From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Subject: Re: [RFC PATCH 09/14] ring_buffer: Initialize completions statically
 in the benchmark
Date: Fri, 4 Sep 2015 11:31:26 +0200
Message-ID: <20150904093126.GH22739@pathway.suse.cz>
References: <1438094371-8326-1-git-send-email-pmladek@suse.com>
 <1438094371-8326-10-git-send-email-pmladek@suse.com>
 <20150803143109.0b13925b@gandalf.local.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150803143109.0b13925b-f9ZlEuEWxVcJvu8Pb33WZ0EMvNT87kid@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, live-patching-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Mon 2015-08-03 14:31:09, Steven Rostedt wrote:
> On Tue, 28 Jul 2015 16:39:26 +0200
> Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org> wrote:
> 
> > It looks strange to initialize the completions repeatedly.
> > 
> > This patch uses static initialization. It simplifies the code
> > and even helps to get rid of two memory barriers.
> 
> There was a reason I did it this way and did not use static
> initializers. But I can't recall why I did that. :-/
> 
> I'll have to think about this some more.

Heh, the parallel programming is a real fun. I tried to understand
the code in more details and sometimes felt like Duane Dibbley.

Anyway, I found few possible races related to the completions.
One scenario was opened by my previous fix b44754d8262d3aab8429
("ring_buffer: Allow to exit the ring buffer benchmark immediately")

The races can be fixed by the patch below. I still do not see any
scenario where the extra initialization of the two completions
is needed but I am not brave enough to remove it after all ;-)


>From ad75428b1e5e5127bf7dc6062f880ece11dbdbbf Mon Sep 17 00:00:00 2001
From: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
Date: Fri, 28 Aug 2015 15:59:00 +0200
Subject: [PATCH 1/2] ring_buffer: Do no not complete benchmark reader too
 early

It seems that complete(&read_done) might be called too early
in some situations.

1st scenario:
-------------

CPU0					CPU1

ring_buffer_producer_thread()
  wake_up_process(consumer);
  wait_for_completion(&read_start);

					ring_buffer_consumer_thread()
					  complete(&read_start);

  ring_buffer_producer()
    # producing data in
    # the do-while cycle

					  ring_buffer_consumer();
					    # reading data
					    # got error
					    # set kill_test = 1;
					    set_current_state(
						TASK_INTERRUPTIBLE);
					    if (reader_finish)  # false
					    schedule();

    # producer still in the middle of
    # do-while cycle
    if (consumer && !(cnt % wakeup_interval))
      wake_up_process(consumer);

					    # spurious wakeup
					    while (!reader_finish &&
						   !kill_test)
					    # leaving because
					    # kill_test == 1
					    reader_finish = 0;
					    complete(&read_done);

1st BANG: We might access uninitialized "read_done" if this is the
	  the first round.

    # producer finally leaving
    # the do-while cycle because kill_test == 1;

    if (consumer) {
      reader_finish = 1;
      wake_up_process(consumer);
      wait_for_completion(&read_done);

2nd BANG: This will never complete because consumer already did
	  the completion.

2nd scenario:
-------------

CPU0					CPU1

ring_buffer_producer_thread()
  wake_up_process(consumer);
  wait_for_completion(&read_start);

					ring_buffer_consumer_thread()
					  complete(&read_start);

  ring_buffer_producer()
    # CPU3 removes the module	  <--- difference from
    # and stops producer          <--- the 1st scenario
    if (kthread_should_stop())
      kill_test = 1;

					  ring_buffer_consumer();
					    while (!reader_finish &&
						   !kill_test)
					    # kill_test == 1 => we never go
					    # into the top level while()
					    reader_finish = 0;
					    complete(&read_done);

    # producer still in the middle of
    # do-while cycle
    if (consumer && !(cnt % wakeup_interval))
      wake_up_process(consumer);

					    # spurious wakeup
					    while (!reader_finish &&
						   !kill_test)
					    # leaving because kill_test == 1
					    reader_finish = 0;
					    complete(&read_done);

BANG: We are in the same "bang" situations as in the 1st scenario.

Root of the problem:
--------------------

ring_buffer_consumer() must complete "read_done" only when "reader_finish"
variable is set. It must not be skipped because of other conditions.

Note that we still must keep the check for "reader_finish" in a loop
because there might be the spurious wakeup as described in the
above scenarios..

Solution:
----------

The top level cycle in ring_buffer_consumer() will finish only when
"reader_finish" is set. The data will be read in "while-do" cycle
so that they are not read after an error (kill_test == 1) and
the spurious wake up.

In addition, "reader_finish" is manipulated by the producer thread.
Therefore we add READ_ONCE() to make sure that the fresh value is
read in each cycle. Also we add the corresponding barrier
to synchronize the sleep check.

Next we set back TASK_RUNNING state for the situation when we
did not sleep.

Just from paranoid reasons, we initialize both completions statically.
It should be more safe if there is other race that we do not know of.

As a side effect we could remove the memory barrier from
ring_buffer_producer_thread(). IMHO, this was the reason of
the barrier. ring_buffer_reset() uses spin locks that should
provide the needed memory barrier for using the buffer.

Signed-off-by: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>
---
 kernel/trace/ring_buffer_benchmark.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ring_buffer_benchmark.c b/kernel/trace/ring_buffer_benchmark.c
index a1503a027ee2..045e0a24c2a0 100644
--- a/kernel/trace/ring_buffer_benchmark.c
+++ b/kernel/trace/ring_buffer_benchmark.c
@@ -24,8 +24,8 @@ struct rb_page {
 static int wakeup_interval = 100;
 
 static int reader_finish;
-static struct completion read_start;
-static struct completion read_done;
+static DECLARE_COMPLETION(read_start);
+static DECLARE_COMPLETION(read_done);
 
 static struct ring_buffer *buffer;
 static struct task_struct *producer;
@@ -178,10 +178,14 @@ static void ring_buffer_consumer(void)
 	read_events ^= 1;
 
 	read = 0;
-	while (!reader_finish && !kill_test) {
-		int found;
+	/*
+	 * Always wait until we are asked to finish and the producer
+	 * is ready to wait for the completion.
+	 */
+	while (!READ_ONCE(reader_finish)) {
+		int found = 1;
 
-		do {
+		while (found && !kill_test) {
 			int cpu;
 
 			found = 0;
@@ -195,17 +199,29 @@ static void ring_buffer_consumer(void)
 
 				if (kill_test)
 					break;
+
 				if (stat == EVENT_FOUND)
 					found = 1;
+
 			}
-		} while (found && !kill_test);
+		}
 
+		/*
+		 * Sleep a bit. Producer with wake up us when some more data
+		 * are available or when we should finish reading.
+		 */
 		set_current_state(TASK_INTERRUPTIBLE);
+		/*
+		 * Make sure that we read the updated finish variable
+		 * before producer tries to wakeup us.
+		 */
+		smp_rmb();
 		if (reader_finish)
 			break;
 
 		schedule();
 	}
+	__set_current_state(TASK_RUNNING);
 	reader_finish = 0;
 	complete(&read_done);
 }
@@ -389,13 +405,10 @@ static int ring_buffer_consumer_thread(void *arg)
 
 static int ring_buffer_producer_thread(void *arg)
 {
-	init_completion(&read_start);
-
 	while (!kthread_should_stop() && !kill_test) {
 		ring_buffer_reset(buffer);
 
 		if (consumer) {
-			smp_wmb();
 			wake_up_process(consumer);
 			wait_for_completion(&read_start);
 		}
-- 
1.8.5.6

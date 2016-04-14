From: Petr Mladek <pmladek@suse.com>
Subject: [PATCH v6 17/20] memstick/r592: Better synchronize debug messages in r592_io kthread
Date: Thu, 14 Apr 2016 17:14:36 +0200
Message-ID: <1460646879-617-18-git-send-email-pmladek@suse.com>
References: <1460646879-617-1-git-send-email-pmladek@suse.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1460646879-617-1-git-send-email-pmladek@suse.com>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>, Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>, Borislav Petkov <bp@suse.de>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, Petr Mladek <pmladek@suse.com>, Maxim Levitsky <maximlevitsky@gmail.com>
List-Id: linux-api@vger.kernel.org

There is an attempt to print debug messages when the kthread is waken
and when it goes into sleep. It does not work well because the spin lock
does not guard all manipulations with the thread state.

I did not find a way how to print a message when the kthread really
goes into sleep. Instead, I added a state variable. It clearly marks
when a series of IO requests is started and finished. It makes sure
that we always have a pair of started/done messages.

The only problem is that it will print these messages also when
the kthread is created and there is no real work. We might want
to use create_kthread() instead of run_kthread(). Then the kthread
will stay stopped until the first request.

Important: This change is only compile tested. I did not find an easy
way how to test it. This is why I was conservative and did not modify
the kthread creation.

Signed-off-by: Petr Mladek <pmladek@suse.com>
CC: Maxim Levitsky <maximlevitsky@gmail.com>
---
 drivers/memstick/host/r592.c | 19 +++++++++----------
 drivers/memstick/host/r592.h |  2 +-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/memstick/host/r592.c b/drivers/memstick/host/r592.c
index d5cfb503b9d6..7d29d6549110 100644
--- a/drivers/memstick/host/r592.c
+++ b/drivers/memstick/host/r592.c
@@ -567,21 +567,24 @@ static int r592_process_thread(void *data)
 {
 	int error;
 	struct r592_device *dev = (struct r592_device *)data;
-	unsigned long flags;
 
 	while (!kthread_should_stop()) {
-		spin_lock_irqsave(&dev->io_thread_lock, flags);
+		if (!dev->io_started) {
+			dbg_verbose("IO: started");
+			dev->io_started = true;
+		}
+
 		set_current_state(TASK_INTERRUPTIBLE);
 		error = memstick_next_req(dev->host, &dev->req);
-		spin_unlock_irqrestore(&dev->io_thread_lock, flags);
 
 		if (error) {
 			if (error == -ENXIO || error == -EAGAIN) {
-				dbg_verbose("IO: done IO, sleeping");
+				dbg_verbose("IO: done");
 			} else {
 				dbg("IO: unknown error from "
 					"memstick_next_req %d", error);
 			}
+			dev->io_started = false;
 
 			if (kthread_should_stop())
 				set_current_state(TASK_RUNNING);
@@ -713,15 +716,11 @@ static int r592_set_param(struct memstick_host *host,
 static void r592_submit_req(struct memstick_host *host)
 {
 	struct r592_device *dev = memstick_priv(host);
-	unsigned long flags;
 
 	if (dev->req)
 		return;
 
-	spin_lock_irqsave(&dev->io_thread_lock, flags);
-	if (wake_up_process(dev->io_thread))
-		dbg_verbose("IO thread woken to process requests");
-	spin_unlock_irqrestore(&dev->io_thread_lock, flags);
+	wake_up_process(dev->io_thread);
 }
 
 static const struct pci_device_id r592_pci_id_tbl[] = {
@@ -767,7 +766,6 @@ static int r592_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	dev->irq = pdev->irq;
 	spin_lock_init(&dev->irq_lock);
-	spin_lock_init(&dev->io_thread_lock);
 	init_completion(&dev->dma_done);
 	INIT_KFIFO(dev->pio_fifo);
 	setup_timer(&dev->detect_timer,
@@ -779,6 +777,7 @@ static int r592_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	host->set_param = r592_set_param;
 	r592_check_dma(dev);
 
+	dev->io_started = false;
 	dev->io_thread = kthread_run(r592_process_thread, dev, "r592_io");
 	if (IS_ERR(dev->io_thread)) {
 		error = PTR_ERR(dev->io_thread);
diff --git a/drivers/memstick/host/r592.h b/drivers/memstick/host/r592.h
index c5726c1e8832..aa8f0f22f4ce 100644
--- a/drivers/memstick/host/r592.h
+++ b/drivers/memstick/host/r592.h
@@ -137,10 +137,10 @@ struct r592_device {
 	void __iomem *mmio;
 	int irq;
 	spinlock_t irq_lock;
-	spinlock_t io_thread_lock;
 	struct timer_list detect_timer;
 
 	struct task_struct *io_thread;
+	bool io_started;
 	bool parallel_mode;
 
 	DECLARE_KFIFO(pio_fifo, u8, sizeof(u32));
-- 
1.8.5.6

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

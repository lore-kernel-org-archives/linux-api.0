From: Davidlohr Bueso <dave@stgolabs.net>
Subject: Re: [PATCH 2/4] swait: add the missing killable swaits
Date: Tue, 4 Jul 2017 19:06:35 -0700
Message-ID: <20170705020635.GD11168@linux-80c1.suse>
References: <20170614222017.14653-1-mcgrof@kernel.org>
 <20170614222017.14653-3-mcgrof@kernel.org>
 <20170629125402.GH26046@kroah.com>
 <alpine.DEB.2.20.1706291504570.1861@nanos>
 <20170629133530.GA14747@kroah.com>
 <alpine.DEB.2.20.1706291545320.1861@nanos>
 <CA+55aFxkp51RipBj7__T0hoy6tAdXJxTqjMdhnnnkKm71P6HuQ@mail.gmail.com>
 <20170629174046.GC3954@linux-80c1.suse>
 <CA+55aFz=6XmH5MfwKLN6MZSyG8fAk-aD67mbDc1ZaKySzsq8aw@mail.gmail.com>
 <20170629183339.GD3954@linux-80c1.suse>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170629183339.GD3954@linux-80c1.suse>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg KH <gregkh@linuxfoundation.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, mfuzzey@parkeon.com, "Eric W. Biederman" <ebiederm@xmission.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Daniel Wagner <wagi@monom.org>, David Woodhouse <dwmw2@infradead.org>, jewalt@lgsinnovations.com, rafal@milecki.pl, Arend Van Spriel <arend.vanspriel@broadcom.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, "Li, Yi" <yi1.li@linux.intel.com>, atull@kernel.org, Moritz Fischer <moritz.fischer@ettus.com>, Petr Mladek <pmladek@suse.com>, Johannes Berg <johannes.berg@intel.com>, Emmanuel Grumbach <emmanuel.grumbach@intel.com>, "Coelho, Luciano" <luciano.coelho@intel.com>, Kalle Valo <kvalo@codeaurora.org>, Andrew Lutomirski <luto@ker>
List-Id: linux-api@vger.kernel.org

On Thu, 29 Jun 2017, Davidlohr Bueso wrote:

>I'll actually take a look at wake_q for wake_up_all() and co. to see if
>we can reduce the spinlock hold times. Of course it would only make sense
>for more than a one wakeup.

So here's something that boots and builds a kernel. Any thoughts?

Thanks,
Davidlohr

----------8<----------------------------------------------
From: Davidlohr Bueso <dave@stgolabs.net>
Subject: [PATCH] sched/wait: Perform lockless wake_up_all()

The use of wake_qs have proven a solid option for performing
wakeups without holding the corresponding lock -- to the extent
that many core subsystems use them. We can make use of wake_qs
in waitqueue wakeups. There are a few constraints, nonetheless,
that limit the usage to _only_ wake_up_all():

(i) We cannot use them in exclusive wakes as wake_qs do not
provide a way to acknowledge a successful wakeup vs when the
task is already running. Therefore any node skipping cannot
be determined.

(ii) Lockless wakeups are only under TASK_NORMAL wakeups, and
therefore cannot be used by wake_up_all_interruptible(). For
minimal overhead, wake_q does not understand queues with mixed
states.

Similar changes in the past have shown measurable performance
improvements and more bounded latencies in benchmarks where
threads are contending for the lock. Ie: futex_wake(N) via
mark_wait_futex(), or rwsem waiter wakeups.

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 include/linux/wait.h | 37 +++++++++++++++++++++++++------------
 kernel/sched/wait.c  | 36 ++++++++++++++++++++++++++++++++++++
 2 files changed, 61 insertions(+), 12 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index b289c96151ee..9f6075271e52 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -12,8 +12,10 @@
 
 typedef struct wait_queue_entry wait_queue_entry_t;
 
-typedef int (*wait_queue_func_t)(struct wait_queue_entry *wq_entry, unsigned mode, int flags, void *key);
-int default_wake_function(struct wait_queue_entry *wq_entry, unsigned mode, int flags, void *key);
+typedef int (*wait_queue_func_t)(struct wait_queue_entry *wq_entry,
+				 unsigned mode, int flags, void *key);
+int default_wake_function(struct wait_queue_entry *wq_entry,
+			  unsigned mode, int flags, void *key);
 
 /* wait_queue_entry::flags */
 #define WQ_FLAG_EXCLUSIVE	0x01
@@ -56,7 +58,8 @@ struct task_struct;
 #define DECLARE_WAIT_QUEUE_HEAD(name) \
 	struct wait_queue_head name = __WAIT_QUEUE_HEAD_INITIALIZER(name)
 
-extern void __init_waitqueue_head(struct wait_queue_head *wq_head, const char *name, struct lock_class_key *);
+extern void __init_waitqueue_head(struct wait_queue_head *wq_head,
+				  const char *name, struct lock_class_key *);
 
 #define init_waitqueue_head(wq_head)						\
 	do {									\
@@ -158,39 +161,49 @@ static inline void __add_wait_queue(struct wait_queue_head *wq_head, struct wait
  * Used for wake-one threads:
  */
 static inline void
-__add_wait_queue_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
+__add_wait_queue_exclusive(struct wait_queue_head *wq_head,
+			   struct wait_queue_entry *wq_entry)
 {
 	wq_entry->flags |= WQ_FLAG_EXCLUSIVE;
 	__add_wait_queue(wq_head, wq_entry);
 }
 
-static inline void __add_wait_queue_entry_tail(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
+static inline void
+__add_wait_queue_entry_tail(struct wait_queue_head *wq_head,
+			    struct wait_queue_entry *wq_entry)
 {
 	list_add_tail(&wq_entry->entry, &wq_head->head);
 }
 
 static inline void
-__add_wait_queue_entry_tail_exclusive(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
+__add_wait_queue_entry_tail_exclusive(struct wait_queue_head *wq_head,
+				      struct wait_queue_entry *wq_entry)
 {
 	wq_entry->flags |= WQ_FLAG_EXCLUSIVE;
 	__add_wait_queue_entry_tail(wq_head, wq_entry);
 }
 
 static inline void
-__remove_wait_queue(struct wait_queue_head *wq_head, struct wait_queue_entry *wq_entry)
+__remove_wait_queue(struct wait_queue_head *wq_head,
+		    struct wait_queue_entry *wq_entry)
 {
 	list_del(&wq_entry->entry);
 }
 
-void __wake_up(struct wait_queue_head *wq_head, unsigned int mode, int nr, void *key);
-void __wake_up_locked_key(struct wait_queue_head *wq_head, unsigned int mode, void *key);
-void __wake_up_sync_key(struct wait_queue_head *wq_head, unsigned int mode, int nr, void *key);
-void __wake_up_locked(struct wait_queue_head *wq_head, unsigned int mode, int nr);
+void __wake_up(struct wait_queue_head *wq_head,
+	       unsigned int mode, int nr, void *key);
+void __wake_up_all_lockless(struct wait_queue_head *wq_head);
+void __wake_up_locked_key(struct wait_queue_head *wq_head,
+			  unsigned int mode, void *key);
+void __wake_up_sync_key(struct wait_queue_head *wq_head,
+			unsigned int mode, int nr, void *key);
+void __wake_up_locked(struct wait_queue_head *wq_head,
+		      unsigned int mode, int nr);
 void __wake_up_sync(struct wait_queue_head *wq_head, unsigned int mode, int nr);
 
 #define wake_up(x)			__wake_up(x, TASK_NORMAL, 1, NULL)
 #define wake_up_nr(x, nr)		__wake_up(x, TASK_NORMAL, nr, NULL)
-#define wake_up_all(x)			__wake_up(x, TASK_NORMAL, 0, NULL)
+#define wake_up_all(x)			__wake_up_all_lockless(x)
 #define wake_up_locked(x)		__wake_up_locked((x), TASK_NORMAL, 1)
 #define wake_up_all_locked(x)		__wake_up_locked((x), TASK_NORMAL, 0)
 
diff --git a/kernel/sched/wait.c b/kernel/sched/wait.c
index 17f11c6b0a9f..d029e13529ed 100644
--- a/kernel/sched/wait.c
+++ b/kernel/sched/wait.c
@@ -5,6 +5,7 @@
  */
 #include <linux/init.h>
 #include <linux/export.h>
+#include <linux/sched/wake_q.h>
 #include <linux/sched/signal.h>
 #include <linux/sched/debug.h>
 #include <linux/mm.h>
@@ -98,6 +99,41 @@ void __wake_up(struct wait_queue_head *wq_head, unsigned int mode,
 }
 EXPORT_SYMBOL(__wake_up);
 
+/**
+ * __wake_up_all_lockless - wake up all threads blocked on a waitqueue, with
+ *                          assistance from wake_qs.
+ * @wq_head: the waitqueue
+ *
+ * Using lockless wake_qs allows the wakeups to occur after releasing the
+ * @wq_head->lock, thus reducing hold times. As such, it only makes sense
+ * when there is more than a single wakeup to be performed, otherwise it's
+ * not really worth it. Similarly, this can only be used for TASK_NORMAL
+ * wakeups, such that we avoid queues with mixed states.
+ *
+ * It may be assumed that unlike __wake_up() this function always implies
+ * a memory barrier before changing the task state due to wake_q_add(),
+ * regardless of whether or not the task was actually running.
+ */
+void __wake_up_all_lockless(struct wait_queue_head *wq_head)
+{
+	unsigned long flags;
+	wait_queue_entry_t *curr, *next;
+	DEFINE_WAKE_Q(wake_q);
+
+	spin_lock_irqsave(&wq_head->lock, flags);
+	/*
+	 * Because we are to awake all tasks, we don't care about
+	 * dealing with WQ_FLAG_EXCLUSIVE cases.
+	 */
+	list_for_each_entry_safe(curr, next, &wq_head->head, entry)
+		wake_q_add(&wake_q, curr->private);
+
+	spin_unlock_irqrestore(&wq_head->lock, flags);
+
+	wake_up_q(&wake_q);
+}
+EXPORT_SYMBOL(__wake_up_all_lockless);
+
 /*
  * Same as __wake_up but called with the spinlock in wait_queue_head_t held.
  */
-- 
2.12.0

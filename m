From: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH 1/3] posix timers: Allocate timer id per process (v2)
Date: Thu, 21 Feb 2013 22:22:25 +0400
Message-ID: <512665E1.4040800@parallels.com>
References: <512665BA.9040802@parallels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <512665BA.9040802-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matthew Helsley <matt.helsley-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Patch replaces global idr with global hash table for posix timers and
makes timer ids unique not globally, but per process. Next free timer id is
type of integer and stored on signal struct (posix_timer_id). If free timer
id reaches negative value on timer creation, it will be dropped to zero and
-EAGAIN will be returned to user.

Hash table has 512 slots.
Key is constructed as follows:
key = hash_32(hash_32(current->signal) ^ posix_timer_id));

Note: with this patch, id, returned to user, is not the minimal free
amymore. It means, that id, returned to user space in loop, listed below,
will be increasing on each iteration till INT_MAX and then dropped to zero:

while(1) {
	id = timer_create(...);
	timer_delete(id);
}

In this version the helpers from include/linux/hashtable.h are used
instead of hand-made hash-table.

Signed-off-by: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
---
 include/linux/posix-timers.h |    1 +
 include/linux/sched.h        |    3 +-
 kernel/posix-timers.c        |  108 +++++++++++++++++++++++++++---------------
 3 files changed, 72 insertions(+), 40 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 042058f..60bac69 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -55,6 +55,7 @@ struct cpu_timer_list {
 /* POSIX.1b interval timer structure. */
 struct k_itimer {
 	struct list_head list;		/* free/ allocate list */
+	struct hlist_node t_hash;
 	spinlock_t it_lock;
 	clockid_t it_clock;		/* which timer type */
 	timer_t it_id;			/* timer id */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d211247..d0d9a8b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -561,7 +561,8 @@ struct signal_struct {
 	unsigned int		has_child_subreaper:1;
 
 	/* POSIX.1b Interval Timers */
-	struct list_head posix_timers;
+	int			posix_timer_id;
+	struct list_head	posix_timers;
 
 	/* ITIMER_REAL timer for the process */
 	struct hrtimer real_timer;
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 69185ae..4f3a18a 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -40,38 +40,31 @@
 #include <linux/list.h>
 #include <linux/init.h>
 #include <linux/compiler.h>
-#include <linux/idr.h>
+#include <linux/hash.h>
 #include <linux/posix-clock.h>
 #include <linux/posix-timers.h>
 #include <linux/syscalls.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/export.h>
+#include <linux/hashtable.h>
 
 /*
- * Management arrays for POSIX timers.	 Timers are kept in slab memory
- * Timer ids are allocated by an external routine that keeps track of the
- * id and the timer.  The external interface is:
- *
- * void *idr_find(struct idr *idp, int id);           to find timer_id <id>
- * int idr_get_new(struct idr *idp, void *ptr);       to get a new id and
- *                                                    related it to <ptr>
- * void idr_remove(struct idr *idp, int id);          to release <id>
- * void idr_init(struct idr *idp);                    to initialize <idp>
- *                                                    which we supply.
- * The idr_get_new *may* call slab for more memory so it must not be
- * called under a spin lock.  Likewise idr_remore may release memory
- * (but it may be ok to do this under a lock...).
- * idr_find is just a memory look up and is quite fast.  A -1 return
- * indicates that the requested id does not exist.
+ * Management arrays for POSIX timers. Timers are now kept in static hash table
+ * with 512 entries.
+ * Timer ids are allocated by local routine, which selects proper hash head by
+ * key, constructed from current->signal address and per signal struct counter.
+ * This keeps timer ids unique per process, but now they can intersect between
+ * processes.
  */
 
 /*
  * Lets keep our timers in a slab cache :-)
  */
 static struct kmem_cache *posix_timers_cache;
-static struct idr posix_timers_id;
-static DEFINE_SPINLOCK(idr_lock);
+
+static DEFINE_HASHTABLE(posix_timers_hashtable, 9);
+static DEFINE_SPINLOCK(hash_lock);
 
 /*
  * we assume that the new SIGEV_THREAD_ID shares no bits with the other
@@ -152,6 +145,57 @@ static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags);
 	__timr;								   \
 })
 
+static int hash(struct signal_struct *sig, unsigned int nr)
+{
+	return hash_32(hash32_ptr(sig) ^ nr, HASH_BITS(posix_timers_hashtable));
+}
+
+static struct k_itimer *__posix_timers_find(struct hlist_head *head,
+					    struct signal_struct *sig,
+					    timer_t id)
+{
+	struct hlist_node *node;
+	struct k_itimer *timer;
+
+	hlist_for_each_entry_rcu(timer, node, head, t_hash) {
+		if ((timer->it_signal == sig) && (timer->it_id == id))
+			return timer;
+	}
+	return NULL;
+}
+
+static struct k_itimer *posix_timer_by_id(timer_t id)
+{
+	struct signal_struct *sig = current->signal;
+	struct hlist_head *head = &posix_timers_hashtable[hash(sig, id)];
+
+	return __posix_timers_find(head, sig, id);
+}
+
+static int posix_timer_add(struct k_itimer *timer)
+{
+	struct signal_struct *sig = current->signal;
+	int first_free_id = sig->posix_timer_id;
+	struct hlist_head *head;
+	int ret = -ENOENT;
+
+	do {
+		spin_lock(&hash_lock);
+		head = &posix_timers_hashtable[hash(sig, sig->posix_timer_id)];
+		if (!__posix_timers_find(head, sig, sig->posix_timer_id)) {
+			hlist_add_head_rcu(&timer->t_hash, head);
+			ret = sig->posix_timer_id;
+		}
+		if (++sig->posix_timer_id < 0)
+			sig->posix_timer_id = 0;
+		if ((sig->posix_timer_id == first_free_id) && (ret == -ENOENT))
+			/* Loop over all possible ids completed */
+			ret = -EAGAIN;
+		spin_unlock(&hash_lock);
+	} while (ret == -ENOENT);
+	return ret;
+}
+
 static inline void unlock_timer(struct k_itimer *timr, unsigned long flags)
 {
 	spin_unlock_irqrestore(&timr->it_lock, flags);
@@ -282,7 +326,6 @@ static __init int init_posix_timers(void)
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
 					NULL);
-	idr_init(&posix_timers_id);
 	return 0;
 }
 
@@ -504,9 +547,9 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 {
 	if (it_id_set) {
 		unsigned long flags;
-		spin_lock_irqsave(&idr_lock, flags);
-		idr_remove(&posix_timers_id, tmr->it_id);
-		spin_unlock_irqrestore(&idr_lock, flags);
+		spin_lock_irqsave(&hash_lock, flags);
+		hlist_del_rcu(&tmr->t_hash);
+		spin_unlock_irqrestore(&hash_lock, flags);
 	}
 	put_pid(tmr->it_pid);
 	sigqueue_free(tmr->sigq);
@@ -552,22 +595,9 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 		return -EAGAIN;
 
 	spin_lock_init(&new_timer->it_lock);
- retry:
-	if (unlikely(!idr_pre_get(&posix_timers_id, GFP_KERNEL))) {
-		error = -EAGAIN;
-		goto out;
-	}
-	spin_lock_irq(&idr_lock);
-	error = idr_get_new(&posix_timers_id, new_timer, &new_timer_id);
-	spin_unlock_irq(&idr_lock);
-	if (error) {
-		if (error == -EAGAIN)
-			goto retry;
-		/*
-		 * Weird looking, but we return EAGAIN if the IDR is
-		 * full (proper POSIX return value for this)
-		 */
-		error = -EAGAIN;
+	new_timer_id = posix_timer_add(new_timer);
+	if (new_timer_id < 0) {
+		error = new_timer_id;
 		goto out;
 	}
 
@@ -640,7 +670,7 @@ static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
 	struct k_itimer *timr;
 
 	rcu_read_lock();
-	timr = idr_find(&posix_timers_id, (int)timer_id);
+	timr = posix_timer_by_id(timer_id);
 	if (timr) {
 		spin_lock_irqsave(&timr->it_lock, *flags);
 		if (timr->it_signal == current->signal) {
-- 
1.7.6.5

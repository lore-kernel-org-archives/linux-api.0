From: Joe Korty <joe.korty@ccur.com>
Subject: [PATCH] Display active jiffie timers in /proc/timer_list, v2
Date: Wed, 26 Nov 2008 11:48:45 -0500
Message-ID: <20081126164845.GA17394@tsunami.ccur.com>
References: <20081121221113.GA13566@tsunami.ccur.com> <517f3f820811250806n33850ea8ua8e203347c0f7ba6@mail.gmail.com> <20081125185740.GA21806@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754754AbYKZQtW@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081125185740.GA21806@tsunami.ccur.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, Linux API <linux-api@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Add an 'active jiffie timers' subdisplay to /proc/timer_list, v2.

Version 1-to-2 features: 
  1) Version 1 created display code moved from
  kernel/timer.c to kernel/time/timer_list.c.  To support
  this, kernel/timer.c internals were moved to a new header
  file, timer-internals.h, which is now included by both
  of the above .c files.

  2) No longer locks a cpus' timer wheel for the entire
  duration of the printing of that wheel's timers; we now
  instead grab and release the lock on a per timer wheel
  slot basis.  Refinements: we don't grab the lock at all
  for those slots which are obviously empty (which will be
  most of them most of the time), and we have pushed out
  the actual printing of the timers past the point where
  the lock is dropped.

  3) Version 1 hex displays changed to decimal, to match
  the style of the other /proc/timer_list output.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.28-rc6/kernel/timer.c
===================================================================
--- 2.6.28-rc6.orig/kernel/timer.c	2008-11-26 10:26:22.000000000 -0500
+++ 2.6.28-rc6/kernel/timer.c	2008-11-26 10:26:23.000000000 -0500
@@ -44,73 +44,16 @@
 #include <asm/timex.h>
 #include <asm/io.h>
 
+#include <linux/timer-internals.h>
+
 u64 jiffies_64 __cacheline_aligned_in_smp = INITIAL_JIFFIES;
 
 EXPORT_SYMBOL(jiffies_64);
 
-/*
- * per-CPU timer vector definitions:
- */
-#define TVN_BITS (CONFIG_BASE_SMALL ? 4 : 6)
-#define TVR_BITS (CONFIG_BASE_SMALL ? 6 : 8)
-#define TVN_SIZE (1 << TVN_BITS)
-#define TVR_SIZE (1 << TVR_BITS)
-#define TVN_MASK (TVN_SIZE - 1)
-#define TVR_MASK (TVR_SIZE - 1)
-
-struct tvec {
-	struct list_head vec[TVN_SIZE];
-};
-
-struct tvec_root {
-	struct list_head vec[TVR_SIZE];
-};
-
-struct tvec_base {
-	spinlock_t lock;
-	struct timer_list *running_timer;
-	unsigned long timer_jiffies;
-	struct tvec_root tv1;
-	struct tvec tv2;
-	struct tvec tv3;
-	struct tvec tv4;
-	struct tvec tv5;
-} ____cacheline_aligned;
-
 struct tvec_base boot_tvec_bases;
 EXPORT_SYMBOL(boot_tvec_bases);
-static DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;
-
-/*
- * Note that all tvec_bases are 2 byte aligned and lower bit of
- * base in timer_list is guaranteed to be zero. Use the LSB for
- * the new flag to indicate whether the timer is deferrable
- */
-#define TBASE_DEFERRABLE_FLAG		(0x1)
+DEFINE_PER_CPU(struct tvec_base *, tvec_bases) = &boot_tvec_bases;
 
-/* Functions below help us manage 'deferrable' flag */
-static inline unsigned int tbase_get_deferrable(struct tvec_base *base)
-{
-	return ((unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG);
-}
-
-static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
-{
-	return ((struct tvec_base *)((unsigned long)base & ~TBASE_DEFERRABLE_FLAG));
-}
-
-static inline void timer_set_deferrable(struct timer_list *timer)
-{
-	timer->base = ((struct tvec_base *)((unsigned long)(timer->base) |
-				       TBASE_DEFERRABLE_FLAG));
-}
-
-static inline void
-timer_set_base(struct timer_list *timer, struct tvec_base *new_base)
-{
-	timer->base = (struct tvec_base *)((unsigned long)(new_base) |
-				      tbase_get_deferrable(timer->base));
-}
 
 static unsigned long round_jiffies_common(unsigned long j, int cpu,
 		bool force_up)
Index: 2.6.28-rc6/kernel/time/timer_list.c
===================================================================
--- 2.6.28-rc6.orig/kernel/time/timer_list.c	2008-11-26 10:26:22.000000000 -0500
+++ 2.6.28-rc6/kernel/time/timer_list.c	2008-11-26 11:14:19.000000000 -0500
@@ -17,6 +17,9 @@
 #include <linux/seq_file.h>
 #include <linux/kallsyms.h>
 #include <linux/tick.h>
+#include <linux/jiffies.h>
+#include <linux/timer.h>
+#include <linux/timer-internals.h>
 
 #include <asm/uaccess.h>
 
@@ -46,6 +49,109 @@
 		SEQ_printf(m, "%s", symname);
 }
 
+/*
+ * Low resolution (jiffie) timer display support routines.
+ */
+static void print_one_jtimer(struct seq_file *m, struct timer_list *timer)
+{
+	unsigned long base_jiffies = tbase_get_base(timer->base)->timer_jiffies;
+#ifdef CONFIG_TIMER_STATS
+	char tmp[TASK_COMM_LEN + 1];
+#endif
+
+	SEQ_printf(m, " %7lu: ", timer->expires - base_jiffies);
+	print_name_offset(m, timer->function);
+	SEQ_printf(m, " (");
+	print_name_offset(m, (void *)(timer->data));
+	SEQ_printf(m, ")");
+#ifdef CONFIG_TIMER_STATS
+	SEQ_printf(m, " from ");
+	print_name_offset(m, timer->start_site);
+	memcpy(tmp, timer->start_comm, TASK_COMM_LEN);
+	tmp[TASK_COMM_LEN] = 0;
+	SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
+#endif
+	SEQ_printf(m, "\n");
+}
+
+#define MAX_TIMERS_PER_SLOT 32
+
+static void print_one_wheel_slot(struct seq_file *m,
+		struct tvec_base *base, struct list_head *head,
+		struct timer_list *tlist)
+{
+	int i, ntimers, overflow;
+	struct timer_list *t;
+	struct list_head *item;
+	unsigned long flags;
+
+	/*
+	 * Don't grab the lock if this timer wheel slot is known
+	 * to have no timers in it.  This dramatically reduces
+	 * lock/unlock churn, as slots are typically empty.
+	 */
+	if (head->next == head)
+		return;
+
+	/*
+	 * Keep lock ownership to a minimum by _not_ printing out timer
+	 * contents while the lock is held.  This requires snapshotting
+	 * timer contents for post-unlock printing.
+	 */
+	spin_lock_irqsave(&base->lock, flags);
+	for (overflow = ntimers = 0, item = head->next;
+			item != head && ntimers <= MAX_TIMERS_PER_SLOT;
+			item = item->next) {
+		if (ntimers >= MAX_TIMERS_PER_SLOT) {
+			overflow++;
+			continue;
+		}
+		t = list_entry(item, struct timer_list, entry);
+		tlist[ntimers++] = *t;
+	}
+	spin_unlock_irqrestore(&base->lock, flags);
+
+	for (i = 0; i < ntimers; i++)
+		print_one_jtimer(m, &tlist[i]);
+
+	if (overflow)
+		SEQ_printf(m, " *** "
+			"Display table overflow, some timers missed\n");
+}
+
+static void print_cpu_jtimers(struct seq_file *m, int cpu)
+{
+	int i;
+	struct tvec_base *base = per_cpu(tvec_bases, cpu);
+	struct timer_list *tlist;
+
+	SEQ_printf(m, "active jiffie timers:\n");
+	SEQ_printf(m, " base: %p\n", base);
+	SEQ_printf(m, " running_timer: %p\n", base->running_timer);
+	SEQ_printf(m, " timer_jiffies: %lu\n", base->timer_jiffies);
+
+	tlist = kmalloc(sizeof(struct timer_list) * MAX_TIMERS_PER_SLOT,
+				m ? GFP_KERNEL : GFP_ATOMIC);
+	if (!tlist) {
+		SEQ_printf(m, "(Error, could not allocate needed memory.)\n");
+		return;
+	}
+
+	for (i = 0; i < TVR_SIZE; i++)
+		print_one_wheel_slot(m, base, base->tv1.vec + i, tlist);
+	for (i = 0; i < TVN_SIZE; i++) {
+		print_one_wheel_slot(m, base, base->tv2.vec + i, tlist);
+		print_one_wheel_slot(m, base, base->tv3.vec + i, tlist);
+		print_one_wheel_slot(m, base, base->tv4.vec + i, tlist);
+		print_one_wheel_slot(m, base, base->tv5.vec + i, tlist);
+	}
+
+	kfree(tlist);
+}
+
+/*
+ * High res timer display support routines.
+ */
 static void
 print_timer(struct seq_file *m, struct hrtimer *taddr, struct hrtimer *timer,
 	    int idx, u64 now)
@@ -179,6 +285,7 @@
 		SEQ_printf(m, "jiffies: %Lu\n",
 			   (unsigned long long)jiffies);
 	}
+	print_cpu_jtimers(m, cpu);
 #endif
 
 #undef P
@@ -252,7 +359,7 @@
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Timer List Version: v0.4\n");
+	SEQ_printf(m, "Timer List Version: v0.5\n");
 	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
 	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
 
Index: 2.6.28-rc6/include/linux/timer-internals.h
===================================================================
--- /dev/null	1970-01-01 00:00:00.000000000 +0000
+++ 2.6.28-rc6/include/linux/timer-internals.h	2008-11-26 11:13:18.000000000 -0500
@@ -0,0 +1,67 @@
+#ifndef _LINUX_TIMER_INTERNALS_H
+#define _LINUX_TIMER_INTERNALS_H 1
+
+/*
+ * per-CPU timer vector definitions:
+ */
+#define TVN_BITS (CONFIG_BASE_SMALL ? 4 : 6)
+#define TVR_BITS (CONFIG_BASE_SMALL ? 6 : 8)
+#define TVN_SIZE (1 << TVN_BITS)
+#define TVR_SIZE (1 << TVR_BITS)
+#define TVN_MASK (TVN_SIZE - 1)
+#define TVR_MASK (TVR_SIZE - 1)
+
+struct tvec {
+	struct list_head vec[TVN_SIZE];
+};
+
+struct tvec_root {
+	struct list_head vec[TVR_SIZE];
+};
+
+struct tvec_base {
+	spinlock_t lock;
+	struct timer_list *running_timer;
+	unsigned long timer_jiffies;
+	struct tvec_root tv1;
+	struct tvec tv2;
+	struct tvec tv3;
+	struct tvec tv4;
+	struct tvec tv5;
+} ____cacheline_aligned;
+
+DECLARE_PER_CPU(struct tvec_base *, tvec_bases);
+
+/*
+ * Note that all tvec_bases are 2 byte aligned and lower bit of
+ * base in timer_list is guaranteed to be zero. Use the LSB for
+ * the new flag to indicate whether the timer is deferrable
+ */
+#define TBASE_DEFERRABLE_FLAG		(0x1)
+
+/* Functions below help us manage 'deferrable' flag */
+static inline unsigned int tbase_get_deferrable(struct tvec_base *base)
+{
+	return (unsigned int)(unsigned long)base & TBASE_DEFERRABLE_FLAG;
+}
+
+static inline struct tvec_base *tbase_get_base(struct tvec_base *base)
+{
+	return (struct tvec_base *)((unsigned long)base
+			& ~TBASE_DEFERRABLE_FLAG);
+}
+
+static inline void timer_set_deferrable(struct timer_list *timer)
+{
+	timer->base = ((struct tvec_base *)((unsigned long)(timer->base) |
+				       TBASE_DEFERRABLE_FLAG));
+}
+
+static inline void
+timer_set_base(struct timer_list *timer, struct tvec_base *new_base)
+{
+	timer->base = (struct tvec_base *)((unsigned long)(new_base) |
+				      tbase_get_deferrable(timer->base));
+}
+
+#endif /* _LINUX_TIMER_INTERNALS_H */

From: Joe Korty <joe.korty@ccur.com>
Subject: [PATCH] Display active jiffie timers in /proc/timer_list
Date: Tue, 25 Nov 2008 13:57:40 -0500
Message-ID: <20081125185740.GA21806@tsunami.ccur.com>
References: <20081121221113.GA13566@tsunami.ccur.com> <517f3f820811250806n33850ea8ua8e203347c0f7ba6@mail.gmail.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753382AbYKYS6U@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <517f3f820811250806n33850ea8ua8e203347c0f7ba6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Add to /proc/timer_list a display of the active jiffie timers.

Tested on i386 and x86_64, with 'less /proc/timer_list' and
through SysRq-Q.

Signed-off-by: Joe Korty <joe.korty@ccur.com>

Index: 2.6.28-rc6/kernel/timer.c
===================================================================
--- 2.6.28-rc6.orig/kernel/timer.c	2008-11-25 11:59:07.000000000 -0500
+++ 2.6.28-rc6/kernel/timer.c	2008-11-25 13:49:05.000000000 -0500
@@ -36,6 +36,8 @@
 #include <linux/syscalls.h>
 #include <linux/delay.h>
 #include <linux/tick.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/kallsyms.h>
 
 #include <asm/uaccess.h>
@@ -1568,6 +1570,87 @@
 	open_softirq(TIMER_SOFTIRQ, run_timer_softirq);
 }
 
+#if defined(CONFIG_PROC_FS) || defined(CONFIG_MAGIC_SYSRQ)
+
+/*
+ * This allows printing both to /proc/timer_list and
+ * to the console (on SysRq-Q):
+ */
+#define SEQ_printf(m, x...)			\
+ do {						\
+	if (m)					\
+		seq_printf(m, x);		\
+	else					\
+		printk(x);			\
+ } while (0)
+
+static void print_nearest_symbol(struct seq_file *m, void *symaddr)
+{
+	char symname[KSYM_NAME_LEN];
+
+	if (lookup_symbol_name((unsigned long)symaddr, symname) < 0)
+		SEQ_printf(m, "<%p>", symaddr);
+	else
+		SEQ_printf(m, "%s", symname);
+}
+
+static void print_single_jtimer(struct seq_file *m, struct timer_list *timer)
+{
+	unsigned long base_jiffies = tbase_get_base(timer->base)->timer_jiffies;
+#ifdef CONFIG_TIMER_STATS
+	char tmp[TASK_COMM_LEN + 1];
+#endif
+
+	SEQ_printf(m, " %p: ", (void *)(timer->expires - base_jiffies));
+	print_nearest_symbol(m, timer->function);
+	SEQ_printf(m, " (");
+	print_nearest_symbol(m, (void *)(timer->data));
+	SEQ_printf(m, ")");
+#ifdef CONFIG_TIMER_STATS
+	SEQ_printf(m, " from ");
+	print_nearest_symbol(m, timer->start_site);
+	memcpy(tmp, timer->start_comm, TASK_COMM_LEN);
+	tmp[TASK_COMM_LEN] = 0;
+	SEQ_printf(m, ", %s/%d", tmp, timer->start_pid);
+#endif
+	SEQ_printf(m, "\n");
+}
+
+static void print_list_jtimers(struct seq_file *m, struct list_head *head)
+{
+	struct timer_list *timer;
+	struct list_head *item;
+
+	for (item = head->next; item != head; item = item->next) {
+		timer = list_entry(item, struct timer_list, entry);
+		print_single_jtimer(m, timer);
+	}
+}
+
+void print_cpu_jtimers(struct seq_file *m, int cpu)
+{
+	int i;
+	struct tvec_base *base = per_cpu(tvec_bases, cpu);
+
+	SEQ_printf(m, "active jiffie timers:\n");
+	spin_lock_irq(&base->lock);
+	SEQ_printf(m, " base: %p\n", base);
+	SEQ_printf(m, " timer_jiffies: %p\n", (void *)(base->timer_jiffies));
+	SEQ_printf(m, " running_timer: %p\n", base->running_timer);
+
+	for (i = 0; i < TVR_SIZE; i++)
+		print_list_jtimers(m, base->tv1.vec + i);
+	for (i = 0; i < TVN_SIZE; i++) {
+		print_list_jtimers(m, base->tv2.vec + i);
+		print_list_jtimers(m, base->tv3.vec + i);
+		print_list_jtimers(m, base->tv4.vec + i);
+		print_list_jtimers(m, base->tv5.vec + i);
+	}
+	spin_unlock_irq(&base->lock);
+}
+
+#endif /* CONFIG_PROC_FS || CONFIG_MAGIC_SYSRQ */
+
 /**
  * msleep - sleep safely even with waitqueue interruptions
  * @msecs: Time in milliseconds to sleep for
Index: 2.6.28-rc6/include/linux/jiffies.h
===================================================================
--- 2.6.28-rc6.orig/include/linux/jiffies.h	2008-11-25 11:59:07.000000000 -0500
+++ 2.6.28-rc6/include/linux/jiffies.h	2008-11-25 13:22:41.000000000 -0500
@@ -298,6 +298,13 @@
 extern u64 jiffies_64_to_clock_t(u64 x);
 extern u64 nsec_to_clock_t(u64 x);
 
+struct seq_file;
+#if defined(CONFIG_PROC_FS) || defined(CONFIG_MAGIC_SYSRQ)
+extern void print_cpu_jtimers(struct seq_file *, int);
+#else
+static inline void print_cpu_jtimers(struct seq_file *, int) {}
+#endif
+
 #define TIMESTAMP_SIZE	30
 
 #endif
Index: 2.6.28-rc6/kernel/time/timer_list.c
===================================================================
--- 2.6.28-rc6.orig/kernel/time/timer_list.c	2008-11-25 11:59:07.000000000 -0500
+++ 2.6.28-rc6/kernel/time/timer_list.c	2008-11-25 13:47:30.000000000 -0500
@@ -17,6 +17,7 @@
 #include <linux/seq_file.h>
 #include <linux/kallsyms.h>
 #include <linux/tick.h>
+#include <linux/jiffies.h>
 
 #include <asm/uaccess.h>
 
@@ -139,6 +140,7 @@
 		SEQ_printf(m, " clock %d:\n", i);
 		print_base(m, cpu_base->clock_base + i, now);
 	}
+
 #define P(x) \
 	SEQ_printf(m, "  .%-15s: %Lu\n", #x, \
 		   (unsigned long long)(cpu_base->x))
@@ -176,9 +178,11 @@
 		P(last_jiffies);
 		P(next_jiffies);
 		P_ns(idle_expires);
-		SEQ_printf(m, "jiffies: %Lu\n",
+		SEQ_printf(m, "jiffies: %llu (0x%llx)\n",
+			   (unsigned long long)jiffies,
 			   (unsigned long long)jiffies);
 	}
+	print_cpu_jtimers(m, cpu);
 #endif
 
 #undef P
@@ -252,7 +256,7 @@
 	u64 now = ktime_to_ns(ktime_get());
 	int cpu;
 
-	SEQ_printf(m, "Timer List Version: v0.4\n");
+	SEQ_printf(m, "Timer List Version: v0.5\n");
 	SEQ_printf(m, "HRTIMER_MAX_CLOCK_BASES: %d\n", HRTIMER_MAX_CLOCK_BASES);
 	SEQ_printf(m, "now at %Ld nsecs\n", (unsigned long long)now);
 
@@ -286,7 +290,7 @@
 {
 	struct proc_dir_entry *pe;
 
-	pe = proc_create("timer_list", 0644, NULL, &timer_list_fops);
+	pe = proc_create("timer_list", 0444, NULL, &timer_list_fops);
 	if (!pe)
 		return -ENOMEM;
 	return 0;

From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] Fix /proc/stat freezes (was [PATCH v15] "task_isolation"
 mode)
Date: Wed, 17 Aug 2016 14:37:46 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1608171432200.30568@east.gentwo.org>
References: <1471382376-5443-1-git-send-email-cmetcalf@mellanox.com>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471382376-5443-1-git-send-email-cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chris Metcalf <cmetcalf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Gilad Ben Yossef <giladb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Viresh Kumar <viresh.kumar-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Francis Giraldeau <francis.giraldeau-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, 16 Aug 2016, Chris Metcalf wrote:

> - Dropped Christoph Lameter's patch to avoid scheduling the
>   clocksource watchdog on nohz cores; the recommendation is to just
>   boot with tsc=reliable for NOHZ in any case, if necessary.

We also said that there should be a WARN_ON if tsc=reliable is not
specified and processors are put into NOHZ mode. This is something not
obvious causing scheduling events on NOHZ processors.


> Frederic, do you have a sense of what is left to be done there?
> I can certainly try to contribute to that effort as well.

Here is a potential fix to the problem that /proc/stat values freeze when
processors go into NOHZ busy mode. I'd like to hear what people think
about the approach here. In particular one issue may be that I am
accessing remote tick-sched structures without serialization. But for
top/ps this may be ok. I noticed that other values shown by top/os also
sometime are a bit fuzzy.



Subject: NOHZ: Correctly display increasing cputime when processor is busy

The tick may be switched off when the processor gets busy with nohz full.
The user time fields in /proc/stat will then no longer increase because
the tick is not run to update the cpustat values anymore.

Compensate for the missing ticks by checking if a processor is in
such a mode. If so then add the ticks that have passed since
the tick was switched off to the usertime.

Note that this introduces a slight inaccuracy. The process may
actually do syscalls without triggering a tick again but the
processing time in those calls is negligible. Any wait or sleep
occurrence during syscalls would activate the tick again.

Any inaccuracy is corrected once the tick is switched on again
since the actual value where cputime aggregates is not changed.

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/fs/proc/stat.c
===================================================================
--- linux.orig/fs/proc/stat.c	2016-08-04 09:04:57.681480937 -0500
+++ linux/fs/proc/stat.c	2016-08-17 14:27:37.813445675 -0500
@@ -77,6 +77,12 @@ static u64 get_iowait_time(int cpu)

 #endif

+static unsigned long inline get_cputime_user(int cpu)
+{
+	return kcpustat_cpu(cpu).cpustat[CPUTIME_USER] +
+			tick_stopped_busy_ticks(cpu);
+}
+
 static int show_stat(struct seq_file *p, void *v)
 {
 	int i, j;
@@ -93,7 +99,7 @@ static int show_stat(struct seq_file *p,
 	getboottime64(&boottime);

 	for_each_possible_cpu(i) {
-		user += kcpustat_cpu(i).cpustat[CPUTIME_USER];
+		user += get_cputime_user(i);
 		nice += kcpustat_cpu(i).cpustat[CPUTIME_NICE];
 		system += kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
 		idle += get_idle_time(i);
@@ -130,7 +136,7 @@ static int show_stat(struct seq_file *p,

 	for_each_online_cpu(i) {
 		/* Copy values here to work around gcc-2.95.3, gcc-2.96 */
-		user = kcpustat_cpu(i).cpustat[CPUTIME_USER];
+		user = get_cputime_user(i);
 		nice = kcpustat_cpu(i).cpustat[CPUTIME_NICE];
 		system = kcpustat_cpu(i).cpustat[CPUTIME_SYSTEM];
 		idle = get_idle_time(i);
Index: linux/kernel/time/tick-sched.c
===================================================================
--- linux.orig/kernel/time/tick-sched.c	2016-07-27 08:41:17.109862517 -0500
+++ linux/kernel/time/tick-sched.c	2016-08-17 14:16:42.073835333 -0500
@@ -990,6 +990,24 @@ ktime_t tick_nohz_get_sleep_length(void)
 	return ts->sleep_length;
 }

+/**
+ * tick_stopped_busy_ticks - return the ticks that did not occur while the
+ *				processor was busy and the tick was off
+ *
+ * Called from sysfs to correctly calculate cputime of nohz full processors
+ */
+unsigned long tick_stopped_busy_ticks(int cpu)
+{
+#ifdef CONFIG_NOHZ_FULL
+	struct tick_sched *ts = per_cpu_ptr(&tick_cpu_sched, cpu);
+
+	if (!ts->inidle && ts->tick_stopped)
+		return jiffies - ts->idle_jiffies;
+	else
+#endif
+		return 0;
+}
+
 static void tick_nohz_account_idle_ticks(struct tick_sched *ts)
 {
 #ifndef CONFIG_VIRT_CPU_ACCOUNTING_NATIVE
Index: linux/include/linux/sched.h
===================================================================
--- linux.orig/include/linux/sched.h	2016-08-04 09:04:57.688480730 -0500
+++ linux/include/linux/sched.h	2016-08-17 14:18:30.983613830 -0500
@@ -2516,6 +2516,9 @@ static inline void wake_up_nohz_cpu(int

 #ifdef CONFIG_NO_HZ_FULL
 extern u64 scheduler_tick_max_deferment(void);
+extern unsigned long tick_stopped_busy_ticks(int cpu);
+#else
+static inline unsigned long tick_stopped_busy_ticks(int cpu) { return 0; }
 #endif

 #ifdef CONFIG_SCHED_AUTOGROUP

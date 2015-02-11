From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v5] perf: Use monotonic clock as a source for timestamps
Date: Wed, 11 Feb 2015 17:12:56 +0100
Message-ID: <20150211161256.GH2896@worktop.programming.kicks-ass.net>
References: <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
 <1421872037-12559-1-git-send-email-pawel.moll@arm.com>
 <1422895966.4944.25.camel@arm.com>
 <CAN+dfcT_6zZZ4oeyngUE5N0Wtx2B9CvXsfU71m+cuyXpq2KBdw@mail.gmail.com>
 <1422955245.4944.26.camel@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1422955245.4944.26.camel-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Cc: ajh mls <ajhmls-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <adrian.hunter-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org


How about something like the below? I _think_ it should mostly work for
x86, where the tsc is a 64bit wide cycle counter.

I suppose we should extend the perf userpage time data with
time_last_cycle and time_mask if/when we want to make this work on
something with a short counter.

Of course, at that time we also need to somehow deal with that counter
wrapping, its hardly practical to go iterate all possible userpg
instances from a timer handler.


---
 Documentation/kernel-parameters.txt |  9 +++++++
 arch/x86/kernel/cpu/perf_event.c    | 44 ++++++++++++++++++++++++---------
 include/linux/perf_event.h          |  6 +++++
 kernel/events/core.c                | 49 ++++++++++++++++++++++++++++++++++---
 kernel/time/timekeeping.c           | 30 +++++++++++++++++++++++
 5 files changed, 123 insertions(+), 15 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 176d4fe4f076..52255676b6e2 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -91,6 +91,7 @@ the beginning of each description states the restrictions within which a
 	NUMA	NUMA support is enabled.
 	NFS	Appropriate NFS support is enabled.
 	OSS	OSS sound support is enabled.
+	PERF	Performance events and counters support is enabled.
 	PV_OPS	A paravirtualized kernel is enabled.
 	PARIDE	The ParIDE (parallel port IDE) subsystem is enabled.
 	PARISC	The PA-RISC architecture is enabled.
@@ -2796,6 +2797,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			allocator.  This parameter is primarily	for debugging
 			and performance comparison.
 
+	perf_use_local_clock
+			[PERF]
+			Use local_clock() as a source for perf timestamps
+			generation. This was be the default behaviour and
+			this parameter can be used to maintain backward
+			compatibility or on older hardware with expensive
+			monotonic clock source.
+
 	pf.		[PARIDE]
 			See Documentation/blockdev/paride.txt.
 
diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index b71a7f86d68a..436a66632f76 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -1952,6 +1952,35 @@ static struct pmu pmu = {
 	.flush_branch_stack	= x86_pmu_flush_branch_stack,
 };
 
+static void local_clock_user_time(struct perf_event_mmap_page *userpg, u64 now)
+{
+	data = cyc2ns_read_begin();
+
+	userpg->cap_user_time = 1;
+	userpg->time_mult = data->cyc2ns_mul;
+	userpg->time_shift = data->cyc2ns_shift;
+	userpg->time_offset = data->cyc2ns_offset - now;
+
+	userpg->cap_user_time_zero = 1;
+	userpg->time_zero = data->cyc2ns_offset;
+
+	cyc2ns_read_end(data);
+}
+
+extern void notrace __ktime_get_mono_fast(u64 *offset, u32 *mult, u16 *shift);
+
+static void ktime_fast_mono_user_time(struct perf_event_mmap_page *userpg, u64 now)
+{
+	userpg->cap_user_time = 1;
+	userpg->cap_user_time_zero = 1;
+
+	__ktime_get_mono_fast(&userpg->time_zero,
+			      &userpg->time_mult,
+			      &userpg->time_shift);
+
+	userpg->offset = userpg->time_zero - now;
+}
+
 void arch_perf_update_userpage(struct perf_event *event,
 			       struct perf_event_mmap_page *userpg, u64 now)
 {
@@ -1966,17 +1995,10 @@ void arch_perf_update_userpage(struct perf_event *event,
 	if (!sched_clock_stable())
 		return;
 
-	data = cyc2ns_read_begin();
-
-	userpg->cap_user_time = 1;
-	userpg->time_mult = data->cyc2ns_mul;
-	userpg->time_shift = data->cyc2ns_shift;
-	userpg->time_offset = data->cyc2ns_offset - now;
-
-	userpg->cap_user_time_zero = 1;
-	userpg->time_zero = data->cyc2ns_offset;
-
-	cyc2ns_read_end(data);
+	if (static_key_false(&perf_use_local_clock_key))
+		local_clock_user_time(userpg, now);
+	else
+		ktime_fast_mono_user_time(userpg, now);
 }
 
 /*
diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 33262004c310..1d61f968113a 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -561,6 +561,12 @@ extern void perf_pmu_enable(struct pmu *pmu);
 extern int perf_event_task_disable(void);
 extern int perf_event_task_enable(void);
 extern int perf_event_refresh(struct perf_event *event, int refresh);
+
+extern struct static_key perf_use_local_clock_key = STATIC_KEY_INIT_FALSE;
+extern void __weak
+arch_perf_update_userpage(struct perf_event *event,
+			  struct perf_event_mmap_page *userpg, u64 now);
+
 extern void perf_event_update_userpage(struct perf_event *event);
 extern int perf_event_release_kernel(struct perf_event *event);
 extern struct perf_event *
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 13209a90b751..7bad385103ea 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -42,6 +42,8 @@
 #include <linux/module.h>
 #include <linux/mman.h>
 #include <linux/compat.h>
+#include <linux/sysctl.h>
+#include <linux/jump_label.h>
 
 #include "internal.h"
 
@@ -322,9 +324,43 @@ extern __weak const char *perf_pmu_name(void)
 	return "pmu";
 }
 
+struct static_key perf_use_local_clock_key = STATIC_KEY_INIT_FALSE;
+static bool perf_use_local_clock_param __initdata;
+static int __init perf_use_local_clock_setup(char *__unused)
+{
+	perf_use_local_clock_param = true;
+	return 1;
+}
+__setup("perf_use_local_clock", perf_use_local_clock_setup);
+
+static int sysctl_perf_sample_time_clk_id = CLOCK_MONOTONIC;
+
+static struct ctl_table perf_sample_time_kern_table[] = {
+	{
+		.procname       = "perf_sample_time_clk_id",
+		.data           = &sysctl_perf_sample_time_clk_id,
+		.maxlen         = sizeof(int),
+		.mode           = 0444,
+		.proc_handler   = proc_dointvec,
+	},
+	{}
+};
+
+static struct ctl_table perf_sample_time_root_table[] = {
+	{
+		.procname	= "kernel",
+		.mode		= 0555,
+		.child		= perf_sample_time_kern_table,
+	},
+	{}
+};
+
 static inline u64 perf_clock(void)
 {
-	return local_clock();
+	if (static_key_false(&perf_use_local_clock_key))
+		return local_clock();
+	else
+		return ktime_get_mono_fast_ns();
 }
 
 static inline struct perf_cpu_context *
@@ -4101,8 +4137,8 @@ static void perf_event_init_userpage(struct perf_event *event)
 	rcu_read_unlock();
 }
 
-void __weak arch_perf_update_userpage(
-	struct perf_event *event, struct perf_event_mmap_page *userpg, u64 now)
+void __weak arch_perf_update_userpage(struct perf_event *event,
+				      struct perf_event_mmap_page *userpg, u64 now)
 {
 }
 
@@ -4487,7 +4523,7 @@ static int perf_mmap(struct file *file, struct vm_area_struct *vma)
 	if (vma->vm_flags & VM_WRITE)
 		flags |= RING_BUFFER_WRITABLE;
 
-	rb = rb_alloc(nr_pages, 
+	rb = rb_alloc(nr_pages,
 		event->attr.watermark ? event->attr.wakeup_watermark : 0,
 		event->cpu, flags);
 
@@ -8516,6 +8552,11 @@ void __init perf_event_init(void)
 	 */
 	BUILD_BUG_ON((offsetof(struct perf_event_mmap_page, data_head))
 		     != 1024);
+
+	if (perf_use_local_clock_param)
+		static_key_slow_inc(&perf_use_local_clock_key);
+	else
+		register_sysctl_table(perf_sample_time_root_table);
 }
 
 static int __init perf_event_sysfs_init(void)
diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
index b124af259800..37bed5931a91 100644
--- a/kernel/time/timekeeping.c
+++ b/kernel/time/timekeeping.c
@@ -334,6 +334,36 @@ u64 notrace ktime_get_mono_fast_ns(void)
 }
 EXPORT_SYMBOL_GPL(ktime_get_mono_fast_ns);
 
+void notrace __ktime_get_mono_fast(u64 *offset, u32 *mult, u16 *shift)
+{
+	struct tk_read_base *tkr;
+	unsigned int seq;
+	cycle_t cycle_now, delta;
+	u64 nsecs, now;
+
+	do {
+		seq = raw_read_seqcount(&tk_fast_mono.seq);
+		tkr = tk_fast_mono.base + (seq & 0x01);
+
+		cycle_now = tkr->read(tkr->clock);
+		delta = clocksource_delta(cycle_now, tkr->cycle_last, tkr->mask);
+
+		nsec = delta * tkr->mult + tkr->xtime_nsec;
+		nsec >>= tkr->shift;
+		nsec += arch_gettimeoffset();
+
+		now = ktime_to_ns(tkr->base_mono) + nsec;
+
+		*mult = tkr->mult;
+		*shift = tkr->shift;
+
+		nsec = mul_u64_u32_shr(cycle_now, tkr->mult, tkr->shift);
+
+		*offset = now - nsec;
+
+	} while (read_seqcount_retry(&tk_fast_mono.seq, seq));
+}
+
 #ifdef CONFIG_GENERIC_TIME_VSYSCALL_OLD
 
 static inline void update_vsyscall(struct timekeeper *tk)

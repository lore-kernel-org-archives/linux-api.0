From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v3 1/3] perf: Use monotonic clock as a source for timestamps
Date: Tue,  4 Nov 2014 00:28:36 +0000
Message-ID: <1415060918-19954-2-git-send-email-pawel.moll@arm.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415060918-19954-1-git-send-email-pawel.moll-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Until now, perf framework never defined the meaning of the timestampt
captured as PERF_SAMPLE_TIME sample type. The values were obtaining
from local (sched) clock, which is unavailable in userspace. This made
it impossible to correlate perf data with any other events. Other
tracing solutions have the source configurable (ftrace) or just share
a common time domain between kernel and userspace (LTTng).

Follow the trend by using monotonic clock, which is readily available
as POSIX CLOCK_MONOTONIC.

Also add a sysctl "perf_sample_time_clk_id" attribute which can be used
by the user to obtain the clk_id to be used with POSIX clock API (eg.
clock_gettime()) to obtain a time value comparable with perf samples.

Signed-off-by: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
---

Ingo, I remember your comments about this approach in the past, but
during discussions at LPC Thomas was convinced that it's the right
thing to do - see cover letter for the series...

 include/linux/perf_event.h | 1 +
 kernel/events/core.c       | 4 +++-
 kernel/sysctl.c            | 7 +++++++
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 893a0d0..ba490d5 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -738,6 +738,7 @@ extern int sysctl_perf_event_paranoid;
 extern int sysctl_perf_event_mlock;
 extern int sysctl_perf_event_sample_rate;
 extern int sysctl_perf_cpu_time_max_percent;
+extern int sysctl_perf_sample_time_clk_id;
 
 extern void perf_sample_event_took(u64 sample_len_ns);
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 2b02c9f..ea3d6d3 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -234,6 +234,8 @@ int perf_cpu_time_max_percent_handler(struct ctl_table *table, int write,
 	return 0;
 }
 
+int sysctl_perf_sample_time_clk_id = CLOCK_MONOTONIC;
+
 /*
  * perf samples are done in some very critical code paths (NMIs).
  * If they take too much CPU time, the system can lock up and not
@@ -324,7 +326,7 @@ extern __weak const char *perf_pmu_name(void)
 
 static inline u64 perf_clock(void)
 {
-	return local_clock();
+	return ktime_get_mono_fast_ns();
 }
 
 static inline struct perf_cpu_context *
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 15f2511..cb75f5b 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -1094,6 +1094,13 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one_hundred,
 	},
+	{
+		.procname	= "perf_sample_time_clk_id",
+		.data		= &sysctl_perf_sample_time_clk_id,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0444,
+		.proc_handler	= proc_dointvec,
+	},
 #endif
 #ifdef CONFIG_KMEMCHECK
 	{
-- 
1.8.3.2

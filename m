From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v5] perf: Use monotonic clock as a source for timestamps
Date: Wed, 21 Jan 2015 20:27:17 +0000
Message-ID: <1421872037-12559-1-git-send-email-pawel.moll@arm.com>
References: <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415292718-19785-2-git-send-email-pawel.moll-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Until now, perf framework never defined the meaning of the timestamps
captured as PERF_SAMPLE_TIME sample type. The values were obtaining
from local (sched) clock, which is unavailable in userspace. This made
it impossible to correlate perf data with any other events. Other
tracing solutions have the source configurable (ftrace) or just share
a common time domain between kernel and userspace (LTTng).

Follow the trend by using monotonic clock, which is readily available
as POSIX CLOCK_MONOTONIC.

Also add a sysctl "perf_sample_time_clk_id" attribute (usually available
as "/proc/sys/kernel/perf_sample_time_clk_id") which can be used by the
user to obtain the clk_id to be used with POSIX clock API (eg.
clock_gettime()) to obtain a time value comparable with perf samples.

Old behaviour can be restored by using "perf_use_local_clock" kernel
parameter.

Signed-off-by: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
---
Changes since v4:

- using jump labels to reduce runtime overhead of the local/mono check

 Documentation/kernel-parameters.txt |  9 ++++++++
 kernel/events/core.c                | 43 ++++++++++++++++++++++++++++++++++++-
 2 files changed, 51 insertions(+), 1 deletion(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4df73da..3cccd0e 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -91,6 +91,7 @@ parameter is applicable:
 	NUMA	NUMA support is enabled.
 	NFS	Appropriate NFS support is enabled.
 	OSS	OSS sound support is enabled.
+	PERF	Performance events and counters support is enabled.
 	PV_OPS	A paravirtualized kernel is enabled.
 	PARIDE	The ParIDE (parallel port IDE) subsystem is enabled.
 	PARISC	The PA-RISC architecture is enabled.
@@ -2795,6 +2796,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
 
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 882f835..f45434d 100644
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
 
+static struct static_key perf_use_local_clock_key = STATIC_KEY_INIT_FALSE;
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
@@ -8271,6 +8307,11 @@ void __init perf_event_init(void)
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
-- 
2.1.0

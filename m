From: Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH v4 1/3] perf: Use monotonic clock as a source for timestamps
Date: Thu,  6 Nov 2014 16:51:56 +0000
Message-ID: <1415292718-19785-2-git-send-email-pawel.moll@arm.com>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Cochran <richardcochran@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, John Stultz <john.stultz@linaro.org>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christopher Covington <cov@codeaurora.org>, Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Tomeu Vizoso <tomeu@tomeuvizoso.net>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>
List-Id: linux-api@vger.kernel.org

Until now, perf framework never defined the meaning of the timestamps
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

Old behaviour can be restored by using "perf_use_local_clock" kernel
parameter.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
Ingo, I remember your comments about this approach in the past, but
during discussions at LPC Thomas was convinced that it's the right
thing to do - see cover letter for the series...

Changes since v3:

- Added "perf_use_lock_clock" parameter...

- ... and creating the sysctl value only when it's not defined (turned
  out that negative clk_ids are not invalid - they are used to describe
  dynamic clocks)

- Had to keep sysctl_perf_sample_time_clk_id non-const, because struct
  ctl_table.data is non-const

 Documentation/kernel-parameters.txt |  9 +++++++++
 kernel/events/core.c                | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4c81a86..8ead8d8 100644
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
@@ -2763,6 +2764,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
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
index 2b02c9f..5d0aa03 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -42,6 +42,7 @@
 #include <linux/module.h>
 #include <linux/mman.h>
 #include <linux/compat.h>
+#include <linux/sysctl.h>
 
 #include "internal.h"
 
@@ -322,8 +323,41 @@ extern __weak const char *perf_pmu_name(void)
 	return "pmu";
 }
 
+static bool perf_use_local_clock;
+static int __init perf_use_local_clock_setup(char *__unused)
+{
+	perf_use_local_clock = true;
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
+	if (likely(!perf_use_local_clock))
+		return ktime_get_mono_fast_ns();
+
 	return local_clock();
 }
 
@@ -8230,6 +8264,9 @@ void __init perf_event_init(void)
 	 */
 	BUILD_BUG_ON((offsetof(struct perf_event_mmap_page, data_head))
 		     != 1024);
+
+	if (!perf_use_local_clock)
+		register_sysctl_table(perf_sample_time_root_table);
 }
 
 static int __init perf_event_sysfs_init(void)
-- 
2.1.0

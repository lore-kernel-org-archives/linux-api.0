From: Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH v4 3/3] perf: Sample additional clock value
Date: Thu,  6 Nov 2014 16:51:58 +0000
Message-ID: <1415292718-19785-4-git-send-email-pawel.moll@arm.com>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Cochran <richardcochran@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, John Stultz <john.stultz@linaro.org>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christopher Covington <cov@codeaurora.org>, Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Tomeu Vizoso <tomeu@tomeuvizoso.net>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>
List-Id: linux-api@vger.kernel.org

This patch adds an option to sample value of an additional clock with
any perf event, with the the aim of allowing time correlation between
data coming from perf and other sources like hardware trace which is
timestamped with an external clock.

The idea is to generate periodic perf record containing timestamps from
two different sources, sampled as close to each other as possible. This
allows performing simple linear approximation:

                      other event
       -----O--------------+-------------O------> t_other
            :              |             :
            :              V             :
       -----O----------------------------O------> t_perf
        perf event

User can request such samples for any standard perf event, with the most
obvious examples of cpu-clock (hrtimer) at selected frequency or other
periodic events like sched:sched_switch.

In order to do this, PERF_SAMPLE_CLOCK has to be set in struct
perf_event_attr.sample_type and a type of the clock to be sampled
selected by setting perf_event_attr.clock to a value corresponding to
a POSIX clock clk_id (see "man 2 clock_gettime")

Currently three clocks are implemented: CLOCK_REALITME = 0,
CLOCK_MONOTONIC = 1 and CLOCK_MONOTONIC_RAW = 2. The clock field is
5 bits wide to allow for future extension to custom, non-POSIX clock
sources(MAX_CLOCK for those is 16, see include/uapi/linux/time.h) like
ARM CoreSight (hardware trace) timestamp generator.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---

Changes since v3:

- none

 include/linux/perf_event.h      |  2 ++
 include/uapi/linux/perf_event.h | 16 ++++++++++++++--
 kernel/events/core.c            | 30 ++++++++++++++++++++++++++++++
 3 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 680767d..b690a0d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -607,6 +607,8 @@ struct perf_sample_data {
 	 * Transaction flags for abort events:
 	 */
 	u64				txn;
+	/* Clock value (additional timestamp for time correlation) */
+	u64				clock;
 };
 
 /* default value for data source */
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 9a64eb1..53a7a72 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -137,8 +137,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_DATA_SRC			= 1U << 15,
 	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
 	PERF_SAMPLE_TRANSACTION			= 1U << 17,
+	PERF_SAMPLE_CLOCK			= 1U << 18,
 
-	PERF_SAMPLE_MAX = 1U << 18,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 19,		/* non-ABI */
 };
 
 /*
@@ -304,7 +305,16 @@ struct perf_event_attr {
 				mmap2          :  1, /* include mmap with inode data     */
 				comm_exec      :  1, /* flag comm events that are due to an exec */
 				uevents        :  1, /* allow uevents into the buffer */
-				__reserved_1   : 38;
+
+				/*
+				 * clock: one of the POSIX clock IDs:
+				 *
+				 * 0 - CLOCK_REALTIME
+				 * 1 - CLOCK_MONOTONIC
+				 * 4 - CLOCK_MONOTONIC_RAW
+				 */
+				clock          :  5, /* clock type */
+				__reserved_1   : 33;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -544,6 +554,7 @@ enum perf_event_type {
 	 * 	{ u64			id;       } && PERF_SAMPLE_ID
 	 * 	{ u64			stream_id;} && PERF_SAMPLE_STREAM_ID
 	 * 	{ u32			cpu, res; } && PERF_SAMPLE_CPU
+	 *	{ u64			clock;    } && PERF_SAMPLE_CLOCK
 	 *	{ u64			id;	  } && PERF_SAMPLE_IDENTIFIER
 	 * } && perf_event_attr::sample_id_all
 	 *
@@ -687,6 +698,7 @@ enum perf_event_type {
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
 	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
+	 *	{ u64			clock;    } && PERF_SAMPLE_CLOCK
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index 9a2d082..816baa6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1264,6 +1264,9 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_TRANSACTION)
 		size += sizeof(data->txn);
 
+	if (sample_type & PERF_SAMPLE_CLOCK)
+		size += sizeof(data->clock);
+
 	event->header_size = size;
 }
 
@@ -1291,6 +1294,9 @@ static void perf_event__id_header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_CPU)
 		size += sizeof(data->cpu_entry);
 
+	if (sample_type & PERF_SAMPLE_CLOCK)
+		size += sizeof(data->clock);
+
 	event->id_header_size = size;
 }
 
@@ -4631,6 +4637,24 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
 		data->cpu_entry.cpu	 = raw_smp_processor_id();
 		data->cpu_entry.reserved = 0;
 	}
+
+	if (sample_type & PERF_SAMPLE_CLOCK) {
+		switch (event->attr.clock) {
+		case CLOCK_REALTIME:
+			data->clock = ktime_get_real_ns();
+			break;
+		case CLOCK_MONOTONIC:
+			data->clock = ktime_get_mono_fast_ns();
+			break;
+		case CLOCK_MONOTONIC_RAW:
+			data->clock = ktime_get_raw_ns();
+			break;
+		default:
+			data->clock = 0;
+			break;
+		}
+	}
+
 }
 
 void perf_event_header__init_id(struct perf_event_header *header,
@@ -4661,6 +4685,9 @@ static void __perf_event__output_id_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_CPU)
 		perf_output_put(handle, data->cpu_entry);
 
+	if (sample_type & PERF_SAMPLE_CLOCK)
+		perf_output_put(handle, data->clock);
+
 	if (sample_type & PERF_SAMPLE_IDENTIFIER)
 		perf_output_put(handle, data->id);
 }
@@ -4889,6 +4916,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_TRANSACTION)
 		perf_output_put(handle, data->txn);
 
+	if (sample_type & PERF_SAMPLE_CLOCK)
+		perf_output_put(handle, data->clock);
+
 	if (!event->attr.watermark) {
 		int wakeup_events = event->attr.wakeup_events;
 
-- 
2.1.0

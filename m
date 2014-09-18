From: Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH 1/2] perf: Add sampling of the raw monotonic clock
Date: Thu, 18 Sep 2014 15:34:32 +0100
Message-ID: <1411050873-9310-2-git-send-email-pawel.moll@arm.com>
References: <1411050873-9310-1-git-send-email-pawel.moll@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1411050873-9310-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Cochran <richardcochran@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>
List-Id: linux-api@vger.kernel.org

This patch adds an option to sample raw monotonic clock
value with any perf event, with the the aim of allowing
time correlation between data coming from perf and
additional performance-related information generated in
userspace.

In order to correlate timestamps in perf data stream
with events happening in userspace (be it JITed debug
symbols or hwmon-originating environment data), user
requests a more or less periodic event (sched_switch
trace event of a hrtimer-based cpu-clock being the
most obvious examples) with PERF_SAMPLE_TIME *and*
PERF_SAMPLE_CLOCK_RAW_MONOTONIC and stamps
user-originating data with values obtained from
clock_gettime(CLOCK_MONOTONIC_RAW). Then, during
analysis, one looks at the perf events immediately
preceding and following (in terms of the
clock_raw_monotonic sample) the userspace event and
does simple linear approximation to get the equivalent
perf time.

        perf event     user event
       -----O--------------+-------------O------> t_mono
            :              |             :
            :              V             :
       -----O----------------------------O------> t_perf

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 include/linux/perf_event.h      |  2 ++
 include/uapi/linux/perf_event.h |  4 +++-
 kernel/events/core.c            | 13 +++++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 707617a..28b73b2 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -602,6 +602,8 @@ struct perf_sample_data {
 	 * Transaction flags for abort events:
 	 */
 	u64				txn;
+	/* Raw monotonic timestamp, for userspace time correlation */
+	u64				clock_raw_monotonic;
 };
 
 static inline void perf_sample_data_init(struct perf_sample_data *data,
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 9269de2..e5a75c5 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -137,8 +137,9 @@ enum perf_event_sample_format {
 	PERF_SAMPLE_DATA_SRC			= 1U << 15,
 	PERF_SAMPLE_IDENTIFIER			= 1U << 16,
 	PERF_SAMPLE_TRANSACTION			= 1U << 17,
+	PERF_SAMPLE_CLOCK_RAW_MONOTONIC		= 1U << 18,
 
-	PERF_SAMPLE_MAX = 1U << 18,		/* non-ABI */
+	PERF_SAMPLE_MAX = 1U << 19,		/* non-ABI */
 };
 
 /*
@@ -686,6 +687,7 @@ enum perf_event_type {
 	 *	{ u64			weight;   } && PERF_SAMPLE_WEIGHT
 	 *	{ u64			data_src; } && PERF_SAMPLE_DATA_SRC
 	 *	{ u64			transaction; } && PERF_SAMPLE_TRANSACTION
+	 *	{ u64			clock_raw_monotonic; } && PERF_SAMPLE_CLOCK_RAW_MONOTONIC
 	 * };
 	 */
 	PERF_RECORD_SAMPLE			= 9,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f9c1ed0..f6df547 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1216,6 +1216,9 @@ static void perf_event__header_size(struct perf_event *event)
 	if (sample_type & PERF_SAMPLE_TRANSACTION)
 		size += sizeof(data->txn);
 
+	if (sample_type & PERF_SAMPLE_CLOCK_RAW_MONOTONIC)
+		size += sizeof(data->clock_raw_monotonic);
+
 	event->header_size = size;
 }
 
@@ -4456,6 +4459,13 @@ static void __perf_event_header__init_id(struct perf_event_header *header,
 		data->cpu_entry.cpu	 = raw_smp_processor_id();
 		data->cpu_entry.reserved = 0;
 	}
+
+	if (sample_type & PERF_SAMPLE_CLOCK_RAW_MONOTONIC) {
+		struct timespec now;
+
+		getrawmonotonic(&now);
+		data->clock_raw_monotonic = timespec_to_ns(&now);
+	}
 }
 
 void perf_event_header__init_id(struct perf_event_header *header,
@@ -4714,6 +4724,9 @@ void perf_output_sample(struct perf_output_handle *handle,
 	if (sample_type & PERF_SAMPLE_TRANSACTION)
 		perf_output_put(handle, data->txn);
 
+	if (sample_type & PERF_SAMPLE_CLOCK_RAW_MONOTONIC)
+		perf_output_put(handle, data->clock_raw_monotonic);
+
 	if (!event->attr.watermark) {
 		int wakeup_events = event->attr.wakeup_events;
 
-- 
1.9.1

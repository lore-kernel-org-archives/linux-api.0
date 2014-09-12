From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: [RFC 2/2] perf: Marker software event and ioctl
Date: Fri, 12 Sep 2014 12:48:33 +0100
Message-ID: <1410522513-1045-3-git-send-email-pawel.moll@arm.com>
References: <1410522513-1045-1-git-send-email-pawel.moll@arm.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410522513-1045-1-git-send-email-pawel.moll-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patch adds a PERF_COUNT_SW_MARKER event type, which
can be requested by user and a PERF_EVENT_IOC_MARKER
ioctl command which will inject an event of said type into
the perf buffer. The ioctl can take a zero-terminated
string argument, similar to tracing_marker in ftrace,
which will be kept in the "raw" field of the sample.

The main use case for this is synchronisation of
performance data generated in user space with the perf
stream coming from the kernel. For example, the marker
can be inserted by a JIT engine after it generated
portion of the code, but before the code is executed
for the first time, allowing the post-processor to
pick the correct debugging information. Other example
is a system profiling tool taking data from other
sources than just perf, which generates a marker
at the beginning at at the end of the session
(also possibly periodically during the session) to
synchronise kernel timestamps with clock values
obtained in userspace (gtod or raw_monotonic).

Signed-off-by: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
---
 include/uapi/linux/perf_event.h |  2 ++
 kernel/events/core.c            | 43 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 45 insertions(+)

diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index e5a75c5..83b0f5b 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -110,6 +110,7 @@ enum perf_sw_ids {
 	PERF_COUNT_SW_ALIGNMENT_FAULTS		= 7,
 	PERF_COUNT_SW_EMULATION_FAULTS		= 8,
 	PERF_COUNT_SW_DUMMY			= 9,
+	PERF_COUNT_SW_MARKER			= 10,
 
 	PERF_COUNT_SW_MAX,			/* non-ABI */
 };
@@ -350,6 +351,7 @@ struct perf_event_attr {
 #define PERF_EVENT_IOC_SET_OUTPUT	_IO ('$', 5)
 #define PERF_EVENT_IOC_SET_FILTER	_IOW('$', 6, char *)
 #define PERF_EVENT_IOC_ID		_IOR('$', 7, __u64 *)
+#define PERF_EVENT_IOC_MARKER		_IOR('$', 8, char *)
 
 enum perf_event_ioc_flags {
 	PERF_IOC_FLAG_GROUP		= 1U << 0,
diff --git a/kernel/events/core.c b/kernel/events/core.c
index df093e3..dbce284 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3655,6 +3655,7 @@ static inline int perf_fget_light(int fd, struct fd *p)
 static int perf_event_set_output(struct perf_event *event,
 				 struct perf_event *output_event);
 static int perf_event_set_filter(struct perf_event *event, void __user *arg);
+static int perf_sw_event_marker(struct perf_event *event, char __user *arg);
 
 static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
@@ -3709,6 +3710,9 @@ static long perf_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	case PERF_EVENT_IOC_SET_FILTER:
 		return perf_event_set_filter(event, (void __user *)arg);
 
+	case PERF_EVENT_IOC_MARKER:
+		return perf_sw_event_marker(event, (char __user *)arg);
+
 	default:
 		return -ENOTTY;
 	}
@@ -3728,6 +3732,7 @@ static long perf_compat_ioctl(struct file *file, unsigned int cmd,
 	switch (_IOC_NR(cmd)) {
 	case _IOC_NR(PERF_EVENT_IOC_SET_FILTER):
 	case _IOC_NR(PERF_EVENT_IOC_ID):
+	case _IOC_NR(PERF_EVENT_IOC_MARKER):
 		/* Fix up pointer size (usually 4 -> 8 in 32-on-64-bit case */
 		if (_IOC_SIZE(cmd) == sizeof(compat_uptr_t)) {
 			cmd &= ~IOCSIZE_MASK;
@@ -5960,6 +5965,44 @@ static struct pmu perf_swevent = {
 	.event_idx	= perf_swevent_event_idx,
 };
 
+static int perf_sw_event_marker(struct perf_event *event, char __user *arg)
+{
+	struct perf_sample_data data;
+	struct pt_regs *regs = current_pt_regs();
+	struct perf_raw_record raw = { 0, };
+
+	if (!static_key_false(&perf_swevent_enabled[PERF_COUNT_SW_MARKER]))
+		return 0;
+
+	perf_sample_data_init(&data, 0, 0);
+
+	if (arg) {
+		long len = strnlen_user(arg, PAGE_SIZE);
+
+		if (len) {
+			raw.size = ALIGN(len + sizeof(u32), sizeof(u64))
+					- sizeof(u32);
+			raw.data = kzalloc(raw.size, GFP_KERNEL);
+			if (!raw.data)
+				return -ENOMEM;
+
+			if (copy_from_user(raw.data, arg, len)) {
+				kfree(raw.data);
+				return -EFAULT;
+			}
+
+			data.raw = &raw;
+		}
+	}
+
+	perf_event_output(event, &data, regs);
+
+	if (raw.size)
+		kfree(raw.data);
+
+	return 0;
+}
+
 #ifdef CONFIG_EVENT_TRACING
 
 static int perf_tp_filter_match(struct perf_event *event,
-- 
1.9.1

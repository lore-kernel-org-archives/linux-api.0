From: Pawel Moll <pawel.moll@arm.com>
Subject: [PATCH v3 2/3] perf: Userspace event
Date: Tue,  4 Nov 2014 00:28:37 +0000
Message-ID: <1415060918-19954-3-git-send-email-pawel.moll@arm.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Richard Cochran <richardcochran@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, John Stultz <john.stultz@linaro.org>, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, Christopher Covington <cov@codeaurora.org>, Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Tomeu Vizoso <tomeu@tomeuvizoso.net>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Pawel Moll <mail@pawelmoll.com>, Pawel Moll <pawel.moll@arm.com>
List-Id: linux-api@vger.kernel.org

From: Pawel Moll <mail@pawelmoll.com>

This patch adds a PR_TASK_PERF_UEVENT prctl call which can be used by
any process to inject custom data into perf data stream as a new
PERF_RECORD_UEVENT record, if such process is being observed or if it
is running on a CPU being observed by the perf framework.

The prctl call takes the following arguments:

	prctl(PR_TASK_PERF_UEVENT, type, size, data, flags);

- type: a number meaning to describe content of the following data.
  Kernel does not pay attention to it and merely passes it further in
  the perf data, therefore its use must be agreed between the events
  producer (the process being observed) and the consumer (performance
  analysis tool). The perf userspace tool will contain a repository of
  "well known" types and reference implementation of their decoders.
- size: Length in bytes of the data.
- data: Pointer to the data.
- flags: Reserved for future use. Always pass zero.

Perf context that are supposed to receive events generated with the
prctl above must be opened with perf_event_attr.uevent set to 1. The
PERF_RECORD_UEVENT records consist of a standard perf event header,
32-bit type value, 32-bit data size and the data itself, followed by
padding to align the overall record size to 8 bytes and optional,
standard sample_id field.

Example use cases:

- "perf_printf" like mechanism to add logging messages to perf data;
  in the simplest case it can be just

	prctl(PR_TASK_PERF_UEVENT, 0, 8, "Message", 0);

- synchronisation of performance data generated in user space with the
  perf stream coming from the kernel. For example, the marker can be
  inserted by a JIT engine after it generated portion of the code, but
  before the code is executed for the first time, allowing the
  post-processor to pick the correct debugging information.

Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 include/linux/perf_event.h      |  4 +++
 include/uapi/linux/perf_event.h | 23 ++++++++++++-
 include/uapi/linux/prctl.h      | 10 ++++++
 kernel/events/core.c            | 71 +++++++++++++++++++++++++++++++++++++++++
 kernel/sys.c                    |  5 +++
 5 files changed, 112 insertions(+), 1 deletion(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index ba490d5..867415d 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -721,6 +721,8 @@ extern int perf_unregister_guest_info_callbacks(struct perf_guest_info_callbacks
 extern void perf_event_exec(void);
 extern void perf_event_comm(struct task_struct *tsk, bool exec);
 extern void perf_event_fork(struct task_struct *tsk);
+extern int perf_uevent(struct task_struct *tsk, u32 type, u32 size,
+		       const char __user *data);
 
 /* Callchains */
 DECLARE_PER_CPU(struct perf_callchain_entry, perf_callchain_entry);
@@ -830,6 +832,8 @@ static inline void perf_event_mmap(struct vm_area_struct *vma)		{ }
 static inline void perf_event_exec(void)				{ }
 static inline void perf_event_comm(struct task_struct *tsk, bool exec)	{ }
 static inline void perf_event_fork(struct task_struct *tsk)		{ }
+static inline int perf_uevent(struct task_struct *tsk, u32 type, u32 size,
+		              const char __user *data)			{ return -1; };
 static inline void perf_event_init(void)				{ }
 static inline int  perf_swevent_get_recursion_context(void)		{ return -1; }
 static inline void perf_swevent_put_recursion_context(int rctx)		{ }
diff --git a/include/uapi/linux/perf_event.h b/include/uapi/linux/perf_event.h
index 9d84540..9a64eb1 100644
--- a/include/uapi/linux/perf_event.h
+++ b/include/uapi/linux/perf_event.h
@@ -303,7 +303,8 @@ struct perf_event_attr {
 				exclude_callchain_user   : 1, /* exclude user callchains */
 				mmap2          :  1, /* include mmap with inode data     */
 				comm_exec      :  1, /* flag comm events that are due to an exec */
-				__reserved_1   : 39;
+				uevents        :  1, /* allow uevents into the buffer */
+				__reserved_1   : 38;
 
 	union {
 		__u32		wakeup_events;	  /* wakeup every n events */
@@ -712,6 +713,26 @@ enum perf_event_type {
 	 */
 	PERF_RECORD_MMAP2			= 10,
 
+	/*
+	 * Data in userspace event record is transparent for the kernel
+	 *
+	 * Userspace perf tool code maintains a list of known types with
+	 * reference implementations of parsers for the data field.
+	 *
+	 * Overall size of the record (including type and size fields)
+	 * is always aligned to 8 bytes by adding padding after the data.
+	 *
+	 * struct {
+	 *	struct perf_event_header	header;
+	 *	u32				type;
+	 *	u32				size;
+	 *	char				data[size];
+	 *	char				__padding[-size & 7];
+	 * 	struct sample_id		sample_id;
+	 * };
+	 */
+	PERF_RECORD_UEVENT			= 11,
+
 	PERF_RECORD_MAX,			/* non-ABI */
 };
 
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 513df75..2a6852f 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -179,4 +179,14 @@ struct prctl_mm_map {
 #define PR_SET_THP_DISABLE	41
 #define PR_GET_THP_DISABLE	42
 
+/*
+ * Perf userspace event generation
+ *
+ * second argument: event type
+ * third argument:  data size
+ * fourth argument: pointer to data
+ * fifth argument:  flags (currently unused, pass 0)
+ */
+#define PR_TASK_PERF_UEVENT	43
+
 #endif /* _LINUX_PRCTL_H */
diff --git a/kernel/events/core.c b/kernel/events/core.c
index ea3d6d3..3738e9c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5565,6 +5565,77 @@ static void perf_log_throttle(struct perf_event *event, int enable)
 }
 
 /*
+ * Userspace-generated event
+ */
+
+struct perf_uevent {
+	struct perf_event_header	header;
+	u32				type;
+	u32				size;
+	u8				data[0];
+};
+
+static void perf_uevent_output(struct perf_event *event, void *data)
+{
+	struct perf_uevent *uevent = data;
+	struct perf_output_handle handle;
+	struct perf_sample_data sample;
+	int size = uevent->header.size;
+
+	if (!event->attr.uevents)
+		return;
+
+	perf_event_header__init_id(&uevent->header, &sample, event);
+
+	if (perf_output_begin(&handle, event, uevent->header.size) != 0)
+		goto out;
+	perf_output_put(&handle, uevent->header);
+	perf_output_put(&handle, uevent->type);
+	perf_output_put(&handle, uevent->size);
+	__output_copy(&handle, uevent->data, uevent->size);
+
+	/* Padding to align overall data size to 8 bytes */
+	perf_output_skip(&handle, -uevent->size & (sizeof(u64) - 1));
+
+	perf_event__output_id_sample(event, &handle, &sample);
+
+	perf_output_end(&handle);
+out:
+	uevent->header.size = size;
+}
+
+int perf_uevent(struct task_struct *tsk, u32 type, u32 size,
+		const char __user *data)
+{
+	struct perf_uevent *uevent;
+
+	/* Need some reasonable limit */
+	if (size > PAGE_SIZE)
+		return -E2BIG;
+
+	uevent = kmalloc(sizeof(*uevent) + size, GFP_KERNEL);
+	if (!uevent)
+		return -ENOMEM;
+
+	uevent->header.type = PERF_RECORD_UEVENT;
+	uevent->header.size = sizeof(*uevent) + ALIGN(size, sizeof(u64));
+
+	uevent->type = type;
+	uevent->size = size;
+	if (copy_from_user(uevent->data, data, size)) {
+		kfree(uevent);
+		return -EFAULT;
+	}
+
+	perf_event_aux(perf_uevent_output, uevent, NULL);
+
+	kfree(uevent);
+
+	return 0;
+}
+
+
+/*
  * Generic event overflow handling, sampling.
  */
 
diff --git a/kernel/sys.c b/kernel/sys.c
index 1eaa2f0..1c83677 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2121,6 +2121,11 @@ SYSCALL_DEFINE5(prctl, int, option, unsigned long, arg2, unsigned long, arg3,
 	case PR_TASK_PERF_EVENTS_ENABLE:
 		error = perf_event_task_enable();
 		break;
+	case PR_TASK_PERF_UEVENT:
+		if (arg5 != 0)
+			return -EINVAL;
+		error = perf_uevent(me, arg2, arg3, (char __user *)arg4);
+		break;
 	case PR_GET_TIMERSLACK:
 		error = current->timer_slack_ns;
 		break;
-- 
1.8.3.2

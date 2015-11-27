From: WEN Pingbo <pingbo.wen@linaro.org>
Subject: [PATCH 1/3] input: evdev: introduce new evdev interface
Date: Fri, 27 Nov 2015 18:00:30 +0800
Message-ID: <1448618432-32357-2-git-send-email-pingbo.wen@linaro.org>
References: <1448618432-32357-1-git-send-email-pingbo.wen@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1448618432-32357-1-git-send-email-pingbo.wen@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: y2038@list.linaro.org, dmitry.torokhov@gmail.com, aksgarg1989@gmail.com, arnd@arndb.de
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, WEN Pingbo <pingbo.wen@linaro.org>
List-Id: linux-api@vger.kernel.org

The y2038 problem in 'struct input_event' is complained too much. And
after some discussion with other people, I found it's impossible to
solve this in a simple way, and keep backward compatible at the same
time, so we need some new y2038-safe interface here.

This patch add two new evdev interface type - EV_IF_RAW and
EV_IF_COMPOSITE. And leaving the old interface as EV_IF_LEGACY for
compatibility. Userspace can switch between those interface seamlessly
via ioctl, which will be introduced in another patch.

And since evdev doesn't really interest in event timestamp, the patch
has also converted input_event to input_value in evdev entirely, and
move all time-related operations to input_event_to/from_user().

Signed-off-by: WEN Pingbo <pingbo.wen@linaro.org>
---
 drivers/input/evdev.c        |  78 ++++++++---------------
 drivers/input/input-compat.c | 148 ++++++++++++++++++++++++++++---------------
 drivers/input/input-compat.h |  48 ++++++++++----
 include/linux/input.h        |  12 ----
 include/uapi/linux/input.h   |  17 +++++
 5 files changed, 176 insertions(+), 127 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index e9ae3d5..170681b 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -28,13 +28,6 @@
 #include <linux/cdev.h>
 #include "input-compat.h"
 
-enum evdev_clock_type {
-	EV_CLK_REAL = 0,
-	EV_CLK_MONO,
-	EV_CLK_BOOT,
-	EV_CLK_MAX
-};
-
 struct evdev {
 	int open;
 	struct input_handle handle;
@@ -57,10 +50,11 @@ struct evdev_client {
 	struct evdev *evdev;
 	struct list_head node;
 	unsigned int clk_type;
+	unsigned int if_type;
 	bool revoked;
 	unsigned long *evmasks[EV_CNT];
 	unsigned int bufsize;
-	struct input_event buffer[];
+	struct input_value buffer[];
 };
 
 static size_t evdev_get_mask_cnt(unsigned int type)
@@ -113,7 +107,7 @@ static void __evdev_flush_queue(struct evdev_client *client, unsigned int type)
 	unsigned int i, head, num;
 	unsigned int mask = client->bufsize - 1;
 	bool is_report;
-	struct input_event *ev;
+	struct input_value *ev;
 
 	BUG_ON(type == EV_SYN);
 
@@ -135,7 +129,6 @@ static void __evdev_flush_queue(struct evdev_client *client, unsigned int type)
 			continue;
 		} else if (head != i) {
 			/* move entry to fill the gap */
-			client->buffer[head].time = ev->time;
 			client->buffer[head].type = ev->type;
 			client->buffer[head].code = ev->code;
 			client->buffer[head].value = ev->value;
@@ -155,16 +148,8 @@ static void __evdev_flush_queue(struct evdev_client *client, unsigned int type)
 
 static void __evdev_queue_syn_dropped(struct evdev_client *client)
 {
-	struct input_event ev;
-	ktime_t time;
+	struct input_value ev;
 
-	time = client->clk_type == EV_CLK_REAL ?
-			ktime_get_real() :
-			client->clk_type == EV_CLK_MONO ?
-				ktime_get() :
-				ktime_get_boottime();
-
-	ev.time = ktime_to_timeval(time);
 	ev.type = EV_SYN;
 	ev.code = SYN_DROPPED;
 	ev.value = 0;
@@ -229,7 +214,7 @@ static int evdev_set_clk_type(struct evdev_client *client, unsigned int clkid)
 }
 
 static void __pass_event(struct evdev_client *client,
-			 const struct input_event *event)
+			 const struct input_value *event)
 {
 	client->buffer[client->head++] = *event;
 	client->head &= client->bufsize - 1;
@@ -241,7 +226,6 @@ static void __pass_event(struct evdev_client *client,
 		 */
 		client->tail = (client->head - 2) & (client->bufsize - 1);
 
-		client->buffer[client->tail].time = event->time;
 		client->buffer[client->tail].type = EV_SYN;
 		client->buffer[client->tail].code = SYN_DROPPED;
 		client->buffer[client->tail].value = 0;
@@ -256,19 +240,15 @@ static void __pass_event(struct evdev_client *client,
 }
 
 static void evdev_pass_values(struct evdev_client *client,
-			const struct input_value *vals, unsigned int count,
-			ktime_t *ev_time)
+			const struct input_value *vals, unsigned int count)
 {
 	struct evdev *evdev = client->evdev;
 	const struct input_value *v;
-	struct input_event event;
 	bool wakeup = false;
 
 	if (client->revoked)
 		return;
 
-	event.time = ktime_to_timeval(ev_time[client->clk_type]);
-
 	/* Interrupts are disabled, just acquire the lock. */
 	spin_lock(&client->buffer_lock);
 
@@ -284,10 +264,7 @@ static void evdev_pass_values(struct evdev_client *client,
 			wakeup = true;
 		}
 
-		event.type = v->type;
-		event.code = v->code;
-		event.value = v->value;
-		__pass_event(client, &event);
+		__pass_event(client, v);
 	}
 
 	spin_unlock(&client->buffer_lock);
@@ -304,22 +281,16 @@ static void evdev_events(struct input_handle *handle,
 {
 	struct evdev *evdev = handle->private;
 	struct evdev_client *client;
-	ktime_t ev_time[EV_CLK_MAX];
-
-	ev_time[EV_CLK_MONO] = ktime_get();
-	ev_time[EV_CLK_REAL] = ktime_mono_to_real(ev_time[EV_CLK_MONO]);
-	ev_time[EV_CLK_BOOT] = ktime_mono_to_any(ev_time[EV_CLK_MONO],
-						 TK_OFFS_BOOT);
 
 	rcu_read_lock();
 
 	client = rcu_dereference(evdev->grab);
 
 	if (client)
-		evdev_pass_values(client, vals, count, ev_time);
+		evdev_pass_values(client, vals, count);
 	else
 		list_for_each_entry_rcu(client, &evdev->client_list, node)
-			evdev_pass_values(client, vals, count, ev_time);
+			evdev_pass_values(client, vals, count);
 
 	rcu_read_unlock();
 }
@@ -498,7 +469,7 @@ static int evdev_open(struct inode *inode, struct file *file)
 	struct evdev *evdev = container_of(inode->i_cdev, struct evdev, cdev);
 	unsigned int bufsize = evdev_compute_buffer_size(evdev->handle.dev);
 	unsigned int size = sizeof(struct evdev_client) +
-					bufsize * sizeof(struct input_event);
+					bufsize * sizeof(struct input_value);
 	struct evdev_client *client;
 	int error;
 
@@ -533,10 +504,10 @@ static ssize_t evdev_write(struct file *file, const char __user *buffer,
 {
 	struct evdev_client *client = file->private_data;
 	struct evdev *evdev = client->evdev;
-	struct input_event event;
+	struct input_value event;
 	int retval = 0;
 
-	if (count != 0 && count < input_event_size())
+	if (count != 0 && count < input_event_size(client->if_type))
 		return -EINVAL;
 
 	retval = mutex_lock_interruptible(&evdev->mutex);
@@ -548,13 +519,19 @@ static ssize_t evdev_write(struct file *file, const char __user *buffer,
 		goto out;
 	}
 
-	while (retval + input_event_size() <= count) {
+	while (retval + input_event_size(client->if_type) <= count) {
 
-		if (input_event_from_user(buffer + retval, &event)) {
+		if (input_event_from_user(buffer + retval, &event,
+					client->if_type)) {
 			retval = -EFAULT;
 			goto out;
 		}
-		retval += input_event_size();
+
+		/*
+		 * We aren't interested in timestamp from userspace,
+		 * skip it if in composite interface
+		 */
+		retval += input_event_size(client->if_type);
 
 		input_inject_event(&evdev->handle,
 				   event.type, event.code, event.value);
@@ -566,7 +543,7 @@ static ssize_t evdev_write(struct file *file, const char __user *buffer,
 }
 
 static int evdev_fetch_next_event(struct evdev_client *client,
-				  struct input_event *event)
+				  struct input_value *event)
 {
 	int have_event;
 
@@ -588,11 +565,11 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
 {
 	struct evdev_client *client = file->private_data;
 	struct evdev *evdev = client->evdev;
-	struct input_event event;
+	struct input_value event;
 	size_t read = 0;
 	int error;
 
-	if (count != 0 && count < input_event_size())
+	if (count != 0 && count < input_event_size(client->if_type))
 		return -EINVAL;
 
 	for (;;) {
@@ -610,13 +587,14 @@ static ssize_t evdev_read(struct file *file, char __user *buffer,
 		if (count == 0)
 			break;
 
-		while (read + input_event_size() <= count &&
+		while (read + input_event_size(client->if_type) <= count &&
 		       evdev_fetch_next_event(client, &event)) {
 
-			if (input_event_to_user(buffer + read, &event))
+			if (input_event_to_user(buffer + read, &event,
+					client->clk_type, client->if_type))
 				return -EFAULT;
 
-			read += input_event_size();
+			read += input_event_size(client->if_type);
 		}
 
 		if (read)
diff --git a/drivers/input/input-compat.c b/drivers/input/input-compat.c
index 64ca711..09162c6 100644
--- a/drivers/input/input-compat.c
+++ b/drivers/input/input-compat.c
@@ -12,56 +12,118 @@
 #include <asm/uaccess.h>
 #include "input-compat.h"
 
-#ifdef CONFIG_COMPAT
+static ktime_t input_get_time(int clk_type)
+{
+	switch (clk_type) {
+	case EV_CLK_MONO:
+		return ktime_get();
+	case EV_CLK_BOOT:
+		return ktime_get_boottime();
+	case EV_CLK_REAL:
+	default:
+		return ktime_get_real();
+	}
+}
 
 int input_event_from_user(const char __user *buffer,
-			  struct input_event *event)
+			  struct input_value *event, int if_type)
 {
-	if (INPUT_COMPAT_TEST && !COMPAT_USE_64BIT_TIME) {
-		struct input_event_compat compat_event;
-
-		if (copy_from_user(&compat_event, buffer,
-				   sizeof(struct input_event_compat)))
-			return -EFAULT;
-
-		event->time.tv_sec = compat_event.time.tv_sec;
-		event->time.tv_usec = compat_event.time.tv_usec;
-		event->type = compat_event.type;
-		event->code = compat_event.code;
-		event->value = compat_event.value;
-
-	} else {
-		if (copy_from_user(event, buffer, sizeof(struct input_event)))
+	if (if_type == EV_IF_LEGACY) {
+#ifdef CONFIG_COMPAT
+		if (INPUT_COMPAT_TEST && !COMPAT_USE_64BIT_TIME) {
+			struct input_event_compat compat_event;
+
+			if (copy_from_user(&compat_event, buffer,
+					   sizeof(struct input_event_compat)))
+				return -EFAULT;
+
+			event->type = compat_event.type;
+			event->code = compat_event.code;
+			event->value = compat_event.value;
+		} else {
+#endif
+			struct input_event ev;
+
+			if (copy_from_user(&ev, buffer,
+						sizeof(struct input_event)))
+				return -EFAULT;
+
+			/* drop timestamp from userspace */
+			event->type = ev.type;
+			event->code = ev.code;
+			event->value = ev.value;
+#ifdef CONFIG_COMPAT
+		}
+#endif
+	} else if (if_type == EV_IF_RAW || if_type == EV_IF_COMPOSITE) {
+		if (copy_from_user(event, buffer, sizeof(struct input_value)))
 			return -EFAULT;
-	}
+	} else
+		return -EINVAL;
 
 	return 0;
 }
 
-int input_event_to_user(char __user *buffer,
-			const struct input_event *event)
+int input_event_to_user(char __user *buffer, const struct input_value *event,
+			int clk_type, int if_type)
 {
-	if (INPUT_COMPAT_TEST && !COMPAT_USE_64BIT_TIME) {
-		struct input_event_compat compat_event;
-
-		compat_event.time.tv_sec = event->time.tv_sec;
-		compat_event.time.tv_usec = event->time.tv_usec;
-		compat_event.type = event->type;
-		compat_event.code = event->code;
-		compat_event.value = event->value;
+	if (if_type == EV_IF_LEGACY) {
+		struct timeval timestamp = ktime_to_timeval(
+				input_get_time(clk_type));
 
-		if (copy_to_user(buffer, &compat_event,
-				 sizeof(struct input_event_compat)))
+#ifdef CONFIG_COMPAT
+		if (INPUT_COMPAT_TEST && !COMPAT_USE_64BIT_TIME) {
+			struct input_event_compat compat_event;
+
+			compat_event.time.tv_sec = timestamp.tv_sec;
+			compat_event.time.tv_usec = timestamp.tv_usec;
+			compat_event.type = event->type;
+			compat_event.code = event->code;
+			compat_event.value = event->value;
+
+			if (copy_to_user(buffer, &compat_event,
+					 sizeof(struct input_event_compat)))
+				return -EFAULT;
+		} else {
+#endif
+			struct input_event ev;
+
+			ev.time = timestamp;
+			ev.type = event->type;
+			ev.code = event->code;
+			ev.value = event->value;
+
+			if (copy_to_user(buffer, &ev,
+					sizeof(struct input_event)))
+				return -EFAULT;
+#ifdef CONFIG_COMPAT
+		}
+#endif
+	} else if (if_type == EV_IF_RAW || if_type == EV_IF_COMPOSITE) {
+		if (copy_to_user(buffer, event, sizeof(struct input_value)))
 			return -EFAULT;
 
-	} else {
-		if (copy_to_user(buffer, event, sizeof(struct input_event)))
-			return -EFAULT;
-	}
+		if (if_type != EV_IF_RAW) {
+			/*
+			 * composite interface, send timestamp event
+			 *
+			 * s64 and input_value are the same size, use s64
+			 * directly here.
+			 */
+			s64 time = ktime_to_ns(input_get_time(clk_type));
+
+			if (copy_to_user(buffer + sizeof(struct input_value),
+						&time, sizeof(s64)))
+				return -EFAULT;
+		}
+	} else
+		return -EINVAL;
 
 	return 0;
 }
 
+#ifdef CONFIG_COMPAT
+
 int input_ff_effect_from_user(const char __user *buffer, size_t size,
 			      struct ff_effect *effect)
 {
@@ -99,24 +161,6 @@ int input_ff_effect_from_user(const char __user *buffer, size_t size,
 
 #else
 
-int input_event_from_user(const char __user *buffer,
-			 struct input_event *event)
-{
-	if (copy_from_user(event, buffer, sizeof(struct input_event)))
-		return -EFAULT;
-
-	return 0;
-}
-
-int input_event_to_user(char __user *buffer,
-			const struct input_event *event)
-{
-	if (copy_to_user(buffer, event, sizeof(struct input_event)))
-		return -EFAULT;
-
-	return 0;
-}
-
 int input_ff_effect_from_user(const char __user *buffer, size_t size,
 			      struct ff_effect *effect)
 {
diff --git a/drivers/input/input-compat.h b/drivers/input/input-compat.h
index 148f66f..4ee8095 100644
--- a/drivers/input/input-compat.h
+++ b/drivers/input/input-compat.h
@@ -65,26 +65,48 @@ struct ff_effect_compat {
 	} u;
 };
 
-static inline size_t input_event_size(void)
-{
-	return (INPUT_COMPAT_TEST && !COMPAT_USE_64BIT_TIME) ?
-		sizeof(struct input_event_compat) : sizeof(struct input_event);
-}
+#endif /* CONFIG_COMPAT */
 
-#else
+enum event_clock_type {
+	EV_CLK_REAL = 0,
+	EV_CLK_MONO,
+	EV_CLK_BOOT,
+	EV_CLK_MAX
+};
+
+enum event_if_type {
+	EV_IF_LEGACY = 0,
+	EV_IF_RAW,
+	EV_IF_COMPOSITE,
+	EV_IF_MAX
+};
 
-static inline size_t input_event_size(void)
+static inline size_t input_event_size(int if_type)
 {
-	return sizeof(struct input_event);
+	switch (if_type) {
+	case EV_IF_LEGACY:
+#ifdef CONFIG_COMPAT
+		if (INPUT_COMPAT_TEST && !COMPAT_USE_64BIT_TIME)
+			return sizeof(struct input_event_compat);
+#endif
+		return sizeof(struct input_event);
+	case EV_IF_RAW:
+		return sizeof(struct input_value);
+	case EV_IF_COMPOSITE:
+		return sizeof(struct input_composite_event);
+	default:
+		return 0;
+	}
 }
 
-#endif /* CONFIG_COMPAT */
-
 int input_event_from_user(const char __user *buffer,
-			 struct input_event *event);
+			  struct input_value *event, int if_type);
+
+int input_event_to_user(char __user *buffer, const struct input_value *event,
+			int clk_type, int if_type);
 
-int input_event_to_user(char __user *buffer,
-			const struct input_event *event);
+#define input_value_to_user(buffer, event, if_type)	\
+	input_event_to_user(buffer, event, 0, if_type)
 
 int input_ff_effect_from_user(const char __user *buffer, size_t size,
 			      struct ff_effect *effect);
diff --git a/include/linux/input.h b/include/linux/input.h
index 1e96769..9f9d551 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -25,18 +25,6 @@
 #include <linux/mod_devicetable.h>
 
 /**
- * struct input_value - input value representation
- * @type: type of value (EV_KEY, EV_ABS, etc)
- * @code: the value code
- * @value: the value
- */
-struct input_value {
-	__u16 type;
-	__u16 code;
-	__s32 value;
-};
-
-/**
  * struct input_dev - represents an input device
  * @name: name of the device
  * @phys: physical path to the device in the system hierarchy
diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
index 2758687..79b35ff 100644
--- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -29,6 +29,23 @@ struct input_event {
 	__s32 value;
 };
 
+/**
+ * struct input_value - input value representation
+ * @type: type of value (EV_KEY, EV_ABS, etc)
+ * @code: the value code
+ * @value: the value
+ */
+struct input_value {
+	__u16 type;
+	__u16 code;
+	__s32 value;
+};
+
+struct input_composite_event {
+	struct input_value v;
+	__s64 time;
+};
+
 /*
  * Protocol version.
  */
-- 
1.9.1

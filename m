From: WEN Pingbo <pingbo.wen@linaro.org>
Subject: [PATCH 3/3] uinput: convert input_event to input_value
Date: Fri, 27 Nov 2015 18:00:32 +0800
Message-ID: <1448618432-32357-4-git-send-email-pingbo.wen@linaro.org>
References: <1448618432-32357-1-git-send-email-pingbo.wen@linaro.org>
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <1448618432-32357-1-git-send-email-pingbo.wen@linaro.org>
Sender: linux-input-owner@vger.kernel.org
To: y2038@list.linaro.org, dmitry.torokhov@gmail.com, aksgarg1989@gmail.com, arnd@arndb.de
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, WEN Pingbo <pingbo.wen@linaro.org>
List-Id: linux-api@vger.kernel.org

This patch depends on 'add new evdev interface'.

We should not use input_event in kernel any more. Convert it in
uinput, and adapt to new api changes.

Signed-off-by: WEN Pingbo <pingbo.wen@linaro.org>
---
 drivers/input/misc/uinput.c | 23 +++++++++++------------
 include/linux/uinput.h      |  2 +-
 2 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/drivers/input/misc/uinput.c b/drivers/input/misc/uinput.c
index 5adbced..d84c6d4 100644
--- a/drivers/input/misc/uinput.c
+++ b/drivers/input/misc/uinput.c
@@ -50,7 +50,6 @@ static int uinput_dev_event(struct input_dev *dev,
 	udev->buff[udev->head].type = type;
 	udev->buff[udev->head].code = code;
 	udev->buff[udev->head].value = value;
-	do_gettimeofday(&udev->buff[udev->head].time);
 	udev->head = (udev->head + 1) % UINPUT_BUFFER_SIZE;
 
 	wake_up_interruptible(&udev->waitq);
@@ -436,24 +435,24 @@ static int uinput_setup_device(struct uinput_device *udev,
 static ssize_t uinput_inject_events(struct uinput_device *udev,
 				    const char __user *buffer, size_t count)
 {
-	struct input_event ev;
+	struct input_value ev;
 	size_t bytes = 0;
 
-	if (count != 0 && count < input_event_size())
+	if (count != 0 && count < input_event_size(EV_IF_LEGACY))
 		return -EINVAL;
 
-	while (bytes + input_event_size() <= count) {
+	while (bytes + input_event_size(EV_IF_LEGACY) <= count) {
 		/*
 		 * Note that even if some events were fetched successfully
 		 * we are still going to return EFAULT instead of partial
 		 * count to let userspace know that it got it's buffers
 		 * all wrong.
 		 */
-		if (input_event_from_user(buffer + bytes, &ev))
+		if (input_event_from_user(buffer + bytes, &ev, EV_IF_LEGACY))
 			return -EFAULT;
 
 		input_event(udev->dev, ev.type, ev.code, ev.value);
-		bytes += input_event_size();
+		bytes += input_event_size(EV_IF_LEGACY);
 	}
 
 	return bytes;
@@ -482,7 +481,7 @@ static ssize_t uinput_write(struct file *file, const char __user *buffer,
 }
 
 static bool uinput_fetch_next_event(struct uinput_device *udev,
-				    struct input_event *event)
+				    struct input_value *event)
 {
 	bool have_event;
 
@@ -502,16 +501,16 @@ static bool uinput_fetch_next_event(struct uinput_device *udev,
 static ssize_t uinput_events_to_user(struct uinput_device *udev,
 				     char __user *buffer, size_t count)
 {
-	struct input_event event;
+	struct input_value event;
 	size_t read = 0;
 
-	while (read + input_event_size() <= count &&
+	while (read + input_event_size(EV_IF_LEGACY) <= count &&
 	       uinput_fetch_next_event(udev, &event)) {
 
-		if (input_event_to_user(buffer + read, &event))
+		if (input_value_to_user(buffer + read, &event, EV_IF_LEGACY))
 			return -EFAULT;
 
-		read += input_event_size();
+		read += input_event_size(EV_IF_LEGACY);
 	}
 
 	return read;
@@ -523,7 +522,7 @@ static ssize_t uinput_read(struct file *file, char __user *buffer,
 	struct uinput_device *udev = file->private_data;
 	ssize_t retval;
 
-	if (count != 0 && count < input_event_size())
+	if (count != 0 && count < input_event_size(EV_IF_LEGACY))
 		return -EINVAL;
 
 	do {
diff --git a/include/linux/uinput.h b/include/linux/uinput.h
index 0994c0d..bdb6fca 100644
--- a/include/linux/uinput.h
+++ b/include/linux/uinput.h
@@ -66,7 +66,7 @@ struct uinput_device {
 	unsigned char		ready;
 	unsigned char		head;
 	unsigned char		tail;
-	struct input_event	buff[UINPUT_BUFFER_SIZE];
+	struct input_value	buff[UINPUT_BUFFER_SIZE];
 	unsigned int		ff_effects_max;
 
 	struct uinput_request	*requests[UINPUT_NUM_REQUESTS];
-- 
1.9.1


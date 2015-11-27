From: WEN Pingbo <pingbo.wen@linaro.org>
Subject: [PATCH 2/3] input: evdev: add new ioctl EVIOCSIFTYPE / EVIOCGIFTYPE
Date: Fri, 27 Nov 2015 18:00:31 +0800
Message-ID: <1448618432-32357-3-git-send-email-pingbo.wen@linaro.org>
References: <1448618432-32357-1-git-send-email-pingbo.wen@linaro.org>
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <1448618432-32357-1-git-send-email-pingbo.wen@linaro.org>
Sender: linux-input-owner@vger.kernel.org
To: y2038@list.linaro.org, dmitry.torokhov@gmail.com, aksgarg1989@gmail.com, arnd@arndb.de
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, WEN Pingbo <pingbo.wen@linaro.org>
List-Id: linux-api@vger.kernel.org

This patch depends on 'introduce new evdev interface'.

Userspace cat set / get evdev interface type via the two ioctl
commands. And default interface type is EV_IF_LEGACY, so the old binary
will work normal with new kernel. Maybe we should change this default
option to encourage people to move to new interface.

And since all events are stored as input_value in evdev, there are no
need to flush evdev_client's buffer if we change clk_type and if_type.

Signed-off-by: WEN Pingbo <pingbo.wen@linaro.org>
---
 drivers/input/evdev.c      | 39 +++++++++++++++++++++++++++------------
 include/uapi/linux/input.h | 10 ++++++++++
 2 files changed, 37 insertions(+), 12 deletions(-)

diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
index 170681b..090576b 100644
--- a/drivers/input/evdev.c
+++ b/drivers/input/evdev.c
@@ -175,7 +175,6 @@ static void evdev_queue_syn_dropped(struct evdev_client *client)
 
 static int evdev_set_clk_type(struct evdev_client *client, unsigned int clkid)
 {
-	unsigned long flags;
 	unsigned int clk_type;
 
 	switch (clkid) {
@@ -193,21 +192,29 @@ static int evdev_set_clk_type(struct evdev_client *client, unsigned int clkid)
 		return -EINVAL;
 	}
 
-	if (client->clk_type != clk_type) {
+	if (client->clk_type != clk_type)
 		client->clk_type = clk_type;
 
-		/*
-		 * Flush pending events and queue SYN_DROPPED event,
-		 * but only if the queue is not empty.
-		 */
-		spin_lock_irqsave(&client->buffer_lock, flags);
+	return 0;
+}
 
-		if (client->head != client->tail) {
-			client->packet_head = client->head = client->tail;
-			__evdev_queue_syn_dropped(client);
-		}
+static int evdev_set_if_type(struct evdev_client *client, unsigned int if_type)
+{
+	if (client->if_type == if_type)
+		return 0;
 
-		spin_unlock_irqrestore(&client->buffer_lock, flags);
+	switch (if_type) {
+	case EVDEV_LEGACY:
+		client->if_type = EV_IF_LEGACY;
+		break;
+	case EVDEV_RAW:
+		client->if_type = EV_IF_RAW;
+		break;
+	case EVDEV_COMPOSITE:
+		client->if_type = EV_IF_COMPOSITE;
+		break;
+	default:
+		return -EINVAL;
 	}
 
 	return 0;
@@ -1046,6 +1053,7 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 	int __user *ip = (int __user *)p;
 	unsigned int i, t, u, v;
 	unsigned int size;
+	int if_type;
 	int error;
 
 	/* First we check for fixed-length commands */
@@ -1144,6 +1152,13 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
 
 	case EVIOCSKEYCODE_V2:
 		return evdev_handle_set_keycode_v2(dev, p);
+	case EVIOCSIFTYPE:
+		if (get_user(if_type, ip))
+			return -EFAULT;
+
+		return evdev_set_if_type(client, if_type);
+	case EVIOCGIFTYPE:
+		return put_user(client->if_type, ip);
 	}
 
 	size = _IOC_SIZE(cmd);
diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
index 79b35ff..9ae5243 100644
--- a/include/uapi/linux/input.h
+++ b/include/uapi/linux/input.h
@@ -234,6 +234,16 @@ struct input_mask {
 
 #define EVIOCSCLOCKID		_IOW('E', 0xa0, int)			/* Set clockid to be used for timestamps */
 
+#define EVIOCSIFTYPE		_IOW('E', 0xa1, int)			/* Set if_type */
+#define EVIOCGIFTYPE		_IOR('E', 0xa2, int)			/* Get if_type */
+
+/*
+ * evdev interface type
+ */
+#define EVDEV_LEGACY			0x00
+#define EVDEV_RAW			0x01
+#define EVDEV_COMPOSITE			0x02
+
 /*
  * IDs.
  */
-- 
1.9.1


From: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 12/14] usb: Add USB subsystem notifications [ver #3]
Date: Wed, 15 Jan 2020 13:32:22 +0000
Message-ID: <157909514270.20155.15305842826442957104.stgit@warthog.procyon.org.uk>
References: <157909503552.20155.3030058841911628518.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <157909503552.20155.3030058841911628518.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Casey Schaufler <casey-iSGtlc1asvQWG2LlvL+J4A@public.gmane.org>, Stephen Smalley <sds-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, nicolas.dichtel-pdR9zngts4EAvxtiuMwx3w@public.gmane.org, raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org, Christian Brauner <christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org>dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, keyrings-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.orglinux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add a USB subsystem notification mechanism whereby notifications about
hardware events such as device connection, disconnection, reset and I/O
errors, can be reported to a monitoring process asynchronously.

Firstly, an event queue needs to be created:

	pipe2(fds, O_NOTIFICATION_PIPE);
	ioctl(fds[1], IOC_WATCH_QUEUE_SET_SIZE, 256);

then a notification can be set up to report USB notifications via that
queue:

	struct watch_notification_filter filter = {
		.nr_filters = 1,
		.filters = {
			[0] = {
				.type = WATCH_TYPE_USB_NOTIFY,
				.subtype_filter[0] = UINT_MAX;
			},
		},
	};
	ioctl(fds[1], IOC_WATCH_QUEUE_SET_FILTER, &filter);
	notify_devices(fds[1], 12);

After that, messages will be placed into the queue when events occur on a
USB device or bus.  Messages are of the following format:

	struct usb_notification {
		struct watch_notification watch;
		__u32	error;
		__u32	reserved;
		__u8	name_len;
		__u8	name[0];
	} *n;

Where:

	n->watch.type will be WATCH_TYPE_USB_NOTIFY

	n->watch.subtype will be the type of notification, such as
	NOTIFY_USB_DEVICE_ADD.

	n->watch.info & WATCH_INFO_LENGTH will indicate the length of the
	message.

	n->watch.info & WATCH_INFO_ID will be the second argument to
	device_notify(), shifted.

	n->error and n->reserved are intended to convey information such as
	error codes, but are currently not used

	n->name_len and n->name convey the USB device name as an
	unterminated string.  This may be truncated - it is currently
	limited to a maximum 63 chars.

Note that it is permissible for messages to be of variable length - or, at
least, the length may be dependent on the subtype.

Signed-off-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---

 Documentation/watch_queue.rst    |    9 +++++++
 drivers/usb/core/Kconfig         |    9 +++++++
 drivers/usb/core/devio.c         |   47 ++++++++++++++++++++++++++++++++++++++
 drivers/usb/core/hub.c           |    4 +++
 include/linux/usb.h              |   18 +++++++++++++++
 include/uapi/linux/watch_queue.h |   28 ++++++++++++++++++++++-
 samples/watch_queue/watch_test.c |   29 +++++++++++++++++++++++
 7 files changed, 142 insertions(+), 2 deletions(-)

diff --git a/Documentation/watch_queue.rst b/Documentation/watch_queue.rst
index f2299f631ae8..5321a9cb1ab2 100644
--- a/Documentation/watch_queue.rst
+++ b/Documentation/watch_queue.rst
@@ -12,6 +12,8 @@ opened by userspace.  This can be used in conjunction with::
 
     * Block layer event notifications
 
+    * USB subsystem event notifications
+
 
 The notifications buffers can be enabled by:
 
@@ -262,6 +264,13 @@ Any particular buffer can be fed from multiple sources.  Sources include:
     or temporary link loss.  Watches of this type are set on the global device
     watch list.
 
+  * WATCH_TYPE_USB_NOTIFY
+
+    Notifications of this type indicate USB subsystem events, such as
+    attachment, removal, reset and I/O errors.  Separate events are generated
+    for buses and devices.  Watchpoints of this type are set on the global
+    device watch list.
+
 
 Event Filtering
 ===============
diff --git a/drivers/usb/core/Kconfig b/drivers/usb/core/Kconfig
index ecaacc8ed311..57e7b649e48b 100644
--- a/drivers/usb/core/Kconfig
+++ b/drivers/usb/core/Kconfig
@@ -102,3 +102,12 @@ config USB_AUTOSUSPEND_DELAY
 	  The default value Linux has always had is 2 seconds.  Change
 	  this value if you want a different delay and cannot modify
 	  the command line or module parameter.
+
+config USB_NOTIFICATIONS
+	bool "Provide USB hardware event notifications"
+	depends on USB && DEVICE_NOTIFICATIONS
+	help
+	  This option provides support for getting hardware event notifications
+	  on USB devices and interfaces.  This makes use of the
+	  /dev/watch_queue misc device to handle the notification buffer.
+	  device_notify(2) is used to set/remove watches.
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index 12bb5722b420..3436a2bb6e98 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -41,6 +41,7 @@
 #include <linux/dma-mapping.h>
 #include <asm/byteorder.h>
 #include <linux/moduleparam.h>
+#include <linux/watch_queue.h>
 
 #include "usb.h"
 
@@ -2747,13 +2748,59 @@ static void usbdev_remove(struct usb_device *udev)
 	mutex_unlock(&usbfs_mutex);
 }
 
+#ifdef CONFIG_USB_NOTIFICATIONS
+static noinline void post_usb_notification(const char *devname,
+					   enum usb_notification_type subtype,
+					   u32 error)
+{
+	unsigned int name_len, n_len;
+	u64 id = 0; /* We can put a device ID here for separate dev watches */
+
+	struct {
+		struct usb_notification n;
+		char more_name[USB_NOTIFICATION_MAX_NAME_LEN -
+			       (sizeof(struct usb_notification) -
+				offsetof(struct usb_notification, name))];
+	} n;
+
+	name_len = strlen(devname);
+	name_len = min_t(size_t, name_len, USB_NOTIFICATION_MAX_NAME_LEN);
+	n_len = offsetof(struct usb_notification, name) + name_len;
+
+	memset(&n, 0, sizeof(n));
+	memcpy(n.n.name, devname, n_len);
+
+	n.n.watch.type		= WATCH_TYPE_USB_NOTIFY;
+	n.n.watch.subtype	= subtype;
+	n.n.watch.info		= n_len;
+	n.n.error		= error;
+	n.n.name_len		= name_len;
+
+	post_device_notification(&n.n.watch, id);
+}
+
+void post_usb_device_notification(const struct usb_device *udev,
+				  enum usb_notification_type subtype, u32 error)
+{
+	post_usb_notification(dev_name(&udev->dev), subtype, error);
+}
+
+void post_usb_bus_notification(const struct usb_bus *ubus,
+			       enum usb_notification_type subtype, u32 error)
+{
+	post_usb_notification(ubus->bus_name, subtype, error);
+}
+#endif
+
 static int usbdev_notify(struct notifier_block *self,
 			       unsigned long action, void *dev)
 {
 	switch (action) {
 	case USB_DEVICE_ADD:
+		post_usb_device_notification(dev, NOTIFY_USB_DEVICE_ADD, 0);
 		break;
 	case USB_DEVICE_REMOVE:
+		post_usb_device_notification(dev, NOTIFY_USB_DEVICE_REMOVE, 0);
 		usbdev_remove(dev);
 		break;
 	}
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index f229ad6952c0..eaf28eed51b0 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -30,6 +30,7 @@
 #include <linux/random.h>
 #include <linux/pm_qos.h>
 #include <linux/kobject.h>
+#include <linux/watch_queue.h>
 
 #include <linux/uaccess.h>
 #include <asm/byteorder.h>
@@ -4606,6 +4607,9 @@ hub_port_init(struct usb_hub *hub, struct usb_device *udev, int port1,
 				(udev->config) ? "reset" : "new", speed,
 				devnum, driver_name);
 
+	if (udev->config)
+		post_usb_device_notification(udev, NOTIFY_USB_DEVICE_RESET, 0);
+
 	/* Set up TT records, if needed  */
 	if (hdev->tt) {
 		udev->tt = hdev->tt;
diff --git a/include/linux/usb.h b/include/linux/usb.h
index e656e7b4b1e4..93fa0666f95a 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -26,6 +26,7 @@
 struct usb_device;
 struct usb_driver;
 struct wusb_dev;
+enum usb_notification_type;
 
 /*-------------------------------------------------------------------------*/
 
@@ -2015,6 +2016,23 @@ extern void usb_led_activity(enum usb_led_event ev);
 static inline void usb_led_activity(enum usb_led_event ev) {}
 #endif
 
+/*
+ * Notification functions.
+ */
+#ifdef CONFIG_USB_NOTIFICATIONS
+extern void post_usb_device_notification(const struct usb_device *udev,
+					 enum usb_notification_type subtype,
+					 u32 error);
+extern void post_usb_bus_notification(const struct usb_bus *ubus,
+				      enum usb_notification_type subtype,
+				      u32 error);
+#else
+static inline void post_usb_device_notification(const struct usb_device *udev,
+						unsigned int subtype, u32 error) {}
+static inline void post_usb_bus_notification(const struct usb_bus *ubus,
+					     unsigned int subtype, u32 error) {}
+#endif
+
 #endif  /* __KERNEL__ */
 
 #endif
diff --git a/include/uapi/linux/watch_queue.h b/include/uapi/linux/watch_queue.h
index 557771413242..ad1ae229674a 100644
--- a/include/uapi/linux/watch_queue.h
+++ b/include/uapi/linux/watch_queue.h
@@ -15,7 +15,8 @@ enum watch_notification_type {
 	WATCH_TYPE_META		= 0,	/* Special record */
 	WATCH_TYPE_KEY_NOTIFY	= 1,	/* Key change event notification */
 	WATCH_TYPE_BLOCK_NOTIFY	= 2,	/* Block layer event notification */
-	WATCH_TYPE__NR		= 3
+	WATCH_TYPE_USB_NOTIFY	= 3,	/* USB subsystem event notification */
+	WATCH_TYPE__NR		= 4
 };
 
 enum watch_meta_notification_subtype {
@@ -129,4 +130,29 @@ struct block_notification {
 	__u64	sector;			/* Affected sector */
 };
 
+/*
+ * Type of USB layer notification.
+ */
+enum usb_notification_type {
+	NOTIFY_USB_DEVICE_ADD		= 0, /* USB device added */
+	NOTIFY_USB_DEVICE_REMOVE	= 1, /* USB device removed */
+	NOTIFY_USB_DEVICE_RESET		= 2, /* USB device reset */
+	NOTIFY_USB_DEVICE_ERROR		= 3, /* USB device error */
+};
+
+/*
+ * USB subsystem notification record.
+ * - watch.type = WATCH_TYPE_USB_NOTIFY
+ * - watch.subtype = enum usb_notification_type
+ */
+struct usb_notification {
+	struct watch_notification watch; /* WATCH_TYPE_USB_NOTIFY */
+	__u32	error;
+	__u32	reserved;
+	__u8	name_len;		/* Length of device name */
+	__u8	name[0];		/* Device name (padded to __u64, truncated at 63 chars) */
+};
+
+#define USB_NOTIFICATION_MAX_NAME_LEN 63
+
 #endif /* _UAPI_LINUX_WATCH_QUEUE_H */
diff --git a/samples/watch_queue/watch_test.c b/samples/watch_queue/watch_test.c
index f5260fb792d1..e4d47dfcc5d7 100644
--- a/samples/watch_queue/watch_test.c
+++ b/samples/watch_queue/watch_test.c
@@ -84,6 +84,26 @@ static void saw_block_change(struct watch_notification *n, size_t len)
 	       (unsigned long long)b->sector);
 }
 
+static const char *usb_subtypes[256] = {
+	[NOTIFY_USB_DEVICE_ADD]		= "dev-add",
+	[NOTIFY_USB_DEVICE_REMOVE]	= "dev-remove",
+	[NOTIFY_USB_DEVICE_RESET]	= "dev-reset",
+	[NOTIFY_USB_DEVICE_ERROR]	= "dev-error",
+};
+
+static void saw_usb_event(struct watch_notification *n, size_t len)
+{
+	struct usb_notification *u = (struct usb_notification *)n;
+
+	if (len < sizeof(struct usb_notification))
+		return;
+
+	printf("USB %*.*s %s e=%x r=%x\n",
+	       u->name_len, u->name_len, u->name,
+	       usb_subtypes[n->subtype],
+	       u->error, u->reserved);
+}
+
 /*
  * Consume and display events.
  */
@@ -160,6 +180,9 @@ static void consumer(int fd)
 			case WATCH_TYPE_BLOCK_NOTIFY:
 				saw_block_change(&n.n, len);
 				break;
+			case WATCH_TYPE_USB_NOTIFY:
+				saw_usb_event(&n.n, len);
+				break;
 			default:
 				printf("other type\n");
 				break;
@@ -171,7 +194,7 @@ static void consumer(int fd)
 }
 
 static struct watch_notification_filter filter = {
-	.nr_filters	= 2,
+	.nr_filters	= 3,
 	.filters = {
 		[0]	= {
 			.type			= WATCH_TYPE_KEY_NOTIFY,
@@ -181,6 +204,10 @@ static struct watch_notification_filter filter = {
 			.type			= WATCH_TYPE_BLOCK_NOTIFY,
 			.subtype_filter[0]	= UINT_MAX,
 		},
+		[2]	= {
+			.type			= WATCH_TYPE_USB_NOTIFY,
+			.subtype_filter[0]	= UINT_MAX,
+		},
 	},
 };
 

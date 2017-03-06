From: Sean Young <sean@mess.org>
Subject: [PATCH] [media] lirc: introduce LIRC_SET_POLL_MODE
Date: Mon, 6 Mar 2017 16:16:04 +0000
Message-ID: <20170306161604.GA19637@gofer.mess.org>
References: <cover.1488023302.git.sean@mess.org>
 <b9722d41efc7dd75ddbab78a62f654aa56d9a0a3.1488023302.git.sean@mess.org>
 <20170302133116.GA29616@gofer.mess.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-media-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170302133116.GA29616@gofer.mess.org>
Sender: linux-media-owner@vger.kernel.org
To: linux-media@vger.kernel.org
Cc: linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

If you want to poll for both decoded scancodes and raw IR, then this
ioctl will help you.

int fd = open("/dev/lirc0", O_RDONLY | O_NONBLOCK);

for (;;) {
	unsigned mode = LIRC_MODE_SCANCODE | LIRC_MODE_MODE2;
	ioctl(fd, LIRC_SET_POLL_MODE, &mode);
	poll(&((struct pollfd){ .fd = fd, .events = POLLIN }), 1, -1);
	mode = LIRC_MODE_SCANCODE;
	ioctl(fd, LIRC_SET_REC_MODE, &mode);
	struct lirc_scancode sc;
	if (read(fd, &sc, sizeof(sc)) == sizeof(sc)) {
		printf("scancode protocol:%d scancode:%llx\n",
			sc.rc_type, sc.scancode);
	}
	mode = LIRC_MODE_MODE2;
	ioctl(fd, LIRC_SET_REC_MODE, &mode);
	unsigned sample;
	if (read(fd, &sample, sizeof(sample)) == sizeof(sample)) {
		if (LIRC_IS_SPACE(sample))
			printf("space %u\n", LIRC_VAL(sample)));
		if (LIRC_IS_PULSE(sample))
			printf("pulse %u\n", LIRC_VAL(sample)));
	}
}

Note that LIRC_SET_REC_MODE will also affect the poll mode, so you
must set it again before calling poll.

Signed-off-by: Sean Young <sean@mess.org>
---
 Documentation/media/uapi/rc/lirc-func.rst          |  1 +
 Documentation/media/uapi/rc/lirc-set-poll-mode.rst | 44 ++++++++++++++++++++++
 drivers/media/rc/ir-lirc-codec.c                   | 29 ++++++++++++--
 drivers/media/rc/rc-core-priv.h                    |  1 +
 include/uapi/linux/lirc.h                          |  9 +++++
 5 files changed, 80 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/media/uapi/rc/lirc-set-poll-mode.rst

diff --git a/Documentation/media/uapi/rc/lirc-func.rst b/Documentation/media/uapi/rc/lirc-func.rst
index 9b5a772..3ae92af 100644
--- a/Documentation/media/uapi/rc/lirc-func.rst
+++ b/Documentation/media/uapi/rc/lirc-func.rst
@@ -26,3 +26,4 @@ LIRC Function Reference
     lirc-set-rec-timeout-reports
     lirc-set-measure-carrier-mode
     lirc-set-wideband-receiver
+    lirc-set-poll-mode
diff --git a/Documentation/media/uapi/rc/lirc-set-poll-mode.rst b/Documentation/media/uapi/rc/lirc-set-poll-mode.rst
new file mode 100644
index 0000000..56112bb
--- /dev/null
+++ b/Documentation/media/uapi/rc/lirc-set-poll-mode.rst
@@ -0,0 +1,44 @@
+.. -*- coding: utf-8; mode: rst -*-
+
+.. _lirc_set_poll_mode:
+
+**********************************************
+ioctls LIRC_SET_POLL_MODE
+**********************************************
+
+Name
+====
+
+LIRC_SET_POLL_MODE - Set poll modes
+
+Synopsis
+========
+
+.. c:function:: int ioctl( int fd, LIRC_SET_POLL_MODE, __u32 modes)
+	:name: LIRC_SET_POLL_MODE
+
+Arguments
+=========
+
+``fd``
+    File descriptor returned by open().
+
+``modes``
+    Bitmask with enabled poll lirc modes
+
+Description
+===========
+
+Set lirc modes for which read readiness is reported by poll. Only
+:ref:`LIRC_MODE_MODE2 <lirc-mode-mode2>` and
+:ref:`LIRC_MODE_SCANCODE <lirc-mode-scancode>` are supported.
+Use :ref:`lirc_get_features` to find out which modes the driver supports.
+
+Note that using :ref:`lirc-set-rec-mode` resets the poll mode.
+
+Return Value
+============
+
+On success 0 is returned, on error -1 and the ``errno`` variable is set
+appropriately. The generic error codes are described at the
+:ref:`Generic Error Codes <gen-errors>` chapter.
diff --git a/drivers/media/rc/ir-lirc-codec.c b/drivers/media/rc/ir-lirc-codec.c
index 960703a..a2a2229 100644
--- a/drivers/media/rc/ir-lirc-codec.c
+++ b/drivers/media/rc/ir-lirc-codec.c
@@ -258,6 +258,24 @@ static long ir_lirc_ioctl(struct file *filep, unsigned int cmd,
 		}
 
 		lirc->rec_mode = val;
+		lirc->poll_mode = val;
+		return 0;
+
+	case LIRC_SET_POLL_MODE:
+		switch (dev->driver_type) {
+		case RC_DRIVER_SCANCODE:
+			if (val != LIRC_MODE_SCANCODE)
+				return -EINVAL;
+			break;
+		case RC_DRIVER_IR_RAW:
+			if (val & ~(LIRC_MODE_SCANCODE | LIRC_MODE_MODE2))
+				return -EINVAL;
+			break;
+		default:
+			return -ENOTTY;
+		}
+
+		lirc->poll_mode = val;
 		return 0;
 
 	case LIRC_GET_SEND_MODE:
@@ -396,11 +414,12 @@ static unsigned int ir_lirc_poll(struct file *filep,
 
 	if (!lirc->drv.attached) {
 		events = POLLHUP;
-	} else if (lirc->rec_mode == LIRC_MODE_SCANCODE) {
-		if (!kfifo_is_empty(&lirc->scancodes))
+	} else {
+		if ((lirc->poll_mode & LIRC_MODE_SCANCODE) &&
+		    !kfifo_is_empty(&lirc->scancodes))
 			events = POLLIN | POLLRDNORM;
-	} else if (lirc->rec_mode == LIRC_MODE_MODE2) {
-		if (!kfifo_is_empty(&lirc->rawir))
+		if ((lirc->poll_mode & LIRC_MODE_MODE2) &&
+		    !kfifo_is_empty(&lirc->rawir))
 			events = POLLIN | POLLRDNORM;
 	}
 
@@ -512,11 +531,13 @@ int ir_lirc_register(struct rc_dev *dev)
 
 	if (dev->driver_type == RC_DRIVER_SCANCODE) {
 		features |= LIRC_CAN_REC_SCANCODE;
+		node->poll_mode = LIRC_MODE_SCANCODE;
 		node->rec_mode = LIRC_MODE_SCANCODE;
 	} else if (dev->driver_type == RC_DRIVER_IR_RAW) {
 		features |= LIRC_CAN_REC_MODE2 | LIRC_CAN_REC_SCANCODE;
 		if (dev->rx_resolution)
 			features |= LIRC_CAN_GET_REC_RESOLUTION;
+		node->poll_mode = LIRC_MODE_MODE2;
 		node->rec_mode = LIRC_MODE_MODE2;
 	}
 	if (dev->tx_ir) {
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index b73222a..d630009 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -51,6 +51,7 @@ struct lirc_node {
 	u64 gap_duration;
 	bool gap;
 	bool send_timeout_reports;
+	int poll_mode;
 	int send_mode;
 	int rec_mode;
 };
diff --git a/include/uapi/linux/lirc.h b/include/uapi/linux/lirc.h
index d04fc62..70e8a71 100644
--- a/include/uapi/linux/lirc.h
+++ b/include/uapi/linux/lirc.h
@@ -134,6 +134,15 @@
 #define LIRC_SET_WIDEBAND_RECEIVER     _IOW('i', 0x00000023, __u32)
 
 /*
+ * For raw IR devices, both raw IR (LIRC_MODE_MODE2) and decodes scancodes
+ * (LIRC_MODE_SCANCODE) can be read. By default, poll will show read
+ * ready for the last mode set by LIRC_SET_REC_MODE. Use LIRC_SET_POLL_MODE
+ * LIRC_MODE_SCANCODE | LIRC_MODE_MODE2 to show read ready for both
+ * modes.
+ */
+#define LIRC_SET_POLL_MODE	       _IOW('i', 0x00000024, __u32)
+
+/*
  * struct lirc_scancode - decoded scancodes with protocol
  * @timestamp: Timestamp in nanoseconds using CLOCK_MONOTONIC when IR
  *	was decoded.
-- 
2.9.3

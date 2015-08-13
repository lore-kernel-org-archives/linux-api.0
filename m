From: Amit Pundir <amit.pundir@linaro.org>
Subject: [RFC][PATCH 1/2] usb: gadget: configfs: add MTP function
Date: Fri, 14 Aug 2015 00:42:19 +0530
Message-ID: <1439493140-22207-2-git-send-email-amit.pundir@linaro.org>
References: <1439493140-22207-1-git-send-email-amit.pundir@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1439493140-22207-1-git-send-email-amit.pundir@linaro.org>
Sender: linux-doc-owner@vger.kernel.org
To: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org
Cc: Mike Lockwood <lockwood@android.com>, Benoit Goby <benoit@android.com>, Colin Cross <ccross@android.com>, =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, Peter Oh <poh@broadcom.com>, Greg Hackmann <ghackmann@google.com>, Badhri Jagan Sridharan <Badhri@google.com>, Android Kernel Team <kernel-team@android.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, Felipe Balbi <balbi@ti.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, Yegor Yefremov <yegorslists@googlemail.com>, Philippe Reynes <tremyfr@gmail.com>, John Stultz <john.stultz@linaro.org>, Sumit Semwal <sumit.semwal@linaro.org>
List-Id: linux-api@vger.kernel.org

This MTP function is based on years of work originally done in the
Android kernel tree by:
    Mike Lockwood <lockwood@android.com>
    Benoit Goby <benoit@android.com>
    Colin Cross <ccross@android.com>
    Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
    Peter Oh <poh@broadcom.com>
    Greg Hackmann <ghackmann@google.com>
    Badhri Jagan Sridharan <Badhri@google.com>
I've folded the series up to make it easier to review, and to provide
a coherent patch description.

Post Gingerbread (Android v2.3), Android dropped USB Mass Storage
in favor of Media Transfer Protocal (MTP), which is widely used for
transferring media files to digital music players and similar
applications. This USB gadget function implements MTP functionalty.

Historically this function has been a part of Android composite
gadget driver. Android composite driver was Android's solution
for dynamic gadget function switching prior to the ConfigFS gadget
being merged. There were failed few attempts in past
http://marc.info/?l=3Dlinux-usb&m=3D132451695808552 to upstream Android
composite driver as well. Now this Android MTP gadget function has been
re-implemented so as to be used as a generic ConfigFS function instead.

Again, many thanks to Mike, Benoit, Colin, Arve, Peter, Greg and Badhri=
,
as they are the real authors of this work. However, I've folded their
patches together and modified it enough that I don't want them to be
blamed for any mistakes I've made condensing their patches down.

Cc: Mike Lockwood <lockwood@android.com>
Cc: Benoit Goby <benoit@android.com>
Cc: Colin Cross <ccross@android.com>
Cc: Arve Hj=C3=B8nnev=C3=A5g <arve@android.com>
Cc: Peter Oh <poh@broadcom.com>
Cc: Greg Hackmann <ghackmann@google.com>
Cc: Badhri Jagan Sridharan <Badhri@google.com>
Cc: Android Kernel Team <kernel-team@android.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Felipe Balbi <balbi@ti.com>
Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Yegor Yefremov <yegorslists@googlemail.com>
Cc: Philippe Reynes <tremyfr@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
---
 Documentation/ABI/testing/configfs-usb-gadget-mtp |    7 +
 Documentation/usb/gadget-testing.txt              |   24 +
 drivers/usb/gadget/Kconfig                        |   13 +
 drivers/usb/gadget/function/Makefile              |    2 +
 drivers/usb/gadget/function/f_mtp.c               | 1365 +++++++++++++=
++++++++
 include/linux/usb/f_mtp.h                         |   23 +
 include/uapi/linux/usb/f_mtp.h                    |   61 +
 7 files changed, 1495 insertions(+)
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-mtp
 create mode 100644 drivers/usb/gadget/function/f_mtp.c
 create mode 100644 include/linux/usb/f_mtp.h
 create mode 100644 include/uapi/linux/usb/f_mtp.h

diff --git a/Documentation/ABI/testing/configfs-usb-gadget-mtp b/Docume=
ntation/ABI/testing/configfs-usb-gadget-mtp
new file mode 100644
index 0000000..6738bee
--- /dev/null
+++ b/Documentation/ABI/testing/configfs-usb-gadget-mtp
@@ -0,0 +1,7 @@
+What:		/config/usb-gadget/gadget/functions/mtp.name
+Date:		Aug 2015
+KernelVersion:	4.2
+Description:	The purpose of this directory is to create and remove it.
+
+		A corresponding USB function instance is created/removed.
+		There are no attributes here.
diff --git a/Documentation/usb/gadget-testing.txt b/Documentation/usb/g=
adget-testing.txt
index 5926780..7fb8494d4 100644
--- a/Documentation/usb/gadget-testing.txt
+++ b/Documentation/usb/gadget-testing.txt
@@ -20,6 +20,7 @@ provided by gadgets.
 17. UAC2 function
 18. UVC function
 19. PRINTER function
+20. MTP function
=20
=20
 1. ACM function
@@ -771,3 +772,26 @@ host:
=20
 More advanced testing can be done with the prn_example
 described in Documentation/usb/gadget-printer.txt.
+
+20. MTP function
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+The function is provided by usb_f_mtp.ko module.
+
+Function-specific configfs interface
+------------------------------------
+
+The function name to use when creating the function directory is "mtp"=
=2E
+The function directory is intentionally empty and has no attributes as=
 such.
+
+After creating the mtp function directory, link mtp function with the =
gadget
+configuration by creating symbolic link, enable the gadget by writing =
a
+suitable string to usb_gadget/<gadget>/UDC and start the mtp userspace=
 daemon.
+
+Testing the mtp function
+------------------------
+
+On the device: enable the gadget, and start the mtp userspace daemon.
+On the host: if configured correctly the media storage device should a=
uto-mount
+itself, or use Linux mtp-tools package to browse/transfer the media co=
ntent
+instead.
diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index bcf83c0..65d110d 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -199,6 +199,9 @@ config USB_F_HID
 config USB_F_PRINTER
 	tristate
=20
+config USB_F_MTP
+	tristate
+
 choice
 	tristate "USB Gadget Drivers"
 	default USB_ETH
@@ -451,6 +454,16 @@ config USB_CONFIGFS_F_PRINTER
 	  For more information, see Documentation/usb/gadget_printer.txt
 	  which includes sample code for accessing the device file.
=20
+config USB_CONFIGFS_F_MTP
+	bool "MTP gadget"
+	depends on USB_CONFIGFS
+	select USB_F_MTP
+	help
+	  The Media Transfer Protocol (MTP) function mounts USB gadget as
+	  a media device but unlike Mass Storage Gadget, MTP operates at
+	  the file level. Thus exposing the relevant content but hiding
+	  the system/restricted files.
+
 source "drivers/usb/gadget/legacy/Kconfig"
=20
 endchoice
diff --git a/drivers/usb/gadget/function/Makefile b/drivers/usb/gadget/=
function/Makefile
index bd7def5..11ef10f 100644
--- a/drivers/usb/gadget/function/Makefile
+++ b/drivers/usb/gadget/function/Makefile
@@ -44,3 +44,5 @@ usb_f_hid-y			:=3D f_hid.o
 obj-$(CONFIG_USB_F_HID)		+=3D usb_f_hid.o
 usb_f_printer-y			:=3D f_printer.o
 obj-$(CONFIG_USB_F_PRINTER)	+=3D usb_f_printer.o
+usb_f_mtp-y			:=3D f_mtp.o
+obj-$(CONFIG_USB_F_MTP)		+=3D usb_f_mtp.o
diff --git a/drivers/usb/gadget/function/f_mtp.c b/drivers/usb/gadget/f=
unction/f_mtp.c
new file mode 100644
index 0000000..3eedece
--- /dev/null
+++ b/drivers/usb/gadget/function/f_mtp.c
@@ -0,0 +1,1365 @@
+/*
+ * Gadget Function Driver for MTP
+ *
+ * Copyright (C) 2010 Google, Inc.
+ * Author: Mike Lockwood <lockwood@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, an=
d
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+/* #define DEBUG */
+/* #define VERBOSE_DEBUG */
+
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/poll.h>
+#include <linux/delay.h>
+#include <linux/wait.h>
+#include <linux/err.h>
+#include <linux/interrupt.h>
+
+#include <linux/types.h>
+#include <linux/file.h>
+#include <linux/device.h>
+#include <linux/miscdevice.h>
+
+#include <linux/usb.h>
+#include <linux/usb_usual.h>
+#include <linux/usb/ch9.h>
+#include <linux/usb/f_mtp.h>
+#include <linux/configfs.h>
+#include <linux/usb/composite.h>
+
+#include "configfs.h"
+
+#define MTP_BULK_BUFFER_SIZE       16384
+#define INTR_BUFFER_SIZE           28
+#define MAX_INST_NAME_LEN          40
+
+/* String IDs */
+#define INTERFACE_STRING_INDEX	0
+
+/* values for mtp_dev.state */
+#define STATE_OFFLINE               0   /* initial state, disconnected=
 */
+#define STATE_READY                 1   /* ready for userspace calls *=
/
+#define STATE_BUSY                  2   /* processing userspace calls =
*/
+#define STATE_CANCELED              3   /* transaction canceled by hos=
t */
+#define STATE_ERROR                 4   /* error from completion routi=
ne */
+
+/* number of tx and rx requests to allocate */
+#define TX_REQ_MAX 4
+#define RX_REQ_MAX 2
+#define INTR_REQ_MAX 5
+
+/* ID for Microsoft MTP OS String */
+#define MTP_OS_STRING_ID   0xEE
+
+/* MTP class reqeusts */
+#define MTP_REQ_CANCEL              0x64
+#define MTP_REQ_GET_EXT_EVENT_DATA  0x65
+#define MTP_REQ_RESET               0x66
+#define MTP_REQ_GET_DEVICE_STATUS   0x67
+
+/* constants for device status */
+#define MTP_RESPONSE_OK             0x2001
+#define MTP_RESPONSE_DEVICE_BUSY    0x2019
+#define DRIVER_NAME "mtp"
+
+static const char mtp_shortname[] =3D DRIVER_NAME "_usb";
+
+struct mtp_dev {
+	struct usb_function function;
+	struct usb_composite_dev *cdev;
+	spinlock_t lock;
+
+	struct usb_ep *ep_in;
+	struct usb_ep *ep_out;
+	struct usb_ep *ep_intr;
+
+	int state;
+
+	/* synchronize access to our device file */
+	atomic_t open_excl;
+	/* to enforce only one ioctl at a time */
+	atomic_t ioctl_excl;
+
+	struct list_head tx_idle;
+	struct list_head intr_idle;
+
+	wait_queue_head_t read_wq;
+	wait_queue_head_t write_wq;
+	wait_queue_head_t intr_wq;
+	struct usb_request *rx_req[RX_REQ_MAX];
+	int rx_done;
+
+	/* for processing MTP_SEND_FILE, MTP_RECEIVE_FILE and
+	 * MTP_SEND_FILE_WITH_HEADER ioctls on a work queue
+	 */
+	struct workqueue_struct *wq;
+	struct work_struct send_file_work;
+	struct work_struct receive_file_work;
+	struct file *xfer_file;
+	loff_t xfer_file_offset;
+	int64_t xfer_file_length;
+	unsigned xfer_send_header;
+	uint16_t xfer_command;
+	uint32_t xfer_transaction_id;
+	int xfer_result;
+};
+
+static struct usb_interface_descriptor mtp_interface_desc =3D {
+	.bLength                =3D USB_DT_INTERFACE_SIZE,
+	.bDescriptorType        =3D USB_DT_INTERFACE,
+	.bInterfaceNumber       =3D 0,
+	.bNumEndpoints          =3D 3,
+	.bInterfaceClass        =3D USB_CLASS_VENDOR_SPEC,
+	.bInterfaceSubClass     =3D USB_SUBCLASS_VENDOR_SPEC,
+	.bInterfaceProtocol     =3D 0,
+};
+
+static struct usb_endpoint_descriptor mtp_highspeed_in_desc =3D {
+	.bLength                =3D USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType        =3D USB_DT_ENDPOINT,
+	.bEndpointAddress       =3D USB_DIR_IN,
+	.bmAttributes           =3D USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize         =3D cpu_to_le16(512),
+};
+
+static struct usb_endpoint_descriptor mtp_highspeed_out_desc =3D {
+	.bLength                =3D USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType        =3D USB_DT_ENDPOINT,
+	.bEndpointAddress       =3D USB_DIR_OUT,
+	.bmAttributes           =3D USB_ENDPOINT_XFER_BULK,
+	.wMaxPacketSize         =3D cpu_to_le16(512),
+};
+
+static struct usb_endpoint_descriptor mtp_fullspeed_in_desc =3D {
+	.bLength                =3D USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType        =3D USB_DT_ENDPOINT,
+	.bEndpointAddress       =3D USB_DIR_IN,
+	.bmAttributes           =3D USB_ENDPOINT_XFER_BULK,
+};
+
+static struct usb_endpoint_descriptor mtp_fullspeed_out_desc =3D {
+	.bLength                =3D USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType        =3D USB_DT_ENDPOINT,
+	.bEndpointAddress       =3D USB_DIR_OUT,
+	.bmAttributes           =3D USB_ENDPOINT_XFER_BULK,
+};
+
+static struct usb_endpoint_descriptor mtp_intr_desc =3D {
+	.bLength                =3D USB_DT_ENDPOINT_SIZE,
+	.bDescriptorType        =3D USB_DT_ENDPOINT,
+	.bEndpointAddress       =3D USB_DIR_IN,
+	.bmAttributes           =3D USB_ENDPOINT_XFER_INT,
+	.wMaxPacketSize         =3D cpu_to_le16(INTR_BUFFER_SIZE),
+	.bInterval              =3D 6,
+};
+
+static struct usb_descriptor_header *fs_mtp_descs[] =3D {
+	(struct usb_descriptor_header *) &mtp_interface_desc,
+	(struct usb_descriptor_header *) &mtp_fullspeed_in_desc,
+	(struct usb_descriptor_header *) &mtp_fullspeed_out_desc,
+	(struct usb_descriptor_header *) &mtp_intr_desc,
+	NULL,
+};
+
+static struct usb_descriptor_header *hs_mtp_descs[] =3D {
+	(struct usb_descriptor_header *) &mtp_interface_desc,
+	(struct usb_descriptor_header *) &mtp_highspeed_in_desc,
+	(struct usb_descriptor_header *) &mtp_highspeed_out_desc,
+	(struct usb_descriptor_header *) &mtp_intr_desc,
+	NULL,
+};
+
+static struct usb_string mtp_string_defs[] =3D {
+	/* Naming interface "MTP" so libmtp will recognize us */
+	[INTERFACE_STRING_INDEX].s	=3D "MTP",
+	{  },	/* end of list */
+};
+
+static struct usb_gadget_strings mtp_string_table =3D {
+	.language		=3D 0x0409,	/* en-US */
+	.strings		=3D mtp_string_defs,
+};
+
+static struct usb_gadget_strings *mtp_strings[] =3D {
+	&mtp_string_table,
+	NULL,
+};
+
+/* Microsoft MTP OS String */
+static u8 mtp_os_string[] =3D {
+	18, /* sizeof(mtp_os_string) */
+	USB_DT_STRING,
+	/* Signature field: "MSFT100" */
+	'M', 0, 'S', 0, 'F', 0, 'T', 0, '1', 0, '0', 0, '0', 0,
+	/* vendor code */
+	1,
+	/* padding */
+	0
+};
+
+/* Microsoft Extended Configuration Descriptor Header Section */
+struct mtp_ext_config_desc_header {
+	__le32	dwLength;
+	__u16	bcdVersion;
+	__le16	wIndex;
+	__u8	bCount;
+	__u8	reserved[7];
+};
+
+/* Microsoft Extended Configuration Descriptor Function Section */
+struct mtp_ext_config_desc_function {
+	__u8	bFirstInterfaceNumber;
+	__u8	bInterfaceCount;
+	__u8	compatibleID[8];
+	__u8	subCompatibleID[8];
+	__u8	reserved[6];
+};
+
+/* MTP Extended Configuration Descriptor */
+struct {
+	struct mtp_ext_config_desc_header	header;
+	struct mtp_ext_config_desc_function    function;
+} mtp_ext_config_desc =3D {
+	.header =3D {
+		.dwLength =3D cpu_to_le32(sizeof(mtp_ext_config_desc)),
+		.bcdVersion =3D cpu_to_le16(0x0100),
+		.wIndex =3D cpu_to_le16(4),
+		.bCount =3D cpu_to_le16(1),
+	},
+	.function =3D {
+		.bFirstInterfaceNumber =3D 0,
+		.bInterfaceCount =3D 1,
+		.compatibleID =3D { 'M', 'T', 'P' },
+	},
+};
+
+struct mtp_device_status {
+	__le16	wLength;
+	__le16	wCode;
+};
+
+struct mtp_data_header {
+	/* length of packet, including this header */
+	__le32	length;
+	/* container type (2 for data packet) */
+	__le16	type;
+	/* MTP command code */
+	__le16	command;
+	/* MTP transaction ID */
+	__le32	transaction_id;
+};
+
+struct mtp_instance {
+	struct usb_function_instance func_inst;
+	const char *name;
+	struct mtp_dev *dev;
+};
+
+/* temporary variable used between mtp_open() and mtp_gadget_bind() */
+static struct mtp_dev *_mtp_dev;
+
+static inline struct mtp_dev *func_to_mtp(struct usb_function *f)
+{
+	return container_of(f, struct mtp_dev, function);
+}
+
+static struct usb_request *mtp_request_new(struct usb_ep *ep, int buff=
er_size)
+{
+	struct usb_request *req =3D usb_ep_alloc_request(ep, GFP_KERNEL);
+
+	if (!req)
+		return NULL;
+	/* now allocate buffers for the requests */
+	req->buf =3D kmalloc(buffer_size, GFP_KERNEL);
+	if (!req->buf) {
+		usb_ep_free_request(ep, req);
+		return NULL;
+	}
+
+	return req;
+}
+
+static void mtp_request_free(struct usb_request *req, struct usb_ep *e=
p)
+{
+	if (req) {
+		kfree(req->buf);
+		usb_ep_free_request(ep, req);
+	}
+}
+
+static inline int mtp_lock(atomic_t *excl)
+{
+	if (atomic_inc_return(excl) =3D=3D 1) {
+		return 0;
+	} else {
+		atomic_dec(excl);
+		return -1;
+	}
+}
+
+static inline void mtp_unlock(atomic_t *excl)
+{
+	atomic_dec(excl);
+}
+
+/* add a request to the tail of a list */
+static void mtp_req_put(struct mtp_dev *dev, struct list_head *head,
+		struct usb_request *req)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	list_add_tail(&req->list, head);
+	spin_unlock_irqrestore(&dev->lock, flags);
+}
+
+/* remove a request from the head of a list */
+static struct usb_request
+*mtp_req_get(struct mtp_dev *dev, struct list_head *head)
+{
+	unsigned long flags;
+	struct usb_request *req;
+
+	spin_lock_irqsave(&dev->lock, flags);
+	if (list_empty(head)) {
+		req =3D 0;
+	} else {
+		req =3D list_first_entry(head, struct usb_request, list);
+		list_del(&req->list);
+	}
+	spin_unlock_irqrestore(&dev->lock, flags);
+	return req;
+}
+
+static void mtp_complete_in(struct usb_ep *ep, struct usb_request *req=
)
+{
+	struct mtp_dev *dev =3D _mtp_dev;
+
+	if (req->status !=3D 0)
+		dev->state =3D STATE_ERROR;
+
+	mtp_req_put(dev, &dev->tx_idle, req);
+
+	wake_up(&dev->write_wq);
+}
+
+static void mtp_complete_out(struct usb_ep *ep, struct usb_request *re=
q)
+{
+	struct mtp_dev *dev =3D _mtp_dev;
+
+	dev->rx_done =3D 1;
+	if (req->status !=3D 0)
+		dev->state =3D STATE_ERROR;
+
+	wake_up(&dev->read_wq);
+}
+
+static void mtp_complete_intr(struct usb_ep *ep, struct usb_request *r=
eq)
+{
+	struct mtp_dev *dev =3D _mtp_dev;
+
+	if (req->status !=3D 0)
+		dev->state =3D STATE_ERROR;
+
+	mtp_req_put(dev, &dev->intr_idle, req);
+
+	wake_up(&dev->intr_wq);
+}
+
+static int mtp_create_bulk_endpoints(struct mtp_dev *dev,
+				struct usb_endpoint_descriptor *in_desc,
+				struct usb_endpoint_descriptor *out_desc,
+				struct usb_endpoint_descriptor *intr_desc)
+{
+	struct usb_composite_dev *cdev =3D dev->cdev;
+	struct usb_request *req;
+	struct usb_ep *ep;
+	int i;
+
+	DBG(cdev, "create_bulk_endpoints dev: %p\n", dev);
+
+	ep =3D usb_ep_autoconfig(cdev->gadget, in_desc);
+	if (!ep) {
+		DBG(cdev, "usb_ep_autoconfig for ep_in failed\n");
+		return -ENODEV;
+	}
+	DBG(cdev, "usb_ep_autoconfig for ep_in got %s\n", ep->name);
+	ep->driver_data =3D dev;		/* claim the endpoint */
+	dev->ep_in =3D ep;
+
+	ep =3D usb_ep_autoconfig(cdev->gadget, out_desc);
+	if (!ep) {
+		DBG(cdev, "usb_ep_autoconfig for ep_out failed\n");
+		return -ENODEV;
+	}
+	DBG(cdev, "usb_ep_autoconfig for mtp ep_out got %s\n", ep->name);
+	ep->driver_data =3D dev;		/* claim the endpoint */
+	dev->ep_out =3D ep;
+
+	ep =3D usb_ep_autoconfig(cdev->gadget, intr_desc);
+	if (!ep) {
+		DBG(cdev, "usb_ep_autoconfig for ep_intr failed\n");
+		return -ENODEV;
+	}
+	DBG(cdev, "usb_ep_autoconfig for mtp ep_intr got %s\n", ep->name);
+	ep->driver_data =3D dev;		/* claim the endpoint */
+	dev->ep_intr =3D ep;
+
+	/* now allocate requests for our endpoints */
+	for (i =3D 0; i < TX_REQ_MAX; i++) {
+		req =3D mtp_request_new(dev->ep_in, MTP_BULK_BUFFER_SIZE);
+		if (!req)
+			goto fail;
+		req->complete =3D mtp_complete_in;
+		mtp_req_put(dev, &dev->tx_idle, req);
+	}
+	for (i =3D 0; i < RX_REQ_MAX; i++) {
+		req =3D mtp_request_new(dev->ep_out, MTP_BULK_BUFFER_SIZE);
+		if (!req)
+			goto fail;
+		req->complete =3D mtp_complete_out;
+		dev->rx_req[i] =3D req;
+	}
+	for (i =3D 0; i < INTR_REQ_MAX; i++) {
+		req =3D mtp_request_new(dev->ep_intr, INTR_BUFFER_SIZE);
+		if (!req)
+			goto fail;
+		req->complete =3D mtp_complete_intr;
+		mtp_req_put(dev, &dev->intr_idle, req);
+	}
+
+	return 0;
+
+fail:
+	pr_err("mtp_bind() could not allocate requests\n");
+	return -1;
+}
+
+static ssize_t mtp_read(struct file *fp, char __user *buf,
+	size_t count, loff_t *pos)
+{
+	struct mtp_dev *dev =3D fp->private_data;
+	struct usb_composite_dev *cdev =3D dev->cdev;
+	struct usb_request *req;
+	ssize_t r =3D count;
+	unsigned xfer;
+	int ret =3D 0;
+
+	DBG(cdev, "mtp_read(%zu)\n", count);
+
+	if (count > MTP_BULK_BUFFER_SIZE)
+		return -EINVAL;
+
+	/* we will block until we're online */
+	DBG(cdev, "mtp_read: waiting for online state\n");
+	ret =3D wait_event_interruptible(dev->read_wq,
+		dev->state !=3D STATE_OFFLINE);
+	if (ret < 0) {
+		r =3D ret;
+		goto done;
+	}
+	spin_lock_irq(&dev->lock);
+	if (dev->state =3D=3D STATE_CANCELED) {
+		/* report cancellation to userspace */
+		dev->state =3D STATE_READY;
+		spin_unlock_irq(&dev->lock);
+		return -ECANCELED;
+	}
+	dev->state =3D STATE_BUSY;
+	spin_unlock_irq(&dev->lock);
+
+requeue_req:
+	/* queue a request */
+	req =3D dev->rx_req[0];
+	req->length =3D count;
+	dev->rx_done =3D 0;
+	ret =3D usb_ep_queue(dev->ep_out, req, GFP_KERNEL);
+	if (ret < 0) {
+		r =3D -EIO;
+		goto done;
+	} else {
+		DBG(cdev, "rx %p queue\n", req);
+	}
+
+	/* wait for a request to complete */
+	ret =3D wait_event_interruptible(dev->read_wq, dev->rx_done);
+	if (ret < 0) {
+		r =3D ret;
+		usb_ep_dequeue(dev->ep_out, req);
+		goto done;
+	}
+	if (dev->state =3D=3D STATE_BUSY) {
+		/* If we got a 0-len packet, throw it back and try again. */
+		if (req->actual =3D=3D 0)
+			goto requeue_req;
+
+		DBG(cdev, "rx %p %d\n", req, req->actual);
+		xfer =3D (req->actual < count) ? req->actual : count;
+		r =3D xfer;
+		if (copy_to_user(buf, req->buf, xfer))
+			r =3D -EFAULT;
+	} else
+		r =3D -EIO;
+
+done:
+	spin_lock_irq(&dev->lock);
+	if (dev->state =3D=3D STATE_CANCELED)
+		r =3D -ECANCELED;
+	else if (dev->state !=3D STATE_OFFLINE)
+		dev->state =3D STATE_READY;
+	spin_unlock_irq(&dev->lock);
+
+	DBG(cdev, "mtp_read returning %zd\n", r);
+	return r;
+}
+
+static ssize_t mtp_write(struct file *fp, const char __user *buf,
+	size_t count, loff_t *pos)
+{
+	struct mtp_dev *dev =3D fp->private_data;
+	struct usb_composite_dev *cdev =3D dev->cdev;
+	struct usb_request *req =3D 0;
+	ssize_t r =3D count;
+	unsigned xfer;
+	int sendZLP =3D 0;
+	int ret;
+
+	DBG(cdev, "mtp_write(%zu)\n", count);
+
+	spin_lock_irq(&dev->lock);
+	if (dev->state =3D=3D STATE_CANCELED) {
+		/* report cancellation to userspace */
+		dev->state =3D STATE_READY;
+		spin_unlock_irq(&dev->lock);
+		return -ECANCELED;
+	}
+	if (dev->state =3D=3D STATE_OFFLINE) {
+		spin_unlock_irq(&dev->lock);
+		return -ENODEV;
+	}
+	dev->state =3D STATE_BUSY;
+	spin_unlock_irq(&dev->lock);
+
+	/* we need to send a zero length packet to signal the end of transfer
+	 * if the transfer size is aligned to a packet boundary.
+	 */
+	if ((count & (dev->ep_in->maxpacket - 1)) =3D=3D 0)
+		sendZLP =3D 1;
+
+	while (count > 0 || sendZLP) {
+		/* so we exit after sending ZLP */
+		if (count =3D=3D 0)
+			sendZLP =3D 0;
+
+		if (dev->state !=3D STATE_BUSY) {
+			DBG(cdev, "mtp_write dev->error\n");
+			r =3D -EIO;
+			break;
+		}
+
+		/* get an idle tx request to use */
+		req =3D 0;
+		ret =3D wait_event_interruptible(dev->write_wq,
+			((req =3D mtp_req_get(dev, &dev->tx_idle))
+				|| dev->state !=3D STATE_BUSY));
+		if (!req) {
+			r =3D ret;
+			break;
+		}
+
+		if (count > MTP_BULK_BUFFER_SIZE)
+			xfer =3D MTP_BULK_BUFFER_SIZE;
+		else
+			xfer =3D count;
+		if (xfer && copy_from_user(req->buf, buf, xfer)) {
+			r =3D -EFAULT;
+			break;
+		}
+
+		req->length =3D xfer;
+		ret =3D usb_ep_queue(dev->ep_in, req, GFP_KERNEL);
+		if (ret < 0) {
+			DBG(cdev, "mtp_write: xfer error %d\n", ret);
+			r =3D -EIO;
+			break;
+		}
+
+		buf +=3D xfer;
+		count -=3D xfer;
+
+		/* zero this so we don't try to free it on error exit */
+		req =3D 0;
+	}
+
+	if (req)
+		mtp_req_put(dev, &dev->tx_idle, req);
+
+	spin_lock_irq(&dev->lock);
+	if (dev->state =3D=3D STATE_CANCELED)
+		r =3D -ECANCELED;
+	else if (dev->state !=3D STATE_OFFLINE)
+		dev->state =3D STATE_READY;
+	spin_unlock_irq(&dev->lock);
+
+	DBG(cdev, "mtp_write returning %zd\n", r);
+	return r;
+}
+
+/* read from a local file and write to USB */
+static void send_file_work(struct work_struct *data)
+{
+	struct mtp_dev *dev =3D container_of(data, struct mtp_dev,
+						send_file_work);
+	struct usb_composite_dev *cdev =3D dev->cdev;
+	struct usb_request *req =3D 0;
+	struct mtp_data_header *header;
+	struct file *filp;
+	loff_t offset;
+	int64_t count;
+	int xfer, ret, hdr_size;
+	int r =3D 0;
+	int sendZLP =3D 0;
+
+	/* read our parameters */
+	smp_rmb();
+	filp =3D dev->xfer_file;
+	offset =3D dev->xfer_file_offset;
+	count =3D dev->xfer_file_length;
+
+	DBG(cdev, "send_file_work(%lld %lld)\n", offset, count);
+
+	if (dev->xfer_send_header) {
+		hdr_size =3D sizeof(struct mtp_data_header);
+		count +=3D hdr_size;
+	} else {
+		hdr_size =3D 0;
+	}
+
+	/* we need to send a zero length packet to signal the end of transfer
+	 * if the transfer size is aligned to a packet boundary.
+	 */
+	if ((count & (dev->ep_in->maxpacket - 1)) =3D=3D 0)
+		sendZLP =3D 1;
+
+	while (count > 0 || sendZLP) {
+		/* so we exit after sending ZLP */
+		if (count =3D=3D 0)
+			sendZLP =3D 0;
+
+		/* get an idle tx request to use */
+		req =3D 0;
+		ret =3D wait_event_interruptible(dev->write_wq,
+			(req =3D mtp_req_get(dev, &dev->tx_idle))
+			|| dev->state !=3D STATE_BUSY);
+		if (dev->state =3D=3D STATE_CANCELED) {
+			r =3D -ECANCELED;
+			break;
+		}
+		if (!req) {
+			r =3D ret;
+			break;
+		}
+
+		if (count > MTP_BULK_BUFFER_SIZE)
+			xfer =3D MTP_BULK_BUFFER_SIZE;
+		else
+			xfer =3D count;
+
+		if (hdr_size) {
+			/* prepend MTP data header */
+			header =3D (struct mtp_data_header *)req->buf;
+			header->length =3D __cpu_to_le32(count);
+			header->type =3D __cpu_to_le16(2); /* data packet */
+			header->command =3D __cpu_to_le16(dev->xfer_command);
+			header->transaction_id =3D
+					__cpu_to_le32(dev->xfer_transaction_id);
+		}
+
+		ret =3D vfs_read(filp, req->buf + hdr_size, xfer - hdr_size,
+								&offset);
+		if (ret < 0) {
+			r =3D ret;
+			break;
+		}
+		xfer =3D ret + hdr_size;
+		hdr_size =3D 0;
+
+		req->length =3D xfer;
+		ret =3D usb_ep_queue(dev->ep_in, req, GFP_KERNEL);
+		if (ret < 0) {
+			DBG(cdev, "send_file_work: xfer error %d\n", ret);
+			dev->state =3D STATE_ERROR;
+			r =3D -EIO;
+			break;
+		}
+
+		count -=3D xfer;
+
+		/* zero this so we don't try to free it on error exit */
+		req =3D 0;
+	}
+
+	if (req)
+		mtp_req_put(dev, &dev->tx_idle, req);
+
+	DBG(cdev, "send_file_work returning %d\n", r);
+	/* write the result */
+	dev->xfer_result =3D r;
+	smp_wmb();
+}
+
+/* read from USB and write to a local file */
+static void receive_file_work(struct work_struct *data)
+{
+	struct mtp_dev *dev =3D container_of(data, struct mtp_dev,
+						receive_file_work);
+	struct usb_composite_dev *cdev =3D dev->cdev;
+	struct usb_request *read_req =3D NULL, *write_req =3D NULL;
+	struct file *filp;
+	loff_t offset;
+	int64_t count;
+	int ret, cur_buf =3D 0;
+	int r =3D 0;
+
+	/* read our parameters */
+	smp_rmb();
+	filp =3D dev->xfer_file;
+	offset =3D dev->xfer_file_offset;
+	count =3D dev->xfer_file_length;
+
+	DBG(cdev, "receive_file_work(%lld)\n", count);
+
+	while (count > 0 || write_req) {
+		if (count > 0) {
+			/* queue a request */
+			read_req =3D dev->rx_req[cur_buf];
+			cur_buf =3D (cur_buf + 1) % RX_REQ_MAX;
+
+			read_req->length =3D (count > MTP_BULK_BUFFER_SIZE
+					? MTP_BULK_BUFFER_SIZE : count);
+			dev->rx_done =3D 0;
+			ret =3D usb_ep_queue(dev->ep_out, read_req, GFP_KERNEL);
+			if (ret < 0) {
+				r =3D -EIO;
+				dev->state =3D STATE_ERROR;
+				break;
+			}
+		}
+
+		if (write_req) {
+			DBG(cdev, "rx %p %d\n", write_req, write_req->actual);
+			ret =3D vfs_write(filp, write_req->buf, write_req->actual,
+				&offset);
+			DBG(cdev, "vfs_write %d\n", ret);
+			if (ret !=3D write_req->actual) {
+				r =3D -EIO;
+				dev->state =3D STATE_ERROR;
+				break;
+			}
+			write_req =3D NULL;
+		}
+
+		if (read_req) {
+			/* wait for our last read to complete */
+			ret =3D wait_event_interruptible(dev->read_wq,
+				dev->rx_done || dev->state !=3D STATE_BUSY);
+			if (dev->state =3D=3D STATE_CANCELED) {
+				r =3D -ECANCELED;
+				if (!dev->rx_done)
+					usb_ep_dequeue(dev->ep_out, read_req);
+				break;
+			}
+			/* if xfer_file_length is 0xFFFFFFFF, then we read until
+			 * we get a zero length packet
+			 */
+			if (count !=3D 0xFFFFFFFF)
+				count -=3D read_req->actual;
+			if (read_req->actual < read_req->length) {
+				/*
+				 * short packet is used to signal EOF for
+				 * sizes > 4 gig
+				 */
+				DBG(cdev, "got short packet\n");
+				count =3D 0;
+			}
+
+			write_req =3D read_req;
+			read_req =3D NULL;
+		}
+	}
+
+	DBG(cdev, "receive_file_work returning %d\n", r);
+	/* write the result */
+	dev->xfer_result =3D r;
+	smp_wmb();
+}
+
+static int mtp_send_event(struct mtp_dev *dev, struct mtp_event *event=
)
+{
+	struct usb_request *req =3D NULL;
+	int ret;
+	int length =3D event->length;
+
+	DBG(dev->cdev, "mtp_send_event(%zu)\n", event->length);
+
+	if (length < 0 || length > INTR_BUFFER_SIZE)
+		return -EINVAL;
+	if (dev->state =3D=3D STATE_OFFLINE)
+		return -ENODEV;
+
+	ret =3D wait_event_interruptible_timeout(dev->intr_wq,
+			(req =3D mtp_req_get(dev, &dev->intr_idle)),
+			msecs_to_jiffies(1000));
+	if (!req)
+		return -ETIME;
+
+	if (copy_from_user(req->buf, (void __user *)event->data, length)) {
+		mtp_req_put(dev, &dev->intr_idle, req);
+		return -EFAULT;
+	}
+	req->length =3D length;
+	ret =3D usb_ep_queue(dev->ep_intr, req, GFP_KERNEL);
+	if (ret)
+		mtp_req_put(dev, &dev->intr_idle, req);
+
+	return ret;
+}
+
+static long mtp_ioctl(struct file *fp, unsigned code, unsigned long va=
lue)
+{
+	struct mtp_dev *dev =3D fp->private_data;
+	struct file *filp =3D NULL;
+	int ret =3D -EINVAL;
+
+	if (mtp_lock(&dev->ioctl_excl))
+		return -EBUSY;
+
+	switch (code) {
+	case MTP_SEND_FILE:
+	case MTP_RECEIVE_FILE:
+	case MTP_SEND_FILE_WITH_HEADER:
+	{
+		struct mtp_file_range	mfr;
+		struct work_struct *work;
+
+		spin_lock_irq(&dev->lock);
+		if (dev->state =3D=3D STATE_CANCELED) {
+			/* report cancellation to userspace */
+			dev->state =3D STATE_READY;
+			spin_unlock_irq(&dev->lock);
+			ret =3D -ECANCELED;
+			goto out;
+		}
+		if (dev->state =3D=3D STATE_OFFLINE) {
+			spin_unlock_irq(&dev->lock);
+			ret =3D -ENODEV;
+			goto out;
+		}
+		dev->state =3D STATE_BUSY;
+		spin_unlock_irq(&dev->lock);
+
+		if (copy_from_user(&mfr, (void __user *)value, sizeof(mfr))) {
+			ret =3D -EFAULT;
+			goto fail;
+		}
+		/* hold a reference to the file while we are working with it */
+		filp =3D fget(mfr.fd);
+		if (!filp) {
+			ret =3D -EBADF;
+			goto fail;
+		}
+
+		/* write the parameters */
+		dev->xfer_file =3D filp;
+		dev->xfer_file_offset =3D mfr.offset;
+		dev->xfer_file_length =3D mfr.length;
+		smp_wmb();
+
+		if (code =3D=3D MTP_SEND_FILE_WITH_HEADER) {
+			work =3D &dev->send_file_work;
+			dev->xfer_send_header =3D 1;
+			dev->xfer_command =3D mfr.command;
+			dev->xfer_transaction_id =3D mfr.transaction_id;
+		} else if (code =3D=3D MTP_SEND_FILE) {
+			work =3D &dev->send_file_work;
+			dev->xfer_send_header =3D 0;
+		} else {
+			work =3D &dev->receive_file_work;
+		}
+
+		/* We do the file transfer on a work queue so it will run
+		 * in kernel context, which is necessary for vfs_read and
+		 * vfs_write to use our buffers in the kernel address space.
+		 */
+		queue_work(dev->wq, work);
+		/* wait for operation to complete */
+		flush_workqueue(dev->wq);
+		fput(filp);
+
+		/* read the result */
+		smp_rmb();
+		ret =3D dev->xfer_result;
+		break;
+	}
+	case MTP_SEND_EVENT:
+	{
+		struct mtp_event	event;
+		/* return here so we don't change dev->state below,
+		 * which would interfere with bulk transfer state.
+		 */
+		if (copy_from_user(&event, (void __user *)value, sizeof(event)))
+			ret =3D -EFAULT;
+		else
+			ret =3D mtp_send_event(dev, &event);
+		goto out;
+	}
+	}
+
+fail:
+	spin_lock_irq(&dev->lock);
+	if (dev->state =3D=3D STATE_CANCELED)
+		ret =3D -ECANCELED;
+	else if (dev->state !=3D STATE_OFFLINE)
+		dev->state =3D STATE_READY;
+	spin_unlock_irq(&dev->lock);
+out:
+	mtp_unlock(&dev->ioctl_excl);
+	DBG(dev->cdev, "ioctl returning %d\n", ret);
+	return ret;
+}
+
+static int mtp_open(struct inode *ip, struct file *fp)
+{
+	pr_info("mtp_open\n");
+	if (mtp_lock(&_mtp_dev->open_excl))
+		return -EBUSY;
+
+	/* clear any error condition */
+	if (_mtp_dev->state !=3D STATE_OFFLINE)
+		_mtp_dev->state =3D STATE_READY;
+
+	fp->private_data =3D _mtp_dev;
+	return 0;
+}
+
+static int mtp_release(struct inode *ip, struct file *fp)
+{
+	pr_info("mtp_release\n");
+
+	mtp_unlock(&_mtp_dev->open_excl);
+	return 0;
+}
+
+/* file operations for /dev/mtp_usb */
+static const struct file_operations mtp_fops =3D {
+	.owner =3D THIS_MODULE,
+	.read =3D mtp_read,
+	.write =3D mtp_write,
+	.unlocked_ioctl =3D mtp_ioctl,
+	.open =3D mtp_open,
+	.release =3D mtp_release,
+};
+
+static struct miscdevice mtp_device =3D {
+	.minor =3D MISC_DYNAMIC_MINOR,
+	.name =3D mtp_shortname,
+	.fops =3D &mtp_fops,
+};
+
+static int mtp_ctrlrequest(struct usb_composite_dev *cdev,
+				const struct usb_ctrlrequest *ctrl)
+{
+	struct mtp_dev *dev =3D _mtp_dev;
+	int	value =3D -EOPNOTSUPP;
+	u16	w_index =3D le16_to_cpu(ctrl->wIndex);
+	u16	w_value =3D le16_to_cpu(ctrl->wValue);
+	u16	w_length =3D le16_to_cpu(ctrl->wLength);
+	unsigned long	flags;
+
+	VDBG(cdev, "mtp_ctrlrequest %02x.%02x v%04x i%04x l%u\n",
+			ctrl->bRequestType, ctrl->bRequest,
+			w_value, w_index, w_length);
+
+	/* Handle MTP OS string */
+	if (ctrl->bRequestType =3D=3D
+			(USB_DIR_IN | USB_TYPE_STANDARD | USB_RECIP_DEVICE)
+			&& ctrl->bRequest =3D=3D USB_REQ_GET_DESCRIPTOR
+			&& (w_value >> 8) =3D=3D USB_DT_STRING
+			&& (w_value & 0xFF) =3D=3D MTP_OS_STRING_ID) {
+		value =3D (w_length < sizeof(mtp_os_string)
+				? w_length : sizeof(mtp_os_string));
+		memcpy(cdev->req->buf, mtp_os_string, value);
+	} else if ((ctrl->bRequestType & USB_TYPE_MASK) =3D=3D USB_TYPE_VENDO=
R) {
+		/* Handle MTP OS descriptor */
+		DBG(cdev, "vendor request: %d index: %d value: %d length: %d\n",
+			ctrl->bRequest, w_index, w_value, w_length);
+
+		if (ctrl->bRequest =3D=3D 1
+				&& (ctrl->bRequestType & USB_DIR_IN)
+				&& (w_index =3D=3D 4 || w_index =3D=3D 5)) {
+			value =3D (w_length < sizeof(mtp_ext_config_desc) ?
+					w_length : sizeof(mtp_ext_config_desc));
+			memcpy(cdev->req->buf, &mtp_ext_config_desc, value);
+		}
+	} else if ((ctrl->bRequestType & USB_TYPE_MASK) =3D=3D USB_TYPE_CLASS=
) {
+		DBG(cdev, "class request: %d index: %d value: %d length: %d\n",
+			ctrl->bRequest, w_index, w_value, w_length);
+
+		if (ctrl->bRequest =3D=3D MTP_REQ_CANCEL && w_index =3D=3D 0
+				&& w_value =3D=3D 0) {
+			DBG(cdev, "MTP_REQ_CANCEL\n");
+
+			spin_lock_irqsave(&dev->lock, flags);
+			if (dev->state =3D=3D STATE_BUSY) {
+				dev->state =3D STATE_CANCELED;
+				wake_up(&dev->read_wq);
+				wake_up(&dev->write_wq);
+			}
+			spin_unlock_irqrestore(&dev->lock, flags);
+
+			/* We need to queue a request to read the remaining
+			 *  bytes, but we don't actually need to look at
+			 * the contents.
+			 */
+			value =3D w_length;
+		} else if (ctrl->bRequest =3D=3D MTP_REQ_GET_DEVICE_STATUS
+				&& w_index =3D=3D 0 && w_value =3D=3D 0) {
+			struct mtp_device_status *status =3D cdev->req->buf;
+
+			status->wLength =3D
+				cpu_to_le16(sizeof(*status));
+			DBG(cdev, "MTP_REQ_GET_DEVICE_STATUS\n");
+			spin_lock_irqsave(&dev->lock, flags);
+			/* device status is "busy" until we report
+			 * the cancellation to userspace
+			 */
+			if (dev->state =3D=3D STATE_CANCELED)
+				status->wCode =3D
+					__cpu_to_le16(MTP_RESPONSE_DEVICE_BUSY);
+			else
+				status->wCode =3D
+					__cpu_to_le16(MTP_RESPONSE_OK);
+			spin_unlock_irqrestore(&dev->lock, flags);
+			value =3D sizeof(*status);
+		}
+	}
+
+	/* respond with data transfer or status phase? */
+	if (value >=3D 0) {
+		int rc;
+
+		cdev->req->zero =3D value < w_length;
+		cdev->req->length =3D value;
+		rc =3D usb_ep_queue(cdev->gadget->ep0, cdev->req, GFP_ATOMIC);
+		if (rc < 0)
+			ERROR(cdev, "%s: response queue error\n", __func__);
+	}
+	return value;
+}
+
+static int
+mtp_function_bind(struct usb_configuration *c, struct usb_function *f)
+{
+	struct usb_composite_dev *cdev =3D c->cdev;
+	struct mtp_dev	*dev =3D func_to_mtp(f);
+	int			id;
+	int			ret;
+
+	dev->cdev =3D cdev;
+	DBG(cdev, "mtp_function_bind dev: %p\n", dev);
+
+	/* allocate interface ID(s) */
+	id =3D usb_interface_id(c, f);
+	if (id < 0)
+		return id;
+	mtp_interface_desc.bInterfaceNumber =3D id;
+
+	if (mtp_string_defs[INTERFACE_STRING_INDEX].id =3D=3D 0) {
+		ret =3D usb_string_id(c->cdev);
+		if (ret < 0)
+			return ret;
+		mtp_string_defs[INTERFACE_STRING_INDEX].id =3D ret;
+		mtp_interface_desc.iInterface =3D ret;
+	}
+	/* allocate endpoints */
+	ret =3D mtp_create_bulk_endpoints(dev, &mtp_fullspeed_in_desc,
+			&mtp_fullspeed_out_desc, &mtp_intr_desc);
+	if (ret)
+		return ret;
+
+	/* support high speed hardware */
+	if (gadget_is_dualspeed(c->cdev->gadget)) {
+		mtp_highspeed_in_desc.bEndpointAddress =3D
+			mtp_fullspeed_in_desc.bEndpointAddress;
+		mtp_highspeed_out_desc.bEndpointAddress =3D
+			mtp_fullspeed_out_desc.bEndpointAddress;
+	}
+
+	DBG(cdev, "%s speed %s: IN/%s, OUT/%s\n",
+			gadget_is_dualspeed(c->cdev->gadget) ? "dual" : "full",
+			f->name, dev->ep_in->name, dev->ep_out->name);
+	return 0;
+}
+
+static void
+mtp_function_unbind(struct usb_configuration *c, struct usb_function *=
f)
+{
+	struct mtp_dev	*dev =3D func_to_mtp(f);
+	struct usb_request *req;
+	int i;
+
+	mtp_string_defs[INTERFACE_STRING_INDEX].id =3D 0;
+	while ((req =3D mtp_req_get(dev, &dev->tx_idle)))
+		mtp_request_free(req, dev->ep_in);
+	for (i =3D 0; i < RX_REQ_MAX; i++)
+		mtp_request_free(dev->rx_req[i], dev->ep_out);
+	while ((req =3D mtp_req_get(dev, &dev->intr_idle)))
+		mtp_request_free(req, dev->ep_intr);
+	dev->state =3D STATE_OFFLINE;
+}
+
+static int mtp_function_set_alt(struct usb_function *f,
+		unsigned intf, unsigned alt)
+{
+	struct mtp_dev	*dev =3D func_to_mtp(f);
+	struct usb_composite_dev *cdev =3D f->config->cdev;
+	int ret;
+
+	DBG(cdev, "mtp_function_set_alt intf: %d alt: %d\n", intf, alt);
+
+	ret =3D config_ep_by_speed(cdev->gadget, f, dev->ep_in);
+	if (ret)
+		return ret;
+
+	ret =3D usb_ep_enable(dev->ep_in);
+	if (ret)
+		return ret;
+
+	ret =3D config_ep_by_speed(cdev->gadget, f, dev->ep_out);
+	if (ret)
+		return ret;
+
+	ret =3D usb_ep_enable(dev->ep_out);
+	if (ret) {
+		usb_ep_disable(dev->ep_in);
+		return ret;
+	}
+
+	ret =3D config_ep_by_speed(cdev->gadget, f, dev->ep_intr);
+	if (ret)
+		return ret;
+
+	ret =3D usb_ep_enable(dev->ep_intr);
+	if (ret) {
+		usb_ep_disable(dev->ep_out);
+		usb_ep_disable(dev->ep_in);
+		return ret;
+	}
+	dev->state =3D STATE_READY;
+
+	/* readers may be blocked waiting for us to go online */
+	wake_up(&dev->read_wq);
+	return 0;
+}
+
+static void mtp_function_disable(struct usb_function *f)
+{
+	struct mtp_dev	*dev =3D func_to_mtp(f);
+	struct usb_composite_dev	*cdev =3D dev->cdev;
+
+	DBG(cdev, "mtp_function_disable\n");
+	dev->state =3D STATE_OFFLINE;
+	usb_ep_disable(dev->ep_in);
+	usb_ep_disable(dev->ep_out);
+	usb_ep_disable(dev->ep_intr);
+
+	/* readers may be blocked waiting for us to go online */
+	wake_up(&dev->read_wq);
+
+	VDBG(cdev, "%s disabled\n", dev->function.name);
+}
+
+static int mtp_setup(struct mtp_instance *fi_mtp)
+{
+	struct mtp_dev *dev;
+	int ret;
+
+	dev =3D kzalloc(sizeof(*dev), GFP_KERNEL);
+
+	if (fi_mtp !=3D NULL)
+		fi_mtp->dev =3D dev;
+
+	if (!dev)
+		return -ENOMEM;
+
+	spin_lock_init(&dev->lock);
+	init_waitqueue_head(&dev->read_wq);
+	init_waitqueue_head(&dev->write_wq);
+	init_waitqueue_head(&dev->intr_wq);
+	atomic_set(&dev->open_excl, 0);
+	atomic_set(&dev->ioctl_excl, 0);
+	INIT_LIST_HEAD(&dev->tx_idle);
+	INIT_LIST_HEAD(&dev->intr_idle);
+
+	dev->wq =3D create_singlethread_workqueue("f_mtp");
+	if (!dev->wq) {
+		ret =3D -ENOMEM;
+		goto err1;
+	}
+	INIT_WORK(&dev->send_file_work, send_file_work);
+	INIT_WORK(&dev->receive_file_work, receive_file_work);
+
+	_mtp_dev =3D dev;
+
+	ret =3D misc_register(&mtp_device);
+	if (ret)
+		goto err2;
+
+	return 0;
+
+err2:
+	destroy_workqueue(dev->wq);
+err1:
+	_mtp_dev =3D NULL;
+	kfree(dev);
+	pr_err("mtp gadget driver failed to initialize\n");
+	return ret;
+}
+
+static void mtp_cleanup(void)
+{
+	struct mtp_dev *dev =3D _mtp_dev;
+
+	if (!dev)
+		return;
+
+	misc_deregister(&mtp_device);
+	destroy_workqueue(dev->wq);
+	_mtp_dev =3D NULL;
+	kfree(dev);
+}
+
+static struct mtp_instance *to_mtp_instance(struct config_item *item)
+{
+	return container_of(to_config_group(item), struct mtp_instance,
+		func_inst.group);
+}
+
+static void mtp_attr_release(struct config_item *item)
+{
+	struct mtp_instance *fi_mtp =3D to_mtp_instance(item);
+
+	usb_put_function_instance(&fi_mtp->func_inst);
+}
+
+static struct configfs_item_operations mtp_item_ops =3D {
+	.release        =3D mtp_attr_release,
+};
+
+static struct config_item_type mtp_func_type =3D {
+	.ct_item_ops    =3D &mtp_item_ops,
+	.ct_owner       =3D THIS_MODULE,
+};
+
+static struct mtp_instance *to_fi_mtp(struct usb_function_instance *fi=
)
+{
+	return container_of(fi, struct mtp_instance, func_inst);
+}
+
+static int mtp_set_inst_name(struct usb_function_instance *fi, const c=
har *name)
+{
+	struct mtp_instance *fi_mtp;
+	char *ptr;
+	int name_len;
+
+	name_len =3D strlen(name) + 1;
+	if (name_len > MAX_INST_NAME_LEN)
+		return -ENAMETOOLONG;
+
+	ptr =3D kstrndup(name, name_len, GFP_KERNEL);
+	if (!ptr)
+		return -ENOMEM;
+
+	fi_mtp =3D to_fi_mtp(fi);
+	fi_mtp->name =3D ptr;
+
+	return 0;
+}
+
+static void mtp_free_inst(struct usb_function_instance *fi)
+{
+	struct mtp_instance *fi_mtp;
+
+	fi_mtp =3D to_fi_mtp(fi);
+	kfree(fi_mtp->name);
+	mtp_cleanup();
+	kfree(fi_mtp);
+}
+
+static struct usb_function_instance *mtp_alloc_inst(void)
+{
+	struct mtp_instance *fi_mtp;
+	int ret =3D 0;
+
+	fi_mtp =3D kzalloc(sizeof(*fi_mtp), GFP_KERNEL);
+	if (!fi_mtp)
+		return ERR_PTR(-ENOMEM);
+	fi_mtp->func_inst.set_inst_name =3D mtp_set_inst_name;
+	fi_mtp->func_inst.free_func_inst =3D mtp_free_inst;
+
+	ret =3D mtp_setup(fi_mtp);
+	if (ret) {
+		kfree(fi_mtp);
+		pr_err("Error setting MTP\n");
+		return ERR_PTR(ret);
+	}
+
+	config_group_init_type_name(&fi_mtp->func_inst.group,
+					"", &mtp_func_type);
+
+	return  &fi_mtp->func_inst;
+}
+
+static int mtp_ctrlreq_configfs(struct usb_function *f,
+				const struct usb_ctrlrequest *ctrl)
+{
+	return mtp_ctrlrequest(f->config->cdev, ctrl);
+}
+
+static void mtp_free(struct usb_function *f)
+{
+	/*NO-OP: no function specific resource allocation in mtp_alloc*/
+}
+
+static struct usb_function *mtp_alloc(struct usb_function_instance *fi=
)
+{
+	struct mtp_instance *fi_mtp =3D to_fi_mtp(fi);
+	struct mtp_dev *dev =3D fi_mtp->dev;
+
+	dev->function.name =3D DRIVER_NAME;
+	dev->function.strings =3D mtp_strings;
+	dev->function.fs_descriptors =3D fs_mtp_descs;
+	dev->function.hs_descriptors =3D hs_mtp_descs;
+	dev->function.bind =3D mtp_function_bind;
+	dev->function.unbind =3D mtp_function_unbind;
+	dev->function.set_alt =3D mtp_function_set_alt;
+	dev->function.disable =3D mtp_function_disable;
+	dev->function.setup =3D mtp_ctrlreq_configfs;
+	dev->function.free_func =3D mtp_free;
+
+	return &dev->function;
+}
+
+DECLARE_USB_FUNCTION_INIT(mtp, mtp_alloc_inst, mtp_alloc);
+MODULE_LICENSE("GPL");
diff --git a/include/linux/usb/f_mtp.h b/include/linux/usb/f_mtp.h
new file mode 100644
index 0000000..4e84177
--- /dev/null
+++ b/include/linux/usb/f_mtp.h
@@ -0,0 +1,23 @@
+/*
+ * Gadget Function Driver for MTP
+ *
+ * Copyright (C) 2010 Google, Inc.
+ * Author: Mike Lockwood <lockwood@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, an=
d
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef __LINUX_USB_F_MTP_H
+#define __LINUX_USB_F_MTP_H
+
+#include <uapi/linux/usb/f_mtp.h>
+
+#endif /* __LINUX_USB_F_MTP_H */
diff --git a/include/uapi/linux/usb/f_mtp.h b/include/uapi/linux/usb/f_=
mtp.h
new file mode 100644
index 0000000..6baa90d
--- /dev/null
+++ b/include/uapi/linux/usb/f_mtp.h
@@ -0,0 +1,61 @@
+/*
+ * MTP Userspace Interface
+ *
+ * Copyright (C) 2010 Google, Inc.
+ * Author: Mike Lockwood <lockwood@android.com>
+ *
+ * This software is licensed under the terms of the GNU General Public
+ * License version 2, as published by the Free Software Foundation, an=
d
+ * may be copied, distributed, and modified under those terms.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ */
+
+#ifndef _UAPI_LINUX_USB_F_MTP_H
+#define _UAPI_LINUX_USB_F_MTP_H
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+struct mtp_file_range {
+	/* file descriptor for file to transfer */
+	int			fd;
+	/* offset in file for start of transfer */
+	loff_t		offset;
+	/* number of bytes to transfer */
+	int64_t		length;
+	/* MTP command ID for data header,
+	 * used only for MTP_SEND_FILE_WITH_HEADER
+	 */
+	uint16_t	command;
+	/* MTP transaction ID for data header,
+	 * used only for MTP_SEND_FILE_WITH_HEADER
+	 */
+	uint32_t	transaction_id;
+};
+
+struct mtp_event {
+	/* size of the event */
+	size_t		length;
+	/* event data to send */
+	void		*data;
+};
+
+/* Sends the specified file range to the host */
+#define MTP_SEND_FILE              _IOW('M', 0, struct mtp_file_range)
+/* Receives data from the host and writes it to a file.
+ * The file is created if it does not exist.
+ */
+#define MTP_RECEIVE_FILE           _IOW('M', 1, struct mtp_file_range)
+/* Sends an event to the host via the interrupt endpoint */
+#define MTP_SEND_EVENT             _IOW('M', 3, struct mtp_event)
+/* Sends the specified file range to the host,
+ * with a 12 byte MTP data packet header at the beginning.
+ */
+#define MTP_SEND_FILE_WITH_HEADER  _IOW('M', 4, struct mtp_file_range)
+
+#endif /* _UAPI_LINUX_USB_F_MTP_H */
--=20
1.9.1


From: Yann Cantin <yann.cantin@laposte.net>
Subject: [RFC ebeam PATCH v2 2/2] input: misc: New USB eBeam input driver
Date: Sat, 25 Jul 2015 20:48:25 +0200
Message-ID: <1437850105-4814-3-git-send-email-yann.cantin@laposte.net>
References: <1437850105-4814-1-git-send-email-yann.cantin@laposte.net>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437850105-4814-1-git-send-email-yann.cantin@laposte.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, dmitry.torokhov@gmail.com, jkosina@suse.cz, gregkh@linuxfoundation.org, oneukum@suse.com, Yann Cantin <yann.cantin@laposte.net>
List-Id: linux-api@vger.kernel.org

Add new USB input driver for Luidia's eBeam devices.

Currently supported (tested) :
- eBeam classic projection and edge projection models
- Nec interactive solution NP01Wi1 & NP01Wi2 accessories.

Notable stuff :
- 13 sysfs custom files : 9 values for the transformation matrix,
  4 for xy ranges and a calibration trigger.
- need userspace gui tool for calibration (ebeam.tuxfamily.org)

Signed-off-by: Yann Cantin <yann.cantin@laposte.net>
---
 Documentation/ABI/testing/sysfs-driver-ebeam |  53 ++
 drivers/input/misc/Kconfig                   |  22 +
 drivers/input/misc/Makefile                  |   1 +
 drivers/input/misc/ebeam.c                   | 759 +++++++++++++++++++++++++++
 4 files changed, 835 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-ebeam
 create mode 100644 drivers/input/misc/ebeam.c

diff --git a/Documentation/ABI/testing/sysfs-driver-ebeam b/Documentation/ABI/testing/sysfs-driver-ebeam
new file mode 100644
index 0000000..3a663e8
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-ebeam
@@ -0,0 +1,53 @@
+What:		/sys/bus/usb/drivers/ebeam/<busnum>-<devnum>:<confignum>.<ifacenum>/min_x
+		/sys/bus/usb/drivers/ebeam/<busnum>-<devnum>:<confignum>.<ifacenum>/min_y
+		/sys/bus/usb/drivers/ebeam/<busnum>-<devnum>:<confignum>.<ifacenum>/max_x
+		/sys/bus/usb/drivers/ebeam/<busnum>-<devnum>:<confignum>.<ifacenum>/max_y
+Date:		Jul 2015
+Kernel Version:	4.1
+Contact:	yann.cantin@laposte.net
+		linux-usb@vger.kernel.org
+Description:
+		Reading from these files return the actually used range values of
+		the reported coordinates.
+		Writing to these files preset these range values.
+		See below for the calibration procedure.
+
+What:		/sys/bus/usb/drivers/ebeam/<busnum>-<devnum>:<confignum>.<ifacenum>/h[1..9]
+Date:		Jul 2015
+Kernel Version:	4.1
+Contact:	yann.cantin@laposte.net
+		linux-usb@vger.kernel.org
+Description:
+		Reading from these files return the 3x3 transformation matrix elements
+		actually used, in row-major.
+		Writing to these files preset these elements values.
+		See below for the calibration procedure.
+
+What:		/sys/bus/usb/drivers/ebeam/<busnum>-<devnum>:<confignum>.<ifacenum>/calibrated
+Date:		Jul 2015
+Kernel Version:	4.1
+Contact:	yann.cantin@laposte.net
+		linux-usb@vger.kernel.org
+Description:
+		Reading from this file :
+		- Return 0 if the driver is in "un-calibrated" mode : it actually send
+		  raw coordinates in the device's internal coordinates system.
+		- Return 1 if the driver is in "calibrated" mode : it send computed coordinates
+		  that (hopefully) matches the screen's coordinates system.
+		Writing 1 to this file enable the "calibrated" mode, 0 reset the driver in
+		"un-calibrated" mode.
+
+Calibration procedure :
+
+When loaded, the driver is in "un-calibrated" mode : it send device's raw coordinates
+in the [0..65535]x[0..65535] range, the transformation matrix is the identity.
+
+A calibration program have to compute a homography transformation matrix that convert
+the device's raw coordinates to the matching screen's ones.
+It then write to the appropriate sysfs files the computed values, pre-setting the
+driver's parameters : xy range, and the matrix's elements.
+When all values are passed, it write 1 to the calibrated sysfs file to enable the "calibrated" mode.
+
+Warning : The parameters aren't used until 1 is writen to the calibrated sysfs file.
+
+These files can also be accessed via /sys/class/input/inputXX/device/
diff --git a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
index d4f0a81..22c46a4 100644
--- a/drivers/input/misc/Kconfig
+++ b/drivers/input/misc/Kconfig
@@ -103,6 +103,28 @@ config INPUT_E3X0_BUTTON
 	  To compile this driver as a module, choose M here: the
 	  module will be called e3x0_button.
 
+config INPUT_EBEAM_USB
+	tristate "USB eBeam driver"
+	depends on USB_ARCH_HAS_HCD
+	select USB
+	help
+	  Say Y here if you have a USB eBeam pointing device and want to
+	  use it without any proprietary user space tools.
+
+	  Have a look at <http://ebeam.tuxfamily.org/> for
+	  a usage description and the required user-space tools.
+
+	  Supported devices :
+	    - Luidia eBeam Classic Projection and eBeam Edge Projection
+	    - Nec NP01Wi1 & NP01Wi2 interactive solution
+
+	  Supposed working devices, need test, may lack functionality :
+	    - Luidia eBeam Edge Whiteboard and eBeam Engage
+	    - Hitachi Starboard FX-63, FX-77, FX-82, FX-77GII
+
+	  To compile this driver as a module, choose M here: the
+	  module will be called ebeam.
+
 config INPUT_PCSPKR
 	tristate "PC Speaker support"
 	depends on PCSPKR_PLATFORM
diff --git a/drivers/input/misc/Makefile b/drivers/input/misc/Makefile
index 53df07d..125f8a9 100644
--- a/drivers/input/misc/Makefile
+++ b/drivers/input/misc/Makefile
@@ -28,6 +28,7 @@ obj-$(CONFIG_INPUT_DA9055_ONKEY)	+= da9055_onkey.o
 obj-$(CONFIG_INPUT_DA9063_ONKEY)	+= da9063_onkey.o
 obj-$(CONFIG_INPUT_DM355EVM)		+= dm355evm_keys.o
 obj-$(CONFIG_INPUT_E3X0_BUTTON)		+= e3x0-button.o
+obj-$(CONFIG_INPUT_EBEAM_USB)		+= ebeam.o
 obj-$(CONFIG_INPUT_DRV260X_HAPTICS)	+= drv260x.o
 obj-$(CONFIG_INPUT_DRV2665_HAPTICS)	+= drv2665.o
 obj-$(CONFIG_INPUT_DRV2667_HAPTICS)	+= drv2667.o
diff --git a/drivers/input/misc/ebeam.c b/drivers/input/misc/ebeam.c
new file mode 100644
index 0000000..e7b9f3e
--- /dev/null
+++ b/drivers/input/misc/ebeam.c
@@ -0,0 +1,759 @@
+/******************************************************************************
+ *
+ * eBeam driver
+ *
+ * Copyright (C) 2012-2015 Yann Cantin (yann.cantin@laposte.net)
+ *
+ *	This program is free software; you can redistribute it and/or
+ *	modify it under the terms of the GNU General Public License as
+ *	published by the Free Software Foundation; either version 2 of the
+ *	License, or (at your option) any later version.
+ *
+ *  based on
+ *
+ *	usbtouchscreen.c by Daniel Ritz <daniel.ritz@gmx.ch>
+ *	aiptek.c (sysfs/settings) by Chris Atenasio <chris@crud.net>
+ *				     Bryan W. Headley <bwheadley@earthlink.net>
+ *
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/math64.h>
+#include <linux/input.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/usb.h>
+#include <linux/usb/input.h>
+#include <asm/unaligned.h>
+
+#define DRIVER_AUTHOR	"Yann Cantin <yann.cantin@laposte.net>"
+#define DRIVER_DESC	"USB eBeam Driver"
+
+/* Common values for eBeam devices */
+#define REPT_SIZE	8	/* packet size            */
+#define MIN_RAW_X	0	/* raw coordinates ranges */
+#define MAX_RAW_X	0xFFFF
+#define MIN_RAW_Y	0
+#define MAX_RAW_Y	0xFFFF
+
+#define EBEAM_BTN_TIP	0x1	/* tip    */
+#define EBEAM_BTN_LIT	0x2	/* little */
+#define EBEAM_BTN_BIG	0x4	/* big    */
+
+/* ebeam settings */
+struct ebeam_settings {
+	int min_x;	/* computed coordinates ranges for the input layer */
+	int max_x;
+	int min_y;
+	int max_y;
+
+	/* H matrix */
+	s64 h1;
+	s64 h2;
+	s64 h3;
+	s64 h4;
+	s64 h5;
+	s64 h6;
+	s64 h7;
+	s64 h8;
+	s64 h9;
+};
+
+/* ebeam device */
+struct ebeam_device {
+	unsigned char		*data;
+	dma_addr_t		data_dma;
+	unsigned char		*buffer;
+	int			buf_len;
+	struct urb		*irq;
+	struct usb_interface	*interface;
+	struct input_dev	*input;
+	char			name[128];
+	char			phys[64];
+	void			*priv;
+
+	struct ebeam_settings	cursetting;	/* device's current settings */
+	struct ebeam_settings	newsetting;	/* ... and new ones          */
+
+	bool			calibrated;	/* false : send raw          */
+						/* true  : send computed     */
+
+	u16			raw_x;		/* raw coordinates           */
+	u16			raw_y;
+	int			x;		/* computed coordinates      */
+	int			y;
+	int			btn_map;	/* internal buttons map      */
+};
+
+/* device types */
+enum {
+	DEVTYPE_EBEAM,
+};
+
+static const struct usb_device_id ebeam_devices[] = {
+	{USB_DEVICE(USB_VENDOR_ID_EFI, USB_DEVICE_ID_EFI_EBEAM_USB1),
+	 .driver_info = DEVTYPE_EBEAM},
+	{USB_DEVICE(USB_VENDOR_ID_EFI, USB_DEVICE_ID_EFI_EBEAM_USB2),
+	 .driver_info = DEVTYPE_EBEAM},
+	{USB_DEVICE(USB_VENDOR_ID_EFI, USB_DEVICE_ID_EFI_EBEAM_BT_USB1),
+	 .driver_info = DEVTYPE_EBEAM},
+	{USB_DEVICE(USB_VENDOR_ID_EFI, USB_DEVICE_ID_EFI_EBEAM_BT_USB2),
+	 .driver_info = DEVTYPE_EBEAM},
+	{}
+};
+
+static void ebeam_init_settings(struct ebeam_device *ebeam)
+{
+	ebeam->calibrated = false;
+
+	/* Init (x,y) min/max to raw ones */
+	ebeam->cursetting.min_x = ebeam->newsetting.min_x = MIN_RAW_X;
+	ebeam->cursetting.max_x = ebeam->newsetting.max_x = MAX_RAW_X;
+	ebeam->cursetting.min_y = ebeam->newsetting.min_y = MIN_RAW_Y;
+	ebeam->cursetting.max_y = ebeam->newsetting.max_y = MAX_RAW_Y;
+
+	/* Safe values for the H matrix (Identity) */
+	ebeam->cursetting.h1 = ebeam->newsetting.h1 = 1;
+	ebeam->cursetting.h2 = ebeam->newsetting.h2 = 0;
+	ebeam->cursetting.h3 = ebeam->newsetting.h3 = 0;
+
+	ebeam->cursetting.h4 = ebeam->newsetting.h4 = 0;
+	ebeam->cursetting.h5 = ebeam->newsetting.h5 = 1;
+	ebeam->cursetting.h6 = ebeam->newsetting.h6 = 0;
+
+	ebeam->cursetting.h7 = ebeam->newsetting.h7 = 0;
+	ebeam->cursetting.h8 = ebeam->newsetting.h8 = 0;
+	ebeam->cursetting.h9 = ebeam->newsetting.h9 = 1;
+}
+
+static void ebeam_setup_input(struct ebeam_device *ebeam,
+			      struct input_dev *input_dev)
+{
+	unsigned long flags;
+
+	/* Take event lock while modifying parameters */
+	spin_lock_irqsave(&input_dev->event_lock, flags);
+
+	/* Properties */
+	set_bit(INPUT_PROP_DIRECT, input_dev->propbit);
+
+	/* Events generated */
+	set_bit(EV_KEY, input_dev->evbit);
+	set_bit(EV_ABS, input_dev->evbit);
+
+	/* Keys */
+	set_bit(BTN_LEFT,	input_dev->keybit);
+	set_bit(BTN_MIDDLE,	input_dev->keybit);
+	set_bit(BTN_RIGHT,	input_dev->keybit);
+
+	/* Axis */
+	if (!ebeam->calibrated) {
+		ebeam->cursetting.min_x = MIN_RAW_X;
+		ebeam->cursetting.max_x = MAX_RAW_X;
+		ebeam->cursetting.min_y = MIN_RAW_Y;
+		ebeam->cursetting.max_y = MAX_RAW_Y;
+	}
+
+	input_set_abs_params(input_dev, ABS_X,
+			     ebeam->cursetting.min_x, ebeam->cursetting.max_x,
+			     0, 0);
+	input_set_abs_params(input_dev, ABS_Y,
+			     ebeam->cursetting.min_y, ebeam->cursetting.max_y,
+			     0, 0);
+
+	spin_unlock_irqrestore(&input_dev->event_lock, flags);
+}
+
+/*******************************************************************************
+ * sysfs part
+ */
+
+/*
+ * screen min/max and H matrix coefs
+ * _get return *current* value
+ * _set set new value
+ */
+#define DEVICE_MINMAX_ATTR(MM)						       \
+static ssize_t MM##_show(struct device *dev,				       \
+			 struct device_attribute *attr,			       \
+			 char *buf)					       \
+{									       \
+	struct ebeam_device *ebeam = dev_get_drvdata(dev);		       \
+									       \
+	return snprintf(buf, PAGE_SIZE, "%d\n", ebeam->cursetting.MM);	       \
+}									       \
+static ssize_t MM##_store(struct device *dev,				       \
+			  struct device_attribute *attr,		       \
+			  const char *buf,				       \
+			  size_t count)					       \
+{									       \
+	struct ebeam_device *ebeam = dev_get_drvdata(dev);		       \
+	int err, MM;							       \
+									       \
+	err = kstrtoint(buf, 10, &MM);					       \
+	if (err)							       \
+		return err;						       \
+									       \
+	ebeam->newsetting.MM = MM;					       \
+	return count;							       \
+}									       \
+static DEVICE_ATTR_RW(MM)
+
+DEVICE_MINMAX_ATTR(min_x);
+DEVICE_MINMAX_ATTR(max_x);
+DEVICE_MINMAX_ATTR(min_y);
+DEVICE_MINMAX_ATTR(max_y);
+
+#define DEVICE_H_ATTR(SET_ID)						       \
+static ssize_t SET_ID##_show(struct device *dev,			       \
+			     struct device_attribute *attr,		       \
+			     char *buf)					       \
+{									       \
+	struct ebeam_device *ebeam = dev_get_drvdata(dev);		       \
+									       \
+	return snprintf(buf, PAGE_SIZE, "%lld\n", ebeam->cursetting.SET_ID);   \
+}									       \
+static ssize_t SET_ID##_store(struct device *dev,			       \
+			      struct device_attribute *attr,		       \
+			      const char *buf,				       \
+			      size_t count)				       \
+{									       \
+	struct ebeam_device *ebeam = dev_get_drvdata(dev);		       \
+	int err;							       \
+	u64 h;								       \
+									       \
+	err = kstrtoll(buf, 10, &h);					       \
+	if (err)							       \
+		return err;						       \
+									       \
+	ebeam->newsetting.SET_ID = h;					       \
+	return count;							       \
+}									       \
+static DEVICE_ATTR_RW(SET_ID)
+
+DEVICE_H_ATTR(h1);
+DEVICE_H_ATTR(h2);
+DEVICE_H_ATTR(h3);
+DEVICE_H_ATTR(h4);
+DEVICE_H_ATTR(h5);
+DEVICE_H_ATTR(h6);
+DEVICE_H_ATTR(h7);
+DEVICE_H_ATTR(h8);
+DEVICE_H_ATTR(h9);
+
+/*
+ * sysfs calibrated
+ * Once H matrix coefs are set, writing 1 to this file triggers
+ * coordinates mapping.
+ * Anything else reset the device to un-calibrated mode,
+ * storing cursetting in newsetting.
+*/
+static ssize_t calibrated_show(struct device *dev,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct ebeam_device *ebeam = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", ebeam->calibrated);
+}
+
+static ssize_t calibrated_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf,
+				size_t count)
+{
+	struct ebeam_device *ebeam = dev_get_drvdata(dev);
+	int err, c;
+
+	err = kstrtoint(buf, 10, &c);
+	if (err)
+		return err;
+
+	if (c == 1) {
+		memcpy(&ebeam->cursetting, &ebeam->newsetting,
+		       sizeof(struct ebeam_settings));
+		ebeam->calibrated = true;
+		ebeam_setup_input(ebeam, ebeam->input);
+	} else {
+		memcpy(&ebeam->newsetting, &ebeam->cursetting,
+		       sizeof(struct ebeam_settings));
+		ebeam->calibrated = false;
+		ebeam_setup_input(ebeam, ebeam->input);
+	}
+
+	return count;
+}
+
+static DEVICE_ATTR_RW(calibrated);
+
+static struct attribute *ebeam_attrs[] = {
+	&dev_attr_min_x.attr,
+	&dev_attr_min_y.attr,
+	&dev_attr_max_x.attr,
+	&dev_attr_max_y.attr,
+	&dev_attr_h1.attr,
+	&dev_attr_h2.attr,
+	&dev_attr_h3.attr,
+	&dev_attr_h4.attr,
+	&dev_attr_h5.attr,
+	&dev_attr_h6.attr,
+	&dev_attr_h7.attr,
+	&dev_attr_h8.attr,
+	&dev_attr_h9.attr,
+	&dev_attr_calibrated.attr,
+	NULL
+};
+
+static const struct attribute_group ebeam_attr_group = {
+	.attrs = ebeam_attrs,
+};
+
+/* IRQ */
+static int ebeam_read_data(struct ebeam_device *ebeam, unsigned char *pkt)
+{
+
+/*
+ * Packet description : 8 bytes
+ *
+ *  nop packet : FF FF FF FF FF FF FF FF
+ *
+ *  pkt[0] : Sensors
+ *	bit 1 : ultrasound signal (guessed)
+ *	bit 2 : IR signal (tested with a remote...) ;
+ *	readings OK : 0x03 (anything else is a show-stopper)
+ *
+ *  pkt[1] : raw_x low
+ *  pkt[2] : raw_x high
+ *
+ *  pkt[3] : raw_y low
+ *  pkt[4] : raw_y high
+ *
+ *  pkt[5] : fiability ?
+ *	often 0xC0
+ *	> 0x80 : OK
+ *
+ *  pkt[6] :
+ *	buttons state (low 4 bits)
+ *		0x1 = no buttons
+ *		bit 0 : tip (WARNING inversed : 0=pressed)
+ *		bit 1 : ? (always 0 during tests)
+ *		bit 2 : little (1=pressed)
+ *		bit 3 : big (1=pressed)
+ *
+ *	pointer ID : (high 4 bits)
+ *		Tested  : 0x6=wand ;
+ *		Guessed : 0x1=red ; 0x2=blue ; 0x3=green ; 0x4=black ;
+ *			  0x5=eraser
+ *		bit 4 : pointer ID
+ *		bit 5 : pointer ID
+ *		bit 6 : pointer ID
+ *		bit 7 : pointer ID
+ *
+ *
+ *  pkt[7] : fiability ?
+ *	often 0xFF
+ *
+ */
+
+	/* Filtering bad/nop packet */
+	if (pkt[0] != 0x03)
+		return 0;
+
+	ebeam->raw_x = get_unaligned_le16(&pkt[1]);
+	ebeam->raw_y = get_unaligned_le16(&pkt[3]);
+
+	ebeam->btn_map = (!(pkt[6] & 0x1)) |
+			 ((pkt[6] & 0x4) >> 1) |
+			 ((pkt[6] & 0x8) >> 1);
+
+	return 1;
+}
+
+/*
+ * IRQ
+ * compute screen coordinates from raw
+ * Overflow and negative values are ignored
+ */
+static bool ebeam_calculate_xy(struct ebeam_device *ebeam)
+{
+	/* 64-bits divisions handled by div64_s64 */
+
+	s64 scale;
+
+	if (!ebeam->calibrated) {
+		ebeam->x = ebeam->raw_x;
+		ebeam->y = ebeam->raw_y;
+	} else {
+		scale = ebeam->cursetting.h7 * ebeam->raw_x +
+			ebeam->cursetting.h8 * ebeam->raw_y +
+			ebeam->cursetting.h9;
+
+		/* Who want a division by zero in kernel ? */
+		if (scale == 0) {
+			dev_err(&(ebeam->interface)->dev,
+				"%s - Division by zero, wrong calibration.\n",
+				__func__);
+			dev_err(&(ebeam->interface)->dev,
+				"%s - Resetting to un-calibrated mode.\n",
+				__func__);
+			ebeam->calibrated = false;
+			return 0;
+		}
+
+		/*
+		 * We *must* round the result, but can't do (int) (v1/v2 + 0.5)
+		 *
+		 * (int) (v1/v2 + 0.5) <=> (int) ( (2*v1 + v2)/(2*v2) )
+		 */
+		ebeam->x =
+		    (int)div64_s64((((ebeam->cursetting.h1 * ebeam->raw_x +
+				      ebeam->cursetting.h2 * ebeam->raw_y +
+				      ebeam->cursetting.h3) << 1) + scale),
+				   (scale << 1));
+		ebeam->y =
+		    (int)div64_s64((((ebeam->cursetting.h4 * ebeam->raw_x +
+				      ebeam->cursetting.h5 * ebeam->raw_y +
+				      ebeam->cursetting.h6) << 1) + scale),
+				   (scale << 1));
+
+		/* check range */
+		if ((ebeam->x < ebeam->cursetting.min_x) ||
+		    (ebeam->x > ebeam->cursetting.max_x) ||
+		    (ebeam->y < ebeam->cursetting.min_y) ||
+		    (ebeam->y > ebeam->cursetting.max_y))
+			return 0;
+	}
+
+	return 1;
+}
+
+/* IRQ */
+static void ebeam_report_input(struct ebeam_device *ebeam)
+{
+	input_report_key(ebeam->input, BTN_LEFT,
+			 (ebeam->btn_map & EBEAM_BTN_TIP));
+	input_report_key(ebeam->input, BTN_MIDDLE,
+			 (ebeam->btn_map & EBEAM_BTN_LIT));
+	input_report_key(ebeam->input, BTN_RIGHT,
+			 (ebeam->btn_map & EBEAM_BTN_BIG));
+
+	input_report_abs(ebeam->input, ABS_X, ebeam->x);
+	input_report_abs(ebeam->input, ABS_Y, ebeam->y);
+
+	input_sync(ebeam->input);
+}
+
+/* IRQ */
+static void ebeam_process_pkt(struct ebeam_device *ebeam,
+			      unsigned char *pkt, int len)
+{
+	if (!ebeam_read_data(ebeam, pkt))
+		return;
+
+	if (!ebeam_calculate_xy(ebeam))
+		return;
+
+	ebeam_report_input(ebeam);
+}
+
+/* IRQ
+ * handler */
+static void ebeam_irq(struct urb *urb)
+{
+	struct ebeam_device *ebeam = urb->context;
+	struct device *dev = &ebeam->interface->dev;
+	int retval;
+
+	switch (urb->status) {
+	case 0:
+		/* success */
+		break;
+	case -ETIME:
+		/* this urb is timing out */
+		dev_dbg(dev,
+			"%s - urb timed out - was the device unplugged?\n",
+			__func__);
+		return;
+	case -ECONNRESET:
+	case -ENOENT:
+	case -ESHUTDOWN:
+	case -EPIPE:
+		/* this urb is terminated, clean up */
+		dev_dbg(dev, "%s - urb shutting down with status: %d\n",
+			__func__, urb->status);
+		return;
+	default:
+		dev_dbg(dev, "%s - nonzero urb status received: %d\n",
+			__func__, urb->status);
+		goto exit;
+	}
+
+	ebeam_process_pkt(ebeam, ebeam->data, urb->actual_length);
+
+exit:
+	usb_mark_last_busy(interface_to_usbdev(ebeam->interface));
+	retval = usb_submit_urb(urb, GFP_ATOMIC);
+	if (retval)
+		dev_err(dev, "%s - usb_submit_urb failed with result: %d\n",
+			__func__, retval);
+}
+
+static int ebeam_open(struct input_dev *input)
+{
+	struct ebeam_device *ebeam = input_get_drvdata(input);
+	int r;
+
+	ebeam->irq->dev = interface_to_usbdev(ebeam->interface);
+
+	r = usb_autopm_get_interface(ebeam->interface) ? -EIO : 0;
+	if (r < 0)
+		goto out;
+
+	if (usb_submit_urb(ebeam->irq, GFP_KERNEL)) {
+		r = -EIO;
+		goto out_put;
+	}
+
+	ebeam->interface->needs_remote_wakeup = 1;
+out_put:
+	usb_autopm_put_interface(ebeam->interface);
+out:
+	return r;
+}
+
+static void ebeam_close(struct input_dev *input)
+{
+	struct ebeam_device *ebeam = input_get_drvdata(input);
+	int r;
+
+	r = usb_autopm_get_interface(ebeam->interface);
+
+	usb_kill_urb(ebeam->irq);
+	ebeam->interface->needs_remote_wakeup = 0;
+
+	if (!r)
+		usb_autopm_put_interface(ebeam->interface);
+}
+
+static int ebeam_suspend(struct usb_interface *intf, pm_message_t message)
+{
+	struct ebeam_device *ebeam = usb_get_intfdata(intf);
+
+	usb_kill_urb(ebeam->irq);
+
+	return 0;
+}
+
+static int ebeam_resume(struct usb_interface *intf)
+{
+	struct ebeam_device *ebeam = usb_get_intfdata(intf);
+	struct input_dev *input = ebeam->input;
+	int result = 0;
+
+	mutex_lock(&input->mutex);
+	if (input->users)
+		result = usb_submit_urb(ebeam->irq, GFP_NOIO);
+	mutex_unlock(&input->mutex);
+
+	return result;
+}
+
+static void ebeam_free_buffers(struct usb_device *udev,
+			       struct ebeam_device *ebeam)
+{
+	usb_free_coherent(udev, REPT_SIZE, ebeam->data, ebeam->data_dma);
+	kfree(ebeam->buffer);
+}
+
+static struct usb_endpoint_descriptor
+*ebeam_get_input_endpoint(struct usb_host_interface *interface)
+{
+	int i;
+
+	for (i = 0; i < interface->desc.bNumEndpoints; i++)
+		if (usb_endpoint_dir_in(&interface->endpoint[i].desc))
+			return &interface->endpoint[i].desc;
+
+	return NULL;
+}
+
+static int ebeam_probe(struct usb_interface *intf,
+		       const struct usb_device_id *id)
+{
+	struct ebeam_device *ebeam;
+	struct input_dev *input_dev;
+	struct usb_endpoint_descriptor *endpoint;
+	struct usb_device *udev = interface_to_usbdev(intf);
+	int err = -ENOMEM;
+
+	endpoint = ebeam_get_input_endpoint(intf->cur_altsetting);
+	if (!endpoint)
+		return -ENXIO;
+
+	ebeam = kzalloc(sizeof(struct ebeam_device), GFP_KERNEL);
+	input_dev = input_allocate_device();
+	if (!ebeam || !input_dev)
+		goto out_free;
+
+	ebeam_init_settings(ebeam);
+
+	ebeam->data = usb_alloc_coherent(udev, REPT_SIZE,
+					 GFP_KERNEL, &ebeam->data_dma);
+	if (!ebeam->data)
+		goto out_free;
+
+	ebeam->irq = usb_alloc_urb(0, GFP_KERNEL);
+	if (!ebeam->irq) {
+		dev_dbg(&intf->dev,
+			"%s - usb_alloc_urb failed: ebeam->irq\n", __func__);
+		goto out_free_buffers;
+	}
+
+	ebeam->interface = intf;
+	ebeam->input = input_dev;
+
+	/* setup name */
+	snprintf(ebeam->name, sizeof(ebeam->name),
+		 "USB eBeam %04x:%04x",
+		 le16_to_cpu(udev->descriptor.idVendor),
+		 le16_to_cpu(udev->descriptor.idProduct));
+
+	if (udev->manufacturer || udev->product) {
+		strlcat(ebeam->name, " (", sizeof(ebeam->name));
+
+		if (udev->manufacturer)
+			strlcat(ebeam->name,
+				udev->manufacturer,
+				sizeof(ebeam->name));
+
+		if (udev->product) {
+			if (udev->manufacturer)
+				strlcat(ebeam->name, " ", sizeof(ebeam->name));
+			strlcat(ebeam->name,
+				udev->product,
+				sizeof(ebeam->name));
+		}
+
+		if (strlcat(ebeam->name, ")", sizeof(ebeam->name))
+		    >= sizeof(ebeam->name)) {
+			/* overflowed, closing ) anyway */
+			ebeam->name[sizeof(ebeam->name) - 2] = ')';
+		}
+	}
+
+	/* usb tree */
+	usb_make_path(udev, ebeam->phys, sizeof(ebeam->phys));
+	strlcat(ebeam->phys, "/input0", sizeof(ebeam->phys));
+
+	/* input setup */
+	input_dev->name = ebeam->name;
+	input_dev->phys = ebeam->phys;
+	usb_to_input_id(udev, &input_dev->id);
+	input_dev->dev.parent = &intf->dev;
+
+	input_set_drvdata(input_dev, ebeam);
+
+	input_dev->open = ebeam_open;
+	input_dev->close = ebeam_close;
+
+	/* usb urb setup */
+	if (usb_endpoint_type(endpoint) == USB_ENDPOINT_XFER_INT)
+		usb_fill_int_urb(ebeam->irq,
+				 udev,
+				 usb_rcvintpipe(udev,
+						endpoint->bEndpointAddress),
+				 ebeam->data,
+				 REPT_SIZE,
+				 ebeam_irq,
+				 ebeam,
+				 endpoint->bInterval);
+	else
+		usb_fill_bulk_urb(ebeam->irq,
+				  udev,
+				  usb_rcvbulkpipe(udev,
+						  endpoint->bEndpointAddress),
+				  ebeam->data,
+				  REPT_SIZE,
+				  ebeam_irq,
+				  ebeam);
+
+	ebeam->irq->dev = udev;
+	ebeam->irq->transfer_dma = ebeam->data_dma;
+	ebeam->irq->transfer_flags |= URB_NO_TRANSFER_DMA_MAP;
+
+	/* usb final setup */
+	usb_set_intfdata(intf, ebeam);
+
+	/* sysfs setup */
+	err = sysfs_create_group(&intf->dev.kobj, &ebeam_attr_group);
+	if (err) {
+		dev_dbg(&intf->dev,
+			"%s - cannot create sysfs group, err: %d\n",
+			__func__, err);
+		goto out_free_usb;
+	}
+
+	/* input final setup */
+	ebeam_setup_input(ebeam, input_dev);
+
+	err = input_register_device(ebeam->input);
+	if (err) {
+		dev_dbg(&intf->dev,
+			"%s - input_register_device failed, err: %d\n",
+			__func__, err);
+		goto out_remove_sysfs;
+	}
+
+	return 0;
+
+out_remove_sysfs:
+	sysfs_remove_group(&intf->dev.kobj, &ebeam_attr_group);
+out_free_usb:
+	usb_set_intfdata(intf, NULL);
+	usb_free_urb(ebeam->irq);
+out_free_buffers:
+	ebeam_free_buffers(udev, ebeam);
+out_free:
+	input_free_device(input_dev);
+	kfree(ebeam);
+	return err;
+}
+
+static void ebeam_disconnect(struct usb_interface *intf)
+{
+	struct ebeam_device *ebeam = usb_get_intfdata(intf);
+
+	if (!ebeam)
+		return;
+
+	dev_dbg(&intf->dev,
+		"%s - ebeam is initialized, cleaning up\n", __func__);
+
+	usb_set_intfdata(intf, NULL);
+	/* this will stop IO via close */
+	input_unregister_device(ebeam->input);
+	sysfs_remove_group(&intf->dev.kobj, &ebeam_attr_group);
+	usb_free_urb(ebeam->irq);
+	ebeam_free_buffers(interface_to_usbdev(intf), ebeam);
+	kfree(ebeam);
+}
+
+MODULE_DEVICE_TABLE(usb, ebeam_devices);
+
+static struct usb_driver ebeam_driver = {
+	.name =			"ebeam",
+	.probe =		ebeam_probe,
+	.disconnect =		ebeam_disconnect,
+	.suspend =		ebeam_suspend,
+	.resume =		ebeam_resume,
+	.reset_resume =		ebeam_resume,
+	.id_table =		ebeam_devices,
+	.supports_autosuspend =	1,
+};
+
+module_usb_driver(ebeam_driver);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
-- 
2.3.8

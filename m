From: =?iso-8859-1?Q?Cl=E9ment?= Vuchener <clement.vuchener@gmail.com>
Subject: [PATCH v2 1/1] Add Corsair Vengeance K90 driver
Date: Mon, 7 Sep 2015 17:59:32 +0200
Message-ID: <d26b465f52632908a982da6daeb105b3dc823cc8.1441641275.git.clement.vuchener@gmail.com>
References: <cover.1441641275.git.clement.vuchener@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-input-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1441641275.git.clement.vuchener@gmail.com>
Sender: linux-input-owner@vger.kernel.org
To: jikos@kernel.org
Cc: linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This patch implements a HID driver for the Corsair Vengeance K90 keyboa=
rd.=20

It fixes the behaviour of the keys using incorrect HID usage codes and =
exposes the macro playback mode and current profile to the user space t=
hrough sysfs attributes. It also adds two LED class devices controlling=
 the "record" LED and the backlight.

Signed-off-by: Cl=E9ment Vuchener <clement.vuchener@gmail.com>
---
 Documentation/ABI/testing/sysfs-driver-hid-corsair |  15 +
 drivers/hid/Kconfig                                |  10 +
 drivers/hid/Makefile                               |   1 +
 drivers/hid/hid-core.c                             |   1 +
 drivers/hid/hid-corsair.c                          | 555 +++++++++++++=
++++++++
 drivers/hid/hid-ids.h                              |   3 +
 6 files changed, 585 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-driver-hid-corsair
 create mode 100644 drivers/hid/hid-corsair.c

diff --git a/Documentation/ABI/testing/sysfs-driver-hid-corsair b/Docum=
entation/ABI/testing/sysfs-driver-hid-corsair
new file mode 100644
index 0000000..b8827f0
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-driver-hid-corsair
@@ -0,0 +1,15 @@
+What:		/sys/bus/drivers/corsair/<dev>/macro_mode
+Date:		August 2015
+KernelVersion:	4.2
+Contact:	Clement Vuchener <clement.vuchener@gmail.com>
+Description:	Get/set the current playback mode. "SW" for software mode
+		where G-keys triggers their regular key codes. "HW" for
+		hardware playback mode where the G-keys play their macro
+		from the on-board memory.
+
+
+What:		/sys/bus/drivers/corsair/<dev>/current_profile
+Date:		August 2015
+KernelVersion:	4.2
+Contact:	Clement Vuchener <clement.vuchener@gmail.com>
+Description:	Get/set the current selected profile. Values are from 1 t=
o 3.
diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
index 6ab51ae..3fe9678 100644
--- a/drivers/hid/Kconfig
+++ b/drivers/hid/Kconfig
@@ -171,6 +171,16 @@ config HID_CHICONY
 	---help---
 	Support for Chicony Tactical pad.
=20
+config HID_CORSAIR
+	tristate "Corsair devices"
+	depends on HID && USB && LEDS_CLASS
+	---help---
+	Support for Corsair devices that are not fully compliant with the
+	HID standard.
+
+	Supported devices:
+	- Vengeance K90
+
 config HID_PRODIKEYS
 	tristate "Prodikeys PC-MIDI Keyboard support"
 	depends on HID && SND
diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index e6441bc..edaa0f2 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_HID_BELKIN)	+=3D hid-belkin.o
 obj-$(CONFIG_HID_BETOP_FF)	+=3D hid-betopff.o
 obj-$(CONFIG_HID_CHERRY)	+=3D hid-cherry.o
 obj-$(CONFIG_HID_CHICONY)	+=3D hid-chicony.o
+obj-$(CONFIG_HID_CORSAIR)	+=3D hid-corsair.o
 obj-$(CONFIG_HID_CP2112)	+=3D hid-cp2112.o
 obj-$(CONFIG_HID_CYPRESS)	+=3D hid-cypress.o
 obj-$(CONFIG_HID_DRAGONRISE)	+=3D hid-dr.o
diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index bcd914a..d5fc4d1 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -1828,6 +1828,7 @@ static const struct hid_device_id hid_have_specia=
l_driver[] =3D {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_WIRELES=
S2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_AK1D) }=
,
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CHICONY, USB_DEVICE_ID_CHICONY_ACER_SW=
ITCH12) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K90) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CREATIVELABS, USB_DEVICE_ID_PRODIKEYS_=
PCMIDI) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYGNAL, USB_DEVICE_ID_CYGNAL_CP2112) }=
,
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CYPRESS, USB_DEVICE_ID_CYPRESS_BARCODE=
_1) },
diff --git a/drivers/hid/hid-corsair.c b/drivers/hid/hid-corsair.c
new file mode 100644
index 0000000..580c214
--- /dev/null
+++ b/drivers/hid/hid-corsair.c
@@ -0,0 +1,555 @@
+/*
+ * HID driver for Corsair devices
+ *
+ * Supported devices:
+ *  - Vengeance K90 Keyboard
+ *
+ * Copyright (c) 2015 Clement Vuchener
+ */
+
+/*
+ * This program is free software; you can redistribute it and/or modif=
y it
+ * under the terms of the GNU General Public License as published by t=
he Free
+ * Software Foundation; either version 2 of the License, or (at your o=
ption)
+ * any later version.
+ */
+
+#include <linux/hid.h>
+#include <linux/module.h>
+#include <linux/usb.h>
+#include <linux/leds.h>
+
+#include "hid-ids.h"
+
+struct k90_led {
+	struct led_classdev cdev;
+	int brightness;
+	struct work_struct work;
+	int removed;
+};
+
+struct k90_drvdata {
+	int current_profile;
+	int macro_mode;
+	int meta_locked;
+	struct k90_led backlight;
+	struct k90_led record_led;
+};
+
+#define K90_GKEY_COUNT	18
+
+static int k90_usage_to_gkey(unsigned int usage)
+{
+	/* G1 (0xd0) to G16 (0xdf) */
+	if (usage >=3D 0xd0 && usage <=3D 0xdf)
+		return usage - 0xd0 + 1;
+	/* G17 (0xe8) to G18 (0xe9) */
+	if (usage >=3D 0xe8 && usage <=3D 0xe9)
+		return usage - 0xe8 + 17;
+	return 0;
+}
+
+static unsigned short k90_gkey_map[K90_GKEY_COUNT] =3D {
+	BTN_TRIGGER_HAPPY1,
+	BTN_TRIGGER_HAPPY2,
+	BTN_TRIGGER_HAPPY3,
+	BTN_TRIGGER_HAPPY4,
+	BTN_TRIGGER_HAPPY5,
+	BTN_TRIGGER_HAPPY6,
+	BTN_TRIGGER_HAPPY7,
+	BTN_TRIGGER_HAPPY8,
+	BTN_TRIGGER_HAPPY9,
+	BTN_TRIGGER_HAPPY10,
+	BTN_TRIGGER_HAPPY11,
+	BTN_TRIGGER_HAPPY12,
+	BTN_TRIGGER_HAPPY13,
+	BTN_TRIGGER_HAPPY14,
+	BTN_TRIGGER_HAPPY15,
+	BTN_TRIGGER_HAPPY16,
+	BTN_TRIGGER_HAPPY17,
+	BTN_TRIGGER_HAPPY18,
+};
+
+module_param_array_named(gkey_codes, k90_gkey_map, ushort, NULL, S_IRU=
GO);
+
+#define K90_USAGE_SPECIAL_MIN 0xf0
+#define K90_USAGE_SPECIAL_MAX 0xff
+
+#define K90_USAGE_MACRO_RECORD_START 0xf6
+#define K90_USAGE_MACRO_RECORD_STOP 0xf7
+
+#define K90_USAGE_PROFILE 0xf1
+#define K90_USAGE_M1 0xf1
+#define K90_USAGE_M2 0xf2
+#define K90_USAGE_M3 0xf3
+#define K90_USAGE_PROFILE_MAX 0xf3
+
+#define K90_USAGE_META_OFF 0xf4
+#define K90_USAGE_META_ON  0xf5
+
+#define K90_USAGE_LIGHT 0xfa
+#define K90_USAGE_LIGHT_OFF 0xfa
+#define K90_USAGE_LIGHT_DIM 0xfb
+#define K90_USAGE_LIGHT_MEDIUM 0xfc
+#define K90_USAGE_LIGHT_BRIGHT 0xfd
+#define K90_USAGE_LIGHT_MAX 0xfd
+
+/* USB control protocol */
+
+#define K90_REQUEST_BRIGHTNESS 49
+#define K90_REQUEST_MACRO_MODE 2
+#define K90_REQUEST_STATUS 4
+#define K90_REQUEST_GET_MODE 5
+#define K90_REQUEST_PROFILE 20
+
+#define K90_MACRO_MODE_SW 0x0030
+#define K90_MACRO_MODE_HW 0x0001
+
+#define K90_MACRO_LED_ON  0x0020
+#define K90_MACRO_LED_OFF 0x0040
+
+/*
+ * LED class devices
+ */
+
+#define K90_BACKLIGHT_LED_SUFFIX ":blue:backlight"
+#define K90_RECORD_LED_SUFFIX ":red:record"
+
+static enum led_brightness k90_brightness_get(struct led_classdev *led=
_cdev)
+{
+	struct k90_led *led =3D container_of(led_cdev, struct k90_led, cdev);
+
+	return led->brightness;
+}
+
+static void k90_brightness_set(struct led_classdev *led_cdev,
+			       enum led_brightness brightness)
+{
+	struct k90_led *led =3D container_of(led_cdev, struct k90_led, cdev);
+
+	led->brightness =3D brightness;
+	schedule_work(&led->work);
+}
+
+static void k90_backlight_work(struct work_struct *work)
+{
+	int ret;
+	struct k90_led *led =3D container_of(work, struct k90_led, work);
+	struct device *dev;
+	struct usb_interface *usbif;
+	struct usb_device *usbdev;
+
+	if (led->removed)
+		return;
+
+	dev =3D led->cdev.dev->parent;
+	usbif =3D to_usb_interface(dev->parent);
+	usbdev =3D interface_to_usbdev(usbif);
+
+	ret =3D usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0),
+			      K90_REQUEST_BRIGHTNESS,
+			      USB_DIR_OUT | USB_TYPE_VENDOR |
+			      USB_RECIP_DEVICE, led->brightness, 0,
+			      NULL, 0, USB_CTRL_SET_TIMEOUT);
+	if (ret !=3D 0)
+		dev_warn(dev, "Failed to set backlight brightness (error: %d).\n",
+			 ret);
+}
+
+static void k90_record_led_work(struct work_struct *work)
+{
+	int ret;
+	struct k90_led *led =3D container_of(work, struct k90_led, work);
+	struct device *dev;
+	struct usb_interface *usbif;
+	struct usb_device *usbdev;
+	int value;
+
+	if (led->removed)
+		return;
+
+	dev =3D led->cdev.dev->parent;
+	usbif =3D to_usb_interface(dev->parent);
+	usbdev =3D interface_to_usbdev(usbif);
+
+	if (led->brightness > 0)
+		value =3D K90_MACRO_LED_ON;
+	else
+		value =3D K90_MACRO_LED_OFF;
+
+	ret =3D usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0),
+			      K90_REQUEST_MACRO_MODE,
+			      USB_DIR_OUT | USB_TYPE_VENDOR |
+			      USB_RECIP_DEVICE, value, 0, NULL, 0,
+			      USB_CTRL_SET_TIMEOUT);
+	if (ret !=3D 0)
+		dev_warn(dev, "Failed to set record LED state (error: %d).\n",
+			 ret);
+}
+
+/*
+ * Keyboard attributes
+ */
+
+static ssize_t k90_show_macro_mode(struct device *dev,
+				   struct device_attribute *attr, char *buf)
+{
+	struct k90_drvdata *drvdata =3D dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+			(drvdata->macro_mode ? "HW" : "SW"));
+}
+
+static ssize_t k90_store_macro_mode(struct device *dev,
+				    struct device_attribute *attr,
+				    const char *buf, size_t count)
+{
+	int ret;
+	struct usb_interface *usbif =3D to_usb_interface(dev->parent);
+	struct usb_device *usbdev =3D interface_to_usbdev(usbif);
+	struct k90_drvdata *drvdata =3D dev_get_drvdata(dev);
+	__u16 value;
+
+	if (strncmp(buf, "SW", 2) =3D=3D 0)
+		value =3D K90_MACRO_MODE_SW;
+	else if (strncmp(buf, "HW", 2) =3D=3D 0)
+		value =3D K90_MACRO_MODE_HW;
+	else
+		return -EINVAL;
+
+	ret =3D usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0),
+			      K90_REQUEST_MACRO_MODE,
+			      USB_DIR_OUT | USB_TYPE_VENDOR |
+			      USB_RECIP_DEVICE, value, 0, NULL, 0,
+			      USB_CTRL_SET_TIMEOUT);
+	if (ret !=3D 0)
+		return ret;
+
+	drvdata->macro_mode =3D (value =3D=3D K90_MACRO_MODE_HW);
+
+	return count;
+}
+
+static ssize_t k90_show_current_profile(struct device *dev,
+					struct device_attribute *attr,
+					char *buf)
+{
+	struct k90_drvdata *drvdata =3D dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n", drvdata->current_profile);
+}
+
+static ssize_t k90_store_current_profile(struct device *dev,
+					 struct device_attribute *attr,
+					 const char *buf, size_t count)
+{
+	int ret;
+	struct usb_interface *usbif =3D to_usb_interface(dev->parent);
+	struct usb_device *usbdev =3D interface_to_usbdev(usbif);
+	struct k90_drvdata *drvdata =3D dev_get_drvdata(dev);
+	int profile;
+
+	if (kstrtoint(buf, 10, &profile))
+		return -EINVAL;
+	if (profile < 1 || profile > 3)
+		return -EINVAL;
+
+	ret =3D usb_control_msg(usbdev, usb_sndctrlpipe(usbdev, 0),
+			      K90_REQUEST_PROFILE,
+			      USB_DIR_OUT | USB_TYPE_VENDOR |
+			      USB_RECIP_DEVICE, profile, 0, NULL, 0,
+			      USB_CTRL_SET_TIMEOUT);
+	if (ret !=3D 0)
+		return ret;
+
+	drvdata->current_profile =3D profile;
+
+	return count;
+}
+
+static DEVICE_ATTR(macro_mode, 0644, k90_show_macro_mode, k90_store_ma=
cro_mode);
+static DEVICE_ATTR(current_profile, 0644, k90_show_current_profile,
+		   k90_store_current_profile);
+
+static struct attribute *k90_attrs[] =3D {
+	&dev_attr_macro_mode.attr,
+	&dev_attr_current_profile.attr,
+	NULL
+};
+
+static const struct attribute_group k90_attr_group =3D {
+	.attrs =3D k90_attrs,
+};
+
+/*
+ * Driver functions
+ */
+
+static int k90_init_special_functions(struct hid_device *dev)
+{
+	int ret;
+	struct usb_interface *usbif =3D to_usb_interface(dev->dev.parent);
+	struct usb_device *usbdev =3D interface_to_usbdev(usbif);
+	char data[8];
+	struct k90_drvdata *drvdata =3D
+	    kzalloc(sizeof(struct k90_drvdata), GFP_KERNEL);
+	size_t name_sz;
+	char *name;
+	struct k90_led *led;
+
+	if (!drvdata) {
+		ret =3D -ENOMEM;
+		goto fail_drvdata;
+	}
+	hid_set_drvdata(dev, drvdata);
+
+	/* The record LED is initially off */
+	drvdata->record_led.brightness =3D 0;
+
+	/* Get current status */
+	ret =3D usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0),
+			      K90_REQUEST_STATUS,
+			      USB_DIR_IN | USB_TYPE_VENDOR |
+			      USB_RECIP_DEVICE, 0, 0, data, 8,
+			      USB_CTRL_SET_TIMEOUT);
+	if (ret < 0) {
+		hid_warn(dev, "Failed to get K90 initial state (error %d).\n",
+			 ret);
+		drvdata->backlight.brightness =3D 0;
+		drvdata->current_profile =3D 1;
+	} else {
+		drvdata->backlight.brightness =3D data[4];
+		drvdata->current_profile =3D data[7];
+	}
+	/* Get current mode */
+	ret =3D usb_control_msg(usbdev, usb_rcvctrlpipe(usbdev, 0),
+			      K90_REQUEST_GET_MODE,
+			      USB_DIR_IN | USB_TYPE_VENDOR |
+			      USB_RECIP_DEVICE, 0, 0, data, 2,
+			      USB_CTRL_SET_TIMEOUT);
+	if (ret < 0)
+		hid_warn(dev, "Failed to get K90 initial mode (error %d).\n",
+			 ret);
+	else {
+		switch (data[0]) {
+		case K90_MACRO_MODE_HW:
+			drvdata->macro_mode =3D 1;
+			break;
+		case K90_MACRO_MODE_SW:
+			drvdata->macro_mode =3D 0;
+			break;
+		default:
+			hid_warn(dev, "K90 in unknown mode: %02x.\n",
+				 data[0]);
+		}
+	}
+
+	/* Init LED device for backlight */
+	name_sz =3D
+	    strlen(dev_name(&dev->dev)) + sizeof(K90_BACKLIGHT_LED_SUFFIX);
+	name =3D devm_kzalloc(&dev->dev, name_sz, GFP_KERNEL);
+	if (!name) {
+		ret =3D -ENOMEM;
+		goto fail_backlight;
+	}
+	snprintf(name, name_sz, "%s" K90_BACKLIGHT_LED_SUFFIX,
+		 dev_name(&dev->dev));
+	led =3D &drvdata->backlight;
+	led->removed =3D 0;
+	led->cdev.name =3D name;
+	led->cdev.max_brightness =3D 3;
+	led->cdev.brightness_set =3D k90_brightness_set;
+	led->cdev.brightness_get =3D k90_brightness_get;
+	INIT_WORK(&led->work, k90_backlight_work);
+	ret =3D led_classdev_register(&dev->dev, &led->cdev);
+	if (ret !=3D 0)
+		goto fail_backlight;
+
+	/* Init LED device for record LED */
+	name_sz =3D strlen(dev_name(&dev->dev)) + sizeof(K90_RECORD_LED_SUFFI=
X);
+	name =3D devm_kzalloc(&dev->dev, name_sz, GFP_KERNEL);
+	if (!name) {
+		ret =3D -ENOMEM;
+		goto fail_record_led;
+	}
+	snprintf(name, name_sz, "%s" K90_RECORD_LED_SUFFIX,
+		 dev_name(&dev->dev));
+	led =3D &drvdata->record_led;
+	led->removed =3D 0;
+	led->cdev.name =3D name;
+	led->cdev.max_brightness =3D 1;
+	led->cdev.brightness_set =3D k90_brightness_set;
+	led->cdev.brightness_get =3D k90_brightness_get;
+	INIT_WORK(&led->work, k90_record_led_work);
+	ret =3D led_classdev_register(&dev->dev, &led->cdev);
+	if (ret !=3D 0)
+		goto fail_record_led;
+
+	/* Init attributes */
+	ret =3D sysfs_create_group(&dev->dev.kobj, &k90_attr_group);
+	if (ret !=3D 0)
+		goto fail_sysfs;
+
+	return 0;
+
+fail_sysfs:
+	drvdata->record_led.removed =3D 1;
+	led_classdev_unregister(&drvdata->record_led.cdev);
+	cancel_work_sync(&drvdata->record_led.work);
+fail_record_led:
+	drvdata->backlight.removed =3D 1;
+	led_classdev_unregister(&drvdata->backlight.cdev);
+	cancel_work_sync(&drvdata->backlight.work);
+fail_backlight:
+	kfree(drvdata);
+fail_drvdata:
+	hid_set_drvdata(dev, NULL);
+	return ret;
+}
+
+static void k90_cleanup_special_functions(struct hid_device *dev)
+{
+	struct k90_drvdata *drvdata =3D hid_get_drvdata(dev);
+
+	if (drvdata) {
+		sysfs_remove_group(&dev->dev.kobj, &k90_attr_group);
+		drvdata->record_led.removed =3D 1;
+		drvdata->backlight.removed =3D 1;
+		led_classdev_unregister(&drvdata->record_led.cdev);
+		led_classdev_unregister(&drvdata->backlight.cdev);
+		cancel_work_sync(&drvdata->record_led.work);
+		cancel_work_sync(&drvdata->backlight.work);
+		kfree(drvdata);
+	}
+}
+
+static int corsair_probe(struct hid_device *dev, const struct hid_devi=
ce_id *id)
+{
+	int ret;
+	struct usb_interface *usbif =3D to_usb_interface(dev->dev.parent);
+
+	ret =3D hid_parse(dev);
+	if (ret !=3D 0) {
+		hid_err(dev, "parse failed\n");
+		return ret;
+	}
+	ret =3D hid_hw_start(dev, HID_CONNECT_DEFAULT);
+	if (ret !=3D 0) {
+		hid_err(dev, "hw start failed\n");
+		return ret;
+	}
+
+	if (usbif->cur_altsetting->desc.bInterfaceNumber =3D=3D 0) {
+		ret =3D k90_init_special_functions(dev);
+		if (ret !=3D 0)
+			hid_warn(dev, "Failed to initialize K90 special functions.\n");
+	} else
+		hid_set_drvdata(dev, NULL);
+
+	return 0;
+}
+
+static void corsair_remove(struct hid_device *dev)
+{
+	struct usb_interface *usbif =3D to_usb_interface(dev->dev.parent);
+
+	if (usbif->cur_altsetting->desc.bInterfaceNumber =3D=3D 0)
+		k90_cleanup_special_functions(dev);
+
+	hid_hw_stop(dev);
+}
+
+static int corsair_event(struct hid_device *dev, struct hid_field *fie=
ld,
+			 struct hid_usage *usage, __s32 value)
+{
+	struct k90_drvdata *drvdata =3D hid_get_drvdata(dev);
+
+	if (!drvdata)
+		return 0;
+
+	switch (usage->hid & HID_USAGE) {
+	case K90_USAGE_MACRO_RECORD_START:
+		drvdata->record_led.brightness =3D 1;
+		break;
+	case K90_USAGE_MACRO_RECORD_STOP:
+		drvdata->record_led.brightness =3D 0;
+		break;
+	case K90_USAGE_M1:
+	case K90_USAGE_M2:
+	case K90_USAGE_M3:
+		drvdata->current_profile =3D
+		    (usage->hid & HID_USAGE) - K90_USAGE_PROFILE + 1;
+		break;
+	case K90_USAGE_META_OFF:
+		drvdata->meta_locked =3D 0;
+		break;
+	case K90_USAGE_META_ON:
+		drvdata->meta_locked =3D 1;
+		break;
+	case K90_USAGE_LIGHT_OFF:
+	case K90_USAGE_LIGHT_DIM:
+	case K90_USAGE_LIGHT_MEDIUM:
+	case K90_USAGE_LIGHT_BRIGHT:
+		drvdata->backlight.brightness =3D (usage->hid & HID_USAGE) -
+		    K90_USAGE_LIGHT;
+		break;
+	default:
+		break;
+	}
+
+	return 0;
+}
+
+static int corsair_input_mapping(struct hid_device *dev,
+				 struct hid_input *input,
+				 struct hid_field *field,
+				 struct hid_usage *usage, unsigned long **bit,
+				 int *max)
+{
+	int gkey;
+
+	gkey =3D k90_usage_to_gkey(usage->hid & HID_USAGE);
+	if (gkey !=3D 0) {
+		hid_map_usage_clear(input, usage, bit, max, EV_KEY,
+				    k90_gkey_map[gkey - 1]);
+		return 1;
+	}
+	if ((usage->hid & HID_USAGE) >=3D K90_USAGE_SPECIAL_MIN &&
+	    (usage->hid & HID_USAGE) <=3D K90_USAGE_SPECIAL_MAX)
+		return -1;
+
+	return 0;
+}
+
+static const struct hid_device_id corsair_devices[] =3D {
+	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K90) },
+	{}
+};
+
+MODULE_DEVICE_TABLE(hid, corsair_devices);
+
+static struct hid_driver corsair_driver =3D {
+	.name =3D "corsair",
+	.id_table =3D corsair_devices,
+	.probe =3D corsair_probe,
+	.event =3D corsair_event,
+	.remove =3D corsair_remove,
+	.input_mapping =3D corsair_input_mapping,
+};
+
+static int __init corsair_init(void)
+{
+	return hid_register_driver(&corsair_driver);
+}
+
+static void corsair_exit(void)
+{
+	hid_unregister_driver(&corsair_driver);
+}
+
+module_init(corsair_init);
+module_exit(corsair_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Clement Vuchener");
+MODULE_DESCRIPTION("HID driver for Corsair devices");
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index f769208..45a61e6 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -251,6 +251,9 @@
 #define USB_DEVICE_ID_CODEMERCS_IOW_FIRST	0x1500
 #define USB_DEVICE_ID_CODEMERCS_IOW_LAST	0x15ff
=20
+#define USB_VENDOR_ID_CORSAIR		0x1b1c
+#define USB_DEVICE_ID_CORSAIR_K90	0x1b02
+
 #define USB_VENDOR_ID_CREATIVELABS	0x041e
 #define USB_DEVICE_ID_PRODIKEYS_PCMIDI	0x2801
=20
--=20
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-input" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Yann Cantin <yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Subject: [ebeam PATCH v2 1/2] hid: Blacklist eBeam devices
Date: Sun, 23 Aug 2015 00:06:03 +0200
Message-ID: <1440281164-23111-2-git-send-email-yann.cantin@laposte.net>
References: <1440281164-23111-1-git-send-email-yann.cantin@laposte.net>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440281164-23111-1-git-send-email-yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jkosina-AlSwsSmVLrQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, oneukum-IBi9RG/b67k@public.gmane.org, Yann Cantin <yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Add known eBeam devices usb ids.
Prevent hid-generic to take over these devices. This breaks Luidia's
proprietary application suite.

Signed-off-by: Yann Cantin <yann.cantin-QFKgK+z4sOrR7s880joybQ@public.gmane.org>
---
 drivers/hid/hid-core.c      |  6 ++++++
 drivers/hid/hid-ids.h       |  6 ++++++
 drivers/input/misc/Kconfig  | 22 ++++++++++++++++++++++
 drivers/input/misc/Makefile |  1 +
 4 files changed, 35 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index e6fce23..b5edb0f 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2270,6 +2270,12 @@ static const struct hid_device_id hid_ignore_list[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DELORME, USB_DEVICE_ID_DELORME_EM_LT20) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DREAM_CHEEKY, 0x0004) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_DREAM_CHEEKY, 0x000a) },
+#if defined(CONFIG_INPUT_EBEAM_USB)
+	{ HID_USB_DEVICE(USB_VENDOR_ID_EFI, USB_DEVICE_ID_EFI_EBEAM_USB1) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_EFI, USB_DEVICE_ID_EFI_EBEAM_USB2) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_EFI, USB_DEVICE_ID_EFI_EBEAM_BT_USB1) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_EFI, USB_DEVICE_ID_EFI_EBEAM_BT_USB2) },
+#endif
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ESSENTIAL_REALITY, USB_DEVICE_ID_ESSENTIAL_REALITY_P5) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC5UH) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_ETT, USB_DEVICE_ID_TC4UM) },
diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index b3b225b..aa6f2da 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -306,6 +306,12 @@
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_73F7	0x73f7
 #define USB_DEVICE_ID_DWAV_EGALAX_MULTITOUCH_A001	0xa001
 
+#define USB_VENDOR_ID_EFI		0x2650
+#define USB_DEVICE_ID_EFI_EBEAM_USB1	0x1311
+#define USB_DEVICE_ID_EFI_EBEAM_USB2	0x1315
+#define USB_DEVICE_ID_EFI_EBEAM_BT_USB1	0x1313
+#define USB_DEVICE_ID_EFI_EBEAM_BT_USB2	0x1320
+
 #define USB_VENDOR_ID_ELAN		0x04f3
 #define USB_DEVICE_ID_ELAN_TOUCHSCREEN	0x0089
 #define USB_DEVICE_ID_ELAN_TOUCHSCREEN_009B	0x009b
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
-- 
2.3.8

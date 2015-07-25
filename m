From: Yann Cantin <yann.cantin@laposte.net>
Subject: [RFC ebeam PATCH v2 1/2] hid: Blacklist eBeam devices
Date: Sat, 25 Jul 2015 20:48:24 +0200
Message-ID: <1437850105-4814-2-git-send-email-yann.cantin@laposte.net>
References: <1437850105-4814-1-git-send-email-yann.cantin@laposte.net>
Return-path: <linux-input-owner@vger.kernel.org>
In-Reply-To: <1437850105-4814-1-git-send-email-yann.cantin@laposte.net>
Sender: linux-input-owner@vger.kernel.org
To: linux-input@vger.kernel.org, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, dmitry.torokhov@gmail.com, jkosina@suse.cz, gregkh@linuxfoundation.org, oneukum@suse.com, Yann Cantin <yann.cantin@laposte.net>
List-Id: linux-api@vger.kernel.org

Add known eBeam devices usb ids.
Prevent hid-generic to take over these devices. This breaks Luidia's
proprietary application suite.

Signed-off-by: Yann Cantin <yann.cantin@laposte.net>
---
 drivers/hid/hid-core.c | 6 ++++++
 drivers/hid/hid-ids.h  | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.c
index 157c627..db4c7ee 100644
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -2267,6 +2267,12 @@ static const struct hid_device_id hid_ignore_list[] = {
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
index b04b082..ca013c2 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -303,6 +303,12 @@
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
-- 
2.3.8


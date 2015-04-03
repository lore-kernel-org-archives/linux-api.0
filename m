From: Azael Avalos <coproscefalo@gmail.com>
Subject: [PATCH v3 2/3] toshiba_acpi: Fix pr_* messages from USB Sleep Functions
Date: Thu,  2 Apr 2015 19:27:18 -0600
Message-ID: <1428024438-3876-1-git-send-email-coproscefalo@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Darren Hart <dvhart@infradead.org>, platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Azael Avalos <coproscefalo@gmail.com>
List-Id: linux-api@vger.kernel.org

This patch fixes the messages displayed by the USB Sleep Functions,
they were printing wrong messages not associated to the feature
currently queried.

Signed-off-by: Azael Avalos <coproscefalo@gmail.com>
---
 drivers/platform/x86/toshiba_acpi.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/platform/x86/toshiba_acpi.c b/drivers/platform/x86/toshiba_acpi.c
index 37f5f64..f624dd5 100644
--- a/drivers/platform/x86/toshiba_acpi.c
+++ b/drivers/platform/x86/toshiba_acpi.c
@@ -965,11 +965,11 @@ static int toshiba_usb_rapid_charge_get(struct toshiba_acpi_dev *dev,
 	status = tci_raw(dev, in, out);
 	sci_close(dev);
 	if (ACPI_FAILURE(status) || out[0] == TOS_FAILURE) {
-		pr_err("ACPI call to get USB S&C battery level failed\n");
+		pr_err("ACPI call to get USB Rapid Charge failed\n");
 		return -EIO;
 	} else if (out[0] == TOS_NOT_SUPPORTED ||
 		   out[0] == TOS_INPUT_DATA_ERROR) {
-		pr_info("USB Sleep and Charge not supported\n");
+		pr_info("USB Rapid Charge not supported\n");
 		return -ENODEV;
 	}
 
@@ -993,10 +993,10 @@ static int toshiba_usb_rapid_charge_set(struct toshiba_acpi_dev *dev,
 	status = tci_raw(dev, in, out);
 	sci_close(dev);
 	if (ACPI_FAILURE(status) || out[0] == TOS_FAILURE) {
-		pr_err("ACPI call to set USB S&C battery level failed\n");
+		pr_err("ACPI call to set USB Rapid Charge failed\n");
 		return -EIO;
 	} else if (out[0] == TOS_NOT_SUPPORTED) {
-		pr_info("USB Sleep and Charge not supported\n");
+		pr_info("USB Rapid Charge not supported\n");
 		return -ENODEV;
 	} else if (out[0] == TOS_INPUT_DATA_ERROR) {
 		return -EIO;
@@ -1015,10 +1015,10 @@ static int toshiba_usb_sleep_music_get(struct toshiba_acpi_dev *dev, u32 *state)
 	result = sci_read(dev, SCI_USB_SLEEP_MUSIC, state);
 	sci_close(dev);
 	if (result == TOS_FAILURE) {
-		pr_err("ACPI call to set USB S&C mode failed\n");
+		pr_err("ACPI call to get Sleep and Music failed\n");
 		return -EIO;
 	} else if (result == TOS_NOT_SUPPORTED) {
-		pr_info("USB Sleep and Charge not supported\n");
+		pr_info("Sleep and Music not supported\n");
 		return -ENODEV;
 	} else if (result == TOS_INPUT_DATA_ERROR) {
 		return -EIO;
@@ -1037,10 +1037,10 @@ static int toshiba_usb_sleep_music_set(struct toshiba_acpi_dev *dev, u32 state)
 	result = sci_write(dev, SCI_USB_SLEEP_MUSIC, state);
 	sci_close(dev);
 	if (result == TOS_FAILURE) {
-		pr_err("ACPI call to set USB S&C mode failed\n");
+		pr_err("ACPI call to set Sleep and Music failed\n");
 		return -EIO;
 	} else if (result == TOS_NOT_SUPPORTED) {
-		pr_info("USB Sleep and Charge not supported\n");
+		pr_info("Sleep and Music not supported\n");
 		return -ENODEV;
 	} else if (result == TOS_INPUT_DATA_ERROR) {
 		return -EIO;
-- 
2.3.4

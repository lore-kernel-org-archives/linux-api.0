From: Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 6/9] HSI: cmt_speech: Rename driver to cmt-speech
Date: Mon,  2 Mar 2015 05:38:56 +0100
Message-ID: <1425271139-24715-7-git-send-email-sre@kernel.org>
References: <1425271139-24715-1-git-send-email-sre@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425271139-24715-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pavel Machek <pavel@ucw.cz>, Pali Rohar <pali.rohar@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Rename driver and platform alias to cmt-speech, so that
it's consistent with the ssi-protocol driver.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/hsi/clients/cmt_speech.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index 8d9860b..52001ed 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -40,7 +40,6 @@
 #include <linux/cs-protocol.h>
 
 #define CS_MMAP_SIZE	PAGE_SIZE
-#define DRIVER_NAME	"cmt_speech"
 
 struct char_queue {
 	struct list_head	list;
@@ -1365,7 +1364,7 @@ static const struct file_operations cs_char_fops = {
 
 static struct miscdevice cs_char_miscdev = {
 	.minor	= MISC_DYNAMIC_MINOR,
-	.name	= DRIVER_NAME,
+	.name	= "cmt_speech",
 	.fops	= &cs_char_fops
 };
 
@@ -1408,7 +1407,7 @@ static int cs_hsi_client_remove(struct device *dev)
 
 static struct hsi_client_driver cs_hsi_driver = {
 	.driver = {
-		.name	= DRIVER_NAME,
+		.name	= "cmt-speech",
 		.owner	= THIS_MODULE,
 		.probe	= cs_hsi_client_probe,
 		.remove	= cs_hsi_client_remove,
@@ -1429,7 +1428,7 @@ static void __exit cs_char_exit(void)
 }
 module_exit(cs_char_exit);
 
-MODULE_ALIAS("hsi:cmt_speech");
+MODULE_ALIAS("hsi:cmt-speech");
 MODULE_AUTHOR("Kai Vehmanen <kai.vehmanen@nokia.com>");
 MODULE_AUTHOR("Peter Ujfalusi <peter.ujfalusi@nokia.com>");
 MODULE_DESCRIPTION("CMT speech driver");
-- 
2.1.4

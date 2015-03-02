From: Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 5/9] HSI: cmt_speech: Cleanup initialisation
Date: Mon,  2 Mar 2015 05:38:55 +0100
Message-ID: <1425271139-24715-6-git-send-email-sre@kernel.org>
References: <1425271139-24715-1-git-send-email-sre@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425271139-24715-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pavel Machek <pavel@ucw.cz>, Pali Rohar <pali.rohar@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Cleanup initialisation process, so that its similar to
the style used in ssi_protocol driver.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/hsi/clients/cmt_speech.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index 6d852ea..8d9860b 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -1369,7 +1369,7 @@ static struct miscdevice cs_char_miscdev = {
 	.fops	= &cs_char_fops
 };
 
-static int __init cs_hsi_client_probe(struct device *dev)
+static int cs_hsi_client_probe(struct device *dev)
 {
 	int err = 0;
 	struct hsi_client *cl = to_hsi_client(dev);
@@ -1385,12 +1385,12 @@ static int __init cs_hsi_client_probe(struct device *dev)
 
 	err = misc_register(&cs_char_miscdev);
 	if (err)
-		dev_err(dev, "Failed to register\n");
+		dev_err(dev, "Failed to register: %d\n", err);
 
 	return err;
 }
 
-static int __exit cs_hsi_client_remove(struct device *dev)
+static int cs_hsi_client_remove(struct device *dev)
 {
 	struct cs_hsi_iface *hi;
 
@@ -1417,19 +1417,15 @@ static struct hsi_client_driver cs_hsi_driver = {
 
 static int __init cs_char_init(void)
 {
-	int err = 0;
-
-	err = hsi_register_client_driver(&cs_hsi_driver);
-	if (err)
-		pr_err(DRIVER_NAME ": Error when registering driver %d\n", err);
-
-	return err;
+	pr_info("CMT speech driver added\n");
+	return hsi_register_client_driver(&cs_hsi_driver);
 }
 module_init(cs_char_init);
 
 static void __exit cs_char_exit(void)
 {
 	hsi_unregister_client_driver(&cs_hsi_driver);
+	pr_info("CMT speech driver removed\n");
 }
 module_exit(cs_char_exit);
 
-- 
2.1.4

From: Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 8/9] HSI: cmt_speech: Remove hardcoded channel numbers
Date: Mon,  2 Mar 2015 05:38:58 +0100
Message-ID: <1425271139-24715-9-git-send-email-sre@kernel.org>
References: <1425271139-24715-1-git-send-email-sre@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425271139-24715-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pavel Machek <pavel@ucw.cz>, Pali Rohar <pali.rohar@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

cmt-speech channel numbers should be coming from Device Tree
instead of being hardcoded.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/hsi/clients/cmt_speech.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index 69dc37f..a017292 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -59,6 +59,9 @@ struct cs_char {
 	spinlock_t		lock;
 	struct fasync_struct	*async_queue;
 	wait_queue_head_t	wait;
+	/* hsi channel ids */
+	int                     channel_id_cmd;
+	int                     channel_id_data;
 };
 
 #define SSI_CHANNEL_STATE_READING	1
@@ -66,9 +69,6 @@ struct cs_char {
 #define SSI_CHANNEL_STATE_POLL		(1 << 2)
 #define SSI_CHANNEL_STATE_ERROR		(1 << 3)
 
-#define CONTROL_HSI_CH			1
-#define DATA_HSI_CH			2
-
 #define TARGET_MASK			0xf000000
 #define TARGET_REMOTE			(1 << CS_DOMAIN_SHIFT)
 #define TARGET_LOCAL			0
@@ -296,7 +296,7 @@ static int cs_alloc_cmds(struct cs_hsi_iface *hi)
 			goto out;
 		}
 		sg_init_one(msg->sgt.sgl, buf, sizeof(*buf));
-		msg->channel = CONTROL_HSI_CH;
+		msg->channel = cs_char_data.channel_id_cmd;
 		msg->context = hi;
 		list_add_tail(&msg->link, &hi->cmdqueue);
 	}
@@ -342,7 +342,7 @@ static int cs_hsi_alloc_data(struct cs_hsi_iface *hi)
 		res = -ENOMEM;
 		goto out1;
 	}
-	rxmsg->channel = DATA_HSI_CH;
+	rxmsg->channel = cs_char_data.channel_id_data;
 	rxmsg->destructor = cs_hsi_data_destructor;
 	rxmsg->context = hi;
 
@@ -351,7 +351,7 @@ static int cs_hsi_alloc_data(struct cs_hsi_iface *hi)
 		res = -ENOMEM;
 		goto out2;
 	}
-	txmsg->channel = DATA_HSI_CH;
+	txmsg->channel = cs_char_data.channel_id_data;
 	txmsg->destructor = cs_hsi_data_destructor;
 	txmsg->context = hi;
 
@@ -1382,6 +1382,22 @@ static int cs_hsi_client_probe(struct device *dev)
 	INIT_LIST_HEAD(&cs_char_data.chardev_queue);
 	INIT_LIST_HEAD(&cs_char_data.dataind_queue);
 
+	cs_char_data.channel_id_cmd = hsi_get_channel_id_by_name(cl,
+		"speech-control");
+	if (cs_char_data.channel_id_cmd < 0) {
+		err = cs_char_data.channel_id_cmd;
+		dev_err(dev, "Could not get cmd channel (%d)\n", err);
+		return err;
+	}
+
+	cs_char_data.channel_id_data = hsi_get_channel_id_by_name(cl,
+		"speech-data");
+	if (cs_char_data.channel_id_data < 0) {
+		err = cs_char_data.channel_id_data;
+		dev_err(dev, "Could not get data channel (%d)\n", err);
+		return err;
+	}
+
 	err = misc_register(&cs_char_miscdev);
 	if (err)
 		dev_err(dev, "Failed to register: %d\n", err);
-- 
2.1.4

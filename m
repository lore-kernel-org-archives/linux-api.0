From: Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 2/9] HSI: cmt_speech: Avoid GFP_ATOMIC in cs_char_open
Date: Mon,  2 Mar 2015 05:38:52 +0100
Message-ID: <1425271139-24715-3-git-send-email-sre@kernel.org>
References: <1425271139-24715-1-git-send-email-sre@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425271139-24715-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pavel Machek <pavel@ucw.cz>, Pali Rohar <pali.rohar@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Kai Vehmanen <kai.vehmanen@nokia.com>, Joni Lapilainen <joni.lapilainen@gmail.com>
List-Id: linux-api@vger.kernel.org

From: Kai Vehmanen <kai.vehmanen@nokia.com>

Also fixes a bug in updating 'opened' state in case cs_hsi_start()
fails when opening the char device.

Signed-off-by: Kai Vehmanen <kai.vehmanen@nokia.com>
Signed-off-by: Joni Lapilainen <joni.lapilainen@gmail.com>
Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/hsi/clients/cmt_speech.c | 43 +++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index 7c0f711..389eafb 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -1271,38 +1271,45 @@ static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
 static int cs_char_open(struct inode *unused, struct file *file)
 {
 	int ret = 0;
+	unsigned long p;
 
 	spin_lock_bh(&cs_char_data.lock);
 	if (cs_char_data.opened) {
 		ret = -EBUSY;
 		spin_unlock_bh(&cs_char_data.lock);
-		goto out;
-	}
-	cs_char_data.mmap_base = get_zeroed_page(GFP_ATOMIC);
-	if (!cs_char_data.mmap_base) {
-		dev_err(&cs_char_data.cl->device,
-					"Shared memory allocation failed.\n");
-		ret = -ENOMEM;
-		spin_unlock_bh(&cs_char_data.lock);
-		goto out;
+		goto out1;
 	}
-	cs_char_data.mmap_size = CS_MMAP_SIZE;
-	cs_char_data.dataind_pending = 0;
 	cs_char_data.opened = 1;
-	file->private_data = &cs_char_data;
+	cs_char_data.dataind_pending = 0;
 	spin_unlock_bh(&cs_char_data.lock);
 
-	BUG_ON(cs_char_data.hi);
+	p = get_zeroed_page(GFP_KERNEL);
+	if (!p) {
+		ret = -ENOMEM;
+		goto out2;
+	}
 
-	ret = cs_hsi_start(&cs_char_data.hi, cs_char_data.cl,
-				cs_char_data.mmap_base, cs_char_data.mmap_size);
+	ret = cs_hsi_start(&cs_char_data.hi, cs_char_data.cl, p, CS_MMAP_SIZE);
 	if (ret) {
 		dev_err(&cs_char_data.cl->device, "Unable to initialize HSI\n");
-		free_page(cs_char_data.mmap_base);
-		goto out;
+		goto out3;
 	}
 
-out:
+	/* these are only used in release so lock not needed */
+	cs_char_data.mmap_base = p;
+	cs_char_data.mmap_size = CS_MMAP_SIZE;
+
+	file->private_data = &cs_char_data;
+
+	return 0;
+
+out3:
+	free_page(p);
+out2:
+	spin_lock_bh(&cs_char_data.lock);
+	cs_char_data.opened = 0;
+	spin_unlock_bh(&cs_char_data.lock);
+out1:
 	return ret;
 }
 
-- 
2.1.4

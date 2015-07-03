From: Marcin Niesluchowski <m.niesluchow@samsung.com>
Subject: [RFC 5/8] kmsg: device support in mem class
Date: Fri, 03 Jul 2015 12:49:52 +0200
Message-ID: <1435920595-30879-6-git-send-email-m.niesluchow@samsung.com>
References: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
Return-path: <linux-doc-owner@vger.kernel.org>
In-reply-to: <1435920595-30879-1-git-send-email-m.niesluchow@samsung.com>
Sender: linux-doc-owner@vger.kernel.org
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Cc: Jonathan Corbet <corbet@lwn.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.cz>, Tejun Heo <tj@kernel.org>, Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>, Joe Perches <joe@perches.com>, Karol Lewandowski <k.lewandowsk@samsung.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Marcin Niesluchowski <m.niesluchow@samsung.com>
List-Id: linux-api@vger.kernel.org

Mem class is current class in which kmsg device is holded in.

Mem class is exteded by kmsg_sys devices handling.

Signed-off-by: Marcin Niesluchowski <m.niesluchow@samsung.com>
---
 drivers/char/mem.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index e518040..8d5ba0d 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -815,7 +815,11 @@ static int memory_open(struct inode *inode, struct file *filp)
 
 	minor = iminor(inode);
 	if (minor >= ARRAY_SIZE(devlist))
+#ifdef CONFIG_PRINTK
+		minor = KMSG_MINOR;
+#else
 		return -ENXIO;
+#endif
 
 	dev = &devlist[minor];
 	if (!dev->fops)
@@ -837,8 +841,20 @@ static const struct file_operations memory_fops = {
 
 static char *mem_devnode(struct device *dev, umode_t *mode)
 {
-	if (mode && devlist[MINOR(dev->devt)].mode)
-		*mode = devlist[MINOR(dev->devt)].mode;
+	int minor;
+
+	if (!mode)
+		return NULL;
+
+	minor = MINOR(dev->devt);
+
+#ifdef CONFIG_PRINTK
+	if (minor >= ARRAY_SIZE(devlist))
+		kmsg_sys_mode(minor, mode);
+	else
+#endif
+		if (devlist[minor].mode)
+			*mode = devlist[minor].mode;
 	return NULL;
 }
 
-- 
1.9.1


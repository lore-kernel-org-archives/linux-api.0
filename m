From: Sebastian Reichel <sre@kernel.org>
Subject: [PATCH 4/9] HSI: cmt_speech: Fix build for 4.0 kernel
Date: Mon,  2 Mar 2015 05:38:54 +0100
Message-ID: <1425271139-24715-5-git-send-email-sre@kernel.org>
References: <1425271139-24715-1-git-send-email-sre@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1425271139-24715-1-git-send-email-sre@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Sebastian Reichel <sre@kernel.org>
Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>, Kai Vehmanen <kvcontact@nosignal.fi>, Pavel Machek <pavel@ucw.cz>, Pali Rohar <pali.rohar@gmail.com>, Aaro Koskinen <aaro.koskinen@iki.fi>, Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Fix building of the old out-of-tree code.

Signed-off-by: Sebastian Reichel <sre@kernel.org>
---
 drivers/hsi/clients/cmt_speech.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hsi/clients/cmt_speech.c b/drivers/hsi/clients/cmt_speech.c
index 56846c9..6d852ea 100644
--- a/drivers/hsi/clients/cmt_speech.c
+++ b/drivers/hsi/clients/cmt_speech.c
@@ -34,9 +34,9 @@
 #include <linux/sched.h>
 #include <linux/ioctl.h>
 #include <linux/uaccess.h>
-#include <linux/pm_qos_params.h>
+#include <linux/pm_qos.h>
 #include <linux/hsi/hsi.h>
-#include <linux/hsi/ssip_slave.h>
+#include <linux/hsi/ssi_protocol.h>
 #include <linux/cs-protocol.h>
 
 #define CS_MMAP_SIZE	PAGE_SIZE
@@ -126,7 +126,7 @@ struct cs_hsi_iface {
 	struct hsi_msg			*data_tx_msg;
 	wait_queue_head_t		datawait;
 
-	struct pm_qos_request_list      pm_qos_req;
+	struct pm_qos_request           pm_qos_req;
 
 	spinlock_t			lock;
 };
@@ -1268,7 +1268,7 @@ static int cs_char_mmap(struct file *file, struct vm_area_struct *vma)
 	if (((vma->vm_end - vma->vm_start) >> PAGE_SHIFT) != 1)
 		return -EINVAL;
 
-	vma->vm_flags |= VM_RESERVED;
+	vma->vm_flags |= VM_IO | VM_DONTDUMP | VM_DONTEXPAND;
 	vma->vm_ops = &cs_char_vm_ops;
 	vma->vm_private_data = file->private_data;
 
-- 
2.1.4

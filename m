From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH] tpm: fix format string error in tpm-chip.c
Date: Tue, 20 Jan 2015 12:03:35 +0200
Message-ID: <1421748215-31516-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, josh@joshtriplett.org, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, stefanb@linux.vnet.ibm.com, linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net, jmorris@namei.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
List-Id: linux-api@vger.kernel.org

dev_set_name() takes three arguments where the second argument is
a format string. This patch fixes the call accordingly in tpm-chip.c

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-chip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 6459af7..1d278cc 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -125,7 +125,7 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	else
 		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
 
-	dev_set_name(&chip->dev, chip->devname);
+	dev_set_name(&chip->dev, "%s", chip->devname);
 
 	device_initialize(&chip->dev);
 
-- 
2.1.0

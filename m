From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v2 3/7] tpm: clean up tpm_tis driver life-cycle
Date: Tue,  7 Oct 2014 20:01:13 +0300
Message-ID: <1412701277-27794-4-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Updated tpm_tis to properly use tpm-chip API instead of using ad hoc
methods. tpm_chip_unregister() is called on remove event when PNP driver
is used and on module removal when platform driver is used.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm_tis.c | 64 ++++++++++++++++++++--------------------------
 1 file changed, 28 insertions(+), 36 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index a2780df..df04ce6 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -75,9 +75,6 @@ enum tis_defaults {
 #define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
 #define	TPM_RID(l)			(0x0F04 | ((l) << 12))
 
-static LIST_HEAD(tis_chips);
-static DEFINE_MUTEX(tis_lock);
-
 #if defined(CONFIG_PNP) && defined(CONFIG_ACPI)
 static int is_itpm(struct pnp_dev *dev)
 {
@@ -535,14 +532,17 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	int rc, i, irq_s, irq_e, probe;
 	struct tpm_chip *chip;
 
-	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
+	chip = tpm_chip_alloc(dev, &tpm_tis);
+	if (!chip)
 		return -ENODEV;
 
-	chip->vendor.iobase = ioremap(start, len);
-	if (!chip->vendor.iobase) {
-		rc = -EIO;
-		goto out_err;
-	}
+	chip->vendor.iobase = devm_ioremap(dev, start, len);
+	if (!chip->vendor.iobase)
+		return -EIO;
+
+	rc = tpm_chip_register(chip);
+	if (rc)
+		return -ENODEV;
 
 	/* Default timeouts */
 	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
@@ -720,16 +720,10 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	}
 
 	INIT_LIST_HEAD(&chip->vendor.list);
-	mutex_lock(&tis_lock);
-	list_add(&chip->vendor.list, &tis_chips);
-	mutex_unlock(&tis_lock);
-
 
 	return 0;
 out_err:
-	if (chip->vendor.iobase)
-		iounmap(chip->vendor.iobase);
-	tpm_remove_hardware(chip->dev);
+	tpm_chip_unregister(chip);
 	return rc;
 }
 
@@ -808,13 +802,27 @@ static struct pnp_device_id tpm_pnp_tbl[] = {
 };
 MODULE_DEVICE_TABLE(pnp, tpm_pnp_tbl);
 
+static void tpm_tis_chip_remove(struct tpm_chip *chip)
+{
+	iowrite32(~TPM_GLOBAL_INT_ENABLE &
+		  ioread32(chip->vendor.iobase +
+			   TPM_INT_ENABLE(chip->vendor.
+					  locality)),
+		  chip->vendor.iobase +
+		  TPM_INT_ENABLE(chip->vendor.locality));
+	release_locality(chip, chip->vendor.locality, 1);
+	if (chip->vendor.irq)
+		free_irq(chip->vendor.irq, chip);
+
+	tpm_chip_unregister(chip);
+}
+
 static void tpm_tis_pnp_remove(struct pnp_dev *dev)
 {
 	struct tpm_chip *chip = pnp_get_drvdata(dev);
-	tpm_remove_hardware(chip->dev);
+	tpm_tis_chip_remove(chip);
 }
 
-
 static struct pnp_driver tis_pnp_driver = {
 	.name = "tpm_tis",
 	.id_table = tpm_pnp_tbl,
@@ -873,31 +881,15 @@ err_dev:
 
 static void __exit cleanup_tis(void)
 {
-	struct tpm_vendor_specific *i, *j;
 	struct tpm_chip *chip;
-	mutex_lock(&tis_lock);
-	list_for_each_entry_safe(i, j, &tis_chips, list) {
-		chip = to_tpm_chip(i);
-		tpm_remove_hardware(chip->dev);
-		iowrite32(~TPM_GLOBAL_INT_ENABLE &
-			  ioread32(chip->vendor.iobase +
-				   TPM_INT_ENABLE(chip->vendor.
-						  locality)),
-			  chip->vendor.iobase +
-			  TPM_INT_ENABLE(chip->vendor.locality));
-		release_locality(chip, chip->vendor.locality, 1);
-		if (chip->vendor.irq)
-			free_irq(chip->vendor.irq, chip);
-		iounmap(i->iobase);
-		list_del(&i->list);
-	}
-	mutex_unlock(&tis_lock);
 #ifdef CONFIG_PNP
 	if (!force) {
 		pnp_unregister_driver(&tis_pnp_driver);
 		return;
 	}
 #endif
+	chip = dev_get_drvdata(&pdev->dev);
+	tpm_tis_chip_remove(chip);
 	platform_device_unregister(pdev);
 	platform_driver_unregister(&tis_drv);
 }
-- 
2.1.0

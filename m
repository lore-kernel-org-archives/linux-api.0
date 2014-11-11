From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v7 06/10] tpm: fix: move sysfs attributes to the correct place.
Date: Tue, 11 Nov 2014 15:45:09 +0200
Message-ID: <1415713513-16524-7-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1415713513-16524-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1415713513-16524-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, josh.triplett@intel.com, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
List-Id: linux-api@vger.kernel.org

The sysfs attributes of the TPM device were created to the platform
device directory that owns the character device instead of placing
them correctly to the directory of the character device,

They were also created in a racy way so that character device might
become visible before sysfs attributes become available.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-chip.c  | 15 ++++++---------
 drivers/char/tpm/tpm-dev.c   |  2 --
 drivers/char/tpm/tpm-sysfs.c | 23 +----------------------
 drivers/char/tpm/tpm.h       |  4 +---
 4 files changed, 8 insertions(+), 36 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index df40eee..5d268ac 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -29,6 +29,8 @@
 #include "tpm.h"
 #include "tpm_eventlog.h"
 
+ATTRIBUTE_GROUPS(tpm_dev);
+
 static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
 static LIST_HEAD(tpm_chip_list);
 static DEFINE_SPINLOCK(driver_lock);
@@ -136,6 +138,8 @@ struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 	else
 		chip->dev.devt = MKDEV(MAJOR(tpm_devt), chip->dev_num);
 
+	chip->dev.groups = tpm_dev_groups;
+
 	dev_set_name(&chip->dev, chip->devname);
 
 	device_initialize(&chip->dev);
@@ -209,13 +213,9 @@ int tpm_chip_register(struct tpm_chip *chip)
 	if (rc)
 		return rc;
 
-	rc = tpm_sysfs_add_device(chip);
-	if (rc)
-		goto del_misc;
-
 	rc = tpm_add_ppi(chip);
 	if (rc)
-		goto del_sysfs;
+		goto out_err;
 
 	chip->bios_dir = tpm_bios_log_setup(chip->devname);
 
@@ -225,9 +225,7 @@ int tpm_chip_register(struct tpm_chip *chip)
 	spin_unlock(&driver_lock);
 
 	return 0;
-del_sysfs:
-	tpm_sysfs_del_device(chip);
-del_misc:
+out_err:
 	tpm_dev_del_device(chip);
 	return rc;
 }
@@ -250,7 +248,6 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 	spin_unlock(&driver_lock);
 	synchronize_rcu();
 
-	tpm_sysfs_del_device(chip);
 	tpm_remove_ppi(chip);
 
 	if (chip->bios_dir)
diff --git a/drivers/char/tpm/tpm-dev.c b/drivers/char/tpm/tpm-dev.c
index de0337e..f3f073f 100644
--- a/drivers/char/tpm/tpm-dev.c
+++ b/drivers/char/tpm/tpm-dev.c
@@ -179,5 +179,3 @@ const struct file_operations tpm_fops = {
 	.write = tpm_write,
 	.release = tpm_release,
 };
-
-
diff --git a/drivers/char/tpm/tpm-sysfs.c b/drivers/char/tpm/tpm-sysfs.c
index ee66fd4..9f5b85a 100644
--- a/drivers/char/tpm/tpm-sysfs.c
+++ b/drivers/char/tpm/tpm-sysfs.c
@@ -263,7 +263,7 @@ static ssize_t timeouts_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RO(timeouts);
 
-static struct attribute *tpm_dev_attrs[] = {
+struct attribute *tpm_dev_attrs[] = {
 	&dev_attr_pubek.attr,
 	&dev_attr_pcrs.attr,
 	&dev_attr_enabled.attr,
@@ -276,24 +276,3 @@ static struct attribute *tpm_dev_attrs[] = {
 	&dev_attr_timeouts.attr,
 	NULL,
 };
-
-static const struct attribute_group tpm_dev_group = {
-	.attrs = tpm_dev_attrs,
-};
-
-int tpm_sysfs_add_device(struct tpm_chip *chip)
-{
-	int err;
-	err = sysfs_create_group(&chip->pdev->kobj,
-				 &tpm_dev_group);
-
-	if (err)
-		dev_err(chip->pdev,
-			"failed to create sysfs attributes, %d\n", err);
-	return err;
-}
-
-void tpm_sysfs_del_device(struct tpm_chip *chip)
-{
-	sysfs_remove_group(&chip->pdev->kobj, &tpm_dev_group);
-}
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 83103e0..9d062e6 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -325,6 +325,7 @@ struct tpm_cmd_t {
 extern struct class *tpm_class;
 extern dev_t tpm_devt;
 extern const struct file_operations tpm_fops;
+extern struct attribute *tpm_dev_attrs[];
 
 ssize_t	tpm_getcap(struct device *, __be32, cap_t *, const char *);
 ssize_t tpm_transmit(struct tpm_chip *chip, const char *buf,
@@ -346,9 +347,6 @@ extern struct tpm_chip *tpmm_chip_alloc(struct device *dev,
 extern int tpm_chip_register(struct tpm_chip *chip);
 extern void tpm_chip_unregister(struct tpm_chip *chip);
 
-int tpm_sysfs_add_device(struct tpm_chip *chip);
-void tpm_sysfs_del_device(struct tpm_chip *chip);
-
 int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 
 #ifdef CONFIG_ACPI
-- 
2.1.0

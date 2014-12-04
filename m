From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v9 2/8] tpm: two-phase chip management functions
Date: Thu,  4 Dec 2014 07:55:12 +0200
Message-ID: <1417672518-4530-3-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, josh.triplett@intel.com, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
List-Id: linux-api@vger.kernel.org

tpm_register_hardware() and tpm_remove_hardware() are called often
before initializing the device. The problem is that the device might
not be fully initialized when it comes visible to the user space.

This patch resolves the issue by diving initialization into two
parts:

- tpmm_chip_alloc() creates struct tpm_chip.

- tpm_chip_register() sets up the character device and sysfs
  attributes.

The framework takes care of freeing struct tpm_chip by using the devres
API. The broken release callback has been wiped. ACPI drivers do not
ever get this callback.

Regards to Jason Gunthorpe for carefully reviewing this part of the
code.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/Makefile           |   2 +-
 drivers/char/tpm/tpm-chip.c         | 194 ++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-interface.c    | 148 +--------------------------
 drivers/char/tpm/tpm.h              |  11 +-
 drivers/char/tpm/tpm_atmel.c        |  11 +-
 drivers/char/tpm/tpm_i2c_atmel.c    |  39 ++------
 drivers/char/tpm/tpm_i2c_infineon.c |  37 ++-----
 drivers/char/tpm/tpm_i2c_nuvoton.c  |  47 +++------
 drivers/char/tpm/tpm_i2c_stm_st33.c |  14 +--
 drivers/char/tpm/tpm_ibmvtpm.c      |  17 ++--
 drivers/char/tpm/tpm_infineon.c     |  29 +++---
 drivers/char/tpm/tpm_nsc.c          |  14 ++-
 drivers/char/tpm/tpm_tis.c          |  80 ++++++---------
 drivers/char/tpm/xen-tpmfront.c     |  14 +--
 14 files changed, 319 insertions(+), 338 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-chip.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 7f54dae..c715596 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel tpm device drivers.
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
-tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o
+tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o
 
 ifdef CONFIG_ACPI
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
new file mode 100644
index 0000000..35aca12
--- /dev/null
+++ b/drivers/char/tpm/tpm-chip.c
@@ -0,0 +1,194 @@
+/*
+ * Copyright (C) 2004 IBM Corporation
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * Authors:
+ * Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+ * Leendert van Doorn <leendert@watson.ibm.com>
+ * Dave Safford <safford@watson.ibm.com>
+ * Reiner Sailer <sailer@watson.ibm.com>
+ * Kylene Hall <kjhall@us.ibm.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * TPM chip management routines.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ */
+
+#include <linux/poll.h>
+#include <linux/slab.h>
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
+#include <linux/freezer.h>
+#include "tpm.h"
+#include "tpm_eventlog.h"
+
+static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
+static LIST_HEAD(tpm_chip_list);
+static DEFINE_SPINLOCK(driver_lock);
+
+/*
+ * tpm_chip_find_get - return tpm_chip for a given chip number
+ * @chip_num the device number for the chip
+ */
+struct tpm_chip *tpm_chip_find_get(int chip_num)
+{
+	struct tpm_chip *pos, *chip = NULL;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
+		if (chip_num != TPM_ANY_NUM && chip_num != pos->dev_num)
+			continue;
+
+		if (try_module_get(pos->dev->driver->owner)) {
+			chip = pos;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return chip;
+}
+
+/**
+ * tpmm_chip_remove() - free chip memory and device number
+ * @data: points to struct tpm_chip instance
+ *
+ * This is used internally by tpmm_chip_alloc() and called by devres
+ * when the device is released. This function does the opposite of
+ * tpmm_chip_alloc() freeing memory and the device number.
+ */
+static void tpmm_chip_remove(void *data)
+{
+	struct tpm_chip *chip = (struct tpm_chip *) data;
+
+	spin_lock(&driver_lock);
+	clear_bit(chip->dev_num, dev_mask);
+	spin_unlock(&driver_lock);
+	kfree(chip);
+}
+
+/**
+ * tpmm_chip_alloc() - allocate a new struct tpm_chip instance
+ * @dev: device to which the chip is associated
+ * @ops: struct tpm_class_ops instance
+ *
+ * Allocates a new struct tpm_chip instance and assigns a free
+ * device number for it. Caller does not have to worry about
+ * freeing the allocated resources. When the devices is removed
+ * devres calls tpmm_chip_remove() to do the job.
+ */
+struct tpm_chip *tpmm_chip_alloc(struct device *dev,
+				 const struct tpm_class_ops *ops)
+{
+	struct tpm_chip *chip;
+
+	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
+	if (chip == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	mutex_init(&chip->tpm_mutex);
+	INIT_LIST_HEAD(&chip->list);
+
+	chip->ops = ops;
+
+	spin_lock(&driver_lock);
+	chip->dev_num = find_first_zero_bit(dev_mask, TPM_NUM_DEVICES);
+	spin_unlock(&driver_lock);
+
+	if (chip->dev_num >= TPM_NUM_DEVICES) {
+		dev_err(dev, "No available tpm device numbers\n");
+		kfree(chip);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	set_bit(chip->dev_num, dev_mask);
+
+	scnprintf(chip->devname, sizeof(chip->devname), "tpm%d", chip->dev_num);
+
+	chip->dev = dev;
+	devm_add_action(dev, tpmm_chip_remove, chip);
+	dev_set_drvdata(dev, chip);
+
+	return chip;
+}
+EXPORT_SYMBOL_GPL(tpmm_chip_alloc);
+
+/*
+ * tpm_chip_register() - create a misc driver for the TPM chip
+ * @chip: TPM chip to use.
+ *
+ * Creates a misc driver for the TPM chip and adds sysfs interfaces for
+ * the device, PPI and TCPA. As the last step this function adds the
+ * chip to the list of TPM chips available for use.
+ *
+ * NOTE: This function should be only called after the chip initialization
+ * is complete.
+ *
+ * Called from tpm_<specific>.c probe function only for devices
+ * the driver has determined it should claim.  Prior to calling
+ * this function the specific probe function has called pci_enable_device
+ * upon errant exit from this function specific probe function should call
+ * pci_disable_device
+ */
+int tpm_chip_register(struct tpm_chip *chip)
+{
+	int rc;
+
+	rc = tpm_dev_add_device(chip);
+	if (rc)
+		return rc;
+
+	rc = tpm_sysfs_add_device(chip);
+	if (rc)
+		goto del_misc;
+
+	rc = tpm_add_ppi(&chip->dev->kobj);
+	if (rc)
+		goto del_sysfs;
+
+	chip->bios_dir = tpm_bios_log_setup(chip->devname);
+
+	/* Make the chip available. */
+	spin_lock(&driver_lock);
+	list_add_rcu(&chip->list, &tpm_chip_list);
+	spin_unlock(&driver_lock);
+
+	return 0;
+del_sysfs:
+	tpm_sysfs_del_device(chip);
+del_misc:
+	tpm_dev_del_device(chip);
+	return rc;
+}
+EXPORT_SYMBOL_GPL(tpm_chip_register);
+
+/*
+ * tpm_chip_unregister() - release the TPM driver
+ * @chip: TPM chip to use.
+ *
+ * Takes the chip first away from the list of available TPM chips and then
+ * cleans up all the resources reserved by tpm_chip_register().
+ *
+ * NOTE: This function should be only called before deinitializing chip
+ * resources.
+ */
+void tpm_chip_unregister(struct tpm_chip *chip)
+{
+	spin_lock(&driver_lock);
+	list_del_rcu(&chip->list);
+	spin_unlock(&driver_lock);
+	synchronize_rcu();
+
+	if (chip->bios_dir)
+		tpm_bios_log_teardown(chip->bios_dir);
+	tpm_remove_ppi(chip);
+	tpm_sysfs_del_device(chip);
+
+	tpm_dev_del_device(chip);
+}
+EXPORT_SYMBOL_GPL(tpm_chip_unregister);
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index c17aa45..4dbed1e 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2004 IBM Corporation
+ * Copyright (C) 2014 Intel Corporation
  *
  * Authors:
  * Leendert van Doorn <leendert@watson.ibm.com>
@@ -47,10 +48,6 @@ module_param_named(suspend_pcr, tpm_suspend_pcr, uint, 0644);
 MODULE_PARM_DESC(suspend_pcr,
 		 "PCR to use for dummy writes to faciltate flush on suspend.");
 
-static LIST_HEAD(tpm_chip_list);
-static DEFINE_SPINLOCK(driver_lock);
-static DECLARE_BITMAP(dev_mask, TPM_NUM_DEVICES);
-
 /*
  * Array with one entry per ordinal defining the maximum amount
  * of time the chip could take to return the result.  The ordinal
@@ -639,27 +636,6 @@ static int tpm_continue_selftest(struct tpm_chip *chip)
 	return rc;
 }
 
-/*
- * tpm_chip_find_get - return tpm_chip for given chip number
- */
-static struct tpm_chip *tpm_chip_find_get(int chip_num)
-{
-	struct tpm_chip *pos, *chip = NULL;
-
-	rcu_read_lock();
-	list_for_each_entry_rcu(pos, &tpm_chip_list, list) {
-		if (chip_num != TPM_ANY_NUM && chip_num != pos->dev_num)
-			continue;
-
-		if (try_module_get(pos->dev->driver->owner)) {
-			chip = pos;
-			break;
-		}
-	}
-	rcu_read_unlock();
-	return chip;
-}
-
 #define TPM_ORDINAL_PCRREAD cpu_to_be32(21)
 #define READ_PCR_RESULT_SIZE 30
 static struct tpm_input_header pcrread_header = {
@@ -887,30 +863,6 @@ again:
 }
 EXPORT_SYMBOL_GPL(wait_for_tpm_stat);
 
-void tpm_remove_hardware(struct device *dev)
-{
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-
-	if (chip == NULL) {
-		dev_err(dev, "No device data found\n");
-		return;
-	}
-
-	spin_lock(&driver_lock);
-	list_del_rcu(&chip->list);
-	spin_unlock(&driver_lock);
-	synchronize_rcu();
-
-	tpm_dev_del_device(chip);
-	tpm_sysfs_del_device(chip);
-	tpm_remove_ppi(&dev->kobj);
-	tpm_bios_log_teardown(chip->bios_dir);
-
-	/* write it this way to be explicit (chip->dev == dev) */
-	put_device(chip->dev);
-}
-EXPORT_SYMBOL_GPL(tpm_remove_hardware);
-
 #define TPM_ORD_SAVESTATE cpu_to_be32(152)
 #define SAVESTATE_RESULT_SIZE 10
 
@@ -1044,104 +996,6 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
 }
 EXPORT_SYMBOL_GPL(tpm_get_random);
 
-/* In case vendor provided release function, call it too.*/
-
-void tpm_dev_vendor_release(struct tpm_chip *chip)
-{
-	if (!chip)
-		return;
-
-	clear_bit(chip->dev_num, dev_mask);
-}
-EXPORT_SYMBOL_GPL(tpm_dev_vendor_release);
-
-
-/*
- * Once all references to platform device are down to 0,
- * release all allocated structures.
- */
-static void tpm_dev_release(struct device *dev)
-{
-	struct tpm_chip *chip = dev_get_drvdata(dev);
-
-	if (!chip)
-		return;
-
-	tpm_dev_vendor_release(chip);
-
-	chip->release(dev);
-	kfree(chip);
-}
-
-/*
- * Called from tpm_<specific>.c probe function only for devices
- * the driver has determined it should claim.  Prior to calling
- * this function the specific probe function has called pci_enable_device
- * upon errant exit from this function specific probe function should call
- * pci_disable_device
- */
-struct tpm_chip *tpm_register_hardware(struct device *dev,
-				       const struct tpm_class_ops *ops)
-{
-	struct tpm_chip *chip;
-
-	/* Driver specific per-device data */
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
-
-	if (chip == NULL)
-		return NULL;
-
-	mutex_init(&chip->tpm_mutex);
-	INIT_LIST_HEAD(&chip->list);
-
-	chip->ops = ops;
-	chip->dev_num = find_first_zero_bit(dev_mask, TPM_NUM_DEVICES);
-
-	if (chip->dev_num >= TPM_NUM_DEVICES) {
-		dev_err(dev, "No available tpm device numbers\n");
-		goto out_free;
-	}
-
-	set_bit(chip->dev_num, dev_mask);
-
-	scnprintf(chip->devname, sizeof(chip->devname), "%s%d", "tpm",
-		  chip->dev_num);
-
-	chip->dev = get_device(dev);
-	chip->release = dev->release;
-	dev->release = tpm_dev_release;
-	dev_set_drvdata(dev, chip);
-
-	if (tpm_dev_add_device(chip))
-		goto put_device;
-
-	if (tpm_sysfs_add_device(chip))
-		goto del_misc;
-
-	if (tpm_add_ppi(&dev->kobj))
-		goto del_sysfs;
-
-	chip->bios_dir = tpm_bios_log_setup(chip->devname);
-
-	/* Make chip available */
-	spin_lock(&driver_lock);
-	list_add_tail_rcu(&chip->list, &tpm_chip_list);
-	spin_unlock(&driver_lock);
-
-	return chip;
-
-del_sysfs:
-	tpm_sysfs_del_device(chip);
-del_misc:
-	tpm_dev_del_device(chip);
-put_device:
-	put_device(chip->dev);
-out_free:
-	kfree(chip);
-	return NULL;
-}
-EXPORT_SYMBOL_GPL(tpm_register_hardware);
-
 MODULE_AUTHOR("Leendert van Doorn (leendert@watson.ibm.com)");
 MODULE_DESCRIPTION("TPM Driver");
 MODULE_VERSION("2.0");
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index e638eb0..9880681 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -110,7 +110,6 @@ struct tpm_chip {
 	struct dentry **bios_dir;
 
 	struct list_head list;
-	void (*release) (struct device *);
 };
 
 #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)
@@ -322,15 +321,17 @@ extern int tpm_get_timeouts(struct tpm_chip *);
 extern void tpm_gen_interrupt(struct tpm_chip *);
 extern int tpm_do_selftest(struct tpm_chip *);
 extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
-extern struct tpm_chip* tpm_register_hardware(struct device *,
-					      const struct tpm_class_ops *ops);
-extern void tpm_dev_vendor_release(struct tpm_chip *);
-extern void tpm_remove_hardware(struct device *);
 extern int tpm_pm_suspend(struct device *);
 extern int tpm_pm_resume(struct device *);
 extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 			     wait_queue_head_t *, bool);
 
+struct tpm_chip *tpm_chip_find_get(int chip_num);
+extern struct tpm_chip *tpmm_chip_alloc(struct device *dev,
+				       const struct tpm_class_ops *ops);
+extern int tpm_chip_register(struct tpm_chip *chip);
+extern void tpm_chip_unregister(struct tpm_chip *chip);
+
 int tpm_dev_add_device(struct tpm_chip *chip);
 void tpm_dev_del_device(struct tpm_chip *chip);
 int tpm_sysfs_add_device(struct tpm_chip *chip);
diff --git a/drivers/char/tpm/tpm_atmel.c b/drivers/char/tpm/tpm_atmel.c
index 6069d13..8e2576a 100644
--- a/drivers/char/tpm/tpm_atmel.c
+++ b/drivers/char/tpm/tpm_atmel.c
@@ -138,11 +138,11 @@ static void atml_plat_remove(void)
 	struct tpm_chip *chip = dev_get_drvdata(&pdev->dev);
 
 	if (chip) {
+		tpm_chip_unregister(chip);
 		if (chip->vendor.have_region)
 			atmel_release_region(chip->vendor.base,
 					     chip->vendor.region_size);
 		atmel_put_base_addr(chip->vendor.iobase);
-		tpm_remove_hardware(chip->dev);
 		platform_device_unregister(pdev);
 	}
 }
@@ -184,8 +184,9 @@ static int __init init_atmel(void)
 		goto err_rel_reg;
 	}
 
-	if (!(chip = tpm_register_hardware(&pdev->dev, &tpm_atmel))) {
-		rc = -ENODEV;
+	chip = tpmm_chip_alloc(&pdev->dev, &tpm_atmel);
+	if (IS_ERR(chip)) {
+		rc = PTR_ERR(chip);
 		goto err_unreg_dev;
 	}
 
@@ -194,6 +195,10 @@ static int __init init_atmel(void)
 	chip->vendor.have_region = have_region;
 	chip->vendor.region_size = region_size;
 
+	rc = tpm_chip_register(chip);
+	if (rc)
+		goto err_unreg_dev;
+
 	return 0;
 
 err_unreg_dev:
diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
index 5f44888..643a940 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -153,25 +153,20 @@ static const struct tpm_class_ops i2c_atmel = {
 static int i2c_atmel_probe(struct i2c_client *client,
 			   const struct i2c_device_id *id)
 {
-	int rc;
 	struct tpm_chip *chip;
 	struct device *dev = &client->dev;
 
 	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C))
 		return -ENODEV;
 
-	chip = tpm_register_hardware(dev, &i2c_atmel);
-	if (!chip) {
-		dev_err(dev, "%s() error in tpm_register_hardware\n", __func__);
-		return -ENODEV;
-	}
+	chip = tpmm_chip_alloc(dev, &i2c_atmel);
+	if (IS_ERR(chip))
+		return PTR_ERR(chip);
 
 	chip->vendor.priv = devm_kzalloc(dev, sizeof(struct priv_data),
 					 GFP_KERNEL);
-	if (!chip->vendor.priv) {
-		rc = -ENOMEM;
-		goto out_err;
-	}
+	if (!chip->vendor.priv)
+		return -ENOMEM;
 
 	/* Default timeouts */
 	chip->vendor.timeout_a = msecs_to_jiffies(TPM_I2C_SHORT_TIMEOUT);
@@ -183,32 +178,20 @@ static int i2c_atmel_probe(struct i2c_client *client,
 	/* There is no known way to probe for this device, and all version
 	 * information seems to be read via TPM commands. Thus we rely on the
 	 * TPM startup process in the common code to detect the device. */
-	if (tpm_get_timeouts(chip)) {
-		rc = -ENODEV;
-		goto out_err;
-	}
-
-	if (tpm_do_selftest(chip)) {
-		rc = -ENODEV;
-		goto out_err;
-	}
+	if (tpm_get_timeouts(chip))
+		return -ENODEV;
 
-	return 0;
+	if (tpm_do_selftest(chip))
+		return -ENODEV;
 
-out_err:
-	tpm_dev_vendor_release(chip);
-	tpm_remove_hardware(chip->dev);
-	return rc;
+	return tpm_chip_register(chip);
 }
 
 static int i2c_atmel_remove(struct i2c_client *client)
 {
 	struct device *dev = &(client->dev);
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-
-	tpm_dev_vendor_release(chip);
-	tpm_remove_hardware(dev);
-	kfree(chip);
+	tpm_chip_unregister(chip);
 	return 0;
 }
 
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 472af4b..03708e6 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -581,12 +581,9 @@ static int tpm_tis_i2c_init(struct device *dev)
 	int rc = 0;
 	struct tpm_chip *chip;
 
-	chip = tpm_register_hardware(dev, &tpm_tis_i2c);
-	if (!chip) {
-		dev_err(dev, "could not register hardware\n");
-		rc = -ENODEV;
-		goto out_err;
-	}
+	chip = tpmm_chip_alloc(dev, &tpm_tis_i2c);
+	if (IS_ERR(chip))
+		return PTR_ERR(chip);
 
 	/* Disable interrupts */
 	chip->vendor.irq = 0;
@@ -600,7 +597,7 @@ static int tpm_tis_i2c_init(struct device *dev)
 	if (request_locality(chip, 0) != 0) {
 		dev_err(dev, "could not request locality\n");
 		rc = -ENODEV;
-		goto out_vendor;
+		goto out_err;
 	}
 
 	/* read four bytes from DID_VID register */
@@ -628,21 +625,9 @@ static int tpm_tis_i2c_init(struct device *dev)
 	tpm_get_timeouts(chip);
 	tpm_do_selftest(chip);
 
-	return 0;
-
+	return tpm_chip_register(chip);
 out_release:
 	release_locality(chip, chip->vendor.locality, 1);
-
-out_vendor:
-	/* close file handles */
-	tpm_dev_vendor_release(chip);
-
-	/* remove hardware */
-	tpm_remove_hardware(chip->dev);
-
-	/* reset these pointers, otherwise we oops */
-	chip->dev->release = NULL;
-	chip->release = NULL;
 	tpm_dev.client = NULL;
 out_err:
 	return rc;
@@ -712,17 +697,9 @@ static int tpm_tis_i2c_probe(struct i2c_client *client,
 static int tpm_tis_i2c_remove(struct i2c_client *client)
 {
 	struct tpm_chip *chip = tpm_dev.chip;
-	release_locality(chip, chip->vendor.locality, 1);
 
-	/* close file handles */
-	tpm_dev_vendor_release(chip);
-
-	/* remove hardware */
-	tpm_remove_hardware(chip->dev);
-
-	/* reset these pointers, otherwise we oops */
-	chip->dev->release = NULL;
-	chip->release = NULL;
+	tpm_chip_unregister(chip);
+	release_locality(chip, chip->vendor.locality, 1);
 	tpm_dev.client = NULL;
 
 	return 0;
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index bbb4997..8c23088 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -530,18 +530,14 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 	dev_info(dev, "VID: %04X DID: %02X RID: %02X\n", (u16) vid,
 		 (u8) (vid >> 16), (u8) (vid >> 24));
 
-	chip = tpm_register_hardware(dev, &tpm_i2c);
-	if (!chip) {
-		dev_err(dev, "%s() error in tpm_register_hardware\n", __func__);
-		return -ENODEV;
-	}
+	chip = tpmm_chip_alloc(dev, &tpm_i2c);
+	if (IS_ERR(chip))
+		return PTR_ERR(chip);
 
 	chip->vendor.priv = devm_kzalloc(dev, sizeof(struct priv_data),
 					 GFP_KERNEL);
-	if (!chip->vendor.priv) {
-		rc = -ENOMEM;
-		goto out_err;
-	}
+	if (!chip->vendor.priv)
+		return -ENOMEM;
 
 	init_waitqueue_head(&chip->vendor.read_queue);
 	init_waitqueue_head(&chip->vendor.int_queue);
@@ -589,7 +585,7 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 							   TPM_DATA_FIFO_W,
 							   1, (u8 *) (&rc));
 				if (rc < 0)
-					goto out_err;
+					return rc;
 				/* TPM_STS <- 0x40 (commandReady) */
 				i2c_nuvoton_ready(chip);
 			} else {
@@ -599,44 +595,29 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 				 * only TPM_STS_VALID should be set
 				 */
 				if (i2c_nuvoton_read_status(chip) !=
-				    TPM_STS_VALID) {
-					rc = -EIO;
-					goto out_err;
-				}
+				    TPM_STS_VALID)
+					return -EIO;
 			}
 		}
 	}
 
-	if (tpm_get_timeouts(chip)) {
-		rc = -ENODEV;
-		goto out_err;
-	}
-
-	if (tpm_do_selftest(chip)) {
-		rc = -ENODEV;
-		goto out_err;
-	}
+	if (tpm_get_timeouts(chip))
+		return -ENODEV;
 
-	return 0;
+	if (tpm_do_selftest(chip))
+		return -ENODEV;
 
-out_err:
-	tpm_dev_vendor_release(chip);
-	tpm_remove_hardware(chip->dev);
-	return rc;
+	return tpm_chip_register(chip);
 }
 
 static int i2c_nuvoton_remove(struct i2c_client *client)
 {
 	struct device *dev = &(client->dev);
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-
-	tpm_dev_vendor_release(chip);
-	tpm_remove_hardware(dev);
-	kfree(chip);
+	tpm_chip_unregister(chip);
 	return 0;
 }
 
-
 static const struct i2c_device_id i2c_nuvoton_id[] = {
 	{I2C_DRIVER_NAME, 0},
 	{}
diff --git a/drivers/char/tpm/tpm_i2c_stm_st33.c b/drivers/char/tpm/tpm_i2c_stm_st33.c
index 86203b0..9a96d37 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -735,11 +735,9 @@ tpm_stm_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (!tpm_dev)
 		return -ENOMEM;
 
-	chip = tpm_register_hardware(&client->dev, &st_i2c_tpm);
-	if (!chip) {
-		dev_info(&client->dev, "fail chip\n");
-		return -ENODEV;
-	}
+	chip = tpmm_chip_alloc(&client->dev, &st_i2c_tpm);
+	if (IS_ERR(chip))
+		return PTR_ERR(chip);
 
 	TPM_VPRIV(chip) = tpm_dev;
 	tpm_dev->client = client;
@@ -807,10 +805,8 @@ tpm_stm_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	tpm_get_timeouts(chip);
 	tpm_do_selftest(chip);
 
-	dev_info(chip->dev, "TPM I2C Initialized\n");
-	return 0;
+	return tpm_chip_register(chip);
 _tpm_clean_answer:
-	tpm_remove_hardware(chip->dev);
 	dev_info(chip->dev, "TPM I2C initialisation fail\n");
 	return ret;
 }
@@ -827,7 +823,7 @@ static int tpm_stm_i2c_remove(struct i2c_client *client)
 		(struct tpm_chip *) i2c_get_clientdata(client);
 
 	if (chip)
-		tpm_remove_hardware(chip->dev);
+		tpm_chip_unregister(chip);
 
 	return 0;
 }
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index 4109222..d594610 100644
--- a/drivers/char/tpm/tpm_ibmvtpm.c
+++ b/drivers/char/tpm/tpm_ibmvtpm.c
@@ -270,8 +270,11 @@ static int ibmvtpm_crq_send_init(struct ibmvtpm_dev *ibmvtpm)
 static int tpm_ibmvtpm_remove(struct vio_dev *vdev)
 {
 	struct ibmvtpm_dev *ibmvtpm = ibmvtpm_get_data(&vdev->dev);
+	struct tpm_chip *chip = dev_get_drvdata(ibmvtpm->dev);
 	int rc = 0;
 
+	tpm_chip_unregister(chip);
+
 	free_irq(vdev->irq, ibmvtpm);
 
 	do {
@@ -290,8 +293,6 @@ static int tpm_ibmvtpm_remove(struct vio_dev *vdev)
 		kfree(ibmvtpm->rtce_buf);
 	}
 
-	tpm_remove_hardware(ibmvtpm->dev);
-
 	kfree(ibmvtpm);
 
 	return 0;
@@ -563,11 +564,9 @@ static int tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
 	struct tpm_chip *chip;
 	int rc = -ENOMEM, rc1;
 
-	chip = tpm_register_hardware(dev, &tpm_ibmvtpm);
-	if (!chip) {
-		dev_err(dev, "tpm_register_hardware failed\n");
-		return -ENODEV;
-	}
+	chip = tpmm_chip_alloc(dev, &tpm_ibmvtpm);
+	if (IS_ERR(chip))
+		return PTR_ERR(chip);
 
 	ibmvtpm = kzalloc(sizeof(struct ibmvtpm_dev), GFP_KERNEL);
 	if (!ibmvtpm) {
@@ -637,7 +636,7 @@ static int tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
 	if (rc)
 		goto init_irq_cleanup;
 
-	return rc;
+	return tpm_chip_register(chip);
 init_irq_cleanup:
 	do {
 		rc1 = plpar_hcall_norets(H_FREE_CRQ, vio_dev->unit_address);
@@ -652,8 +651,6 @@ cleanup:
 		kfree(ibmvtpm);
 	}
 
-	tpm_remove_hardware(dev);
-
 	return rc;
 }
 
diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
index dc0a255..dcdb671 100644
--- a/drivers/char/tpm/tpm_infineon.c
+++ b/drivers/char/tpm/tpm_infineon.c
@@ -546,7 +546,14 @@ static int tpm_inf_pnp_probe(struct pnp_dev *dev,
 			 vendorid[0], vendorid[1],
 			 productid[0], productid[1], chipname);
 
-		if (!(chip = tpm_register_hardware(&dev->dev, &tpm_inf)))
+		chip = tpmm_chip_alloc(&dev->dev, &tpm_inf);
+		if (IS_ERR(chip)) {
+			rc = PTR_ERR(chip);
+			goto err_release_region;
+		}
+
+		rc = tpm_chip_register(chip);
+		if (rc)
 			goto err_release_region;
 
 		return 0;
@@ -572,17 +579,15 @@ static void tpm_inf_pnp_remove(struct pnp_dev *dev)
 {
 	struct tpm_chip *chip = pnp_get_drvdata(dev);
 
-	if (chip) {
-		if (tpm_dev.iotype == TPM_INF_IO_PORT) {
-			release_region(tpm_dev.data_regs, tpm_dev.data_size);
-			release_region(tpm_dev.config_port,
-				       tpm_dev.config_size);
-		} else {
-			iounmap(tpm_dev.mem_base);
-			release_mem_region(tpm_dev.map_base, tpm_dev.map_size);
-		}
-		tpm_dev_vendor_release(chip);
-		tpm_remove_hardware(chip->dev);
+	tpm_chip_unregister(chip);
+
+	if (tpm_dev.iotype == TPM_INF_IO_PORT) {
+		release_region(tpm_dev.data_regs, tpm_dev.data_size);
+		release_region(tpm_dev.config_port,
+			       tpm_dev.config_size);
+	} else {
+		iounmap(tpm_dev.mem_base);
+		release_mem_region(tpm_dev.map_base, tpm_dev.map_size);
 	}
 }
 
diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 3179ec9..00c5470 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -247,10 +247,9 @@ static struct platform_device *pdev = NULL;
 static void tpm_nsc_remove(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-	if ( chip ) {
-		release_region(chip->vendor.base, 2);
-		tpm_remove_hardware(chip->dev);
-	}
+
+	tpm_chip_unregister(chip);
+	release_region(chip->vendor.base, 2);
 }
 
 static SIMPLE_DEV_PM_OPS(tpm_nsc_pm, tpm_pm_suspend, tpm_pm_resume);
@@ -308,11 +307,16 @@ static int __init init_nsc(void)
 		goto err_del_dev;
 	}
 
-	if (!(chip = tpm_register_hardware(&pdev->dev, &tpm_nsc))) {
+	chip = tpmm_chip_alloc(&pdev->dev, &tpm_nsc);
+	if (IS_ERR(chip)) {
 		rc = -ENODEV;
 		goto err_rel_reg;
 	}
 
+	rc = tpm_chip_register(chip);
+	if (rc)
+		goto err_rel_reg;
+
 	dev_dbg(&pdev->dev, "NSC TPM detected\n");
 	dev_dbg(&pdev->dev,
 		"NSC LDN 0x%x, SID 0x%x, SRID 0x%x\n",
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 51350cd..4cf2ea2 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -79,9 +79,6 @@ struct priv_data {
 	bool irq_tested;
 };
 
-static LIST_HEAD(tis_chips);
-static DEFINE_MUTEX(tis_lock);
-
 #if defined(CONFIG_PNP) && defined(CONFIG_ACPI)
 static int is_itpm(struct pnp_dev *dev)
 {
@@ -572,6 +569,17 @@ static bool interrupts = true;
 module_param(interrupts, bool, 0444);
 MODULE_PARM_DESC(interrupts, "Enable interrupts");
 
+static void tpm_tis_remove(struct tpm_chip *chip)
+{
+	iowrite32(~TPM_GLOBAL_INT_ENABLE &
+		  ioread32(chip->vendor.iobase +
+			   TPM_INT_ENABLE(chip->vendor.
+					  locality)),
+		  chip->vendor.iobase +
+		  TPM_INT_ENABLE(chip->vendor.locality));
+	release_locality(chip, chip->vendor.locality, 1);
+}
+
 static int tpm_tis_init(struct device *dev, resource_size_t start,
 			resource_size_t len, unsigned int irq)
 {
@@ -583,15 +591,16 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	priv = devm_kzalloc(dev, sizeof(struct priv_data), GFP_KERNEL);
 	if (priv == NULL)
 		return -ENOMEM;
-	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
-		return -ENODEV;
+
+	chip = tpmm_chip_alloc(dev, &tpm_tis);
+	if (IS_ERR(chip))
+		return PTR_ERR(chip);
+
 	chip->vendor.priv = priv;
 
-	chip->vendor.iobase = ioremap(start, len);
-	if (!chip->vendor.iobase) {
-		rc = -EIO;
-		goto out_err;
-	}
+	chip->vendor.iobase = devm_ioremap(dev, start, len);
+	if (!chip->vendor.iobase)
+		return -EIO;
 
 	/* Default timeouts */
 	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
@@ -685,8 +694,8 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		for (i = irq_s; i <= irq_e && chip->vendor.irq == 0; i++) {
 			iowrite8(i, chip->vendor.iobase +
 				 TPM_INT_VECTOR(chip->vendor.locality));
-			if (request_irq
-			    (i, tis_int_probe, IRQF_SHARED,
+			if (devm_request_irq
+			    (dev, i, tis_int_probe, IRQF_SHARED,
 			     chip->vendor.miscdev.name, chip) != 0) {
 				dev_info(chip->dev,
 					 "Unable to request irq: %d for probe\n",
@@ -726,15 +735,14 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 			iowrite32(intmask,
 				  chip->vendor.iobase +
 				  TPM_INT_ENABLE(chip->vendor.locality));
-			free_irq(i, chip);
 		}
 	}
 	if (chip->vendor.irq) {
 		iowrite8(chip->vendor.irq,
 			 chip->vendor.iobase +
 			 TPM_INT_VECTOR(chip->vendor.locality));
-		if (request_irq
-		    (chip->vendor.irq, tis_int_handler, IRQF_SHARED,
+		if (devm_request_irq
+		    (dev, chip->vendor.irq, tis_int_handler, IRQF_SHARED,
 		     chip->vendor.miscdev.name, chip) != 0) {
 			dev_info(chip->dev,
 				 "Unable to request irq: %d for use\n",
@@ -767,17 +775,9 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		goto out_err;
 	}
 
-	INIT_LIST_HEAD(&chip->vendor.list);
-	mutex_lock(&tis_lock);
-	list_add(&chip->vendor.list, &tis_chips);
-	mutex_unlock(&tis_lock);
-
-
-	return 0;
+	return tpm_chip_register(chip);
 out_err:
-	if (chip->vendor.iobase)
-		iounmap(chip->vendor.iobase);
-	tpm_remove_hardware(chip->dev);
+	tpm_tis_remove(chip);
 	return rc;
 }
 
@@ -859,13 +859,10 @@ MODULE_DEVICE_TABLE(pnp, tpm_pnp_tbl);
 static void tpm_tis_pnp_remove(struct pnp_dev *dev)
 {
 	struct tpm_chip *chip = pnp_get_drvdata(dev);
-
-	tpm_dev_vendor_release(chip);
-
-	kfree(chip);
+	tpm_chip_unregister(chip);
+	tpm_tis_remove(chip);
 }
 
-
 static struct pnp_driver tis_pnp_driver = {
 	.name = "tpm_tis",
 	.id_table = tpm_pnp_tbl,
@@ -884,7 +881,7 @@ MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
 
 static struct platform_driver tis_drv = {
 	.driver = {
-		.name = "tpm_tis",
+		.name		= "tpm_tis",
 		.owner		= THIS_MODULE,
 		.pm		= &tpm_tis_pm,
 	},
@@ -924,31 +921,16 @@ err_dev:
 
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
+	tpm_chip_unregister(chip);
+	tpm_tis_remove(chip);
 	platform_device_unregister(pdev);
 	platform_driver_unregister(&tis_drv);
 }
diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index 2064b45..ce01db3 100644
--- a/drivers/char/tpm/xen-tpmfront.c
+++ b/drivers/char/tpm/xen-tpmfront.c
@@ -175,9 +175,9 @@ static int setup_chip(struct device *dev, struct tpm_private *priv)
 {
 	struct tpm_chip *chip;
 
-	chip = tpm_register_hardware(dev, &tpm_vtpm);
-	if (!chip)
-		return -ENODEV;
+	chip = tpmm_chip_alloc(dev, &tpm_vtpm);
+	if (IS_ERR(chip))
+		return PTR_ERR(chip);
 
 	init_waitqueue_head(&chip->vendor.read_queue);
 
@@ -286,6 +286,7 @@ static int tpmfront_probe(struct xenbus_device *dev,
 		const struct xenbus_device_id *id)
 {
 	struct tpm_private *priv;
+	struct tpm_chip *chip;
 	int rv;
 
 	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
@@ -302,21 +303,22 @@ static int tpmfront_probe(struct xenbus_device *dev,
 
 	rv = setup_ring(dev, priv);
 	if (rv) {
-		tpm_remove_hardware(&dev->dev);
+		chip = dev_get_drvdata(&dev->dev);
+		tpm_chip_unregister(chip);
 		ring_free(priv);
 		return rv;
 	}
 
 	tpm_get_timeouts(priv->chip);
 
-	return rv;
+	return tpm_chip_register(priv->chip);
 }
 
 static int tpmfront_remove(struct xenbus_device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(&dev->dev);
 	struct tpm_private *priv = TPM_VPRIV(chip);
-	tpm_remove_hardware(&dev->dev);
+	tpm_chip_unregister(chip);
 	ring_free(priv);
 	TPM_VPRIV(chip) = NULL;
 	return 0;
-- 
2.1.0

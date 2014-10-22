From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v1 2/3] tpm: two-phase chip management functions
Date: Wed, 22 Oct 2014 19:23:55 +0300
Message-ID: <1413995036-22497-3-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1413995036-22497-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1413995036-22497-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, josh.triplett@intel.com, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
List-Id: linux-api@vger.kernel.org

tpm_register_hardware() and tpm_remove_hardware() are called often
before initializing the device. This is wrong order since it could
be that main TPM driver needs a fully initialized chip to be able to
do its job. For example, now it is impossible to move common startup
functions such as tpm_do_selftest() to tpm_register_hardware().

Added tpm_chip_alloc() and tpm_chip_register() where tpm_chip_alloc()
reserves memory resources and tpm_chip_register() initializes the
device driver. This way it is possible to alter struct tpm_chip
attributes and initialize the device driver before passing it to
tpm_chip_register().

The framework takes care of freeing struct tpm_chip by using devres
API. The broken release callback has been wiped. For example, ACPI
drivers do not ever get this callback.

This is a interm step to get proper life-cycle for TPM device drivers.
The next steps are adding proper ref counting and locking to tpm_chip
that is used in every place in the TPM driver.

Big thank you to Jason Gunthorpe for carefully reviewing this part
of the code. Without his contribution reaching the best quality would
not have been possible.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/Makefile           |   2 +-
 drivers/char/tpm/tpm-chip.c         | 190 ++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-interface.c    | 148 +---------------------------
 drivers/char/tpm/tpm.h              |  11 ++-
 drivers/char/tpm/tpm_atmel.c        |  11 ++-
 drivers/char/tpm/tpm_i2c_atmel.c    |  33 +++----
 drivers/char/tpm/tpm_i2c_infineon.c |  37 ++-----
 drivers/char/tpm/tpm_i2c_nuvoton.c  |  44 +++------
 drivers/char/tpm/tpm_i2c_stm_st33.c |  22 ++---
 drivers/char/tpm/tpm_ibmvtpm.c      |  17 ++--
 drivers/char/tpm/tpm_infineon.c     |  13 ++-
 drivers/char/tpm/tpm_nsc.c          |  11 ++-
 drivers/char/tpm/tpm_tis.c          |  79 ++++++---------
 drivers/char/tpm/xen-tpmfront.c     |  14 +--
 14 files changed, 316 insertions(+), 316 deletions(-)
 create mode 100644 drivers/char/tpm/tpm-chip.c

diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 4d85dd6..837da04 100644
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
index 0000000..4a29421
--- /dev/null
+++ b/drivers/char/tpm/tpm-chip.c
@@ -0,0 +1,190 @@
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
+ * when the device is released. This funcion does the opposite of
+ * tpmm_chip_alloc() freeing memory and the device number.
+ */
+static void tpmm_chip_remove(void *data)
+{
+	struct tpm_chip *chip = (struct tpm_chip *) data;
+	dev_dbg(chip->dev, "%s\n", __func__);
+	clear_bit(chip->dev_num, dev_mask);
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
+				const struct tpm_class_ops *ops)
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
+	chip->dev_num = find_first_zero_bit(dev_mask, TPM_NUM_DEVICES);
+
+	if (chip->dev_num >= TPM_NUM_DEVICES) {
+		dev_err(dev, "No available tpm device numbers\n");
+		kfree(chip);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	set_bit(chip->dev_num, dev_mask);
+
+	scnprintf(chip->devname, sizeof(chip->devname), "%s%d", "tpm",
+		  chip->dev_num);
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
+	dev_dbg(chip->dev, "%s\n", __func__);
+
+	spin_lock(&driver_lock);
+	list_del_rcu(&chip->list);
+	spin_unlock(&driver_lock);
+	synchronize_rcu();
+
+	tpm_sysfs_del_device(chip);
+	tpm_remove_ppi(&chip->dev->kobj);
+	tpm_bios_log_teardown(chip->bios_dir);
+	tpm_dev_del_device(chip);
+}
+EXPORT_SYMBOL_GPL(tpm_chip_unregister);
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index fedb4d5..59d6654 100644
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
-	list_add_rcu(&chip->list, &tpm_chip_list);
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
index 12326e1..fa0974c 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -110,7 +110,6 @@ struct tpm_chip {
 	struct dentry **bios_dir;
 
 	struct list_head list;
-	void (*release) (struct device *);
 };
 
 #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)
@@ -320,15 +319,17 @@ extern int tpm_get_timeouts(struct tpm_chip *);
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
index 7727292..8af3b4a 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -160,11 +160,9 @@ static int i2c_atmel_probe(struct i2c_client *client,
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
@@ -179,21 +177,16 @@ static int i2c_atmel_probe(struct i2c_client *client,
 	/* There is no known way to probe for this device, and all version
 	 * information seems to be read via TPM commands. Thus we rely on the
 	 * TPM startup process in the common code to detect the device. */
-	if (tpm_get_timeouts(chip)) {
-		rc = -ENODEV;
-		goto out_err;
-	}
+	if (tpm_get_timeouts(chip))
+		return -ENODEV;
 
-	if (tpm_do_selftest(chip)) {
-		rc = -ENODEV;
-		goto out_err;
-	}
+	if (tpm_do_selftest(chip))
+		return -ENODEV;
 
-	return 0;
+	rc = tpm_chip_register(chip);
+	if (rc)
+		return rc;
 
-out_err:
-	tpm_dev_vendor_release(chip);
-	tpm_remove_hardware(chip->dev);
 	return rc;
 }
 
@@ -201,11 +194,7 @@ static int i2c_atmel_remove(struct i2c_client *client)
 {
 	struct device *dev = &(client->dev);
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-
-	if (chip)
-		tpm_dev_vendor_release(chip);
-	tpm_remove_hardware(dev);
-	kfree(chip);
+	tpm_chip_unregister(chip);
 	return 0;
 }
 
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 472af4b..6f00bc3 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -581,10 +581,9 @@ static int tpm_tis_i2c_init(struct device *dev)
 	int rc = 0;
 	struct tpm_chip *chip;
 
-	chip = tpm_register_hardware(dev, &tpm_tis_i2c);
-	if (!chip) {
-		dev_err(dev, "could not register hardware\n");
-		rc = -ENODEV;
+	chip = tpmm_chip_alloc(dev, &tpm_tis_i2c);
+	if (IS_ERR(chip)) {
+		rc = PTR_ERR(chip);
 		goto out_err;
 	}
 
@@ -600,7 +599,7 @@ static int tpm_tis_i2c_init(struct device *dev)
 	if (request_locality(chip, 0) != 0) {
 		dev_err(dev, "could not request locality\n");
 		rc = -ENODEV;
-		goto out_vendor;
+		goto out_err;
 	}
 
 	/* read four bytes from DID_VID register */
@@ -628,21 +627,13 @@ static int tpm_tis_i2c_init(struct device *dev)
 	tpm_get_timeouts(chip);
 	tpm_do_selftest(chip);
 
-	return 0;
+	rc = tpm_chip_register(chip);
+	if (rc)
+		goto out_release;
 
+	return 0;
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
@@ -712,17 +703,9 @@ static int tpm_tis_i2c_probe(struct i2c_client *client,
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
index 7b158ef..09f0c46 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -530,11 +530,9 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
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
@@ -584,7 +582,7 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 							   TPM_DATA_FIFO_W,
 							   1, (u8 *) (&rc));
 				if (rc < 0)
-					goto out_err;
+					return rc;
 				/* TPM_STS <- 0x40 (commandReady) */
 				i2c_nuvoton_ready(chip);
 			} else {
@@ -594,45 +592,33 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
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
+	if (tpm_get_timeouts(chip))
+		return -ENODEV;
 
-	if (tpm_do_selftest(chip)) {
-		rc = -ENODEV;
-		goto out_err;
-	}
+	if (tpm_do_selftest(chip))
+		return -ENODEV;
 
-	return 0;
+	rc = tpm_chip_register(chip);
+	if (rc)
+		return rc;
 
-out_err:
-	tpm_dev_vendor_release(chip);
-	tpm_remove_hardware(chip->dev);
-	return rc;
+	return 0;
 }
 
 static int i2c_nuvoton_remove(struct i2c_client *client)
 {
 	struct device *dev = &(client->dev);
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-
-	if (chip)
-		tpm_dev_vendor_release(chip);
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
index 4669e37..dd32429 100644
--- a/drivers/char/tpm/tpm_i2c_stm_st33.c
+++ b/drivers/char/tpm/tpm_i2c_stm_st33.c
@@ -619,10 +619,9 @@ tpm_st33_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
 		goto end;
 	}
 
-	chip = tpm_register_hardware(&client->dev, &st_i2c_tpm);
-	if (!chip) {
-		dev_info(&client->dev, "fail chip\n");
-		err = -ENODEV;
+	chip = tpmm_chip_alloc(&client->dev, &st_i2c_tpm);
+	if (IS_ERR(chip)) {
+		err = PTR_ERR(chip);
 		goto end;
 	}
 
@@ -631,14 +630,14 @@ tpm_st33_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	if (!platform_data) {
 		dev_info(&client->dev, "chip not available\n");
 		err = -ENODEV;
-		goto _tpm_clean_answer;
+		goto end;
 	}
 
 	platform_data->tpm_i2c_buffer[0] =
 	    kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
 	if (platform_data->tpm_i2c_buffer[0] == NULL) {
 		err = -ENOMEM;
-		goto _tpm_clean_answer;
+		goto end;
 	}
 	platform_data->tpm_i2c_buffer[1] =
 	    kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
@@ -716,7 +715,10 @@ tpm_st33_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	tpm_get_timeouts(chip);
 	tpm_do_selftest(chip);
 
-	dev_info(chip->dev, "TPM I2C Initialized\n");
+	err = tpm_chip_register(chip);
+	if (err)
+		goto _irq_set;
+
 	return 0;
 _irq_set:
 	free_irq(gpio_to_irq(platform_data->io_serirq), (void *)chip);
@@ -732,8 +734,6 @@ _tpm_clean_response2:
 _tpm_clean_response1:
 	kzfree(platform_data->tpm_i2c_buffer[0]);
 	platform_data->tpm_i2c_buffer[0] = NULL;
-_tpm_clean_answer:
-	tpm_remove_hardware(chip->dev);
 end:
 	pr_info("TPM I2C initialisation fail\n");
 	return err;
@@ -752,13 +752,13 @@ static int tpm_st33_i2c_remove(struct i2c_client *client)
 		((struct i2c_client *)TPM_VPRIV(chip))->dev.platform_data;
 
 	if (pin_infos != NULL) {
+		tpm_chip_unregister(chip);
+
 		free_irq(pin_infos->io_serirq, chip);
 
 		gpio_free(pin_infos->io_serirq);
 		gpio_free(pin_infos->io_lpcpd);
 
-		tpm_remove_hardware(chip->dev);
-
 		if (pin_infos->tpm_i2c_buffer[1] != NULL) {
 			kzfree(pin_infos->tpm_i2c_buffer[1]);
 			pin_infos->tpm_i2c_buffer[1] = NULL;
diff --git a/drivers/char/tpm/tpm_ibmvtpm.c b/drivers/char/tpm/tpm_ibmvtpm.c
index af74c57..eb95796 100644
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
@@ -555,11 +556,9 @@ static int tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
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
@@ -629,7 +628,7 @@ static int tpm_ibmvtpm_probe(struct vio_dev *vio_dev,
 	if (rc)
 		goto init_irq_cleanup;
 
-	return rc;
+	return tpm_chip_register(chip);
 init_irq_cleanup:
 	do {
 		rc1 = plpar_hcall_norets(H_FREE_CRQ, vio_dev->unit_address);
@@ -644,8 +643,6 @@ cleanup:
 		kfree(ibmvtpm);
 	}
 
-	tpm_remove_hardware(dev);
-
 	return rc;
 }
 
diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
index dc0a255..d1559f6 100644
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
@@ -573,6 +580,8 @@ static void tpm_inf_pnp_remove(struct pnp_dev *dev)
 	struct tpm_chip *chip = pnp_get_drvdata(dev);
 
 	if (chip) {
+		tpm_chip_unregister(chip);
+
 		if (tpm_dev.iotype == TPM_INF_IO_PORT) {
 			release_region(tpm_dev.data_regs, tpm_dev.data_size);
 			release_region(tpm_dev.config_port,
@@ -581,8 +590,6 @@ static void tpm_inf_pnp_remove(struct pnp_dev *dev)
 			iounmap(tpm_dev.mem_base);
 			release_mem_region(tpm_dev.map_base, tpm_dev.map_size);
 		}
-		tpm_dev_vendor_release(chip);
-		tpm_remove_hardware(chip->dev);
 	}
 }
 
diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index 3179ec9..151f96a 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -247,9 +247,9 @@ static struct platform_device *pdev = NULL;
 static void tpm_nsc_remove(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-	if ( chip ) {
+	if (chip) {
+		tpm_chip_unregister(chip);
 		release_region(chip->vendor.base, 2);
-		tpm_remove_hardware(chip->dev);
 	}
 }
 
@@ -308,11 +308,16 @@ static int __init init_nsc(void)
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
index 2c46734..e2cb04d 100644
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
@@ -528,6 +525,17 @@ static bool interrupts = true;
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
@@ -535,14 +543,13 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	int rc, i, irq_s, irq_e, probe;
 	struct tpm_chip *chip;
 
-	if (!(chip = tpm_register_hardware(dev, &tpm_tis)))
-		return -ENODEV;
+	chip = tpmm_chip_alloc(dev, &tpm_tis);
+	if (IS_ERR(chip))
+		return PTR_ERR(chip);
 
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
@@ -649,8 +656,8 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
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
@@ -690,15 +697,14 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
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
@@ -719,17 +725,9 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 		}
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
 
@@ -811,13 +809,10 @@ MODULE_DEVICE_TABLE(pnp, tpm_pnp_tbl);
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
@@ -836,7 +831,7 @@ MODULE_PARM_DESC(hid, "Set additional specific HID for this driver to probe");
 
 static struct platform_driver tis_drv = {
 	.driver = {
-		.name = "tpm_tis",
+		.name		= "tpm_tis",
 		.owner		= THIS_MODULE,
 		.pm		= &tpm_tis_pm,
 	},
@@ -876,31 +871,17 @@ err_dev:
 
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
+	/* FIXME might be broken when using force */
+	tpm_chip_unregister(chip);
+	tpm_tis_remove(chip);
 	platform_device_unregister(pdev);
 	platform_driver_unregister(&tis_drv);
 }
diff --git a/drivers/char/tpm/xen-tpmfront.c b/drivers/char/tpm/xen-tpmfront.c
index 441b44e..c3b4f5a 100644
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

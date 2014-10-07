From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v2 2/7] tpm: two-phase chip management functions
Date: Tue,  7 Oct 2014 20:01:12 +0300
Message-ID: <1412701277-27794-3-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1412701277-27794-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Added tpm_chip_alloc() and tpm_chip_register() where tpm_chip_alloc()
reserves memory resources and tpm_chip_register() initializes the
device driver. This way it is possible to alter struct tpm_chip
attributes before passing it to tpm_chip_register().

The framework takes care of freeing struct tpm_chip by using devres
API. The broken release callback has been wiped.

tpm_register_hardware() and tpm_remove_hardware are still available
as a wrapper in order to make this change less intrusive. However,
device drivers should eventually move to the tpm_chip_* functions.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/Makefile           |   2 +-
 drivers/char/tpm/tpm-chip.c         | 178 ++++++++++++++++++++++++++++++++++++
 drivers/char/tpm/tpm-interface.c    | 124 ++-----------------------
 drivers/char/tpm/tpm.h              |   8 +-
 drivers/char/tpm/tpm_i2c_atmel.c    |   5 -
 drivers/char/tpm/tpm_i2c_infineon.c |  10 --
 drivers/char/tpm/tpm_i2c_nuvoton.c  |   5 -
 drivers/char/tpm/tpm_infineon.c     |   1 -
 drivers/char/tpm/tpm_tis.c          |   5 +-
 9 files changed, 194 insertions(+), 144 deletions(-)
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
index 0000000..6cc4cee
--- /dev/null
+++ b/drivers/char/tpm/tpm-chip.c
@@ -0,0 +1,178 @@
+/*
+ * Copyright (C) 2004 IBM Corporation
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * Authors:
+ * Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
+ * Leendert van Doorn <leendert-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
+ * Dave Safford <safford-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
+ * Reiner Sailer <sailer-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
+ * Kylene Hall <kjhall-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
+ *
+ * Maintained by: <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
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
+ * tpm_devm_chip_remove() - free chip memory and device number
+ * @data: points to struct tpm_chip instance
+ *
+ * This is used internally by tpm_chip_alloc() and called by devres
+ * when the device is released. This funcion does the opposite of
+ * tpm_chip_alloc() freeing memory and the device number.
+ */
+static void tpm_devm_chip_remove(void *data)
+{
+	struct tpm_chip *chip = (struct tpm_chip *) data;
+	dev_dbg(chip->dev, "%s\n", __func__);
+	clear_bit(chip->dev_num, dev_mask);
+	kfree(chip);
+}
+
+/**
+ * tpm_chip_alloc() - allocate a new struct tpm_chip instance
+ * @dev: device to which the chip is associated
+ * @ops: struct tpm_class_ops instance
+ *
+ * Allocates a new struct tpm_chip instance and assigns a free
+ * device number for it. Caller does not have to worry about
+ * freeing the allocated resources. When the devices is removed
+ * devres calls tpm_devm_chip_remove() to do the job.
+ */
+struct tpm_chip *tpm_chip_alloc(struct device *dev,
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
+	devm_add_action(dev, tpm_devm_chip_remove, chip);
+	dev_set_drvdata(dev, chip);
+
+	return chip;
+}
+EXPORT_SYMBOL_GPL(tpm_chip_alloc);
+
+/*
+ * tpm_chip_register() - create a misc driver for the TPM chip
+ * @chip: TPM chip to use.
+ *
+ * Creates a misc driver for the TPM chip and adds sysfs interfaces for
+ * the device, PPI and TCPA. As the last step this function adds the
+ * chip to the list of TPM chips available for use.
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
+	tpm_dev_del_device(chip);
+	tpm_sysfs_del_device(chip);
+	tpm_remove_ppi(&chip->dev->kobj);
+	tpm_bios_log_teardown(chip->bios_dir);
+}
+EXPORT_SYMBOL_GPL(tpm_chip_unregister);
diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-interface.c
index fedb4d5..1ce3ad3 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2004 IBM Corporation
+ * Copyright (C) 2014 Intel Corporation
  *
  * Authors:
  * Leendert van Doorn <leendert-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
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
@@ -896,18 +872,7 @@ void tpm_remove_hardware(struct device *dev)
 		return;
 	}
 
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
+	tpm_chip_unregister(chip);
 }
 EXPORT_SYMBOL_GPL(tpm_remove_hardware);
 
@@ -1044,35 +1009,6 @@ int tpm_get_random(u32 chip_num, u8 *out, size_t max)
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
 /*
  * Called from tpm_<specific>.c probe function only for devices
  * the driver has determined it should claim.  Prior to calling
@@ -1084,61 +1020,17 @@ struct tpm_chip *tpm_register_hardware(struct device *dev,
 				       const struct tpm_class_ops *ops)
 {
 	struct tpm_chip *chip;
+	int rc;
 
-	/* Driver specific per-device data */
-	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
-
-	if (chip == NULL)
+	chip = tpm_chip_alloc(dev, ops);
+	if (IS_ERR(chip))
 		return NULL;
 
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
+	rc = tpm_chip_register(chip);
+	if (rc)
+		return NULL;
 
 	return chip;
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
 }
 EXPORT_SYMBOL_GPL(tpm_register_hardware);
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 12326e1..5eb89897 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -110,7 +110,6 @@ struct tpm_chip {
 	struct dentry **bios_dir;
 
 	struct list_head list;
-	void (*release) (struct device *);
 };
 
 #define to_tpm_chip(n) container_of(n, struct tpm_chip, vendor)
@@ -322,13 +321,18 @@ extern int tpm_do_selftest(struct tpm_chip *);
 extern unsigned long tpm_calc_ordinal_duration(struct tpm_chip *, u32);
 extern struct tpm_chip* tpm_register_hardware(struct device *,
 					      const struct tpm_class_ops *ops);
-extern void tpm_dev_vendor_release(struct tpm_chip *);
 extern void tpm_remove_hardware(struct device *);
 extern int tpm_pm_suspend(struct device *);
 extern int tpm_pm_resume(struct device *);
 extern int wait_for_tpm_stat(struct tpm_chip *, u8, unsigned long,
 			     wait_queue_head_t *, bool);
 
+struct tpm_chip *tpm_chip_find_get(int chip_num);
+extern struct tpm_chip *tpm_chip_alloc(struct device *dev,
+				       const struct tpm_class_ops *ops);
+extern int tpm_chip_register(struct tpm_chip *chip);
+extern void tpm_chip_unregister(struct tpm_chip *chip);
+
 int tpm_dev_add_device(struct tpm_chip *chip);
 void tpm_dev_del_device(struct tpm_chip *chip);
 int tpm_sysfs_add_device(struct tpm_chip *chip);
diff --git a/drivers/char/tpm/tpm_i2c_atmel.c b/drivers/char/tpm/tpm_i2c_atmel.c
index 7727292..1b52045 100644
--- a/drivers/char/tpm/tpm_i2c_atmel.c
+++ b/drivers/char/tpm/tpm_i2c_atmel.c
@@ -192,7 +192,6 @@ static int i2c_atmel_probe(struct i2c_client *client,
 	return 0;
 
 out_err:
-	tpm_dev_vendor_release(chip);
 	tpm_remove_hardware(chip->dev);
 	return rc;
 }
@@ -200,12 +199,8 @@ out_err:
 static int i2c_atmel_remove(struct i2c_client *client)
 {
 	struct device *dev = &(client->dev);
-	struct tpm_chip *chip = dev_get_drvdata(dev);
 
-	if (chip)
-		tpm_dev_vendor_release(chip);
 	tpm_remove_hardware(dev);
-	kfree(chip);
 	return 0;
 }
 
diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 472af4b..9d9834d 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -634,15 +634,10 @@ out_release:
 	release_locality(chip, chip->vendor.locality, 1);
 
 out_vendor:
-	/* close file handles */
-	tpm_dev_vendor_release(chip);
-
 	/* remove hardware */
 	tpm_remove_hardware(chip->dev);
 
 	/* reset these pointers, otherwise we oops */
-	chip->dev->release = NULL;
-	chip->release = NULL;
 	tpm_dev.client = NULL;
 out_err:
 	return rc;
@@ -714,15 +709,10 @@ static int tpm_tis_i2c_remove(struct i2c_client *client)
 	struct tpm_chip *chip = tpm_dev.chip;
 	release_locality(chip, chip->vendor.locality, 1);
 
-	/* close file handles */
-	tpm_dev_vendor_release(chip);
-
 	/* remove hardware */
 	tpm_remove_hardware(chip->dev);
 
 	/* reset these pointers, otherwise we oops */
-	chip->dev->release = NULL;
-	chip->release = NULL;
 	tpm_dev.client = NULL;
 
 	return 0;
diff --git a/drivers/char/tpm/tpm_i2c_nuvoton.c b/drivers/char/tpm/tpm_i2c_nuvoton.c
index 7b158ef..3a2caec 100644
--- a/drivers/char/tpm/tpm_i2c_nuvoton.c
+++ b/drivers/char/tpm/tpm_i2c_nuvoton.c
@@ -615,7 +615,6 @@ static int i2c_nuvoton_probe(struct i2c_client *client,
 	return 0;
 
 out_err:
-	tpm_dev_vendor_release(chip);
 	tpm_remove_hardware(chip->dev);
 	return rc;
 }
@@ -623,12 +622,8 @@ out_err:
 static int i2c_nuvoton_remove(struct i2c_client *client)
 {
 	struct device *dev = &(client->dev);
-	struct tpm_chip *chip = dev_get_drvdata(dev);
 
-	if (chip)
-		tpm_dev_vendor_release(chip);
 	tpm_remove_hardware(dev);
-	kfree(chip);
 	return 0;
 }
 
diff --git a/drivers/char/tpm/tpm_infineon.c b/drivers/char/tpm/tpm_infineon.c
index dc0a255..0a72840 100644
--- a/drivers/char/tpm/tpm_infineon.c
+++ b/drivers/char/tpm/tpm_infineon.c
@@ -581,7 +581,6 @@ static void tpm_inf_pnp_remove(struct pnp_dev *dev)
 			iounmap(tpm_dev.mem_base);
 			release_mem_region(tpm_dev.map_base, tpm_dev.map_size);
 		}
-		tpm_dev_vendor_release(chip);
 		tpm_remove_hardware(chip->dev);
 	}
 }
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 2c46734..a2780df 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -811,10 +811,7 @@ MODULE_DEVICE_TABLE(pnp, tpm_pnp_tbl);
 static void tpm_tis_pnp_remove(struct pnp_dev *dev)
 {
 	struct tpm_chip *chip = pnp_get_drvdata(dev);
-
-	tpm_dev_vendor_release(chip);
-
-	kfree(chip);
+	tpm_remove_hardware(chip->dev);
 }
 
 
-- 
2.1.0

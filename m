From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v3 4/6] tpm: TPM 2.0 sysfs attributes
Date: Wed, 15 Oct 2014 13:35:14 +0200
Message-ID: <1413372916-12091-5-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1413372916-12091-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1413372916-12091-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, josh.triplett@intel.com, christophe.ricard@gmail.com, will.c.arthur@intel.com, monty.wiseman@intel.com, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Implemented sysfs attributes for TPM2 devices. TPM2 sysfs attributes
are mounted in the actual device associated with the chip instead of
platform device like with TPM1 devices.

Documentation/ABI/stable/sysfs-class/tpm2 contains descriptions
of these attributes.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 Documentation/ABI/stable/sysfs-class-tpm2 |  72 +++++++
 drivers/char/tpm/Makefile                 |   2 +-
 drivers/char/tpm/tpm-chip.c               |  12 +-
 drivers/char/tpm/tpm.h                    |  24 +++
 drivers/char/tpm/tpm2-sysfs.c             | 314 ++++++++++++++++++++++++++++++
 5 files changed, 421 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/ABI/stable/sysfs-class-tpm2
 create mode 100644 drivers/char/tpm/tpm2-sysfs.c

diff --git a/Documentation/ABI/stable/sysfs-class-tpm2 b/Documentation/ABI/stable/sysfs-class-tpm2
new file mode 100644
index 0000000..b3d20a4
--- /dev/null
+++ b/Documentation/ABI/stable/sysfs-class-tpm2
@@ -0,0 +1,72 @@
+What:		/sys/class/misc/tpmX/device/
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The device/ directory under a specific TPM instance exposes
+		the properties of that TPM chip.
+
+What:		/sys/class/misc/tpmX/device/version
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The "version" property prints the protocol version number
+		in the major.minor format.
+
+What:		/sys/class/misc/tpmX/device/sh_enabled
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The "sh_enabled" property prints a '1' if the Storage Hierarchy
+		is enabled, i.e. if PM_PT_STARTUP_CLEAR.shEnable is set.
+
+What:		/sys/class/misc/tpmX/device/sh_owned
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The "sh_owned" property prints a '1' if the ownership of the
+		Storage Hierarchy has been taken, i.e. if
+		TPM_PT_PERMANENT.ownerAuthSet is set.
+
+What:		/sys/class/misc/tpmX/device/eh_enabled
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The "eh_enabled" property prints a '1' if the Endorsement
+		Hierarchy is enabled, i.e if PM_PT_STARTUP_CLEAR.ehEnable is
+		set.
+
+What:		/sys/class/misc/tpmX/device/eh_owned
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The "eh_owned" property prints a '1' if the ownership of the
+		Endrosoment Hierarchy has been taken, i.e if
+		TPM_PT_PERMANENT.endorsementAuthSet is set.
+
+What:		/sys/class/misc/tpmX/device/manufacturer
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The "manufacturer" property prints the vendor ID of the TPM
+		manufacturer.
+
+What:		/sys/class/misc/tpmX/device/firmware
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The property prints the vendor-specific value indicating the
+		version of the firmware.
+
+What:		/sys/class/misc/tpmX/device/pcr/sha1/X
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	These files print PCR values for the SHA-1 bank.
+
+What:		/sys/class/misc/tpmX/device/cancel
+Date:		October 2014
+KernelVersion:	3.19
+Contact:	tpmdd-devel@lists.sf.net
+Description:	The "cancel" property allows you to cancel the currently
+		pending TPM command. Writing any value to cancel will call the
+		TPM chip specific cancel operation.
diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index ae56af9..d3cf905 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -2,7 +2,7 @@
 # Makefile for the kernel tpm device drivers.
 #
 obj-$(CONFIG_TCG_TPM) += tpm.o
-tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o
+tpm-y := tpm-interface.o tpm-dev.o tpm-sysfs.o tpm-chip.o tpm2-cmd.o tpm2-sysfs.o
 tpm-$(CONFIG_ACPI) += tpm_ppi.o
 
 ifdef CONFIG_ACPI
diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 3bb0d9f..5fac0a8 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -140,9 +140,13 @@ int tpm_chip_register(struct tpm_chip *chip)
 		return rc;
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
-		rc = tpm_add_ppi(&chip->vendor.miscdev.this_device->kobj);
+		rc = tpm2_sysfs_add_device(chip);
 		if (rc)
 			goto del_misc;
+
+		rc = tpm_add_ppi(&chip->vendor.miscdev.this_device->kobj);
+		if (rc)
+			goto del_sysfs;
 	} else {
 		rc = tpm_sysfs_add_device(chip);
 		if (rc)
@@ -162,7 +166,10 @@ int tpm_chip_register(struct tpm_chip *chip)
 
 	return 0;
 del_sysfs:
-	tpm_sysfs_del_device(chip);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2)
+		tpm2_sysfs_del_device(chip);
+	else
+		tpm_sysfs_del_device(chip);
 del_misc:
 	tpm_dev_del_device(chip);
 	return rc;
@@ -190,6 +197,7 @@ void tpm_chip_unregister(struct tpm_chip *chip)
 
 	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
 		tpm_remove_ppi(&chip->vendor.miscdev.this_device->kobj);
+		tpm2_sysfs_del_device(chip);
 	} else {
 		tpm_bios_log_teardown(chip->bios_dir);
 		tpm_remove_ppi(&chip->dev->kobj);
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index b1de902..9f1f146 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -107,6 +107,24 @@ enum tpm2_capabilities {
 	TPM2_CAP_TPM_PROPERTIES = 6,
 };
 
+enum tpm2_tpm_properties {
+	TPM2_PT_MANUFACTURER		= 0x00000105,
+	TPM2_PT_FIRMWARE_VERSION_1	= 0x00000111,
+	TPM2_PT_FIRMWARE_VERSION_2	= 0x00000111,
+	TPM2_PT_PERMANENT		= 0x00000200,
+	TPM2_PT_STARTUP_CLEAR		= 0x00000201,
+};
+
+enum tpm2_pt_startup_clear {
+	TPM2_PT_SC_SH_ENABLE	= BIT(1),
+	TPM2_PT_SC_EH_ENABLE	= BIT(2),
+};
+
+enum tpm2_pt_permanent {
+	TPM2_PT_PM_OWNER_AUTH_SET	= BIT(0),
+	TPM2_PT_PM_ENDORSEMENT_AUTH_SET	= BIT(1),
+};
+
 enum tpm2_startup_types {
 	TPM2_SU_CLEAR	= 0x0000,
 	TPM2_SU_STATE	= 0x0001,
@@ -165,6 +183,9 @@ struct tpm_chip {
 
 	struct dentry **bios_dir;
 
+	struct kobject *pcrs_kobj;
+	void *sha1_bank;
+
 	struct list_head list;
 };
 
@@ -416,3 +437,6 @@ extern ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,
 			       u32* value, const char *desc);
 extern unsigned long tpm2_calc_ordinal_duration(struct tpm_chip *, u32);
 extern int tpm2_do_selftest(struct tpm_chip *chip);
+
+int tpm2_sysfs_add_device(struct tpm_chip *chip);
+void tpm2_sysfs_del_device(struct tpm_chip *chip);
diff --git a/drivers/char/tpm/tpm2-sysfs.c b/drivers/char/tpm/tpm2-sysfs.c
new file mode 100644
index 0000000..e502032
--- /dev/null
+++ b/drivers/char/tpm/tpm2-sysfs.c
@@ -0,0 +1,314 @@
+/*
+ * Copyright (C) 2014 Intel Corporation
+ * Copyright (C) 2004 IBM Corporation
+ * Copyright (C) 2013 Obsidian Research Corp
+ *
+ * Authors:
+ * Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+ *
+ * sysfs filesystem inspection interface to the TPM
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License as
+ * published by the Free Software Foundation, version 2 of the
+ * License.
+ *
+ */
+#include <linux/device.h>
+#include <linux/slab.h>
+#include "tpm.h"
+
+static ssize_t sh_enabled_show(struct device *dev, struct device_attribute *attr,
+		     char *buf)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	u32 value;
+	ssize_t rc;
+
+	rc = tpm2_get_tpm_pt(chip, TPM2_PT_STARTUP_CLEAR, &value,
+			     "could not retrieve STARTUP_CLEAR property");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", (value & TPM2_PT_SC_SH_ENABLE) > 0);
+	return rc;
+}
+static DEVICE_ATTR_RO(sh_enabled);
+
+static ssize_t sh_owned_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	u32 value;
+	ssize_t rc;
+
+	rc = tpm2_get_tpm_pt(chip, TPM2_PT_PERMANENT, &value,
+			     "could not retrieve PERMANENT property");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", (value & TPM2_PT_PM_OWNER_AUTH_SET) > 0);
+	return rc;
+}
+static DEVICE_ATTR_RO(sh_owned);
+
+static ssize_t eh_enabled_show(struct device *dev, struct device_attribute *attr,
+		     char *buf)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	u32 value;
+	ssize_t rc;
+
+	rc = tpm2_get_tpm_pt(chip, TPM2_PT_STARTUP_CLEAR, &value,
+			     "could not retrieve STARTUP_CLEAR property");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", (value & TPM2_PT_SC_EH_ENABLE) > 0);
+	return rc;
+}
+static DEVICE_ATTR_RO(eh_enabled);
+
+static ssize_t eh_owned_show(struct device *dev, struct device_attribute *attr,
+			  char *buf)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	u32 value;
+	ssize_t rc;
+
+	rc = tpm2_get_tpm_pt(chip, TPM2_PT_PERMANENT, &value,
+			     "could not retrieve PERMANENT property");
+	if (rc)
+		return 0;
+
+	rc = sprintf(buf, "%d\n", (value & TPM2_PT_PM_ENDORSEMENT_AUTH_SET) > 0);
+	return rc;
+}
+static DEVICE_ATTR_RO(eh_owned);
+
+static ssize_t manufacturer_show(struct device *dev,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	u32 manufacturer;
+	ssize_t rc;
+	char *str = buf;
+
+	rc = tpm2_get_tpm_pt(chip, TPM2_PT_MANUFACTURER, (u32 *) &manufacturer,
+			     "could not retrieve MANUFACTURER property");
+	if (rc)
+		return 0;
+
+	str += sprintf(str, "0x%08x\n", be32_to_cpu(manufacturer));
+
+	return str - buf;
+}
+static DEVICE_ATTR_RO(manufacturer);
+
+static ssize_t firmware_show(struct device *dev, struct device_attribute *attr,
+			 char *buf)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	u32 firmware1;
+	u32 firmware2;
+	ssize_t rc;
+	char *str = buf;
+
+	rc = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_1, (u32 *) &firmware1,
+			     "could not retrieve FIRMWARE_VERSION_1 property");
+	if (rc)
+		return 0;
+
+	rc = tpm2_get_tpm_pt(chip, TPM2_PT_FIRMWARE_VERSION_2, (u32 *) &firmware2,
+			     "could not retrieve FIRMWARE_VERSION_2 property");
+	if (rc)
+		return 0;
+
+	str += sprintf(str, "0x%08x.0x%08x\n", firmware1, firmware2);
+
+	return str - buf;
+}
+static DEVICE_ATTR_RO(firmware);
+
+static ssize_t cancel_store(struct device *dev, struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+	if (chip == NULL)
+		return 0;
+
+	chip->ops->cancel(chip);
+	return count;
+}
+static DEVICE_ATTR_WO(cancel);
+
+static ssize_t version_show(struct device *dev, struct device_attribute *attr,
+			   char *buf)
+{
+	char *str = buf;
+
+	str += sprintf(str, "2.0\n");
+
+	return str - buf;
+}
+static DEVICE_ATTR_RO(version);
+
+static struct attribute *tpm_dev_attrs[] = {
+	&dev_attr_sh_enabled.attr,
+	&dev_attr_sh_owned.attr,
+	&dev_attr_eh_enabled.attr,
+	&dev_attr_eh_owned.attr,
+	&dev_attr_manufacturer.attr,
+	&dev_attr_firmware.attr,
+	&dev_attr_cancel.attr,
+	&dev_attr_version.attr,
+	NULL,
+};
+
+static const struct attribute_group tpm_dev_group = {
+	.attrs	= tpm_dev_attrs,
+};
+
+struct pcr_attr {
+	struct attribute attr;
+	unsigned int index;
+	char name[3];
+};
+
+struct pcr_bank {
+	struct kobject kobj;
+	struct kobj_type ktype;
+	struct device *dev;
+	struct pcr_attr pcr_attrs[TPM2_PLATFORM_PCR];
+	struct attribute *attrs[TPM2_PLATFORM_PCR + 1];
+};
+
+static ssize_t pcr_bank_attr_show(struct kobject *kobj,
+				  struct attribute *attr,
+				  char *buf)
+{
+	u8 digest[TPM_DIGEST_SIZE];
+	ssize_t rc;
+	int i;
+	char *str = buf;
+	struct tpm_chip *chip;
+	struct pcr_attr *pcr_attr;
+	struct pcr_bank *pcr_bank;
+
+	pcr_attr = container_of(attr, struct pcr_attr, attr);
+	pcr_bank = container_of(kobj, struct pcr_bank, kobj);
+	chip = dev_get_drvdata(pcr_bank->dev);
+
+	rc = tpm2_pcr_read(chip, pcr_attr->index, digest);
+	if (rc)
+		return rc;
+
+	for (i = 0; i < TPM_DIGEST_SIZE; i++)
+		str += sprintf(str, "%02X", digest[i]);
+
+	str += sprintf(str, "\n");
+
+	return str - buf;
+}
+
+static void pcr_bank_release(struct kobject *kobj)
+{
+	struct pcr_bank *pcr_bank;
+	pcr_bank = container_of(kobj, struct pcr_bank, kobj);
+	kfree(pcr_bank);
+}
+
+static const struct sysfs_ops pcr_bank_sysfs_ops = {
+	.show		= pcr_bank_attr_show,
+};
+
+static struct pcr_bank *pcr_bank_create(struct device *dev,
+					struct kobject *parent_kobj)
+{
+	struct pcr_bank *pcr_bank;
+	struct pcr_attr *pcr_attr;
+	struct attribute *attr;
+	int i;
+	int rc;
+
+	pcr_bank = kzalloc(sizeof(*pcr_bank), GFP_KERNEL);
+	if (!pcr_bank)
+		return NULL;
+
+	pcr_bank->dev			= dev;
+	pcr_bank->ktype.sysfs_ops	= &pcr_bank_sysfs_ops;
+	pcr_bank->ktype.default_attrs	= pcr_bank->attrs;
+	pcr_bank->ktype.release		= pcr_bank_release;
+
+	for (i = 0; i < TPM2_PLATFORM_PCR; i++) {
+		pcr_attr = &pcr_bank->pcr_attrs[i];
+		pcr_attr->index = i;
+		sprintf(pcr_attr->name, "%d", i);
+
+		attr = &pcr_attr->attr;
+		attr->name = pcr_attr->name;
+		attr->mode = S_IRUGO;
+
+		pcr_bank->attrs[i] = attr;
+	}
+
+	pcr_bank->attrs[i] = NULL;
+
+	rc = kobject_init_and_add(&pcr_bank->kobj, &pcr_bank->ktype,
+				  parent_kobj, "sha1");
+	if (rc) {
+		kfree(pcr_bank);
+		return NULL;
+	}
+
+	return pcr_bank;
+}
+
+int tpm2_sysfs_add_device(struct tpm_chip *chip)
+{
+	struct pcr_bank *pcr_bank;
+	struct kobject *pcrs_kobj;
+	struct device *dev = chip->dev;
+	int rc;
+
+	rc = sysfs_create_group(&chip->vendor.miscdev.this_device->kobj,
+				&tpm_dev_group);
+	if (rc) {
+		dev_err(dev, "failed to create sysfs attributes, %d\n", rc);
+		return rc;
+	}
+
+	pcrs_kobj = kobject_create_and_add("pcrs",
+					   &chip->vendor.miscdev.this_device->kobj);
+	if (!pcrs_kobj) {
+		sysfs_remove_group(&dev->kobj, &tpm_dev_group);
+		dev_err(dev, "failed to create sysfs attributes, %d\n", rc);
+		return -ENOMEM;
+	}
+
+	pcr_bank = pcr_bank_create(chip->vendor.miscdev.this_device,
+				   pcrs_kobj);
+	if (!pcr_bank) {
+		kobject_put(pcrs_kobj);
+		sysfs_remove_group(&dev->kobj, &tpm_dev_group);
+		dev_err(dev, "failed to create sysfs attributes, %d\n", rc);
+		return -ENOMEM;
+	}
+
+	kobject_uevent(pcrs_kobj, KOBJ_ADD);
+
+	chip = dev_get_drvdata(dev);
+	chip->pcrs_kobj = pcrs_kobj;
+	chip->sha1_bank = &pcr_bank->kobj;
+
+	return 0;
+}
+
+void tpm2_sysfs_del_device(struct tpm_chip *chip)
+{
+	kobject_put(chip->sha1_bank);
+	kobject_put(chip->pcrs_kobj);
+	sysfs_remove_group(&chip->vendor.miscdev.this_device->kobj,
+			   &tpm_dev_group);
+}
-- 
2.1.0

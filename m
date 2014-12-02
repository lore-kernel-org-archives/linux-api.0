From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v8 3/8] tpm: fix raciness of PPI interface lookup
Date: Wed,  3 Dec 2014 00:31:15 +0200
Message-ID: <1417559480-13757-4-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, josh.triplett@intel.com, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
List-Id: linux-api@vger.kernel.org

Traversal of the ACPI device tree was not done right. PPI interface
should be looked up only from the ACPI device that is the platform
device for the TPM. This could cause problems with systems with
two TPM chips such as 4th gen Intel systems.

In addition, added the missing license and copyright platter to
the tpm_ppi.c.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/tpm-chip.c |   2 +-
 drivers/char/tpm/tpm.h      |  16 ++++--
 drivers/char/tpm/tpm_ppi.c  | 137 +++++++++++++++++++++++++++-----------------
 drivers/char/tpm/tpm_tis.c  |  15 +++--
 4 files changed, 107 insertions(+), 63 deletions(-)

diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
index 6a21ef7..870f8f0 100644
--- a/drivers/char/tpm/tpm-chip.c
+++ b/drivers/char/tpm/tpm-chip.c
@@ -147,7 +147,7 @@ int tpm_chip_register(struct tpm_chip *chip)
 	if (rc)
 		goto del_misc;
 
-	rc = tpm_add_ppi(&chip->dev->kobj);
+	rc = tpm_add_ppi(chip);
 	if (rc)
 		goto del_sysfs;
 
diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
index 9880681..69f4003 100644
--- a/drivers/char/tpm/tpm.h
+++ b/drivers/char/tpm/tpm.h
@@ -27,6 +27,7 @@
 #include <linux/platform_device.h>
 #include <linux/io.h>
 #include <linux/tpm.h>
+#include <linux/acpi.h>
 
 enum tpm_const {
 	TPM_MINOR = 224,	/* officially assigned */
@@ -94,6 +95,8 @@ struct tpm_vendor_specific {
 #define TPM_VID_WINBOND  0x1050
 #define TPM_VID_STM      0x104A
 
+#define TPM_PPI_VERSION_LEN		3
+
 struct tpm_chip {
 	struct device *dev;	/* Device stuff */
 	const struct tpm_class_ops *ops;
@@ -109,6 +112,11 @@ struct tpm_chip {
 
 	struct dentry **bios_dir;
 
+#ifdef CONFIG_ACPI
+	acpi_handle acpi_dev_handle;
+	char ppi_version[TPM_PPI_VERSION_LEN + 1];
+#endif /* CONFIG_ACPI */
+
 	struct list_head list;
 };
 
@@ -340,15 +348,15 @@ void tpm_sysfs_del_device(struct tpm_chip *chip);
 int tpm_pcr_read_dev(struct tpm_chip *chip, int pcr_idx, u8 *res_buf);
 
 #ifdef CONFIG_ACPI
-extern int tpm_add_ppi(struct kobject *);
-extern void tpm_remove_ppi(struct kobject *);
+extern int tpm_add_ppi(struct tpm_chip *chip);
+extern void tpm_remove_ppi(struct tpm_chip *chip);
 #else
-static inline int tpm_add_ppi(struct kobject *parent)
+static inline int tpm_add_ppi(struct tpm_chip *chip)
 {
 	return 0;
 }
 
-static inline void tpm_remove_ppi(struct kobject *parent)
+static inline void tpm_remove_ppi(struct tpm_chip *chip)
 {
 }
 #endif
diff --git a/drivers/char/tpm/tpm_ppi.c b/drivers/char/tpm/tpm_ppi.c
index 61dcc80..6652025 100644
--- a/drivers/char/tpm/tpm_ppi.c
+++ b/drivers/char/tpm/tpm_ppi.c
@@ -1,3 +1,22 @@
+/*
+ * Copyright (C) 2012-2014 Intel Corporation
+ *
+ * Authors:
+ * Xiaoyan Zhang <xiaoyan.zhang@intel.com>
+ * Jiang Liu <jiang.liu@linux.intel.com>
+ * Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * This file contains implementation of the sysfs interface for PPI.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+
 #include <linux/acpi.h>
 #include "tpm.h"
 
@@ -12,7 +31,6 @@
 #define PPI_TPM_REQ_MAX		22
 #define PPI_VS_REQ_START	128
 #define PPI_VS_REQ_END		255
-#define PPI_VERSION_LEN		3
 
 static const u8 tpm_ppi_uuid[] = {
 	0xA6, 0xFA, 0xDD, 0x3D,
@@ -22,45 +40,22 @@ static const u8 tpm_ppi_uuid[] = {
 	0x8D, 0x10, 0x08, 0x9D, 0x16, 0x53
 };
 
-static char tpm_ppi_version[PPI_VERSION_LEN + 1];
-static acpi_handle tpm_ppi_handle;
-
-static acpi_status ppi_callback(acpi_handle handle, u32 level, void *context,
-				void **return_value)
-{
-	union acpi_object *obj;
-
-	if (!acpi_check_dsm(handle, tpm_ppi_uuid, TPM_PPI_REVISION_ID,
-			    1 << TPM_PPI_FN_VERSION))
-		return AE_OK;
-
-	/* Cache version string */
-	obj = acpi_evaluate_dsm_typed(handle, tpm_ppi_uuid,
-				      TPM_PPI_REVISION_ID, TPM_PPI_FN_VERSION,
-				      NULL, ACPI_TYPE_STRING);
-	if (obj) {
-		strlcpy(tpm_ppi_version, obj->string.pointer,
-			PPI_VERSION_LEN + 1);
-		ACPI_FREE(obj);
-	}
-
-	*return_value = handle;
-
-	return AE_CTRL_TERMINATE;
-}
-
 static inline union acpi_object *
-tpm_eval_dsm(int func, acpi_object_type type, union acpi_object *argv4)
+tpm_eval_dsm(acpi_handle ppi_handle, int func, acpi_object_type type,
+	     union acpi_object *argv4)
 {
-	BUG_ON(!tpm_ppi_handle);
-	return acpi_evaluate_dsm_typed(tpm_ppi_handle, tpm_ppi_uuid,
-				       TPM_PPI_REVISION_ID, func, argv4, type);
+	BUG_ON(!ppi_handle);
+	return acpi_evaluate_dsm_typed(ppi_handle, tpm_ppi_uuid,
+				       TPM_PPI_REVISION_ID,
+				       func, argv4, type);
 }
 
 static ssize_t tpm_show_ppi_version(struct device *dev,
 				    struct device_attribute *attr, char *buf)
 {
-	return scnprintf(buf, PAGE_SIZE, "%s\n", tpm_ppi_version);
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n", chip->ppi_version);
 }
 
 static ssize_t tpm_show_ppi_request(struct device *dev,
@@ -68,8 +63,10 @@ static ssize_t tpm_show_ppi_request(struct device *dev,
 {
 	ssize_t size = -EINVAL;
 	union acpi_object *obj;
+	struct tpm_chip *chip = dev_get_drvdata(dev);
 
-	obj = tpm_eval_dsm(TPM_PPI_FN_GETREQ, ACPI_TYPE_PACKAGE, NULL);
+	obj = tpm_eval_dsm(chip->acpi_dev_handle, TPM_PPI_FN_GETREQ,
+			   ACPI_TYPE_PACKAGE, NULL);
 	if (!obj)
 		return -ENXIO;
 
@@ -103,14 +100,15 @@ static ssize_t tpm_store_ppi_request(struct device *dev,
 	int func = TPM_PPI_FN_SUBREQ;
 	union acpi_object *obj, tmp;
 	union acpi_object argv4 = ACPI_INIT_DSM_ARGV4(1, &tmp);
+	struct tpm_chip *chip = dev_get_drvdata(dev);
 
 	/*
 	 * the function to submit TPM operation request to pre-os environment
 	 * is updated with function index from SUBREQ to SUBREQ2 since PPI
 	 * version 1.1
 	 */
-	if (acpi_check_dsm(tpm_ppi_handle, tpm_ppi_uuid, TPM_PPI_REVISION_ID,
-			   1 << TPM_PPI_FN_SUBREQ2))
+	if (acpi_check_dsm(chip->acpi_dev_handle, tpm_ppi_uuid,
+			   TPM_PPI_REVISION_ID, 1 << TPM_PPI_FN_SUBREQ2))
 		func = TPM_PPI_FN_SUBREQ2;
 
 	/*
@@ -119,7 +117,7 @@ static ssize_t tpm_store_ppi_request(struct device *dev,
 	 * string/package type. For PPI version 1.0 and 1.1, use buffer type
 	 * for compatibility, and use package type since 1.2 according to spec.
 	 */
-	if (strcmp(tpm_ppi_version, "1.2") < 0) {
+	if (strcmp(chip->ppi_version, "1.2") < 0) {
 		if (sscanf(buf, "%d", &req) != 1)
 			return -EINVAL;
 		argv4.type = ACPI_TYPE_BUFFER;
@@ -131,7 +129,8 @@ static ssize_t tpm_store_ppi_request(struct device *dev,
 			return -EINVAL;
 	}
 
-	obj = tpm_eval_dsm(func, ACPI_TYPE_INTEGER, &argv4);
+	obj = tpm_eval_dsm(chip->acpi_dev_handle, func, ACPI_TYPE_INTEGER,
+			   &argv4);
 	if (!obj) {
 		return -ENXIO;
 	} else {
@@ -157,6 +156,7 @@ static ssize_t tpm_show_ppi_transition_action(struct device *dev,
 		.buffer.length = 0,
 		.buffer.pointer = NULL
 	};
+	struct tpm_chip *chip = dev_get_drvdata(dev);
 
 	static char *info[] = {
 		"None",
@@ -171,9 +171,10 @@ static ssize_t tpm_show_ppi_transition_action(struct device *dev,
 	 * (e.g. Capella with PPI 1.0) need integer/string/buffer type, so for
 	 * compatibility, define params[3].type as buffer, if PPI version < 1.2
 	 */
-	if (strcmp(tpm_ppi_version, "1.2") < 0)
+	if (strcmp(chip->ppi_version, "1.2") < 0)
 		obj = &tmp;
-	obj = tpm_eval_dsm(TPM_PPI_FN_GETACT, ACPI_TYPE_INTEGER, obj);
+	obj = tpm_eval_dsm(chip->acpi_dev_handle, TPM_PPI_FN_GETACT,
+			   ACPI_TYPE_INTEGER, obj);
 	if (!obj) {
 		return -ENXIO;
 	} else {
@@ -196,8 +197,10 @@ static ssize_t tpm_show_ppi_response(struct device *dev,
 	acpi_status status = -EINVAL;
 	union acpi_object *obj, *ret_obj;
 	u64 req, res;
+	struct tpm_chip *chip = dev_get_drvdata(dev);
 
-	obj = tpm_eval_dsm(TPM_PPI_FN_GETRSP, ACPI_TYPE_PACKAGE, NULL);
+	obj = tpm_eval_dsm(chip->acpi_dev_handle, TPM_PPI_FN_GETRSP,
+			   ACPI_TYPE_PACKAGE, NULL);
 	if (!obj)
 		return -ENXIO;
 
@@ -248,7 +251,8 @@ cleanup:
 	return status;
 }
 
-static ssize_t show_ppi_operations(char *buf, u32 start, u32 end)
+static ssize_t show_ppi_operations(acpi_handle dev_handle, char *buf, u32 start,
+				   u32 end)
 {
 	int i;
 	u32 ret;
@@ -264,14 +268,15 @@ static ssize_t show_ppi_operations(char *buf, u32 start, u32 end)
 		"User not required",
 	};
 
-	if (!acpi_check_dsm(tpm_ppi_handle, tpm_ppi_uuid, TPM_PPI_REVISION_ID,
+	if (!acpi_check_dsm(dev_handle, tpm_ppi_uuid, TPM_PPI_REVISION_ID,
 			    1 << TPM_PPI_FN_GETOPR))
 		return -EPERM;
 
 	tmp.integer.type = ACPI_TYPE_INTEGER;
 	for (i = start; i <= end; i++) {
 		tmp.integer.value = i;
-		obj = tpm_eval_dsm(TPM_PPI_FN_GETOPR, ACPI_TYPE_INTEGER, &argv);
+		obj = tpm_eval_dsm(dev_handle, TPM_PPI_FN_GETOPR,
+				   ACPI_TYPE_INTEGER, &argv);
 		if (!obj) {
 			return -ENOMEM;
 		} else {
@@ -291,14 +296,20 @@ static ssize_t tpm_show_ppi_tcg_operations(struct device *dev,
 					   struct device_attribute *attr,
 					   char *buf)
 {
-	return show_ppi_operations(buf, 0, PPI_TPM_REQ_MAX);
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	return show_ppi_operations(chip->acpi_dev_handle, buf, 0,
+				   PPI_TPM_REQ_MAX);
 }
 
 static ssize_t tpm_show_ppi_vs_operations(struct device *dev,
 					  struct device_attribute *attr,
 					  char *buf)
 {
-	return show_ppi_operations(buf, PPI_VS_REQ_START, PPI_VS_REQ_END);
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	return show_ppi_operations(chip->acpi_dev_handle, buf, PPI_VS_REQ_START,
+				   PPI_VS_REQ_END);
 }
 
 static DEVICE_ATTR(version, S_IRUGO, tpm_show_ppi_version, NULL);
@@ -323,16 +334,34 @@ static struct attribute_group ppi_attr_grp = {
 	.attrs = ppi_attrs
 };
 
-int tpm_add_ppi(struct kobject *parent)
+int tpm_add_ppi(struct tpm_chip *chip)
 {
-	/* Cache TPM ACPI handle and version string */
-	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT, ACPI_UINT32_MAX,
-			    ppi_callback, NULL, NULL, &tpm_ppi_handle);
-	return tpm_ppi_handle ? sysfs_create_group(parent, &ppi_attr_grp) : 0;
+	union acpi_object *obj;
+
+	if (!chip->acpi_dev_handle)
+		return 0;
+
+	if (!acpi_check_dsm(chip->acpi_dev_handle, tpm_ppi_uuid,
+			    TPM_PPI_REVISION_ID, 1 << TPM_PPI_FN_VERSION))
+		return 0;
+
+	/* Cache PPI version string. */
+	obj = acpi_evaluate_dsm_typed(chip->acpi_dev_handle, tpm_ppi_uuid,
+				      TPM_PPI_REVISION_ID, TPM_PPI_FN_VERSION,
+				      NULL, ACPI_TYPE_STRING);
+	if (!obj)
+		return -ENOMEM;
+
+	strlcpy(chip->ppi_version, obj->string.pointer,
+		sizeof(chip->ppi_version));
+
+	ACPI_FREE(obj);
+
+	return sysfs_create_group(&chip->dev->kobj, &ppi_attr_grp);
 }
 
-void tpm_remove_ppi(struct kobject *parent)
+void tpm_remove_ppi(struct tpm_chip *chip)
 {
-	if (tpm_ppi_handle)
-		sysfs_remove_group(parent, &ppi_attr_grp);
+	if (chip->ppi_version[0] != '\0')
+		sysfs_remove_group(&chip->dev->kobj, &ppi_attr_grp);
 }
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 0066b68..00ed222 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -536,8 +536,9 @@ static void tpm_tis_remove(struct tpm_chip *chip)
 	release_locality(chip, chip->vendor.locality, 1);
 }
 
-static int tpm_tis_init(struct device *dev, resource_size_t start,
-			resource_size_t len, unsigned int irq)
+static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
+			resource_size_t start, resource_size_t len,
+			unsigned int irq)
 {
 	u32 vendor, intfcaps, intmask;
 	int rc, i, irq_s, irq_e, probe;
@@ -547,6 +548,8 @@ static int tpm_tis_init(struct device *dev, resource_size_t start,
 	if (IS_ERR(chip))
 		return PTR_ERR(chip);
 
+	chip->acpi_dev_handle = acpi_dev_handle;
+
 	chip->vendor.iobase = devm_ioremap(dev, start, len);
 	if (!chip->vendor.iobase)
 		return -EIO;
@@ -777,6 +780,7 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 {
 	resource_size_t start, len;
 	unsigned int irq = 0;
+	acpi_handle acpi_dev_handle = NULL;
 
 	start = pnp_mem_start(pnp_dev, 0);
 	len = pnp_mem_len(pnp_dev, 0);
@@ -789,7 +793,10 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
 	if (is_itpm(pnp_dev))
 		itpm = true;
 
-	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
+	if (pnp_acpi_device(pnp_dev))
+		acpi_dev_handle = pnp_acpi_device(pnp_dev)->handle;
+
+	return tpm_tis_init(&pnp_dev->dev, acpi_dev_handle, start, len, irq);
 }
 
 static struct pnp_device_id tpm_pnp_tbl[] = {
@@ -858,7 +865,7 @@ static int __init init_tis(void)
 		rc = PTR_ERR(pdev);
 		goto err_dev;
 	}
-	rc = tpm_tis_init(&pdev->dev, TIS_MEM_BASE, TIS_MEM_LEN, 0);
+	rc = tpm_tis_init(&pdev->dev, NULL, TIS_MEM_BASE, TIS_MEM_LEN, 0);
 	if (rc)
 		goto err_init;
 	return 0;
-- 
2.1.0

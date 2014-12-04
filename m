From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [PATCH v9 7/8] tpm: TPM 2.0 CRB Interface
Date: Thu,  4 Dec 2014 07:55:17 +0200
Message-ID: <1417672518-4530-8-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Huewe <peterhuewe@gmx.de>, Ashley Lai <ashley@ashleylai.com>, Marcel Selhorst <tpmdd@selhorst.net>
Cc: tpmdd-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, josh.triplett@intel.com, christophe.ricard@gmail.com, jason.gunthorpe@obsidianresearch.com, linux-api@vger.kernel.org, trousers-tech@lists.sourceforge.net, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
List-Id: linux-api@vger.kernel.org

tpm_crb is a driver for TPM 2.0 Command Response Buffer (CRB) Interface
as defined in PC Client Platform TPM Profile (PTP) Specification.

Only polling and single locality is supported as these are the limitations
of the available hardware, Platform Trust Techonlogy (PTT) in Haswell
CPUs.

The driver always applies CRB with ACPI start because PTT reports using
only ACPI start as start method but as a result of my testing it requires
also CRB start.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
---
 drivers/char/tpm/Kconfig   |   9 ++
 drivers/char/tpm/Makefile  |   1 +
 drivers/char/tpm/tpm_crb.c | 356 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 366 insertions(+)
 create mode 100644 drivers/char/tpm/tpm_crb.c

diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
index 3d0873b..9d4e375 100644
--- a/drivers/char/tpm/Kconfig
+++ b/drivers/char/tpm/Kconfig
@@ -122,4 +122,13 @@ config TCG_XEN
 	  To compile this driver as a module, choose M here; the module
 	  will be called xen-tpmfront.
 
+config TCG_CRB
+	tristate "TPM 2.0 CRB Interface"
+	depends on X86 && ACPI
+	---help---
+	  If you have a TPM security chip that is compliant with the
+	  TCG CRB 2.0 TPM specification say Yes and it will be accessible
+	  from within Linux.  To compile this driver as a module, choose
+	  M here; the module will be called tpm_crb.
+
 endif # TCG_TPM
diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
index 88848ed..990cf18 100644
--- a/drivers/char/tpm/Makefile
+++ b/drivers/char/tpm/Makefile
@@ -22,3 +22,4 @@ obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
 obj-$(CONFIG_TCG_IBMVTPM) += tpm_ibmvtpm.o
 obj-$(CONFIG_TCG_TIS_I2C_ST33) += tpm_i2c_stm_st33.o
 obj-$(CONFIG_TCG_XEN) += xen-tpmfront.o
+obj-$(CONFIG_TCG_CRB) += tpm_crb.o
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
new file mode 100644
index 0000000..eb78f93
--- /dev/null
+++ b/drivers/char/tpm/tpm_crb.c
@@ -0,0 +1,356 @@
+/*
+ * Copyright (C) 2014 Intel Corporation
+ *
+ * Authors:
+ * Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
+ *
+ * Maintained by: <tpmdd-devel@lists.sourceforge.net>
+ *
+ * This device driver implements the TPM interface as defined in
+ * the TCG CRB 2.0 TPM specification.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+
+#include <linux/acpi.h>
+#include <linux/highmem.h>
+#include <linux/rculist.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include "tpm.h"
+
+#define ACPI_SIG_TPM2 "TPM2"
+
+static const u8 CRB_ACPI_START_UUID[] = {
+	/* 0000 */ 0xAB, 0x6C, 0xBF, 0x6B, 0x63, 0x54, 0x14, 0x47,
+	/* 0008 */ 0xB7, 0xCD, 0xF0, 0x20, 0x3C, 0x03, 0x68, 0xD4
+};
+
+enum crb_defaults {
+	CRB_ACPI_START_REVISION_ID = 1,
+	CRB_ACPI_START_INDEX = 1,
+};
+
+enum crb_start_method {
+	CRB_SM_ACPI_START = 2,
+	CRB_SM_CRB = 7,
+	CRB_SM_CRB_WITH_ACPI_START = 8,
+};
+
+struct acpi_tpm2 {
+	struct acpi_table_header hdr;
+	u16 platform_class;
+	u16 reserved;
+	u64 control_area_pa;
+	u32 start_method;
+} __packed;
+
+enum crb_ca_request {
+	CRB_CA_REQ_GO_IDLE	= BIT(0),
+	CRB_CA_REQ_CMD_READY	= BIT(1),
+};
+
+enum crb_ca_status {
+	CRB_CA_STS_ERROR	= BIT(0),
+	CRB_CA_STS_TPM_IDLE	= BIT(1),
+};
+
+enum crb_start {
+	CRB_START_INVOKE	= BIT(0),
+};
+
+enum crb_cancel {
+	CRB_CANCEL_INVOKE	= BIT(0),
+};
+
+struct crb_control_area {
+	u32 req;
+	u32 sts;
+	u32 cancel;
+	u32 start;
+	u32 int_enable;
+	u32 int_sts;
+	u32 cmd_size;
+	u64 cmd_pa;
+	u32 rsp_size;
+	u64 rsp_pa;
+} __packed;
+
+enum crb_status {
+	CRB_STS_COMPLETE	= BIT(0),
+};
+
+enum crb_flags {
+	CRB_FL_ACPI_START	= BIT(0),
+	CRB_FL_CRB_START	= BIT(1),
+};
+
+struct crb_priv {
+	unsigned int flags;
+	struct crb_control_area *cca;
+	u8 *cmd;
+	u8 *rsp;
+};
+
+#ifdef CONFIG_PM_SLEEP
+int crb_suspend(struct device *dev)
+{
+	return 0;
+}
+
+static int crb_resume(struct device *dev)
+{
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	(void) tpm2_do_selftest(chip);
+
+	return 0;
+}
+#endif
+
+static SIMPLE_DEV_PM_OPS(crb_pm, crb_suspend, crb_resume);
+
+static u8 crb_status(struct tpm_chip *chip)
+{
+	struct crb_priv *priv = chip->vendor.priv;
+	u8 sts = 0;
+
+	if ((le32_to_cpu(ioread32(&priv->cca->start)) & CRB_START_INVOKE) !=
+	    CRB_START_INVOKE)
+		sts |= CRB_STS_COMPLETE;
+
+	return sts;
+}
+
+static int crb_recv(struct tpm_chip *chip, u8 *buf, size_t count)
+{
+	struct crb_priv *priv = chip->vendor.priv;
+	unsigned int expected;
+
+	/* sanity check */
+	if (count < 6)
+		return -EIO;
+
+	if (le32_to_cpu(ioread32(&priv->cca->sts)) & CRB_CA_STS_ERROR)
+		return -EIO;
+
+	memcpy(buf, priv->rsp, 6);
+	expected = be32_to_cpup((__be32 *) &buf[2]);
+
+	if (expected > count)
+		return -EIO;
+
+	memcpy(&buf[6], &priv->rsp[6], expected - 6);
+
+	return expected;
+}
+
+static int crb_do_acpi_start(struct tpm_chip *chip)
+{
+	union acpi_object *obj;
+	int rc;
+
+	obj = acpi_evaluate_dsm(chip->acpi_dev_handle,
+				CRB_ACPI_START_UUID,
+				CRB_ACPI_START_REVISION_ID,
+				CRB_ACPI_START_INDEX,
+				NULL);
+	if (!obj)
+		return -ENXIO;
+	rc = obj->integer.value == 0 ? 0 : -ENXIO;
+	ACPI_FREE(obj);
+	return rc;
+}
+
+static int crb_send(struct tpm_chip *chip, u8 *buf, size_t len)
+{
+	struct crb_priv *priv = chip->vendor.priv;
+	int rc = 0;
+
+	if (len > le32_to_cpu(ioread32(&priv->cca->cmd_size))) {
+		dev_err(&chip->dev,
+			"invalid command count value %x %zx\n",
+			(unsigned int) len,
+			(size_t) le32_to_cpu(ioread32(&priv->cca->cmd_size)));
+		return -E2BIG;
+	}
+
+	memcpy(priv->cmd, buf, len);
+
+	/* Make sure that cmd is populated before issuing start. */
+	wmb();
+
+	if (priv->flags & CRB_FL_CRB_START)
+		iowrite32(cpu_to_le32(CRB_START_INVOKE), &priv->cca->start);
+
+	if (priv->flags & CRB_FL_ACPI_START)
+		rc = crb_do_acpi_start(chip);
+
+	return rc;
+}
+
+static void crb_cancel(struct tpm_chip *chip)
+{
+	struct crb_priv *priv = chip->vendor.priv;
+
+	iowrite32(cpu_to_le32(CRB_CANCEL_INVOKE), &priv->cca->cancel);
+
+	/* Make sure that cmd is populated before issuing cancel. */
+	wmb();
+
+	if ((priv->flags & CRB_FL_ACPI_START) && crb_do_acpi_start(chip))
+		dev_err(&chip->dev, "ACPI Start failed\n");
+
+	iowrite32(0, &priv->cca->cancel);
+}
+
+static bool crb_req_canceled(struct tpm_chip *chip, u8 status)
+{
+	struct crb_priv *priv = chip->vendor.priv;
+
+	return (le32_to_cpu(priv->cca->cancel) & CRB_CANCEL_INVOKE) ==
+		CRB_CANCEL_INVOKE;
+}
+
+static const struct tpm_class_ops tpm_crb = {
+	.status = crb_status,
+	.recv = crb_recv,
+	.send = crb_send,
+	.cancel = crb_cancel,
+	.req_canceled = crb_req_canceled,
+	.req_complete_mask = CRB_STS_COMPLETE,
+	.req_complete_val = CRB_STS_COMPLETE,
+};
+
+static int crb_acpi_add(struct acpi_device *device)
+{
+	struct tpm_chip *chip;
+	struct acpi_tpm2 *buf;
+	struct crb_priv *priv;
+	struct device *dev = &device->dev;
+	acpi_status status;
+	u32 sm;
+	u64 pa;
+	int rc;
+
+	chip = tpmm_chip_alloc(dev, &tpm_crb);
+	if (IS_ERR(chip))
+		return PTR_ERR(chip);
+
+	chip->flags = TPM_CHIP_FLAG_TPM2;
+
+	status = acpi_get_table(ACPI_SIG_TPM2, 1,
+				(struct acpi_table_header **) &buf);
+	if (ACPI_FAILURE(status)) {
+		dev_err(dev, "failed to get TPM2 ACPI table\n");
+		return -ENODEV;
+	}
+
+	if (buf->hdr.length < sizeof(struct acpi_tpm2)) {
+		dev_err(dev, "TPM2 ACPI table has wrong size");
+		return -EINVAL;
+	}
+
+	priv = (struct crb_priv *) devm_kzalloc(dev, sizeof(struct crb_priv),
+						GFP_KERNEL);
+	if (!priv) {
+		dev_err(dev, "failed to devm_kzalloc for private data\n");
+		return -ENOMEM;
+	}
+
+	sm = le32_to_cpu(buf->start_method);
+
+	/* The reason for the extra quirk is that the PTT in 4th Gen Core CPUs
+	 * report only ACPI start but in practice seems to require both
+	 * ACPI start and CRB start.
+	 */
+	if (sm == CRB_SM_CRB || sm == CRB_SM_CRB_WITH_ACPI_START ||
+	    !strcmp(acpi_device_hid(device), "MSFT0101"))
+		priv->flags |= CRB_FL_CRB_START;
+
+	if (sm == CRB_SM_ACPI_START || sm == CRB_SM_CRB_WITH_ACPI_START)
+		priv->flags |= CRB_FL_ACPI_START;
+
+	priv->cca = (struct crb_control_area *)
+		devm_ioremap_nocache(dev, buf->control_area_pa, 0x1000);
+	if (!priv->cca) {
+		dev_err(dev, "ioremap of the control area failed\n");
+		return -ENOMEM;
+	}
+
+	memcpy_fromio(&pa, &priv->cca->cmd_pa, 8);
+	pa = le64_to_cpu(pa);
+	priv->cmd = devm_ioremap_nocache(dev, le64_to_cpu(pa),
+					 ioread32(&priv->cca->cmd_size));
+	if (!priv->cmd) {
+		dev_err(dev, "ioremap of the command buffer failed\n");
+		return -ENOMEM;
+	}
+
+	memcpy_fromio(&pa, &priv->cca->rsp_pa, 8);
+	pa = le64_to_cpu(pa);
+	priv->rsp = devm_ioremap_nocache(dev, le64_to_cpu(pa),
+					 ioread32(&priv->cca->rsp_size));
+	if (!priv->rsp) {
+		dev_err(dev, "ioremap of the response buffer failed\n");
+		return -ENOMEM;
+	}
+
+	chip->vendor.priv = priv;
+
+	/* Default timeouts and durations */
+	chip->vendor.timeout_a = usecs_to_jiffies(TPM2_TIMEOUT_A);
+	chip->vendor.timeout_b = usecs_to_jiffies(TPM2_TIMEOUT_B);
+	chip->vendor.timeout_c = usecs_to_jiffies(TPM2_TIMEOUT_C);
+	chip->vendor.timeout_d = usecs_to_jiffies(TPM2_TIMEOUT_D);
+	chip->vendor.duration[TPM_SHORT] =
+		usecs_to_jiffies(TPM2_DURATION_SHORT);
+	chip->vendor.duration[TPM_MEDIUM] =
+		usecs_to_jiffies(TPM2_DURATION_MEDIUM);
+	chip->vendor.duration[TPM_LONG] =
+		usecs_to_jiffies(TPM2_DURATION_LONG);
+
+	chip->acpi_dev_handle = device->handle;
+
+	rc = tpm2_do_selftest(chip);
+	if (rc)
+		return rc;
+
+	return tpm_chip_register(chip);
+}
+
+int crb_acpi_remove(struct acpi_device *device)
+{
+	struct device *dev = &device->dev;
+	struct tpm_chip *chip = dev_get_drvdata(dev);
+
+	tpm_chip_unregister(chip);
+	return 0;
+}
+
+static struct acpi_device_id crb_device_ids[] = {
+	{"MSFT0101", 0},
+	{"", 0},
+};
+MODULE_DEVICE_TABLE(acpi, crb_device_ids);
+
+static struct acpi_driver crb_acpi_driver = {
+	.name = "tpm_crb",
+	.ids = crb_device_ids,
+	.ops = {
+		.add = crb_acpi_add,
+		.remove = crb_acpi_remove,
+	},
+	.drv = {
+		.pm = &crb_pm,
+	},
+};
+
+module_acpi_driver(crb_acpi_driver);
+MODULE_AUTHOR("Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>");
+MODULE_DESCRIPTION("TPM2 Driver");
+MODULE_VERSION("0.1");
+MODULE_LICENSE("GPL");
-- 
2.1.0

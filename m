From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v10 8/8] tpm: TPM 2.0 FIFO Interface
Date: Fri, 12 Dec 2014 11:46:40 -0800
Message-ID: <1418413600-5400-9-git-send-email-jarkko.sakkinen@linux.intel.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1418413600-5400-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Detect TPM 2.0 by sending idempotent TPM 2.x command. Ordinals for
TPM 2.0 are higher than TPM 1.x commands so this should be fail-safe.
Using STS3 is unreliable because some chips just report 0xff and not
what the spec says.

Before TPM family is detected, timeouts are set to the maximum values
for both TPM 1.x and TPM 2.x. In addition to this, suspend/resume
functionality is implemented for TPM 2.x.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Signed-off-by: Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Jasob Gunthorpe <jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Reviewed-by: Stephan Berger <stephan.berger-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 drivers/char/tpm/tpm_tis.c | 112 +++++++++++++++++++++++++++++++++++----------
 1 file changed, 89 insertions(+), 23 deletions(-)

diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 89e1abb..c8884be 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (C) 2005, 2006 IBM Corporation
+ * Copyright (C) 2014 Intel Corporation
  *
  * Authors:
  * Leendert van Doorn <leendert-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
@@ -64,12 +65,22 @@ enum tis_defaults {
 	TIS_LONG_TIMEOUT = 2000,	/* 2 sec */
 };
 
+
+/* Some timeout values are needed before it is known whether the chip is
+ * TPM 1.0 or TPM 2.0.
+ */
+#define TIS_TIMEOUT_A_MAX	max(TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_A)
+#define TIS_TIMEOUT_B_MAX	max(TIS_LONG_TIMEOUT, TPM2_TIMEOUT_B)
+#define TIS_TIMEOUT_C_MAX	max(TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_C)
+#define TIS_TIMEOUT_D_MAX	max(TIS_SHORT_TIMEOUT, TPM2_TIMEOUT_D)
+
 #define	TPM_ACCESS(l)			(0x0000 | ((l) << 12))
 #define	TPM_INT_ENABLE(l)		(0x0008 | ((l) << 12))
 #define	TPM_INT_VECTOR(l)		(0x000C | ((l) << 12))
 #define	TPM_INT_STATUS(l)		(0x0010 | ((l) << 12))
 #define	TPM_INTF_CAPS(l)		(0x0014 | ((l) << 12))
 #define	TPM_STS(l)			(0x0018 | ((l) << 12))
+#define	TPM_STS3(l)			(0x001b | ((l) << 12))
 #define	TPM_DATA_FIFO(l)		(0x0024 | ((l) << 12))
 
 #define	TPM_DID_VID(l)			(0x0F00 | ((l) << 12))
@@ -363,6 +374,7 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 {
 	int rc;
 	u32 ordinal;
+	unsigned long dur;
 
 	rc = tpm_tis_send_data(chip, buf, len);
 	if (rc < 0)
@@ -374,9 +386,14 @@ static int tpm_tis_send_main(struct tpm_chip *chip, u8 *buf, size_t len)
 
 	if (chip->vendor.irq) {
 		ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
+
+		if (chip->flags & TPM_CHIP_FLAG_TPM2)
+			dur = tpm2_calc_ordinal_duration(chip, ordinal);
+		else
+			dur = tpm_calc_ordinal_duration(chip, ordinal);
+
 		if (wait_for_tpm_stat
-		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID,
-		     tpm_calc_ordinal_duration(chip, ordinal),
+		    (chip, TPM_STS_DATA_AVAIL | TPM_STS_VALID, dur,
 		     &chip->vendor.read_queue, false) < 0) {
 			rc = -ETIME;
 			goto out_err;
@@ -598,17 +615,19 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
 		return PTR_ERR(chip);
 
 	chip->vendor.priv = priv;
+#ifdef CONFIG_ACPI
 	chip->acpi_dev_handle = acpi_dev_handle;
+#endif
 
 	chip->vendor.iobase = devm_ioremap(dev, start, len);
 	if (!chip->vendor.iobase)
 		return -EIO;
 
-	/* Default timeouts */
-	chip->vendor.timeout_a = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-	chip->vendor.timeout_b = msecs_to_jiffies(TIS_LONG_TIMEOUT);
-	chip->vendor.timeout_c = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
-	chip->vendor.timeout_d = msecs_to_jiffies(TIS_SHORT_TIMEOUT);
+	/* Maximum timeouts */
+	chip->vendor.timeout_a = TIS_TIMEOUT_A_MAX;
+	chip->vendor.timeout_b = TIS_TIMEOUT_B_MAX;
+	chip->vendor.timeout_c = TIS_TIMEOUT_C_MAX;
+	chip->vendor.timeout_d = TIS_TIMEOUT_D_MAX;
 
 	if (wait_startup(chip, 0) != 0) {
 		rc = -ENODEV;
@@ -620,11 +639,18 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
 		goto out_err;
 	}
 
+	/* Every TPM 2.x command has a higher ordinal than TPM 1.x commands.
+	 * Therefore, we can use an idempotent TPM 2.x command to probe TPM 2.x.
+	 */
+	rc = tpm2_gen_interrupt(chip, true);
+	if (rc == 0 || rc == TPM2_RC_INITIALIZE)
+		chip->flags |= TPM_CHIP_FLAG_TPM2;
+
 	vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
 	chip->vendor.manufacturer_id = vendor;
 
-	dev_info(dev,
-		 "1.2 TPM (device-id 0x%X, rev-id %d)\n",
+	dev_info(dev, "%s TPM (device-id 0x%X, rev-id %d)\n",
+		 (chip->flags & TPM_CHIP_FLAG_TPM2) ? "2.0" : "1.2",
 		 vendor >> 16, ioread8(chip->vendor.iobase + TPM_RID(0)));
 
 	if (!itpm) {
@@ -720,7 +746,10 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
 			chip->vendor.probed_irq = 0;
 
 			/* Generate Interrupts */
-			tpm_gen_interrupt(chip);
+			if (chip->flags & TPM_CHIP_FLAG_TPM2)
+				tpm2_gen_interrupt(chip, false);
+			else
+				tpm_gen_interrupt(chip);
 
 			chip->vendor.irq = chip->vendor.probed_irq;
 
@@ -765,16 +794,44 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
 		}
 	}
 
-	if (tpm_get_timeouts(chip)) {
-		dev_err(dev, "Could not get TPM timeouts and durations\n");
-		rc = -ENODEV;
-		goto out_err;
-	}
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		chip->vendor.timeout_a = msecs_to_jiffies(TPM2_TIMEOUT_A);
+		chip->vendor.timeout_b = msecs_to_jiffies(TPM2_TIMEOUT_B);
+		chip->vendor.timeout_c = msecs_to_jiffies(TPM2_TIMEOUT_C);
+		chip->vendor.timeout_d = msecs_to_jiffies(TPM2_TIMEOUT_D);
+		chip->vendor.duration[TPM_SHORT] =
+			msecs_to_jiffies(TPM2_DURATION_SHORT);
+		chip->vendor.duration[TPM_MEDIUM] =
+			msecs_to_jiffies(TPM2_DURATION_MEDIUM);
+		chip->vendor.duration[TPM_LONG] =
+			msecs_to_jiffies(TPM2_DURATION_LONG);
+
+		rc = tpm2_do_selftest(chip);
+		if (rc == TPM2_RC_INITIALIZE) {
+			dev_warn(dev, "Firmware has not started TPM\n");
+			rc  = tpm2_startup(chip, TPM2_SU_CLEAR);
+			if (!rc)
+				rc = tpm2_do_selftest(chip);
+		}
 
-	if (tpm_do_selftest(chip)) {
-		dev_err(dev, "TPM self test failed\n");
-		rc = -ENODEV;
-		goto out_err;
+		if (rc) {
+			dev_err(dev, "TPM self test failed\n");
+			if (rc > 0)
+				rc = -ENODEV;
+			goto out_err;
+		}
+	} else {
+		if (tpm_get_timeouts(chip)) {
+			dev_err(dev, "Could not get TPM timeouts and durations\n");
+			rc = -ENODEV;
+			goto out_err;
+		}
+
+		if (tpm_do_selftest(chip)) {
+			dev_err(dev, "TPM self test failed\n");
+			rc = -ENODEV;
+			goto out_err;
+		}
 	}
 
 	return tpm_chip_register(chip);
@@ -808,14 +865,23 @@ static void tpm_tis_reenable_interrupts(struct tpm_chip *chip)
 static int tpm_tis_resume(struct device *dev)
 {
 	struct tpm_chip *chip = dev_get_drvdata(dev);
-	int ret;
+	int ret = 0;
 
 	if (chip->vendor.irq)
 		tpm_tis_reenable_interrupts(chip);
 
-	ret = tpm_pm_resume(dev);
-	if (!ret)
-		tpm_do_selftest(chip);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		/* NOP if firmware properly does this. */
+		tpm2_startup(chip, TPM2_SU_STATE);
+
+		ret = tpm2_shutdown(chip, TPM2_SU_STATE);
+		if (!ret)
+			ret = tpm2_do_selftest(chip);
+	} else {
+		ret = tpm_pm_resume(dev);
+		if (!ret)
+			tpm_do_selftest(chip);
+	}
 
 	return ret;
 }
-- 
2.1.0

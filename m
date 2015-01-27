From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH] tpm: fix suspend/resume paths for TPM 2.0
Date: Tue, 27 Jan 2015 13:02:44 +0200
Message-ID: <1422356564-17312-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

=46ixed suspend/resume paths for TPM 2.0 and consolidated all the
associated code to the tpm_pm_suspend() and tpm_pm_resume()
functions. Resume path should be handled by the firmware, i.e.
Startup(CLEAR) for hibernate and Startup(STATE) for suspend.

There might be some non-PC embedded devices in the future where
Startup() is not the handled by the FW but fixing the code for
those IMHO should be postponed until there is hardware available
to test the fixes although extra Startup in the driver code is
essentially a NOP.

Reported-by: Peter H=C3=BCwe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm-interface.c | 10 ++++++++--
 drivers/char/tpm/tpm_crb.c       | 16 +---------------
 drivers/char/tpm/tpm_tis.c       | 22 ++++++++++------------
 3 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/drivers/char/tpm/tpm-interface.c b/drivers/char/tpm/tpm-in=
terface.c
index bf53a37..93c8b90fd 100644
--- a/drivers/char/tpm/tpm-interface.c
+++ b/drivers/char/tpm/tpm-interface.c
@@ -901,8 +901,13 @@ int tpm_pm_suspend(struct device *dev)
 	if (chip =3D=3D NULL)
 		return -ENODEV;
=20
-	if (chip->flags & TPM_CHIP_FLAG_TPM2)
-		return tpm2_shutdown(chip, TPM2_SU_CLEAR);
+	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
+		rc =3D tpm2_shutdown(chip, TPM2_SU_STATE);
+		if (rc < 0)
+			return rc;
+
+		return 0;
+	}
=20
 	/* for buggy tpm, flush pcrs with extend to selected dummy */
 	if (tpm_suspend_pcr) {
@@ -952,6 +957,7 @@ EXPORT_SYMBOL_GPL(tpm_pm_suspend);
 int tpm_pm_resume(struct device *dev)
 {
 	struct tpm_chip *chip =3D dev_get_drvdata(dev);
+	int ret;
=20
 	if (chip =3D=3D NULL)
 		return -ENODEV;
diff --git a/drivers/char/tpm/tpm_crb.c b/drivers/char/tpm/tpm_crb.c
index 3dd23cf..3e080f5 100644
--- a/drivers/char/tpm/tpm_crb.c
+++ b/drivers/char/tpm/tpm_crb.c
@@ -95,21 +95,7 @@ struct crb_priv {
 	u8 __iomem *rsp;
 };
=20
-#ifdef CONFIG_PM_SLEEP
-static int crb_resume(struct device *dev)
-{
-	int rc;
-	struct tpm_chip *chip =3D dev_get_drvdata(dev);
-
-	rc =3D tpm2_shutdown(chip, TPM2_SU_STATE);
-	if (!rc)
-		rc =3D tpm2_do_selftest(chip);
-
-	return rc;
-}
-#endif
-
-static SIMPLE_DEV_PM_OPS(crb_pm, tpm_pm_suspend, crb_resume);
+static SIMPLE_DEV_PM_OPS(crb_pm, tpm_pm_suspend, tpm_pm_resume);
=20
 static u8 crb_status(struct tpm_chip *chip)
 {
diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
index 6725bef..c105eb7 100644
--- a/drivers/char/tpm/tpm_tis.c
+++ b/drivers/char/tpm/tpm_tis.c
@@ -865,25 +865,23 @@ static void tpm_tis_reenable_interrupts(struct tp=
m_chip *chip)
 static int tpm_tis_resume(struct device *dev)
 {
 	struct tpm_chip *chip =3D dev_get_drvdata(dev);
-	int ret =3D 0;
+	int ret;
=20
 	if (chip->vendor.irq)
 		tpm_tis_reenable_interrupts(chip);
=20
-	if (chip->flags & TPM_CHIP_FLAG_TPM2) {
-		/* NOP if firmware properly does this. */
-		tpm2_startup(chip, TPM2_SU_STATE);
+	ret =3D tpm_pm_resume(dev);
+	if (ret)
+		return ret;
=20
-		ret =3D tpm2_shutdown(chip, TPM2_SU_STATE);
-		if (!ret)
-			ret =3D tpm2_do_selftest(chip);
-	} else {
-		ret =3D tpm_pm_resume(dev);
-		if (!ret)
-			tpm_do_selftest(chip);
+	/* TPM 1.2 requires self-test on resume. */
+	if (!(chip->flags & TPM_CHIP_FLAG_TPM2)) {
+		ret =3D tpm_do_selftest(chip);
+		if (ret < 0)
+			return ret;
 	}
=20
-	return ret;
+	return 0;
 }
 #endif
=20
--=20
2.1.4

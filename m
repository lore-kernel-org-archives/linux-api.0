From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Re: [PATCH v10 0/8] TPM 2.0 support
Date: Tue, 16 Dec 2014 23:31:24 +0200
Message-ID: <20141216213123.GA21710@intel.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141215201757.GA27923@intel.com>
 <trinity-c582edfe-4951-4a31-911d-db0c6f723157-1418764766771@3capp-gmx-bs15>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="5mCyUwZo2JvN/JJP"
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <trinity-c582edfe-4951-4a31-911d-db0c6f723157-1418764766771@3capp-gmx-bs15>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Huewe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org


--5mCyUwZo2JvN/JJP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit


On Tue, Dec 16, 2014 at 10:19:26PM +0100, Peter Huewe wrote:
> > So, what do you think? Are we now settled with this?
> 
> Meh...
> It does not recognize my tpm20 with force=1 :( :( :(
> Probably since I don't have a machine with bios integration -> no tpm startup,
> and your startup is returned with RC_SIZE :(

I don't know why it worked for me. My dTPM2 does not export ACPI device
but I guess firmware does execute startup. 

I root caused this quickly and attached patch here. Does that resolve
your issue?


>  rmmod tpm; modprobe tpm_tis force=1 ; dmesg 
> modprobe: ERROR: could not insert 'tpm_tis': No such device
> [   77.744050] tpm_tis tpm_tis: 2.0 TPM (device-id 0x1A, rev-id 16)
> [   77.816049] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   77.888043] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   77.960043] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   77.960057] genirq: Flags mismatch irq 6. 00000080 (tpm0) vs. 00000000 (floppy)
> [   77.960067] tpm_tis tpm_tis: Unable to request irq: 6 for probe
> [   77.960073] genirq: Flags mismatch irq 7. 00000080 (tpm0) vs. 00000000 (parport0)
> [   77.960077] tpm_tis tpm_tis: Unable to request irq: 7 for probe
> [   77.960082] genirq: Flags mismatch irq 8. 00000080 (tpm0) vs. 00000000 (rtc0)
> [   77.960087] tpm_tis tpm_tis: Unable to request irq: 8 for probe
> [   78.032041] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   78.104043] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   78.176041] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   78.248041] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   78.320041] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   78.392040] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   78.464041] tpm_tis tpm_tis: A TPM error (256) occurred attempting to generate an interrupt
> [   78.524041] tpm_tis tpm_tis: A TPM error (256) occurred continue selftest
> [   78.524048] tpm_tis tpm_tis: Firmware has not started TPM
> [   78.596041] tpm_tis tpm_tis: A TPM error (149) occurred attempting to start the TPM
> [   78.596048] tpm_tis tpm_tis: TPM self test failed
> 
> 
> ;(
> Peter

/Jarkko

--5mCyUwZo2JvN/JJP
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-tpm-invalid-size-for-struct-tpm2_startup_header.patch"

>From e8337658b6f29fc1259b1ddaf81e51ede91219e8 Mon Sep 17 00:00:00 2001
From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Date: Tue, 16 Dec 2014 23:28:51 +0200
Subject: [PATCH] tpm: invalid size for struct tpm2_startup_header

sizeof(tpm2_pcr_read_in) was used in place of sizeof(tpm2_startup_in).
This patch fixes the issue.

Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
---
 drivers/char/tpm/tpm2-cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
index 610dc87..d1b99df 100644
--- a/drivers/char/tpm/tpm2-cmd.c
+++ b/drivers/char/tpm/tpm2-cmd.c
@@ -411,7 +411,7 @@ ssize_t tpm2_get_tpm_pt(struct tpm_chip *chip, u32 property_id,  u32 *value,
 
 #define TPM2_STARTUP_IN_SIZE \
 	(sizeof(struct tpm_input_header) + \
-	 sizeof(struct tpm2_pcr_read_in))
+	 sizeof(struct tpm2_startup_in))
 
 static const struct tpm_input_header tpm2_startup_header = {
 	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
-- 
2.1.0


--5mCyUwZo2JvN/JJP--

From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH] tpm, tpm_tis: fix TPM 2.0 probing
Date: Mon, 9 Feb 2015 00:08:46 +0100
Message-ID: <201502090008.47986.PeterHuewe@gmx.de>
References: <1423059669-31734-1-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423059669-31734-1-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Mittwoch, 4. Februar 2015, 15:21:09 schrieb Jarkko Sakkinen:
> If during transmission system error was returned, the logic was to
> incorrectly deduce that chip is a TPM 1.x chip. This patch fixes this
> issue. Also, this patch changes probing so that message tag is used as the
> measure for TPM 2.x, which should be much more stable.
Is it aware that some TPMs may respond with 0x00C1 as TAG for TPM1.2 commands?


> A separate function
> called tpm2_probe() is encapsulated because it can be used with any
> chipset.

> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>  drivers/char/tpm/tpm.h      |  3 ++-
>  drivers/char/tpm/tpm2-cmd.c | 40 +++++++++++++++++++++++++++++++++-------
>  drivers/char/tpm/tpm_tis.c  | 11 ++++-------
>  3 files changed, 39 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/char/tpm/tpm.h b/drivers/char/tpm/tpm.h
> index 7b0727c..a4b0f5e 100644
> --- a/drivers/char/tpm/tpm.h
> +++ b/drivers/char/tpm/tpm.h
> @@ -435,4 +435,5 @@ extern int tpm2_startup(struct tpm_chip *chip, u16
> startup_type); extern int tpm2_shutdown(struct tpm_chip *chip, u16
> shutdown_type); extern unsigned long tpm2_calc_ordinal_duration(struct
> tpm_chip *, u32); extern int tpm2_do_selftest(struct tpm_chip *chip);
> -extern int tpm2_gen_interrupt(struct tpm_chip *chip, bool quiet);
> +extern int tpm2_gen_interrupt(struct tpm_chip *chip);
> +extern int tpm2_probe(struct tpm_chip *chip);
> diff --git a/drivers/char/tpm/tpm2-cmd.c b/drivers/char/tpm/tpm2-cmd.c
> index 1abe650..49cd354 100644
> --- a/drivers/char/tpm/tpm2-cmd.c
> +++ b/drivers/char/tpm/tpm2-cmd.c
> @@ -598,20 +598,46 @@ EXPORT_SYMBOL_GPL(tpm2_do_selftest);
>  /**
>   * tpm2_gen_interrupt() - generate an interrupt
>   * @chip: TPM chip to use
> - * @quiet: surpress the error message
>   *
>   * 0 is returned when the operation is successful. If a negative number is
>   * returned it remarks a POSIX error code. If a positive number is
> returned * it remarks a TPM error.
>   */
> -int tpm2_gen_interrupt(struct tpm_chip *chip, bool quiet)
> +int tpm2_gen_interrupt(struct tpm_chip *chip)
>  {
> -	const char *desc = NULL;
>  	u32 dummy;
> 
> -	if (!quiet)
> -		desc = "attempting to generate an interrupt";
> -
> -	return tpm2_get_tpm_pt(chip, TPM2_CAP_TPM_PROPERTIES, &dummy, desc);
> +	return tpm2_get_tpm_pt(chip, 0x100, &dummy,
> +			       "attempting to generate an interrupt");
Why the change from TPM2_CAP_TPM_PROPERTIES = 6 to 0x100 and what does 0x100 
stand for?


>  }
>  EXPORT_SYMBOL_GPL(tpm2_gen_interrupt);
> +
> +/**
> + * tpm2_probe() - probe TPM 2.0
> + * @chip: TPM chip to use
> + *
> + * Send idempotent TPM 2.0 command and see whether TPM 2.0 chip replied
> based on + * the reply tag.
> + */
> +int tpm2_probe(struct tpm_chip *chip)
> +{
> +	struct tpm2_cmd cmd;
> +	int rc;
> +
> +	cmd.header.in = tpm2_get_tpm_pt_header;
> +	cmd.params.get_tpm_pt_in.cap_id = cpu_to_be32(TPM2_CAP_TPM_PROPERTIES);
> +	cmd.params.get_tpm_pt_in.property_id = cpu_to_be32(0x100);
> +	cmd.params.get_tpm_pt_in.property_cnt = cpu_to_be32(1);
> +
> +	rc = tpm_transmit(chip, (const char *) &cmd, sizeof(cmd));
> +	if (rc <  0)
> +		return rc;
> +	else if (rc < TPM_HEADER_SIZE)
> +		return -EFAULT;
> +
> +	if (be16_to_cpu(cmd.header.out.tag) == TPM2_ST_NO_SESSIONS)
> +		chip->flags |= TPM_CHIP_FLAG_TPM2;
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(tpm2_probe);
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 6725bef..ee6e0bd 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -639,12 +639,9 @@ static int tpm_tis_init(struct device *dev,
> acpi_handle acpi_dev_handle, goto out_err;
>  	}
> 
> -	/* Every TPM 2.x command has a higher ordinal than TPM 1.x commands.
> -	 * Therefore, we can use an idempotent TPM 2.x command to probe TPM 2.x.
> -	 */
> -	rc = tpm2_gen_interrupt(chip, true);
> -	if (rc == 0 || rc == TPM2_RC_INITIALIZE)
> -		chip->flags |= TPM_CHIP_FLAG_TPM2;
> +	rc = tpm2_probe(chip);
> +	if (rc)
> +		goto out_err;
> 
>  	vendor = ioread32(chip->vendor.iobase + TPM_DID_VID(0));
>  	chip->vendor.manufacturer_id = vendor;
> @@ -747,7 +744,7 @@ static int tpm_tis_init(struct device *dev, acpi_handle
> acpi_dev_handle,
> 
>  			/* Generate Interrupts */
>  			if (chip->flags & TPM_CHIP_FLAG_TPM2)
> -				tpm2_gen_interrupt(chip, false);
> +				tpm2_gen_interrupt(chip);
>  			else
>  				tpm_gen_interrupt(chip);

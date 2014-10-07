From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v2 3/7] tpm: clean up tpm_tis driver
 life-cycle
Date: Tue, 7 Oct 2014 11:53:26 -0600
Message-ID: <20141007175326.GB10432@obsidianresearch.com>
References: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1412701277-27794-4-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1412701277-27794-4-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 07, 2014 at 08:01:13PM +0300, Jarkko Sakkinen wrote:

> +	chip = tpm_chip_alloc(dev, &tpm_tis);
> +	if (!chip)
>  		return -ENODEV;

Needs to use ERR_PTR
  
> +	rc = tpm_chip_register(chip);
> +	if (rc)
> +		return -ENODEV;

Wrong ordering, this needs to be last in the probe function

Return rc not -ENODEV
  
> +static void tpm_tis_chip_remove(struct tpm_chip *chip)
> +{
> +	iowrite32(~TPM_GLOBAL_INT_ENABLE &
> +		  ioread32(chip->vendor.iobase +
> +			   TPM_INT_ENABLE(chip->vendor.
> +					  locality)),
> +		  chip->vendor.iobase +
> +		  TPM_INT_ENABLE(chip->vendor.locality));
> +	release_locality(chip, chip->vendor.locality, 1);
> +	if (chip->vendor.irq)
> +		free_irq(chip->vendor.irq, chip);
> +
> +	tpm_chip_unregister(chip);
> +}

Wrong ordering, tpm_chip_unregister needs to be first

> +	chip = dev_get_drvdata(&pdev->dev);
> +	tpm_tis_chip_remove(chip);
>  	platform_device_unregister(pdev);

I'm under the impression devm does not work outside a device driver
context, so adding devm breaks force mode in this driver. Do you see
differently?

AFAIK the two options are to fix force mode so that it attaches the
dummy platform driver (that is what it is for after all) or remove
force mode.

Jason

From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Subject: Re: [PATCH v9 3/8] tpm: fix raciness of PPI interface lookup
Date: Thu, 4 Dec 2014 21:34:15 +0100
Message-ID: <201412042134.15776.PeterHuewe@gmx.de>
References: <1417672518-4530-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417672518-4530-4-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417672518-4530-4-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

Am Donnerstag, 4. Dezember 2014, 06:55:13 schrieb Jarkko Sakkinen:
> Traversal of the ACPI device tree was not done right. PPI interface
> should be looked up only from the ACPI device that is the platform
> device for the TPM. This could cause problems with systems with
> two TPM chips such as 4th gen Intel systems.
> 
> In addition, added the missing license and copyright platter to
> the tpm_ppi.c.
> 
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

:(

> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -580,8 +580,9 @@ static void tpm_tis_remove(struct tpm_chip *chip)
>  	release_locality(chip, chip->vendor.locality, 1);
>  }
> 
> -static int tpm_tis_init(struct device *dev, resource_size_t start,
> -			resource_size_t len, unsigned int irq)
> +static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
> +			resource_size_t start, resource_size_t len,
> +			unsigned int irq)
>  {
>  	u32 vendor, intfcaps, intmask;
>  	int rc, i, irq_s, irq_e, probe;
> @@ -597,6 +598,7 @@ static int tpm_tis_init(struct device *dev,
> resource_size_t start, return PTR_ERR(chip);
> 
>  	chip->vendor.priv = priv;
> +	chip->acpi_dev_handle = acpi_dev_handle;
> 
>  	chip->vendor.iobase = devm_ioremap(dev, start, len);
>  	if (!chip->vendor.iobase)
> @@ -827,6 +829,7 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
>  {
>  	resource_size_t start, len;
>  	unsigned int irq = 0;
> +	acpi_handle acpi_dev_handle = NULL;
> 
>  	start = pnp_mem_start(pnp_dev, 0);
>  	len = pnp_mem_len(pnp_dev, 0);
> @@ -839,7 +842,10 @@ static int tpm_tis_pnp_init(struct pnp_dev *pnp_dev,
>  	if (is_itpm(pnp_dev))
>  		itpm = true;
> 
> -	return tpm_tis_init(&pnp_dev->dev, start, len, irq);
> +	if (pnp_acpi_device(pnp_dev))
> +		acpi_dev_handle = pnp_acpi_device(pnp_dev)->handle;
> +
> +	return tpm_tis_init(&pnp_dev->dev, acpi_dev_handle, start, len, irq);
>  }

With CONFIG_ACPI not set I get a build error :(

  CC [M]  drivers/char/tpm/tpm_tis.o
drivers/char/tpm/tpm_tis.c: In function 'tpm_tis_init':
drivers/char/tpm/tpm_tis.c:614:6: error: 'struct tpm_chip' has no member named 
'acpi_dev_handle'
scripts/Makefile.build:263: recipe for target 'drivers/char/tpm/tpm_tis.o' 
failed
make[3]: *** [drivers/char/tpm/tpm_tis.o] Error 1
scripts/Makefile.build:404: recipe for target 'drivers/char/tpm' failed
make[2]: *** [drivers/char/tpm] Error 2
scripts/Makefile.build:404: recipe for target 'drivers/char' failed
make[1]: *** [drivers/char] Error 2
Makefile:929: recipe for target 'drivers' failed
make: *** [drivers] Error 2


Please fix.
Peter

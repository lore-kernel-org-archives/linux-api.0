From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v7 09/10] tpm: TPM 2.0 FIFO Interface
Date: Wed, 26 Nov 2014 20:38:39 -0500
Message-ID: <5476809F.3090503@linux.vnet.ibm.com>
References: <1415713513-16524-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1415713513-16524-10-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415713513-16524-10-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
Cc: christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 11/11/2014 08:45 AM, Jarkko Sakkinen wrote:
> From: Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Detect TPM 2.0 by using the extended STS (STS3) register. For TPM 2.0,
> instead of calling tpm_get_timeouts(), assign duration and timeout
> values defined in the TPM 2.0 PTP specification.


>
> Signed-off-by: Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> ---
>   drivers/char/tpm/tpm_tis.c | 71 ++++++++++++++++++++++++++++++++++++----------
>   1 file changed, 56 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/char/tpm/tpm_tis.c b/drivers/char/tpm/tpm_tis.c
> index 7a2c59b..0b3c089 100644
> --- a/drivers/char/tpm/tpm_tis.c
> +++ b/drivers/char/tpm/tpm_tis.c
> @@ -1,5 +1,6 @@
>   /*
>    * Copyright (C) 2005, 2006 IBM Corporation
> + * Copyright (C) 2014 Intel Corporation
>    *
>    * Authors:
>    * Leendert van Doorn <leendert-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
> @@ -44,6 +45,10 @@ enum tis_status {
>   	TPM_STS_DATA_EXPECT = 0x08,
>   };
>
> +enum tis_status3 {
> +	TPM_STS3_TPM2_FAM = 0x04,
> +};
> +

I just looked at the specs: You have to define a mask for bits 2 and 3 
-> 0xc0.


> @@ -554,11 +567,28 @@ static int tpm_tis_init(struct device *dev, acpi_handle acpi_dev_handle,
>   	if (!chip->vendor.iobase)
>   		return -EIO;
>
> +	sts3 = ioread8(chip->vendor.iobase + TPM_STS3(1));
> +	if (sts3 & TPM_STS3_TPM2_FAM)
> +		chip->flags = TPM_CHIP_FLAG_TPM2;

And use the mask here.

((sts3 & XYZ_MASK) == TPM_STS3_TPM2_FAM)
     chip->flags = TPM_CHIP_FLAG_TPM2;

Since the bits 00 indicate TPM 1.2, 01 TPM2 and 10 and 11 are reserved!


    Stefan

From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v8 6/8] tpm: TPM 2.0 baseline support
Date: Tue, 02 Dec 2014 21:21:02 -0500
Message-ID: <547E738E.3060600@linux.vnet.ibm.com>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417559480-13757-7-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417559480-13757-7-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
Cc: christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Arthur <will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 12/02/2014 05:31 PM, Jarkko Sakkinen wrote:
> +
> +#define TPM2_STARTUP_IN_SIZE \
> +	(sizeof(struct tpm_input_header) + \
> +	 sizeof(struct tpm2_pcr_read_in))
> +
> +static const struct tpm_input_header tpm2_startup_header = {
> +	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> +	.length = cpu_to_be32(TPM2_STARTUP_IN_SIZE),
> +	.ordinal = cpu_to_be32(TPM2_CC_STARTUP)
> +};
> +
>
[...]
> +
> +#define TPM2_PCR_READ_IN_SIZE \
> +	(sizeof(struct tpm_input_header) + \
> +	 sizeof(struct tpm2_pcr_read_in))
> +
> +static const struct tpm_input_header tpm2_pcrread_header = {
> +	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> +	.length = cpu_to_be32(TPM2_PCR_READ_IN_SIZE),
> +	.ordinal = cpu_to_be32(TPM2_CC_PCR_READ)
> +};
> +
>
[...]
> +static const struct tpm_input_header tpm2_pcrextend_header = {
> +	.tag = cpu_to_be16(TPM2_ST_SESSIONS),
> +	.length = cpu_to_be32(sizeof(struct tpm_input_header) +
> +			      sizeof(struct tpm2_pcr_extend_in)),
> +	.ordinal = cpu_to_be32(TPM2_CC_PCR_EXTEND)
> +};


really just a nit: also use a #define here



> +static const struct tpm_input_header tpm2_getrandom_header = {
> +	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> +	.length = cpu_to_be32(sizeof(struct tpm_input_header) +
> +			      sizeof(struct tpm2_get_random_in)),
> +	.ordinal = cpu_to_be32(TPM2_CC_GET_RANDOM)
> +};
> +
also here

> +
> +#define TPM2_GET_TPM_PT_IN_SIZE \
> +	(sizeof(struct tpm_input_header) + \
> +	 sizeof(struct tpm2_get_tpm_pt_in))
> +
> +static const struct tpm_input_header tpm2_get_tpm_pt_header = {
> +	.tag = cpu_to_be16(TPM2_ST_NO_SESSIONS),
> +	.length = cpu_to_be32(TPM2_GET_TPM_PT_IN_SIZE),
> +	.ordinal = cpu_to_be32(TPM2_CC_GET_CAPABILITY)
> +};
> +


Otherwise it looks good now.

    Stefan

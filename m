From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v6 08/11] tpm: Driver for supporting multiple emulated
 TPMs
Date: Thu, 10 Mar 2016 12:32:15 -0500
Message-ID: <56E1AF9F.3010409@linux.vnet.ibm.com>
References: <1457545170-30120-1-git-send-email-stefanb@linux.vnet.ibm.com>
 <1457545170-30120-9-git-send-email-stefanb@linux.vnet.ibm.com>
 <20160310163915.GA4863@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160310163915.GA4863-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 03/10/2016 11:39 AM, Jarkko Sakkinen wrote:
> +/* above flags */
> +#define VTPM_FLAG_TPM2           1  /* emulator is TPM 2 */
> +
> +/* all supported flags */
> +#define VTPM_FLAGS_ALL  (VTPM_FLAG_TPM2)
> +
> +#define VTPM_TPM 0xa0
> +
> +#define VTPM_NEW_DEV         _IOW(VTPM_TPM, 0x00, struct vtpm_new_dev)
> I'd rather use VTPM_IOC_NEW_DEV.

What about the name of the structure ? vtpm_ioc_new_dev?

    Stefan

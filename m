From: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v8 7/8] tpm: TPM 2.0 CRB Interface
Date: Tue, 02 Dec 2014 18:07:16 -0500
Message-ID: <547E4624.8060206@linux.vnet.ibm.com>
References: <1417559480-13757-1-git-send-email-jarkko.sakkinen@linux.intel.com> <1417559480-13757-8-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1417559480-13757-8-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>
Cc: christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 12/02/2014 05:31 PM, Jarkko Sakkinen wrote:


> +struct acpi_tpm2 {
> +	struct acpi_table_header hdr;
> +	u16 platform_class;
> +	u16 reserved;
> +	u64 control_area_pa;
> +	u32 start_method;
> +} __packed;
[...]
> +	}
> +
> +	if (buf->hdr.length != sizeof(struct acpi_tpm2)) {

This should be

if (buf->hdr.length < sizeof(struct acpi_tpm2)) {

since the ACPI TPM2 table may have a variable number of 'Platform 
Specific Parameters' beyond the 'Start Method Field'. What we don't want 
to have is less, but more is fine.

    Stefan

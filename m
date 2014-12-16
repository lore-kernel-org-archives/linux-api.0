From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: Re: [tpmdd-devel] [PATCH v10 0/8] TPM 2.0 support
Date: Tue, 16 Dec 2014 23:34:47 +0200
Message-ID: <20141216213447.GA24841@intel.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141215201757.GA27923@intel.com>
 <trinity-c582edfe-4951-4a31-911d-db0c6f723157-1418764766771@3capp-gmx-bs15>
 <trinity-c704c9fe-b92f-48bd-80cc-a452bd18cc28-1418765537847@3capp-gmx-bs15>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <trinity-c704c9fe-b92f-48bd-80cc-a452bd18cc28-1418765537847@3capp-gmx-bs15>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Huewe <PeterHuewe-Mmb7MZpHnFY@public.gmane.org>
Cc: christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 16, 2014 at 10:32:18PM +0100, Peter Huewe wrote:
> Hi,
> if I fix this (already adressed issue) 
>  #define TPM2_STARTUP_IN_SIZE \
>         (sizeof(struct tpm_input_header) + \
> -        sizeof(struct tpm2_pcr_read_in))
> +        sizeof(struct tpm2_startup_in))
>  
> it gets detected correctly.
>  
> I'll fix it, no updated patch needed.

Oops, I was too fast :)

> Not sure however if I think to reuse tpm2_startup_in also for shutdown, simply
> because it has  the same size, but ok.

They are equivalent messages except for the command code.

> Peter

/Jarkko

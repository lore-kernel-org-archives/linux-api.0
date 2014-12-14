From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v10 1/8] tpm: merge duplicate transmit_cmd() functions
Date: Sun, 14 Dec 2014 17:42:33 +0200
Message-ID: <20141214154233.GA14110@intel.com>
References: <1418413600-5400-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1418413600-5400-2-git-send-email-jarkko.sakkinen@linux.intel.com>
 <548D98B8.3010003@linux.vnet.ibm.com>
 <1418569030.9230.7.camel@linux.intel.com>
 <889c95a4-ae60-44db-be8a-fd56a9497c78@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <889c95a4-ae60-44db-be8a-fd56a9497c78-2ueSQiBKiTY7tOexoI0I+QC/G2K4zDHf@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: peterhuewe-Mmb7MZpHnFY@public.gmane.org
Cc: Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trousers-tech-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Dec 14, 2014 at 04:31:10PM +0100, peterhuewe-Mmb7MZpHnFY@public.gmane.org wrote:
> 
> 
> On 14. Dezember 2014 15:57:10 MEZ, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> >On Sun, 2014-12-14 at 09:03 -0500, Stefan Berger wrote:
> >> On 12/12/2014 02:46 PM, Jarkko Sakkinen wrote:
> >> > Merged transmit_cmd() functions in tpm-interface.c and tpm-sysfs.c.
> >> > Added "tpm_" prefix for consistency sake. Changed cmd parameter as
> >> > opaque. This enables to use separate command structures for TPM1
> >> > and TPM2 commands in future. Loose coupling works fine here.
> >> >
> >> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >> > Reviewed-by: Jasob Gunthorpe <jason.gunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> >> > Reviewed-by: Stephan Berger <stephan.berger-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >> 
> >> Not quite ... Stefan Berger <stefanb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >
> >Oops. Peter, I guess you could fix those or? My apologies.
> >
> >>      Stefan
> >
> >/Jarkko
> I'll fix this,
> No problem.

Thank you.

> Peter

/Jarkko

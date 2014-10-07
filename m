From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v2 2/7] tpm: two-phase chip management
 functions
Date: Tue, 7 Oct 2014 22:15:42 +0300
Message-ID: <20141007191542.GA31645@intel.com>
References: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1412701277-27794-3-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141007175017.GA10432@obsidianresearch.com>
 <20141007180417.GA29459@intel.com>
 <20141007182756.GA10774@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141007182756.GA10774-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 07, 2014 at 12:27:56PM -0600, Jason Gunthorpe wrote:
> On Tue, Oct 07, 2014 at 09:04:17PM +0300, Jarkko Sakkinen wrote:
> 
> > > Did you test compile all the drivers? One of my git commits on github
> > > has some hackery to make that possible on x86.
> > 
> > Yeah, I compiled all the drivers:
> > 
> > $ grep CONFIG_TCG .config
> > CONFIG_TCG_TPM=m
> > CONFIG_TCG_TIS=m
> > CONFIG_TCG_TIS_I2C_ATMEL=m
> > CONFIG_TCG_TIS_I2C_INFINEON=m
> > CONFIG_TCG_TIS_I2C_NUVOTON=m
> > CONFIG_TCG_NSC=m
> > CONFIG_TCG_ATMEL=m
> > CONFIG_TCG_INFINEON=m
> > CONFIG_TCG_ST33_I2C=m
> > CONFIG_TCG_XEN=m
> > CONFIG_TCG_CRB=m
> 
> CONFIG_TCG_IBMVTPM is missing, apply this:
> 
> https://github.com/jgunthorpe/linux/commit/74afd69de603783858283f9b337e1694988964f8

Oops, how did that go unnoticed. Will do.

> Jason

/Jarkko

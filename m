From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v2 2/7] tpm: two-phase chip management
 functions
Date: Tue, 7 Oct 2014 16:34:42 -0600
Message-ID: <20141007223442.GA3014@obsidianresearch.com>
References: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1412701277-27794-3-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141007175017.GA10432@obsidianresearch.com>
 <20141007222814.GA7262@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141007222814.GA7262-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Oct 08, 2014 at 01:28:14AM +0300, Jarkko Sakkinen wrote:

> > > @@ -714,15 +709,10 @@ static int tpm_tis_i2c_remove(struct i2c_client *client)
> > >  	struct tpm_chip *chip = tpm_dev.chip;
> > >  	release_locality(chip, chip->vendor.locality, 1);
> > >  
> > > -	/* close file handles */
> > > -	tpm_dev_vendor_release(chip);
> > > -
> > >  	/* remove hardware */
> > >  	tpm_remove_hardware(chip->dev);
> > 
> > Wrong ordering here, tpm_remove_hardware should always be first -
> > drivers should not tear down internal state before calling it, so
> > release_locality should be second.
> > 
> > Noting that since we use devm the kfree will not happen until
> > remove returns, so the chip pointer is still valid.
> 
> Should I fix this ordering? I was thinking to focus putting proper
> patterns in place only in tpm_tis and tpm_crb because they are the
> that I'm able to test easily and then they can work as guideline for
> other drivers.

I think since this patch is already touching this function there is
no reason not to make it be correct (especially since it was noticed)

The rest can wait till we globally replace tpm_remove_hardware with
tpm_unregister - at that time the ordering can be audited and
checked.

Then the drivers will be clean and the core can finally be fixed.

Jason

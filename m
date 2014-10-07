From: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [tpmdd-devel] [PATCH v2 2/7] tpm: two-phase chip management
 functions
Date: Wed, 8 Oct 2014 01:28:14 +0300
Message-ID: <20141007222814.GA7262@intel.com>
References: <1412701277-27794-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1412701277-27794-3-git-send-email-jarkko.sakkinen@linux.intel.com>
 <20141007175017.GA10432@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141007175017.GA10432-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Oct 07, 2014 at 11:50:17AM -0600, Jason Gunthorpe wrote:
> On Tue, Oct 07, 2014 at 08:01:12PM +0300, Jarkko Sakkinen wrote:
> > Added tpm_chip_alloc() and tpm_chip_register() where tpm_chip_alloc()
> > reserves memory resources and tpm_chip_register() initializes the
> > device driver. This way it is possible to alter struct tpm_chip
> > attributes before passing it to tpm_chip_register().
> 
> This looks broadly reasonable to me
> 
> Please add a note to the commit that this is known to still have
> problems with resource reference counting, but they are less severe
> than what existed before, and this is only an interm step.
> 
> > +/**
> > + * tpm_chip_alloc() - allocate a new struct tpm_chip instance
> 
> This is using devm so it should be called 'tpmm_chip_alloc()' for
> clarity
> 
> 
> I know that was there before, but it sure is racy:
> 
> > +	chip->dev_num = find_first_zero_bit(dev_mask, TPM_NUM_DEVICES);
> [..]
> > +	set_bit(chip->dev_num, dev_mask);
> 
> Someday it should use IDR.
> 
> 
> > @@ -896,18 +872,7 @@ void tpm_remove_hardware(struct device *dev)
> >  		return;
> >  	}
> >  
> > -	spin_lock(&driver_lock);
> > -	list_del_rcu(&chip->list);
> > -	spin_unlock(&driver_lock);
> > -	synchronize_rcu();
> > -
> > -	tpm_dev_del_device(chip);
> > -	tpm_sysfs_del_device(chip);
> > -	tpm_remove_ppi(&dev->kobj);
> > -	tpm_bios_log_teardown(chip->bios_dir);
> > -
> > -	/* write it this way to be explicit (chip->dev == dev) */
> > -	put_device(chip->dev);
> > +	tpm_chip_unregister(chip);
> >  }
> >  EXPORT_SYMBOL_GPL(tpm_remove_hardware);
> 
> This can move to tpm-chip too, same with tpm_register_hardware
> 
> > @@ -714,15 +709,10 @@ static int tpm_tis_i2c_remove(struct i2c_client *client)
> >  	struct tpm_chip *chip = tpm_dev.chip;
> >  	release_locality(chip, chip->vendor.locality, 1);
> >  
> > -	/* close file handles */
> > -	tpm_dev_vendor_release(chip);
> > -
> >  	/* remove hardware */
> >  	tpm_remove_hardware(chip->dev);
> 
> Wrong ordering here, tpm_remove_hardware should always be first -
> drivers should not tear down internal state before calling it, so
> release_locality should be second.
> 
> Noting that since we use devm the kfree will not happen until
> remove returns, so the chip pointer is still valid.

Should I fix this ordering? I was thinking to focus putting proper
patterns in place only in tpm_tis and tpm_crb because they are the
that I'm able to test easily and then they can work as guideline for
other drivers.

> >  	/* reset these pointers, otherwise we oops */
> > -	chip->dev->release = NULL;
> > -	chip->release = NULL;
> >  	tpm_dev.client = NULL;
> 
> The comment can go too
> 
> Note: tpm_dev should be driver private data, but that is not your
> problem..
> 
> Did you test compile all the drivers? One of my git commits on github
> has some hackery to make that possible on x86.
> 
> Jason

/Jarkko

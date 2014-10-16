From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 4/6] tpm: TPM 2.0 sysfs attributes
Date: Thu, 16 Oct 2014 11:31:46 +0200
Message-ID: <20141016093146.GA25070@kroah.com>
References: <1413372916-12091-1-git-send-email-jarkko.sakkinen@linux.intel.com>
 <1413372916-12091-5-git-send-email-jarkko.sakkinen@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1413372916-12091-5-git-send-email-jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Ashley Lai <ashley-fm2HMyfA2y6tG0bUXCXiUA@public.gmane.org>, Marcel Selhorst <tpmdd-yWjUBOtONefk1uMJSBkQmQ@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, josh.triplett-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, christophe.ricard-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, will.c.arthur-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, monty.wiseman-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Oct 15, 2014 at 01:35:14PM +0200, Jarkko Sakkinen wrote:
> +int tpm2_sysfs_add_device(struct tpm_chip *chip)
> +{
> +	struct pcr_bank *pcr_bank;
> +	struct kobject *pcrs_kobj;
> +	struct device *dev = chip->dev;
> +	int rc;
> +
> +	rc = sysfs_create_group(&chip->vendor.miscdev.this_device->kobj,
> +				&tpm_dev_group);
> +	if (rc) {
> +		dev_err(dev, "failed to create sysfs attributes, %d\n", rc);
> +		return rc;
> +	}

You just raced and created sysfs files _after_ userspace saw that your
device was enabled.

> +	pcrs_kobj = kobject_create_and_add("pcrs",
> +					   &chip->vendor.miscdev.this_device->kobj);

Ick, no no no no.  Never create a kobject under a 'struct device'.  You
just lost all libudev support for any attribute you created under here,
not good at all.  Use a "real" device if you really want a sub-device,
not a kobject.

thanks,

greg k-h

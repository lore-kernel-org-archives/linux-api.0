From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v1 2/5] firmware: Basic dmi-sysfs support
Date: Thu, 17 Feb 2011 13:56:08 -0800
Message-ID: <20110217215608.GA2451@kroah.com>
References: <20110217212754.3967.98648.stgit@mike.mtv.corp.google.com>
 <20110217212805.3967.47547.stgit@mike.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110217212805.3967.47547.stgit@mike.mtv.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Waychison <mikew@google.com>
Cc: Olof Johansson <olofj@chromium.org>, Andi Kleen <andi@firstfloor.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Lippert <rlippert@google.com>, Jon Mayer <jonmayer@google.com>, Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>, linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>, David Hendrix <dhendrix@chromium.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Overall, this looks great, just a few minor comments below:

On Thu, Feb 17, 2011 at 01:28:05PM -0800, Mike Waychison wrote:
> +config DMI_SYSFS
> +	tristate "DMI table support in sysfs"
> +	depends on SYSFS && DMI
> +	default X86

Huh?  Default should be 'N' for any new feature, unless it keeps your
machine from booting.

I think you want this option to depend on X86 though, right?

> +	help
> +	  Say Y or M here to enable the exporting of the raw DMI table
> +	  data via sysfs.  This is useful for consuming the data without
> +	  requiring any access to /dev/mem at all.  Tables are found
> +	  under /sys/firmware/dmi when this option is enabled and
> +	  loaded.

I just realized (due to other work I'm doing on a laptop) that we have a
bunch of entries today in /sys/class/dmi/id which is a pointer to the
dmi "device".

Now I think this really is different (these are the raw DMI tables), but
this doesn't have anything to do with that code, right?

> + *
> + * Copyright 2010 Google, Inc.

It's 2011 :)

> +static int __init dmi_sysfs_init(void)
> +{
> +	int error = -ENOMEM;
> +	int val;
> +
> +	/* Set up our directory */
> +	dmi_kobj = kobject_create_and_add("dmi", firmware_kobj);
> +	if (!dmi_kobj)
> +		goto err;
> +
> +	dmi_kset = kset_create_and_add("entries", NULL, dmi_kobj);
> +	if (!dmi_kset)
> +		goto err;
> +
> +	val = 0;
> +	error = dmi_walk(dmi_sysfs_register_handle, &val);
> +	if (error)
> +		goto err;
> +	if (val) {
> +		error = val;
> +		goto err;
> +	}
> +
> +	pr_info("dmi-sysfs: loaded.\n");

Is this really needed?  pr_dbg() instead please?

> +
> +	return 0;
> +err:
> +	cleanup_entry_list();
> +	kset_unregister(dmi_kset);
> +	kobject_put(dmi_kobj);
> +	return error;
> +}
> +
> +/* clean up everything. */
> +static void __exit dmi_sysfs_exit(void)
> +{
> +	pr_info("dmi-sysfs: unloading.\n");
> +	cleanup_entry_list();
> +	kset_unregister(dmi_kset);
> +	kobject_put(dmi_kobj);
> +}
> +
> +module_init(dmi_sysfs_init);
> +module_exit(dmi_sysfs_exit);
> +
> +MODULE_AUTHOR("Google, Inc.");

You don't want your name here?

thanks,

greg k-h

From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] drivers/scsi/emcctd: drivers/scsi/emcctd: Client driver
 implementation for  EMC-Symmetrix GuestOS emulated Cut-Through Device
Date: Tue, 19 Jan 2016 10:12:26 -0800
Message-ID: <20160119181226.GB10487@kroah.com>
References: <82807C73E0BDBB498164AAE7B8F6A1481C61263E@MX105CL01.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <82807C73E0BDBB498164AAE7B8F6A1481C61263E-7nf3+EsVnp4EVr6dp/gChrOUoyqYp7Dr@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Singhal, Maneesh" <Maneesh.Singhal-mb1K0bWo544@public.gmane.org>
Cc: "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "JBottomley-wo1vFcy6AUs@public.gmane.org" <JBottomley-wo1vFcy6AUs@public.gmane.org>, "martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Jan 19, 2016 at 11:58:06AM +0000, Singhal, Maneesh wrote:
> Hello,
> Kindly review the following patch for the following driver to be added in SCSI subsystem -
> 
> Regards
> Maneesh
> 
> ----------------------------------------------------------------------------
> >From f3c4b836d6f130b1d7ded618002c8164f8f4a06d Mon Sep 17 00:00:00 2001
> From: "maneesh.singhal" <maneesh.singhal-mb1K0bWo544@public.gmane.org>
> Date: Tue, 19 Jan 2016 06:39:35 -0500
> Subject: [PATCH] [PATCH] drivers/scsi/emcctd: Client driver implementation for
>  EMC-Symmetrix GuestOS emulated Cut-Through Device.
> 
> The patch is a driver implementation  EMC-Symmetrix GuestOS emulated Cut-Through
> Device. The Cut-Through Device PCI emulation is implemented for GuestOS
> environments in the HyperMax OS. GuestOS environments allows loading of
> any x86 compliant operating systems like Linux/FreeBSD etc.
> 
> The client driver is a SCSI HBA implementation which interfaces with SCSI
> midlayer in the north-bound interfaces and connects with the emulated PCI device
> on the south side.
> 
> The PCI vendor ID:product ID for emulated Cut-Through Device is 0x1120:0x1B00.
> 
> Signed-off-by: maneesh.singhal <maneesh.singhal-mb1K0bWo544@public.gmane.org>
> ---
>  Documentation/scsi/emcctd.txt           |   57 +
>  MAINTAINERS                             |    9 +
>  drivers/scsi/Kconfig                    |    1 +
>  drivers/scsi/Makefile                   |    1 +
>  drivers/scsi/emcctd/Kconfig             |    7 +
>  drivers/scsi/emcctd/Makefile            |    1 +
>  drivers/scsi/emcctd/README              |   10 +
>  drivers/scsi/emcctd/emc_ctd_interface.h |  386 +++++
>  drivers/scsi/emcctd/emcctd.c            | 2840 +++++++++++++++++++++++++++++++
>  drivers/scsi/emcctd/emcctd.h            |  232 +++
>  10 files changed, 3544 insertions(+)
>  create mode 100644 Documentation/scsi/emcctd.txt
>  create mode 100644 drivers/scsi/emcctd/Kconfig
>  create mode 100644 drivers/scsi/emcctd/Makefile
>  create mode 100644 drivers/scsi/emcctd/README
>  create mode 100644 drivers/scsi/emcctd/emc_ctd_interface.h
>  create mode 100644 drivers/scsi/emcctd/emcctd.c
>  create mode 100644 drivers/scsi/emcctd/emcctd.h
> 
> diff --git a/Documentation/scsi/emcctd.txt b/Documentation/scsi/emcctd.txt
> new file mode 100644
> index 0000000..bcafc87
> --- /dev/null
> +++ b/Documentation/scsi/emcctd.txt
> @@ -0,0 +1,56 @@
> +This file contains brief information about the EMC Cut-Through Driver (emcctd).
> +The driver is currently maintained by Singhal, Maneesh (maneesh.singhal-mb1K0bWo544@public.gmane.org)
> +
> +Last modified: Mon Jan 18 2016 by Maneesh Singhal
> +
> +BASICS
> +
> +Its a client driver implementation for EMC-Symmetrix GuestOS emulated
> +Cut-Through Device. The Cut-Through Device PCI emulation is implemented for
> +GuestOS environments in the HyperMax OS. GuestOS environments allows loading of
> +any x86 compliant operating systems like Linux/FreeBSD etc.
> +
> +The client driver is a SCSI HBA implementation which interfaces with SCSI
> +midlayer in the north-bound interfaces and connects with the emulated PCI device
> +on the south side.
> +
> +The PCI vendor ID:product ID for emulated Cut-Through Device is 0x1120:0x1B00.
> +
> +VERSIONING
> +
> +The Version of the driver is maintained as 2.0.0.X, where 2 refers to the CTD
> +protocol in use, and X refers to the ongoing version of the driver.
> +
> +
> +SYSFS SUPPORT
> +
> +The driver creates the directory /sys/module/emcctd and populates it with
> +version file and a directory for various parameters as described in MODULE
> +PARAMETERS section.
> +
> +PROCFS SUPPORT
> +
> +The driver creates the directory /proc/emc and creates files emcctd_stats_x
> +where 'x' refers to the PCI emulation number this client driver connected to.
> +These files cotains WWN information and IO statistics for the particular PCI
> +emulation.

No, no driver should be adding proc files, please use sysfs or debugfs
for debugging things.

> +MODULE PARAMETERS

No driver should be using module parameters anymore, again, please use
the correct interfaces.

> +
> +The supported parameters which could add debuggability or change the runtime
> +behavior of the driver are as following:
> +
> +ctd_debug=0 | 1		Enable driver debug messages(0=off, 1=on)

Use the dynamic debugging interface, don't make a custom one just for
your tiny, single, driver.

> +
> +max_luns=xx		Specify the maximum number of LUN's per
> +			host(default=16384)

Why can't this be dynamic?  Why do you need a static number?

> +
> +cmd_per_lun=xx		Specify the maximum commands per lun(default=16)

Why do you need to change this?  Why can't it be dynamic?

> +
> +DEBUGGING HINTS
> +
> +Debugging code is now compiled in by default but debugging is turned off
> +with the kernel module parameter debug_flag defaulting to 0.

Again, no, use the dynamic debug interface, don't make something
"special" just for a single driver, we spent a lot of time trying to
unify everything, don't go backwards.

thanks,

greg k-h

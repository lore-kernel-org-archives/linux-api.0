From: "Singhal, Maneesh" <Maneesh.Singhal@emc.com>
Subject: RE: [PATCH] drivers/scsi/emcctd: drivers/scsi/emcctd: Client driver
 implementation for  EMC-Symmetrix GuestOS emulated Cut-Through Device
Date: Sat, 23 Jan 2016 06:04:23 +0000
Message-ID: <82807C73E0BDBB498164AAE7B8F6A1481C6181E3@MX105CL01.corp.emc.com>
References: <82807C73E0BDBB498164AAE7B8F6A1481C61263E@MX105CL01.corp.emc.com>
 <20160119181226.GB10487@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20160119181226.GB10487@kroah.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Hello Greg,

Thanks for taking out time to review the patch. Please find my replies inlined...
Will post the next patch for modifications soon.

> -----Original Message-----
> From: Greg KH [mailto:greg@kroah.com]
> Sent: Tuesday, January 19, 2016 11:42 PM
> To: Singhal, Maneesh
> Cc: linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> JBottomley@odin.com; martin.petersen@oracle.com; linux-
> api@vger.kernel.org
> Subject: Re: [PATCH] drivers/scsi/emcctd: drivers/scsi/emcctd: Client
> driver implementation for EMC-Symmetrix GuestOS emulated Cut-
> Through Device
> 
> On Tue, Jan 19, 2016 at 11:58:06AM +0000, Singhal, Maneesh wrote:
> > Hello,
> > Kindly review the following patch for the following driver to be
> added
> > in SCSI subsystem -
> >
> > Regards
> > Maneesh
> >
> > ----------------------------------------------------------------------
> > ------
> > >From f3c4b836d6f130b1d7ded618002c8164f8f4a06d Mon Sep 17
> 00:00:00
> > >2001
> > From: "maneesh.singhal" <maneesh.singhal@emc.com>
> > Date: Tue, 19 Jan 2016 06:39:35 -0500
> > Subject: [PATCH] [PATCH] drivers/scsi/emcctd: Client driver
> > implementation for  EMC-Symmetrix GuestOS emulated Cut-
> Through Device.
> >
> > The patch is a driver implementation  EMC-Symmetrix GuestOS
> emulated
> > Cut-Through Device. The Cut-Through Device PCI emulation is
> > implemented for GuestOS environments in the HyperMax OS.
> GuestOS
> > environments allows loading of any x86 compliant operating systems
> like Linux/FreeBSD etc.
> >
> > The client driver is a SCSI HBA implementation which interfaces with
> > SCSI midlayer in the north-bound interfaces and connects with the
> > emulated PCI device on the south side.
> >
> > The PCI vendor ID:product ID for emulated Cut-Through Device is
> 0x1120:0x1B00.
> >
> > Signed-off-by: maneesh.singhal <maneesh.singhal@emc.com>
> > ---
> >  Documentation/scsi/emcctd.txt           |   57 +
> >  MAINTAINERS                             |    9 +
> >  drivers/scsi/Kconfig                    |    1 +
> >  drivers/scsi/Makefile                   |    1 +
> >  drivers/scsi/emcctd/Kconfig             |    7 +
> >  drivers/scsi/emcctd/Makefile            |    1 +
> >  drivers/scsi/emcctd/README              |   10 +
> >  drivers/scsi/emcctd/emc_ctd_interface.h |  386 +++++
> >  drivers/scsi/emcctd/emcctd.c            | 2840
> +++++++++++++++++++++++++++++++
> >  drivers/scsi/emcctd/emcctd.h            |  232 +++
> >  10 files changed, 3544 insertions(+)
> >  create mode 100644 Documentation/scsi/emcctd.txt  create mode
> 100644
> > drivers/scsi/emcctd/Kconfig  create mode 100644
> > drivers/scsi/emcctd/Makefile  create mode 100644
> > drivers/scsi/emcctd/README  create mode 100644
> > drivers/scsi/emcctd/emc_ctd_interface.h
> >  create mode 100644 drivers/scsi/emcctd/emcctd.c  create mode
> 100644
> > drivers/scsi/emcctd/emcctd.h
> >
> > diff --git a/Documentation/scsi/emcctd.txt
> > b/Documentation/scsi/emcctd.txt new file mode 100644 index
> > 0000000..bcafc87
> > --- /dev/null
> > +++ b/Documentation/scsi/emcctd.txt
> > @@ -0,0 +1,56 @@
> > +This file contains brief information about the EMC Cut-Through
> Driver (emcctd).
> > +The driver is currently maintained by Singhal, Maneesh
> > +(maneesh.singhal@emc.com)
> > +
> > +Last modified: Mon Jan 18 2016 by Maneesh Singhal
> > +
> > +BASICS
> > +
> > +Its a client driver implementation for EMC-Symmetrix GuestOS
> emulated
> > +Cut-Through Device. The Cut-Through Device PCI emulation is
> > +implemented for GuestOS environments in the HyperMax OS.
> GuestOS
> > +environments allows loading of any x86 compliant operating
> systems like Linux/FreeBSD etc.
> > +
> > +The client driver is a SCSI HBA implementation which interfaces with
> > +SCSI midlayer in the north-bound interfaces and connects with the
> > +emulated PCI device on the south side.
> > +
> > +The PCI vendor ID:product ID for emulated Cut-Through Device is
> 0x1120:0x1B00.
> > +
> > +VERSIONING
> > +
> > +The Version of the driver is maintained as 2.0.0.X, where 2 refers to
> > +the CTD protocol in use, and X refers to the ongoing version of the
> driver.
> > +
> > +
> > +SYSFS SUPPORT
> > +
> > +The driver creates the directory /sys/module/emcctd and
> populates it
> > +with version file and a directory for various parameters as described
> > +in MODULE PARAMETERS section.
> > +
> > +PROCFS SUPPORT
> > +
> > +The driver creates the directory /proc/emc and creates files
> > +emcctd_stats_x where 'x' refers to the PCI emulation number this
> client driver connected to.
> > +These files cotains WWN information and IO statistics for the
> > +particular PCI emulation.
> 
> No, no driver should be adding proc files, please use sysfs or debugfs
> for debugging things.
[MS>] Sure.
> 
> > +MODULE PARAMETERS
> 
> No driver should be using module parameters anymore, again, please
> use the correct interfaces.
> 
[MS>] Yes got that
> > +
> > +The supported parameters which could add debuggability or change
> the
> > +runtime behavior of the driver are as following:
> > +
> > +ctd_debug=0 | 1		Enable driver debug messages(0=off,
> 1=on)
> 
> Use the dynamic debugging interface, don't make a custom one just
> for your tiny, single, driver.
> 
[MS>] Sure. Will fix this.
> > +
> > +max_luns=xx		Specify the maximum number of LUN's
> per
> > +			host(default=16384)
> 
> Why can't this be dynamic?  Why do you need a static number?
[MS>] Will fix this
> 
> > +
> > +cmd_per_lun=xx		Specify the maximum commands per
> lun(default=16)
> 
> Why do you need to change this?  Why can't it be dynamic?
[MS>] Yes it can be. Will fix
> 
> > +
> > +DEBUGGING HINTS
> > +
> > +Debugging code is now compiled in by default but debugging is
> turned
> > +off with the kernel module parameter debug_flag defaulting to 0.
> 
> Again, no, use the dynamic debug interface, don't make something
> "special" just for a single driver, we spent a lot of time trying to unify
> everything, don't go backwards.
[MS>] Sure. Thanks
> 
> thanks,
> 
> greg k-h

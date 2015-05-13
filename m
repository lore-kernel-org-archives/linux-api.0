From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 1/5] misc: Beaglebone capemanager
Date: Wed, 13 May 2015 08:36:09 -0700
Message-ID: <20150513153609.GB11677@kroah.com>
References: <1431503985-31853-1-git-send-email-pantelis.antoniou@konsulko.com>
 <1431503985-31853-2-git-send-email-pantelis.antoniou@konsulko.com>
 <20150513115514.GB1021@kroah.com>
 <67B17BCF-0489-4FD6-88F0-57B6187BEFEB@konsulko.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <67B17BCF-0489-4FD6-88F0-57B6187BEFEB-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
Cc: Matt Porter <mporter-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>, Koen Kooi <koen-QLwJDigV5abLmq1fohREcCpxlwaOVQ5f@public.gmane.org>, Robert Nelson <robertcnelson-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robherring2-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Srinivas Kandagatla <srinivas.kandagatla-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Guenter Roeck <linux-0h96xk9xTtrk1uMJSBkQmQ@public.gmane.org>, Geert Uytterhoeven <geert+renesas-gXvu3+zWzMSzQB+pC5nmwQ@public.gmane.org>, =?iso-8859-1?Q?Beno=EEt?= Cousso <bcousson-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, May 13, 2015 at 03:10:25PM +0300, Pantelis Antoniou wrote:
> Hi Greg,
>=20
> > On May 13, 2015, at 14:55 , Greg Kroah-Hartman <gregkh@linuxfoundat=
ion.org> wrote:
> >=20
> > On Wed, May 13, 2015 at 10:59:41AM +0300, Pantelis Antoniou wrote:
> >> A cape loader based on DT overlays and DT objects.
> >>=20
> >> This is the beaglebone cape manager which allows capes to be autom=
atically
> >> probed and instantiated via means of a device tree overlay deduced=
 from
> >> the part-number and version contained on the cape's EEPROM.
> >>=20
> >> The reference manual contains information about the specification
> >> and the contents of the EEPROM.
> >>=20
> >> http://beagleboard.org/static/beaglebone/latest/Docs/Hardware/BONE=
_SRM.pdf
> >>=20
> >> Documentation about the workings of the cape manager is located
> >> in Documentation/misc-devices/bone_capemgr.txt
> >>=20
> >> This driver is using the EEPROM framework interface to retrieve
> >> the data stored on the baseboard and cape EEPROMs.
> >>=20
> >> Signed-off-by: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> >> ---
> >> drivers/misc/Kconfig        |   10 +
> >> drivers/misc/Makefile       |    1 +
> >> drivers/misc/bone_capemgr.c | 1926 +++++++++++++++++++++++++++++++=
++++++++++++
> >> 3 files changed, 1937 insertions(+)
> >> create mode 100644 drivers/misc/bone_capemgr.c
> >>=20
> >> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> >> index 006242c..f9e09e1 100644
> >> --- a/drivers/misc/Kconfig
> >> +++ b/drivers/misc/Kconfig
> >> @@ -515,6 +515,16 @@ config VEXPRESS_SYSCFG
> >> 	  bus. System Configuration interface is one of the possible mean=
s
> >> 	  of generating transactions on this bus.
> >>=20
> >> +config BONE_CAPEMGR
> >> +	tristate "Beaglebone cape manager"
> >> +	depends on ARCH_OMAP2PLUS && OF
> >> +	select EEPROM
> >> +	select OF_OVERLAY
> >> +	default n
> >=20
> > N is always the default, please remove.
> >=20
>=20
> OK
>=20
> >> +	help
> >> +	  Say Y here to include support for automatic loading of
> >> +	  beaglebone capes.
> >> +
> >=20
> > What about if it's a module?
> >=20
> >=20
>=20
> It should work but it=E2=80=99s going to be weird (i.e. no-one has us=
ed it as such).
> I=E2=80=99ll update the blurb.

You are saying it is a valid config option, so please test it as such,
or if it's not a valid config option, don't allow it.

> >> source "drivers/misc/c2port/Kconfig"
> >> source "drivers/misc/eeprom/Kconfig"
> >> source "drivers/misc/cb710/Kconfig"
> >> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> >> index 7d5c4cd..659b78b 100644
> >> --- a/drivers/misc/Makefile
> >> +++ b/drivers/misc/Makefile
> >> @@ -56,3 +56,4 @@ obj-$(CONFIG_GENWQE)		+=3D genwqe/
> >> obj-$(CONFIG_ECHO)		+=3D echo/
> >> obj-$(CONFIG_VEXPRESS_SYSCFG)	+=3D vexpress-syscfg.o
> >> obj-$(CONFIG_CXL_BASE)		+=3D cxl/
> >> +obj-$(CONFIG_BONE_CAPEMGR)	+=3D bone_capemgr.o
> >> diff --git a/drivers/misc/bone_capemgr.c b/drivers/misc/bone_capem=
gr.c
> >> new file mode 100644
> >> index 0000000..423719c
> >> --- /dev/null
> >> +++ b/drivers/misc/bone_capemgr.c
> >> @@ -0,0 +1,1926 @@
> >> +/*
> >> + * TI Beaglebone cape manager
> >> + *
> >> + * Copyright (C) 2012 Texas Instruments Inc.
> >> + * Copyright (C) 2012-2015 Konsulko Group.
> >> + * Author: Pantelis Antoniou <pantelis.antoniou-OWPKS81ov/FWk0Htik3J/w@public.gmane.org>
> >> + *
> >> + * This program is free software; you can redistribute it and/or =
modify
> >> + * it under the terms of the GNU General Public License as publis=
hed by
> >> + * the Free Software Foundation; either version 2 of the License,=
 or
> >> + * (at your option) any later version.
> >=20
> > I have to ask, do you really mean, "or any later version=E2=80=9D?
> >=20
>=20
> Yes, this is purely a community thing. No evil vendor at play at all.

I have no idea what that means.


> >> + *
> >> + * This program is distributed in the hope that it will be useful=
,
> >> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
> >> + * GNU General Public License for more details.
> >> + */
> >> +
> >> +#include <linux/module.h>
> >> +#include <linux/delay.h>
> >> +#include <linux/err.h>
> >> +#include <linux/interrupt.h>
> >> +#include <linux/completion.h>
> >> +#include <linux/platform_device.h>
> >> +#include <linux/clk.h>
> >> +#include <linux/io.h>
> >> +#include <linux/of.h>
> >> +#include <linux/of_device.h>
> >> +#include <linux/of_fdt.h>
> >> +#include <linux/slab.h>
> >> +#include <linux/pm_runtime.h>
> >> +#include <linux/pinctrl/consumer.h>
> >> +#include <linux/firmware.h>
> >> +#include <linux/err.h>
> >> +#include <linux/ctype.h>
> >> +#include <linux/string.h>
> >> +#include <linux/memory.h>
> >> +#include <linux/kthread.h>
> >> +#include <linux/wait.h>
> >> +#include <linux/file.h>
> >> +#include <linux/fs.h>
> >> +#include <linux/eeprom-consumer.h>
> >> +
> >> +/* disabled capes */
> >> +static char *disable_partno;
> >> +module_param(disable_partno, charp, 0444);
> >> +MODULE_PARM_DESC(disable_partno,
> >> +		"Comma delimited list of PART-NUMBER[:REV] of disabled capes");
> >> +
> >> +/* enable capes */
> >> +static char *enable_partno;
> >> +module_param(enable_partno, charp, 0444);
> >> +MODULE_PARM_DESC(enable_partno,
> >> +		"Comma delimited list of PART-NUMBER[:REV] of enabled capes");
> >> +
> >> +/* delay to scan on boot until rootfs appears */
> >> +static int boot_scan_period =3D 1000;
> >> +module_param(boot_scan_period, int, 0444);
> >> +MODULE_PARM_DESC(boot_scan_period,
> >> +		"boot scan period until rootfs firmware is available");
> >=20
> > Ick, no module parameters please, can't we drop these?
> >=20
>=20
> In a nutshell, no :)
>=20
> These has to be way to control whether a cape is disabled (if found) =
and enabled (if the manufacturer in it=E2=80=99s infinite wisdom remove=
d the EEPROM to save $0.01 per cape).

Please line-wrap your responses.

> The easiest way to achieve this is with the kernel command line.

No it is not.  You can't easily change the kernel command line for an
embedded system (or so everyone keeps telling me when I say things like
"just update your kernel command line!")  So embedded people can't have
it both ways, sorry.

Can't you put these in a dt file?

> > And we have a rootfs delay option already for the whole system, thi=
s
> > module shouldn't need a special one.
> >=20
>=20
> No, that won=E2=80=99t work.
>=20
> You see the problem is as follows.
>=20
> The capemanager is not built as a module, it is builtin.

Not according to your Kconfig file :)

> By the time the probe method is called the rootfs has no been mounted=
 yet.
> This is actually what we want for the cases where the rootfs resides =
on a cape and
> the cape=E2=80=99s dtbo firmware file is built-in the kernel image.
>=20
> This does not work when the firmware file is located in the rootfs fi=
lesystem, since
> the call to request_firmware will fail at that time.

Then you let it happen later.  Or do it async.  Don't create new comman=
d
line options for when we already have the same command line option!

> That option controls the polling delay until the system boot state in=
dicates that the
> rootfs is available and the call will succeed.

If this is such an issue, just sit and spin and wait for it to show up.

> There are lots of warts in our firmware loader.

You can fix them, don't make the kernel work around the warts because
you don't want to :)

thanks,

greg k-h

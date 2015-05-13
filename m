From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: Re: [PATCH 1/5] misc: Beaglebone capemanager
Date: Wed, 13 May 2015 15:10:25 +0300
Message-ID: <67B17BCF-0489-4FD6-88F0-57B6187BEFEB@konsulko.com>
References: <1431503985-31853-1-git-send-email-pantelis.antoniou@konsulko.com> <1431503985-31853-2-git-send-email-pantelis.antoniou@konsulko.com> <20150513115514.GB1021@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150513115514.GB1021@kroah.com>
Sender: linux-doc-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Robert Nelson <robertcnelson@gmail.com>, Rob Herring <robherring2@gmail.com>, Grant Likely <grant.likely@secretlab.ca>, Jonathan Corbet <corbet@lwn.net>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Guenter Roeck <linux@roeck-us.net>, Geert Uytterhoeven <geert+renesas@glider.be>, =?utf-8?Q?Beno=C3=AEt_Cousso?= <bcousson@baylibre.com>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Greg,

> On May 13, 2015, at 14:55 , Greg Kroah-Hartman <gregkh@linuxfoundatio=
n.org> wrote:
>=20
> On Wed, May 13, 2015 at 10:59:41AM +0300, Pantelis Antoniou wrote:
>> A cape loader based on DT overlays and DT objects.
>>=20
>> This is the beaglebone cape manager which allows capes to be automat=
ically
>> probed and instantiated via means of a device tree overlay deduced f=
rom
>> the part-number and version contained on the cape's EEPROM.
>>=20
>> The reference manual contains information about the specification
>> and the contents of the EEPROM.
>>=20
>> http://beagleboard.org/static/beaglebone/latest/Docs/Hardware/BONE_S=
RM.pdf
>>=20
>> Documentation about the workings of the cape manager is located
>> in Documentation/misc-devices/bone_capemgr.txt
>>=20
>> This driver is using the EEPROM framework interface to retrieve
>> the data stored on the baseboard and cape EEPROMs.
>>=20
>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>> ---
>> drivers/misc/Kconfig        |   10 +
>> drivers/misc/Makefile       |    1 +
>> drivers/misc/bone_capemgr.c | 1926 +++++++++++++++++++++++++++++++++=
++++++++++
>> 3 files changed, 1937 insertions(+)
>> create mode 100644 drivers/misc/bone_capemgr.c
>>=20
>> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
>> index 006242c..f9e09e1 100644
>> --- a/drivers/misc/Kconfig
>> +++ b/drivers/misc/Kconfig
>> @@ -515,6 +515,16 @@ config VEXPRESS_SYSCFG
>> 	  bus. System Configuration interface is one of the possible means
>> 	  of generating transactions on this bus.
>>=20
>> +config BONE_CAPEMGR
>> +	tristate "Beaglebone cape manager"
>> +	depends on ARCH_OMAP2PLUS && OF
>> +	select EEPROM
>> +	select OF_OVERLAY
>> +	default n
>=20
> N is always the default, please remove.
>=20

OK

>> +	help
>> +	  Say Y here to include support for automatic loading of
>> +	  beaglebone capes.
>> +
>=20
> What about if it's a module?
>=20
>=20

It should work but it=E2=80=99s going to be weird (i.e. no-one has used=
 it as such).
I=E2=80=99ll update the blurb.

>> source "drivers/misc/c2port/Kconfig"
>> source "drivers/misc/eeprom/Kconfig"
>> source "drivers/misc/cb710/Kconfig"
>> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
>> index 7d5c4cd..659b78b 100644
>> --- a/drivers/misc/Makefile
>> +++ b/drivers/misc/Makefile
>> @@ -56,3 +56,4 @@ obj-$(CONFIG_GENWQE)		+=3D genwqe/
>> obj-$(CONFIG_ECHO)		+=3D echo/
>> obj-$(CONFIG_VEXPRESS_SYSCFG)	+=3D vexpress-syscfg.o
>> obj-$(CONFIG_CXL_BASE)		+=3D cxl/
>> +obj-$(CONFIG_BONE_CAPEMGR)	+=3D bone_capemgr.o
>> diff --git a/drivers/misc/bone_capemgr.c b/drivers/misc/bone_capemgr=
=2Ec
>> new file mode 100644
>> index 0000000..423719c
>> --- /dev/null
>> +++ b/drivers/misc/bone_capemgr.c
>> @@ -0,0 +1,1926 @@
>> +/*
>> + * TI Beaglebone cape manager
>> + *
>> + * Copyright (C) 2012 Texas Instruments Inc.
>> + * Copyright (C) 2012-2015 Konsulko Group.
>> + * Author: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>> + *
>> + * This program is free software; you can redistribute it and/or mo=
dify
>> + * it under the terms of the GNU General Public License as publishe=
d by
>> + * the Free Software Foundation; either version 2 of the License, o=
r
>> + * (at your option) any later version.
>=20
> I have to ask, do you really mean, "or any later version=E2=80=9D?
>=20

Yes, this is purely a community thing. No evil vendor at play at all.
=20
>=20
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>> + * GNU General Public License for more details.
>> + */
>> +
>> +#include <linux/module.h>
>> +#include <linux/delay.h>
>> +#include <linux/err.h>
>> +#include <linux/interrupt.h>
>> +#include <linux/completion.h>
>> +#include <linux/platform_device.h>
>> +#include <linux/clk.h>
>> +#include <linux/io.h>
>> +#include <linux/of.h>
>> +#include <linux/of_device.h>
>> +#include <linux/of_fdt.h>
>> +#include <linux/slab.h>
>> +#include <linux/pm_runtime.h>
>> +#include <linux/pinctrl/consumer.h>
>> +#include <linux/firmware.h>
>> +#include <linux/err.h>
>> +#include <linux/ctype.h>
>> +#include <linux/string.h>
>> +#include <linux/memory.h>
>> +#include <linux/kthread.h>
>> +#include <linux/wait.h>
>> +#include <linux/file.h>
>> +#include <linux/fs.h>
>> +#include <linux/eeprom-consumer.h>
>> +
>> +/* disabled capes */
>> +static char *disable_partno;
>> +module_param(disable_partno, charp, 0444);
>> +MODULE_PARM_DESC(disable_partno,
>> +		"Comma delimited list of PART-NUMBER[:REV] of disabled capes");
>> +
>> +/* enable capes */
>> +static char *enable_partno;
>> +module_param(enable_partno, charp, 0444);
>> +MODULE_PARM_DESC(enable_partno,
>> +		"Comma delimited list of PART-NUMBER[:REV] of enabled capes");
>> +
>> +/* delay to scan on boot until rootfs appears */
>> +static int boot_scan_period =3D 1000;
>> +module_param(boot_scan_period, int, 0444);
>> +MODULE_PARM_DESC(boot_scan_period,
>> +		"boot scan period until rootfs firmware is available");
>=20
> Ick, no module parameters please, can't we drop these?
>=20

In a nutshell, no :)

These has to be way to control whether a cape is disabled (if found) an=
d enabled (if the manufacturer in it=E2=80=99s infinite wisdom removed =
the EEPROM to save $0.01 per cape).

The easiest way to achieve this is with the kernel command line.

> And we have a rootfs delay option already for the whole system, this
> module shouldn't need a special one.
>=20

No, that won=E2=80=99t work.

You see the problem is as follows.

The capemanager is not built as a module, it is builtin.

By the time the probe method is called the rootfs has no been mounted y=
et.
This is actually what we want for the cases where the rootfs resides on=
 a cape and
the cape=E2=80=99s dtbo firmware file is built-in the kernel image.

This does not work when the firmware file is located in the rootfs file=
system, since
the call to request_firmware will fail at that time.

That option controls the polling delay until the system boot state indi=
cates that the
rootfs is available and the call will succeed.

There are lots of warts in our firmware loader.

> thanks,
>=20
> greg k-h

Regards

=E2=80=94 Pantelis


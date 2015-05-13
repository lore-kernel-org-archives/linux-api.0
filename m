From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Subject: Re: [PATCH 1/5] misc: Beaglebone capemanager
Date: Wed, 13 May 2015 18:51:57 +0300
Message-ID: <8D8A507E-68BA-430D-A0EB-282C187DE830@konsulko.com>
References: <1431503985-31853-1-git-send-email-pantelis.antoniou@konsulko.com> <1431503985-31853-2-git-send-email-pantelis.antoniou@konsulko.com> <20150513115514.GB1021@kroah.com> <67B17BCF-0489-4FD6-88F0-57B6187BEFEB@konsulko.com> <20150513153609.GB11677@kroah.com>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2098\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <20150513153609.GB11677@kroah.com>
Sender: linux-doc-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Porter <mporter@konsulko.com>, Koen Kooi <koen@dominion.thruhere.net>, Robert Nelson <robertcnelson@gmail.com>, Rob Herring <robherring2@gmail.com>, Grant Likely <grant.likely@secretlab.ca>, Jonathan Corbet <corbet@lwn.net>, Srinivas Kandagatla <srinivas.kandagatla@linaro.org>, Guenter Roeck <linux@roeck-us.net>, Geert Uytterhoeven <geert+renesas@glider.be>, =?utf-8?Q?Beno=C3=AEt_Cousso?= <bcousson@baylibre.com>, linux-api@vger.kernel.org, linux-doc@vger.kernel.org, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi Greg,

> On May 13, 2015, at 18:36 , Greg Kroah-Hartman <gregkh@linuxfoundatio=
n.org> wrote:
>=20
> On Wed, May 13, 2015 at 03:10:25PM +0300, Pantelis Antoniou wrote:
>> Hi Greg,
>>=20
>>> On May 13, 2015, at 14:55 , Greg Kroah-Hartman <gregkh@linuxfoundat=
ion.org> wrote:
>>>=20
>>> On Wed, May 13, 2015 at 10:59:41AM +0300, Pantelis Antoniou wrote:
>>>> A cape loader based on DT overlays and DT objects.
>>>>=20
>>>> This is the beaglebone cape manager which allows capes to be autom=
atically
>>>> probed and instantiated via means of a device tree overlay deduced=
 from
>>>> the part-number and version contained on the cape's EEPROM.
>>>>=20
>>>> The reference manual contains information about the specification
>>>> and the contents of the EEPROM.
>>>>=20
>>>> http://beagleboard.org/static/beaglebone/latest/Docs/Hardware/BONE=
_SRM.pdf
>>>>=20
>>>> Documentation about the workings of the cape manager is located
>>>> in Documentation/misc-devices/bone_capemgr.txt
>>>>=20
>>>> This driver is using the EEPROM framework interface to retrieve
>>>> the data stored on the baseboard and cape EEPROMs.
>>>>=20
>>>> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>>>> ---
>>>> drivers/misc/Kconfig        |   10 +
>>>> drivers/misc/Makefile       |    1 +
>>>> drivers/misc/bone_capemgr.c | 1926 +++++++++++++++++++++++++++++++=
++++++++++++
>>>> 3 files changed, 1937 insertions(+)
>>>> create mode 100644 drivers/misc/bone_capemgr.c
>>>>=20
>>>> diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
>>>> index 006242c..f9e09e1 100644
>>>> --- a/drivers/misc/Kconfig
>>>> +++ b/drivers/misc/Kconfig
>>>> @@ -515,6 +515,16 @@ config VEXPRESS_SYSCFG
>>>> 	  bus. System Configuration interface is one of the possible mean=
s
>>>> 	  of generating transactions on this bus.
>>>>=20
>>>> +config BONE_CAPEMGR
>>>> +	tristate "Beaglebone cape manager"
>>>> +	depends on ARCH_OMAP2PLUS && OF
>>>> +	select EEPROM
>>>> +	select OF_OVERLAY
>>>> +	default n
>>>=20
>>> N is always the default, please remove.
>>>=20
>>=20
>> OK
>>=20
>>>> +	help
>>>> +	  Say Y here to include support for automatic loading of
>>>> +	  beaglebone capes.
>>>> +
>>>=20
>>> What about if it's a module?
>>>=20
>>>=20
>>=20
>> It should work but it=E2=80=99s going to be weird (i.e. no-one has u=
sed it as such).
>> I=E2=80=99ll update the blurb.
>=20
> You are saying it is a valid config option, so please test it as such=
,
> or if it's not a valid config option, don't allow it.
>=20

It is a valid option, just no-one has a use for it. Who knows what kind=
 of
crazy setup the end-users will use.

I=E2=80=99ll test it as a module to make sure.

>>>> source "drivers/misc/c2port/Kconfig"
>>>> source "drivers/misc/eeprom/Kconfig"
>>>> source "drivers/misc/cb710/Kconfig"
>>>> diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
>>>> index 7d5c4cd..659b78b 100644
>>>> --- a/drivers/misc/Makefile
>>>> +++ b/drivers/misc/Makefile
>>>> @@ -56,3 +56,4 @@ obj-$(CONFIG_GENWQE)		+=3D genwqe/
>>>> obj-$(CONFIG_ECHO)		+=3D echo/
>>>> obj-$(CONFIG_VEXPRESS_SYSCFG)	+=3D vexpress-syscfg.o
>>>> obj-$(CONFIG_CXL_BASE)		+=3D cxl/
>>>> +obj-$(CONFIG_BONE_CAPEMGR)	+=3D bone_capemgr.o
>>>> diff --git a/drivers/misc/bone_capemgr.c b/drivers/misc/bone_capem=
gr.c
>>>> new file mode 100644
>>>> index 0000000..423719c
>>>> --- /dev/null
>>>> +++ b/drivers/misc/bone_capemgr.c
>>>> @@ -0,0 +1,1926 @@
>>>> +/*
>>>> + * TI Beaglebone cape manager
>>>> + *
>>>> + * Copyright (C) 2012 Texas Instruments Inc.
>>>> + * Copyright (C) 2012-2015 Konsulko Group.
>>>> + * Author: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or =
modify
>>>> + * it under the terms of the GNU General Public License as publis=
hed by
>>>> + * the Free Software Foundation; either version 2 of the License,=
 or
>>>> + * (at your option) any later version.
>>>=20
>>> I have to ask, do you really mean, "or any later version=E2=80=9D?
>>>=20
>>=20
>> Yes, this is purely a community thing. No evil vendor at play at all=
=2E
>=20
> I have no idea what that means.
>=20
>=20

That this is purely work for the community. No-one pays for it.

>>>> + *
>>>> + * This program is distributed in the hope that it will be useful=
,
>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
>>>> + * GNU General Public License for more details.
>>>> + */
>>>> +
>>>> +#include <linux/module.h>
>>>> +#include <linux/delay.h>
>>>> +#include <linux/err.h>
>>>> +#include <linux/interrupt.h>
>>>> +#include <linux/completion.h>
>>>> +#include <linux/platform_device.h>
>>>> +#include <linux/clk.h>
>>>> +#include <linux/io.h>
>>>> +#include <linux/of.h>
>>>> +#include <linux/of_device.h>
>>>> +#include <linux/of_fdt.h>
>>>> +#include <linux/slab.h>
>>>> +#include <linux/pm_runtime.h>
>>>> +#include <linux/pinctrl/consumer.h>
>>>> +#include <linux/firmware.h>
>>>> +#include <linux/err.h>
>>>> +#include <linux/ctype.h>
>>>> +#include <linux/string.h>
>>>> +#include <linux/memory.h>
>>>> +#include <linux/kthread.h>
>>>> +#include <linux/wait.h>
>>>> +#include <linux/file.h>
>>>> +#include <linux/fs.h>
>>>> +#include <linux/eeprom-consumer.h>
>>>> +
>>>> +/* disabled capes */
>>>> +static char *disable_partno;
>>>> +module_param(disable_partno, charp, 0444);
>>>> +MODULE_PARM_DESC(disable_partno,
>>>> +		"Comma delimited list of PART-NUMBER[:REV] of disabled capes");
>>>> +
>>>> +/* enable capes */
>>>> +static char *enable_partno;
>>>> +module_param(enable_partno, charp, 0444);
>>>> +MODULE_PARM_DESC(enable_partno,
>>>> +		"Comma delimited list of PART-NUMBER[:REV] of enabled capes");
>>>> +
>>>> +/* delay to scan on boot until rootfs appears */
>>>> +static int boot_scan_period =3D 1000;
>>>> +module_param(boot_scan_period, int, 0444);
>>>> +MODULE_PARM_DESC(boot_scan_period,
>>>> +		"boot scan period until rootfs firmware is available");
>>>=20
>>> Ick, no module parameters please, can't we drop these?
>>>=20
>>=20
>> In a nutshell, no :)
>>=20
>> These has to be way to control whether a cape is disabled (if found)=
 and enabled (if the manufacturer in it=E2=80=99s infinite wisdom remov=
ed the EEPROM to save $0.01 per cape).
>=20
> Please line-wrap your responses.
>=20
>> The easiest way to achieve this is with the kernel command line.
>=20
> No it is not.  You can't easily change the kernel command line for an
> embedded system (or so everyone keeps telling me when I say things li=
ke
> "just update your kernel command line!")  So embedded people can't ha=
ve
> it both ways, sorry.
>=20

Depends on the embedded system. On the ones I=E2=80=99m working with a =
sane bootloader
(for example u-boot) the command line is easily modified.

> Can't you put these in a dt file?
>=20

Do you really want to start this argument? Didn=E2=80=99t we used to ha=
ve great flamewars
about putting linux specific things in the DT?

Does enabling & disabling capes fall into =E2=80=98hardware description=
=E2=80=99?

I guess we=E2=80=99ll have to ask the DT maintainers for that.

Rob, Grant?=20

>>> And we have a rootfs delay option already for the whole system, thi=
s
>>> module shouldn't need a special one.
>>>=20
>>=20
>> No, that won=E2=80=99t work.
>>=20
>> You see the problem is as follows.
>>=20
>> The capemanager is not built as a module, it is builtin.
>=20
> Not according to your Kconfig file :)
>=20

Touch=C3=A9

>> By the time the probe method is called the rootfs has no been mounte=
d yet.
>> This is actually what we want for the cases where the rootfs resides=
 on a cape and
>> the cape=E2=80=99s dtbo firmware file is built-in the kernel image.
>>=20
>> This does not work when the firmware file is located in the rootfs f=
ilesystem, since
>> the call to request_firmware will fail at that time.
>=20
> Then you let it happen later.  Or do it async.  Don't create new comm=
and
> line options for when we already have the same command line option!
>=20

Err, the two options are nothing alike no? One deals is defined as:

rootdelay: "Delay (in seconds) to pause before attempting to mount the =
root filesystem"

The other is the period with which to perform period firmware requests.

>> That option controls the polling delay until the system boot state i=
ndicates that the
>> rootfs is available and the call will succeed.
>=20
> If this is such an issue, just sit and spin and wait for it to show u=
p.
>=20

I can do that; that would get rid of the option too.

>> There are lots of warts in our firmware loader.
>=20
> You can fix them, don't make the kernel work around the warts because
> you don't want to :)
>=20

Yes, but that=E2=80=99s not the case here. I have in mind fixing some p=
roblems with the
firmware loader, but http://www.imdb.com/title/tt0070355/quotes?item=3D=
qt1629888


> thanks,
>=20
> greg k-h


Regards

=E2=80=94 Pantelis


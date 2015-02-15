From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Subject: Re: [PATCH 00/14] Add support to STMicroelectronics STM32 family
Date: Sun, 15 Feb 2015 16:14:12 +0100
Message-ID: <54E0B7C4.7050900@suse.de>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="95i9U1kwvGuqWFIAJoHA3lRp5dcDBiePX"
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-gpio-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Philipp Zabel <p.zabel@pengutronix.de>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees
List-Id: linux-api@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--95i9U1kwvGuqWFIAJoHA3lRp5dcDBiePX
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Hi Maxime,

Am 12.02.2015 um 18:45 schrieb Maxime Coquelin:
> This patchset adds basic support for STMicroelectronics STM32 series MC=
Us.
>=20
> STM32 MCUs are Cortex-M CPU, used in various applications (consumer
> electronics, industrial applications, hobbyists...).
> Datasheets, user and programming manuals are publicly available on
> STMicroelectronics website.
>=20
> With this series applied, the STM32F419 Discovery can boot succesfully.=

>=20
> Once this series accepted, next steps will be to add DMA support, as US=
ART,
> I2C and SPI IPs don't have any FIFO. Then will come the clock driver, a=
s today
> the bootloader has to be patched to enable the needed clocks.

This is somewhat unfortunate, as I have been working on the same thing
and have demonstrated the STM32F429 Discovery Kit at ARM TechSymposium
Europe in December and submitted a talk for LinuxCon Japan.

https://github.com/afaerber/afboot-stm32
https://github.com/afaerber/linux/commits/stm32

On a brief look, it seems you are further along in terms of code quality
and documenting. Do you spot anything that's missing in your series and
could be added from my branch? The clk controller maybe? Also I already
started looking into gpio and usb drivers. Me too, I skipped DMA support
though.

Regards,
Andreas

>=20
> Maxime Coquelin (14):
>   scripts: link-vmlinux: Don't pass page offset to kallsyms if XIP
>     Kernel
>   ARM: ARMv7M: Enlarge vector table to 256 entries
>   clocksource: Add ARM System timer driver
>   reset: Add reset_controller_of_init() function
>   ARM: call reset_controller_of_init from default time_init handler
>   drivers: reset: Add STM32 reset driver
>   clockevent: Add STM32 Timer driver
>   pinctrl: Add pinctrl driver for STM32 MCUs
>   serial: stm32-usart: Add STM32 USART Driver
>   ARM: Add STM32 family machine
>   ARM: dts: Add ARM System timer as clockevent in armv7m
>   ARM: dts: Introduce STM32F429 MCU
>   ARM: configs: Add STM32 defconfig
>   MAINTAINERS: Add entry for STM32 MCUs
>=20
>  Documentation/arm/stm32/overview.txt               |  32 +
>  Documentation/arm/stm32/stm32f429-overview.txt     |  22 +
>  .../devicetree/bindings/arm/system_timer.txt       |  15 +
>  .../devicetree/bindings/pinctrl/pinctrl-stm32.txt  |  99 +++
>  .../devicetree/bindings/reset/st,stm32-reset.txt   |  19 +
>  .../devicetree/bindings/serial/st,stm32-usart.txt  |  18 +
>  .../devicetree/bindings/timer/st,stm32-timer.txt   |  19 +
>  MAINTAINERS                                        |   7 +
>  arch/arm/Kconfig                                   |  22 +
>  arch/arm/Makefile                                  |   1 +
>  arch/arm/boot/dts/Makefile                         |   1 +
>  arch/arm/boot/dts/armv7-m.dtsi                     |   7 +
>  arch/arm/boot/dts/stm32f429-disco.dts              |  41 ++
>  arch/arm/boot/dts/stm32f429.dtsi                   | 279 ++++++++
>  arch/arm/configs/stm32_defconfig                   |  72 ++
>  arch/arm/kernel/entry-v7m.S                        |   8 +-
>  arch/arm/kernel/time.c                             |   4 +
>  arch/arm/mach-stm32/Makefile                       |   1 +
>  arch/arm/mach-stm32/Makefile.boot                  |   0
>  arch/arm/mach-stm32/board-dt.c                     |  19 +
>  drivers/clocksource/Kconfig                        |  16 +
>  drivers/clocksource/Makefile                       |   2 +
>  drivers/clocksource/arm_system_timer.c             |  74 ++
>  drivers/clocksource/timer-stm32.c                  | 187 +++++
>  drivers/pinctrl/Kconfig                            |   9 +
>  drivers/pinctrl/Makefile                           |   1 +
>  drivers/pinctrl/pinctrl-stm32.c                    | 779 +++++++++++++=
++++++++
>  drivers/reset/Makefile                             |   1 +
>  drivers/reset/core.c                               |  20 +
>  drivers/reset/reset-stm32.c                        | 124 ++++
>  drivers/tty/serial/Kconfig                         |  17 +
>  drivers/tty/serial/Makefile                        |   1 +
>  drivers/tty/serial/stm32-usart.c                   | 695 +++++++++++++=
+++++
>  include/asm-generic/vmlinux.lds.h                  |   4 +-
>  include/dt-bindings/pinctrl/pinctrl-stm32.h        |  43 ++
>  include/linux/reset-controller.h                   |   6 +
>  include/uapi/linux/serial_core.h                   |   3 +
>  scripts/link-vmlinux.sh                            |   2 +-
>  38 files changed, 2664 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/arm/stm32/overview.txt
>  create mode 100644 Documentation/arm/stm32/stm32f429-overview.txt
>  create mode 100644 Documentation/devicetree/bindings/arm/system_timer.=
txt
>  create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-s=
tm32.txt
>  create mode 100644 Documentation/devicetree/bindings/reset/st,stm32-re=
set.txt
>  create mode 100644 Documentation/devicetree/bindings/serial/st,stm32-u=
sart.txt
>  create mode 100644 Documentation/devicetree/bindings/timer/st,stm32-ti=
mer.txt
>  create mode 100644 arch/arm/boot/dts/stm32f429-disco.dts
>  create mode 100644 arch/arm/boot/dts/stm32f429.dtsi
>  create mode 100644 arch/arm/configs/stm32_defconfig
>  create mode 100644 arch/arm/mach-stm32/Makefile
>  create mode 100644 arch/arm/mach-stm32/Makefile.boot
>  create mode 100644 arch/arm/mach-stm32/board-dt.c
>  create mode 100644 drivers/clocksource/arm_system_timer.c
>  create mode 100644 drivers/clocksource/timer-stm32.c
>  create mode 100644 drivers/pinctrl/pinctrl-stm32.c
>  create mode 100644 drivers/reset/reset-stm32.c
>  create mode 100644 drivers/tty/serial/stm32-usart.c
>  create mode 100644 include/dt-bindings/pinctrl/pinctrl-stm32.h
>=20


--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Felix Imend=F6rffer, Jane Smithard, Jennifer Guild, Dilip Upmanyu,
Graham Norton; HRB 21284 (AG N=FCrnberg)


--95i9U1kwvGuqWFIAJoHA3lRp5dcDBiePX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJU4LfEAAoJEPou0S0+fgE//zYP/0EeKpvBKU08wt7+ELInpcJP
ak50cp7i1usajMEgEjeEH7VeM+0MiGWLvEfFUOTnqidzo07aRG66svOL8orTVcW3
GZL5MGm3zFsGGnZqff19CnRMcz2ys3BoqylCw4ya9iFD3tycqGthp7Zl6J7sZORD
bi6Jk75LB4QEaMxAueQ8GbAQ/tswioGua7GByW0seRe2HiLS4/nDrgWnfkfdsobc
TpyUvNCBz3HLg7/5VomZ+CfnEK0jjH2AJ3I3+y+RHVerbGN6QxcyPc7j1Lprre+N
SafndVvs3pKb5jfgwDV4UUmzGxV4B0Tx4B336X+Zz0QhdzuWRJ4zfumQi1V8l6iD
b8fh1TMxhluOcP6V0rwhpWLBFVzyOZjcA9hAJ+3ul0udLGvqVofGui6FCjpNNhVu
BP8J4gb78HIao+bPImCs32xfSJ+EQdZIoGCXt6iFA6Co2pOUyn3dqoC200JqNoL3
UOmU30VqfEvf3xyvyhSVl65XZnlkOw+HDKAbtJYaAFnHlNNzuxF4B7khcumbbPiz
afWKJJXFfun50Y80SdZCzaf4E3kZ43j0c9KxjA0NZf1FlC1XqixQ6LkI9BRaaRnH
GfHvjnBwPznT5/6F2DT2Na7GqbGkxCCKHNO01vZuJNX47sUPSTOO1Kkjszs6SrVt
sbkXP7xSgMjDuE/BcIOg
=yIcJ
-----END PGP SIGNATURE-----

--95i9U1kwvGuqWFIAJoHA3lRp5dcDBiePX--

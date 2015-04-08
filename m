From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v6 00/15] Add support to STMicroelectronics STM32 family
Date: Wed, 8 Apr 2015 11:14:30 +0200
Message-ID: <CALszF6BMKC8XLgdjsRBpRAZLOpg3OP56uh_HOmsxL0DruxOK0w@mail.gmail.com>
References: <1428424234-28572-1-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428424234-28572-1-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, olof-nZhT3qVonbNeoWH0uzbU5w@public.gmane.org
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Greg Kroah-Hartman <gregkh@linu>
List-Id: linux-api@vger.kernel.org

Hi Arnd, Olof,

2015-04-07 18:30 GMT+02:00 Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
> This sixth round adds minor fixes to USART driver, and adds some Acks.
>
> STM32 MCUs are Cortex-M CPU, used in various applications (consumer
> electronics, industrial applications, hobbyists...).
> Datasheets, user and programming manuals are publicly available on
> STMicroelectronics website.
>
> With this series applied, the STM32F419 Discovery can boot succesfully.
>
> Changes since v5:
> -----------------
>  - Change st,hw-flow-ctrl property to auto-flow-control (Rob)
>  - Constify stm32_uart_ops (Joe)
>  - Propagate request_irq error in USART driver (Andy)
>  - Applies Acked-by and Reviewed-by (Rob, Peter)
>
> Changes since v4:
> -----------------
>  - Cosmetic changes in USART driver (Andy)
>  - Apply Acks on reset driver & bindings (Philipp & Rob)
>
> Changes since v3:
> -----------------
>  - Fix and simplify error path in ARMv7-M Systick driver (Daniel)
>  - Improve reset bindings documentation (Philipp)
>  - Fix trailing lines anf typos in reset driver & doc (Philipp & Chanwoo)
>  - Fix MODULE_LICENCE in USART driver (Paul)
>  - Refactor USART baudrate calculation (Peter & Andy)
>  - Fix error path in USART init (Peter & Russell)
>  - Fix HW flow control in USART driver (Peter)
>  - Fix serial port type number to unused one (Peter)
>  - Applies Chanwoo's Tested-by on the series
>
> Changes since v2:
> -----------------
>  - Remove pinctrl driver from the series.
>  - Remove reset_controller_of_init(), and reset the timers in the bootloader
>  - Add HW flow contrl property for serial driver
>  - Lots of changes in the DTS file, as per Andreas recommendations
>  - Some Kconfig clean-ups
>  - Adapt the config to be compatible with Andreas' bootwrapper, except UART port.
>  - Various fixes in documentation
>
> Changes since v1:
> -----------------
>  - Move bindings documentation in their own patches (Andreas)
>  - Rename ARM System timer to armv7m-systick (Rob)
>  - Add clock-frequency property handling in armv7m-systick (Rob)
>  - Re-factor the reset controllers into a single controller (Philipp)
>  - Add kerneldoc to reset_controller_of_init (Philipp)
>  - Add named constants in include/dt-bindings/reset/ (Philipp)
>  - Make pinctrl driver to depend on ARCH_STM32 or COMPILE_TEST (Geert)
>  - Introduce CPUV7M_NUM_IRQ config flag to indicate the number of interrupts
> supported by the MCU, in order to limit memory waste in vectors' table (Uwe)
>
> Maxime Coquelin (15):
>   scripts: link-vmlinux: Don't pass page offset to kallsyms if XIP
>     Kernel
>   ARM: ARMv7-M: Enlarge vector table up to 256 entries
>   dt-bindings: Document the ARM System timer bindings
>   clocksource/drivers: Add ARM System timer driver
>   dt-bindings: Document the STM32 reset bindings
>   drivers: reset: Add STM32 reset driver
>   dt-bindings: Document the STM32 timer bindings
>   clockevents/drivers: Add STM32 Timer driver
>   dt-bindings: Document the STM32 USART bindings
>   serial: stm32-usart: Add STM32 USART Driver
>   ARM: Add STM32 family machine
>   ARM: dts: Add ARM System timer as clockevent in armv7m
>   ARM: dts: Introduce STM32F429 MCU
>   ARM: configs: Add STM32 defconfig
>   MAINTAINERS: Add entry for STM32 MCUs
>
>  Documentation/arm/stm32/overview.txt               |  32 +
>  Documentation/arm/stm32/stm32f429-overview.txt     |  22 +
>  .../devicetree/bindings/arm/armv7m_systick.txt     |  26 +
>  .../devicetree/bindings/reset/st,stm32-rcc.txt     | 107 +++
>  .../devicetree/bindings/serial/st,stm32-usart.txt  |  32 +
>  .../devicetree/bindings/timer/st,stm32-timer.txt   |  22 +
>  MAINTAINERS                                        |   8 +
>  arch/arm/Kconfig                                   |  18 +
>  arch/arm/Makefile                                  |   1 +
>  arch/arm/boot/dts/Makefile                         |   1 +
>  arch/arm/boot/dts/armv7-m.dtsi                     |   6 +
>  arch/arm/boot/dts/stm32f429-disco.dts              |  71 ++
>  arch/arm/boot/dts/stm32f429.dtsi                   | 226 +++++++
>  arch/arm/configs/stm32_defconfig                   |  71 ++
>  arch/arm/kernel/entry-v7m.S                        |  13 +-
>  arch/arm/mach-stm32/Makefile                       |   1 +
>  arch/arm/mach-stm32/Makefile.boot                  |   3 +
>  arch/arm/mach-stm32/board-dt.c                     |  19 +
>  arch/arm/mm/Kconfig                                |  15 +
>  drivers/clocksource/Kconfig                        |  15 +
>  drivers/clocksource/Makefile                       |   2 +
>  drivers/clocksource/armv7m_systick.c               |  79 +++
>  drivers/clocksource/timer-stm32.c                  | 184 ++++++
>  drivers/reset/Makefile                             |   1 +
>  drivers/reset/reset-stm32.c                        | 124 ++++
>  drivers/tty/serial/Kconfig                         |  17 +
>  drivers/tty/serial/Makefile                        |   1 +
>  drivers/tty/serial/stm32-usart.c                   | 735 +++++++++++++++++++++
>  include/uapi/linux/serial_core.h                   |   3 +
>  scripts/link-vmlinux.sh                            |   2 +-
>  30 files changed, 1852 insertions(+), 5 deletions(-)
>  create mode 100644 Documentation/arm/stm32/overview.txt
>  create mode 100644 Documentation/arm/stm32/stm32f429-overview.txt
>  create mode 100644 Documentation/devicetree/bindings/arm/armv7m_systick.txt
>  create mode 100644 Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
>  create mode 100644 Documentation/devicetree/bindings/serial/st,stm32-usart.txt
>  create mode 100644 Documentation/devicetree/bindings/timer/st,stm32-timer.txt
>  create mode 100644 arch/arm/boot/dts/stm32f429-disco.dts
>  create mode 100644 arch/arm/boot/dts/stm32f429.dtsi
>  create mode 100644 arch/arm/configs/stm32_defconfig
>  create mode 100644 arch/arm/mach-stm32/Makefile
>  create mode 100644 arch/arm/mach-stm32/Makefile.boot
>  create mode 100644 arch/arm/mach-stm32/board-dt.c
>  create mode 100644 drivers/clocksource/armv7m_systick.c
>  create mode 100644 drivers/clocksource/timer-stm32.c
>  create mode 100644 drivers/reset/reset-stm32.c
>  create mode 100644 drivers/tty/serial/stm32-usart.c
>
> --
> 1.9.1
>

Do you think we could consider this series for v4.1?
I can prepare a pull request if needed.

Maybe it is too late, but since it is mainly new files, the risk of
conflicts is rather low.

Kind regards,
Maxime

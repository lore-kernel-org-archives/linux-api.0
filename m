From: Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH v3  00/15] Add support to STMicroelectronics STM32 family
Date: Fri, 13 Mar 2015 08:45:14 +0900
Message-ID: <5502250A.8090900@samsung.com>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-gpio-owner@vger.kernel.org>
In-reply-to: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
Sender: linux-gpio-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, stefan@agner.ch, pmeerw@pmeerw.net, pebolle@tiscali.nl, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.>
List-Id: linux-api@vger.kernel.org

Dear Maxime,

I'm working for STM32 SoC. So, I'm very interesting in this patch-set.
If you possible, please add me to Cc list on next patch-set.

Best Regards,
Chanwoo Choi


On 03/13/2015 06:55 AM, Maxime Coquelin wrote:
> From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> 
> This third round tries to address most of the comments made on previous series.
> 
> It contains few less patches, as the reset_controller_of_init() patch has been
> removed, now that the bootlaoder handles the reset of the timers.
> 
> The pinctrl driver has also been removed after Linus review.
> It will be reworked to use the generic pinconf bindings, and may contain
> changes for other machines (Mediatek), to add support for pinmux property
> handling directly in pinconf-generic.
> 
> STM32 MCUs are Cortex-M CPU, used in various applications (consumer
> electronics, industrial applications, hobbyists...).
> Datasheets, user and programming manuals are publicly available on
> STMicroelectronics website.
> 
> With this series applied, the STM32F419 Discovery can boot succesfully.
> 
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
> 
> Maxime Coquelin (15):
>   scripts: link-vmlinux: Don't pass page offset to kallsyms if XIP
>     Kernel
>   ARM: ARMv7-M: Enlarge vector table up to 256 entries
>   dt-bindings: Document the ARM System timer bindings
>   clocksource: Add ARM System timer driver
>   dt-bindings: Document the STM32 reset bindings
>   drivers: reset: Add STM32 reset driver
>   dt-bindings: Document the STM32 timer bindings
>   clockevent: Add STM32 Timer driver
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
>  .../devicetree/bindings/reset/st,stm32-rcc.txt     | 102 +++
>  .../devicetree/bindings/serial/st,stm32-usart.txt  |  32 +
>  .../devicetree/bindings/timer/st,stm32-timer.txt   |  22 +
>  MAINTAINERS                                        |   8 +
>  arch/arm/Kconfig                                   |  18 +
>  arch/arm/Makefile                                  |   1 +
>  arch/arm/boot/dts/Makefile                         |   1 +
>  arch/arm/boot/dts/armv7-m.dtsi                     |   6 +
>  arch/arm/boot/dts/stm32f429-disco.dts              |  71 +++
>  arch/arm/boot/dts/stm32f429.dtsi                   | 226 +++++++
>  arch/arm/configs/stm32_defconfig                   |  71 +++
>  arch/arm/kernel/entry-v7m.S                        |  13 +-
>  arch/arm/mach-stm32/Makefile                       |   1 +
>  arch/arm/mach-stm32/Makefile.boot                  |   3 +
>  arch/arm/mach-stm32/board-dt.c                     |  19 +
>  arch/arm/mm/Kconfig                                |  15 +
>  drivers/clocksource/Kconfig                        |  15 +
>  drivers/clocksource/Makefile                       |   2 +
>  drivers/clocksource/armv7m_systick.c               |  78 +++
>  drivers/clocksource/timer-stm32.c                  | 184 ++++++
>  drivers/reset/Makefile                             |   1 +
>  drivers/reset/reset-stm32.c                        | 125 ++++
>  drivers/tty/serial/Kconfig                         |  17 +
>  drivers/tty/serial/Makefile                        |   1 +
>  drivers/tty/serial/stm32-usart.c                   | 695 +++++++++++++++++++++
>  include/uapi/linux/serial_core.h                   |   3 +
>  scripts/link-vmlinux.sh                            |   2 +-
>  30 files changed, 1807 insertions(+), 5 deletions(-)
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


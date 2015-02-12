From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 00/14] Add support to STMicroelectronics STM32 family
Date: Thu, 12 Feb 2015 18:45:50 +0100
Message-ID: <1423763164-5606-1-git-send-email-mcoquelin.stm32__47224.0473646254$1423763198$gmane$org@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Nikolay Borisov <Nikolay.Borisov-5wv7dgnIgG8@public.gmane.org>
List-Id: linux-api@vger.kernel.org

This patchset adds basic support for STMicroelectronics STM32 series MCUs.

STM32 MCUs are Cortex-M CPU, used in various applications (consumer
electronics, industrial applications, hobbyists...).
Datasheets, user and programming manuals are publicly available on
STMicroelectronics website.

With this series applied, the STM32F419 Discovery can boot succesfully.

Once this series accepted, next steps will be to add DMA support, as USART,
I2C and SPI IPs don't have any FIFO. Then will come the clock driver, as today
the bootloader has to be patched to enable the needed clocks.

Maxime Coquelin (14):
  scripts: link-vmlinux: Don't pass page offset to kallsyms if XIP
    Kernel
  ARM: ARMv7M: Enlarge vector table to 256 entries
  clocksource: Add ARM System timer driver
  reset: Add reset_controller_of_init() function
  ARM: call reset_controller_of_init from default time_init handler
  drivers: reset: Add STM32 reset driver
  clockevent: Add STM32 Timer driver
  pinctrl: Add pinctrl driver for STM32 MCUs
  serial: stm32-usart: Add STM32 USART Driver
  ARM: Add STM32 family machine
  ARM: dts: Add ARM System timer as clockevent in armv7m
  ARM: dts: Introduce STM32F429 MCU
  ARM: configs: Add STM32 defconfig
  MAINTAINERS: Add entry for STM32 MCUs

 Documentation/arm/stm32/overview.txt               |  32 +
 Documentation/arm/stm32/stm32f429-overview.txt     |  22 +
 .../devicetree/bindings/arm/system_timer.txt       |  15 +
 .../devicetree/bindings/pinctrl/pinctrl-stm32.txt  |  99 +++
 .../devicetree/bindings/reset/st,stm32-reset.txt   |  19 +
 .../devicetree/bindings/serial/st,stm32-usart.txt  |  18 +
 .../devicetree/bindings/timer/st,stm32-timer.txt   |  19 +
 MAINTAINERS                                        |   7 +
 arch/arm/Kconfig                                   |  22 +
 arch/arm/Makefile                                  |   1 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/armv7-m.dtsi                     |   7 +
 arch/arm/boot/dts/stm32f429-disco.dts              |  41 ++
 arch/arm/boot/dts/stm32f429.dtsi                   | 279 ++++++++
 arch/arm/configs/stm32_defconfig                   |  72 ++
 arch/arm/kernel/entry-v7m.S                        |   8 +-
 arch/arm/kernel/time.c                             |   4 +
 arch/arm/mach-stm32/Makefile                       |   1 +
 arch/arm/mach-stm32/Makefile.boot                  |   0
 arch/arm/mach-stm32/board-dt.c                     |  19 +
 drivers/clocksource/Kconfig                        |  16 +
 drivers/clocksource/Makefile                       |   2 +
 drivers/clocksource/arm_system_timer.c             |  74 ++
 drivers/clocksource/timer-stm32.c                  | 187 +++++
 drivers/pinctrl/Kconfig                            |   9 +
 drivers/pinctrl/Makefile                           |   1 +
 drivers/pinctrl/pinctrl-stm32.c                    | 779 +++++++++++++++++++++
 drivers/reset/Makefile                             |   1 +
 drivers/reset/core.c                               |  20 +
 drivers/reset/reset-stm32.c                        | 124 ++++
 drivers/tty/serial/Kconfig                         |  17 +
 drivers/tty/serial/Makefile                        |   1 +
 drivers/tty/serial/stm32-usart.c                   | 695 ++++++++++++++++++
 include/asm-generic/vmlinux.lds.h                  |   4 +-
 include/dt-bindings/pinctrl/pinctrl-stm32.h        |  43 ++
 include/linux/reset-controller.h                   |   6 +
 include/uapi/linux/serial_core.h                   |   3 +
 scripts/link-vmlinux.sh                            |   2 +-
 38 files changed, 2664 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/arm/stm32/overview.txt
 create mode 100644 Documentation/arm/stm32/stm32f429-overview.txt
 create mode 100644 Documentation/devicetree/bindings/arm/system_timer.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/pinctrl-stm32.txt
 create mode 100644 Documentation/devicetree/bindings/reset/st,stm32-reset.txt
 create mode 100644 Documentation/devicetree/bindings/serial/st,stm32-usart.txt
 create mode 100644 Documentation/devicetree/bindings/timer/st,stm32-timer.txt
 create mode 100644 arch/arm/boot/dts/stm32f429-disco.dts
 create mode 100644 arch/arm/boot/dts/stm32f429.dtsi
 create mode 100644 arch/arm/configs/stm32_defconfig
 create mode 100644 arch/arm/mach-stm32/Makefile
 create mode 100644 arch/arm/mach-stm32/Makefile.boot
 create mode 100644 arch/arm/mach-stm32/board-dt.c
 create mode 100644 drivers/clocksource/arm_system_timer.c
 create mode 100644 drivers/clocksource/timer-stm32.c
 create mode 100644 drivers/pinctrl/pinctrl-stm32.c
 create mode 100644 drivers/reset/reset-stm32.c
 create mode 100644 drivers/tty/serial/stm32-usart.c
 create mode 100644 include/dt-bindings/pinctrl/pinctrl-stm32.h

-- 
1.9.1

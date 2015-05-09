From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: [PATCH v8 00/16] Add support to STMicroelectronics STM32 family
Date: Sat,  9 May 2015 09:53:42 +0200
Message-ID: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
Sender: linux-arch-owner@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, stefan@agner.ch, pmeerw@pmeerw.net, pebolle@tiscali.nl, peter@hurleysoftware.com, andy.shevchenko@gmail.com, cw00.choi@samsung.com, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, joe@perches.com, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, lee.jones@linaro.org, Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.cz>, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-gpio@vger.kernel.org, linux-serial@vger.kernel.org, linux-arch@vger.kerne
List-Id: linux-api@vger.kernel.org

Main change in this eighth round is the introduction of a new DT bindings
include file for RCC IP drivers. It is for now only used by reset driver,
but goal is to use it also for the clock driver later.
Other changes are bug fix in termios callback of serial driver (uninitialized 
variables), and NO_HZ enablement in stm32_defconfig.

STM32 MCUs are Cortex-M CPU, used in various applications (consumer
electronics, industrial applications, hobbyists...).
Datasheets, user and programming manuals are publicly available on
STMicroelectronics website.

With this series applied, the STM32F429 Discovery can boot succesfully.

Note: Patch 2/16 has already been applied by Russell (8340/1).

Changes since v7:
-----------------
 - Add DT-bindings header file for RCC IP (Daniel)
 - Fix uninitialized variables in serial driver
 - Enable CONFIG_NO_HZ in stm32_defconfig

Changes since v6:
-----------------
 - serial: Fix locking in case of sysrq (Vladimir)
 - Rebase on top of v4.1-rc1
 - Apply Acked-by and Reviewed-by
 - Clean-up stm32_defconfig

Changes since v5:
-----------------
 - Change st,hw-flow-ctrl property to auto-flow-control (Rob)
 - Constify stm32_uart_ops (Joe)
 - Propagate request_irq error in USART driver (Andy)
 - Applies Acked-by and Reviewed-by (Rob, Peter)

Changes since v4:
-----------------
 - Cosmetic changes in USART driver (Andy)
 - Apply Acks on reset driver & bindings (Philipp & Rob)

Changes since v3:
-----------------
 - Fix and simplify error path in ARMv7-M Systick driver (Daniel)
 - Improve reset bindings documentation (Philipp)
 - Fix trailing lines anf typos in reset driver & doc (Philipp & Chanwoo)
 - Fix MODULE_LICENCE in USART driver (Paul)
 - Refactor USART baudrate calculation (Peter & Andy)
 - Fix error path in USART init (Peter & Russell)
 - Fix HW flow control in USART driver (Peter)
 - Fix serial port type number to unused one (Peter)
 - Applies Chanwoo's Tested-by on the series

Changes since v2:
-----------------
 - Remove pinctrl driver from the series. 
 - Remove reset_controller_of_init(), and reset the timers in the bootloader
 - Add HW flow contrl property for serial driver
 - Lots of changes in the DTS file, as per Andreas recommendations
 - Some Kconfig clean-ups
 - Adapt the config to be compatible with Andreas' bootwrapper, except UART port.
 - Various fixes in documentation

Changes since v1:
-----------------
 - Move bindings documentation in their own patches (Andreas)
 - Rename ARM System timer to armv7m-systick (Rob)
 - Add clock-frequency property handling in armv7m-systick (Rob)
 - Re-factor the reset controllers into a single controller (Philipp)
 - Add kerneldoc to reset_controller_of_init (Philipp)
 - Add named constants in include/dt-bindings/reset/ (Philipp)
 - Make pinctrl driver to depend on ARCH_STM32 or COMPILE_TEST (Geert)
 - Introduce CPUV7M_NUM_IRQ config flag to indicate the number of interrupts
supported by the MCU, in order to limit memory waste in vectors' table (Uwe)

Maxime Coquelin (16):
  scripts: link-vmlinux: Don't pass page offset to kallsyms if XIP
    Kernel
  ARM: ARMv7-M: Enlarge vector table up to 256 entries
  dt-bindings: Document the ARM System timer bindings
  clocksource/drivers: Add ARM System timer driver
  dt-bindings: mfd: Add STM32F4 RCC numeric constants into DT include
    file
  dt-bindings: Document the STM32 reset bindings
  drivers: reset: Add STM32 reset driver
  dt-bindings: Document the STM32 timer bindings
  clockevents/drivers: Add STM32 Timer driver
  dt-bindings: Document the STM32 USART bindings
  serial: stm32-usart: Add STM32 USART Driver
  ARM: Add STM32 family machine
  ARM: dts: Add ARM System timer as clocksource in armv7m
  ARM: dts: Introduce STM32F429 MCU
  ARM: configs: Add STM32 defconfig
  MAINTAINERS: Add entry for STM32 MCUs

 Documentation/arm/stm32/overview.txt               |  32 +
 Documentation/arm/stm32/stm32f429-overview.txt     |  22 +
 .../devicetree/bindings/arm/armv7m_systick.txt     |  26 +
 .../devicetree/bindings/reset/st,stm32-rcc.txt     |  50 ++
 .../devicetree/bindings/serial/st,stm32-usart.txt  |  32 +
 .../devicetree/bindings/timer/st,stm32-timer.txt   |  22 +
 MAINTAINERS                                        |   8 +
 arch/arm/Kconfig                                   |  18 +
 arch/arm/Makefile                                  |   1 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/armv7-m.dtsi                     |   6 +
 arch/arm/boot/dts/stm32f429-disco.dts              |  71 ++
 arch/arm/boot/dts/stm32f429.dtsi                   | 227 +++++++
 arch/arm/configs/stm32_defconfig                   |  70 ++
 arch/arm/kernel/entry-v7m.S                        |  13 +-
 arch/arm/mach-stm32/Makefile                       |   1 +
 arch/arm/mach-stm32/Makefile.boot                  |   3 +
 arch/arm/mach-stm32/board-dt.c                     |  19 +
 arch/arm/mm/Kconfig                                |  15 +
 drivers/clocksource/Kconfig                        |  15 +
 drivers/clocksource/Makefile                       |   2 +
 drivers/clocksource/armv7m_systick.c               |  79 +++
 drivers/clocksource/timer-stm32.c                  | 184 +++++
 drivers/reset/Makefile                             |   1 +
 drivers/reset/reset-stm32.c                        | 124 ++++
 drivers/tty/serial/Kconfig                         |  17 +
 drivers/tty/serial/Makefile                        |   1 +
 drivers/tty/serial/stm32-usart.c                   | 739 +++++++++++++++++++++
 include/dt-bindings/mfd/stm32f4-rcc.h              |  92 +++
 include/uapi/linux/serial_core.h                   |   3 +
 scripts/link-vmlinux.sh                            |   2 +-
 31 files changed, 1891 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/arm/stm32/overview.txt
 create mode 100644 Documentation/arm/stm32/stm32f429-overview.txt
 create mode 100644 Documentation/devicetree/bindings/arm/armv7m_systick.txt
 create mode 100644 Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
 create mode 100644 Documentation/devicetree/bindings/serial/st,stm32-usart.txt
 create mode 100644 Documentation/devicetree/bindings/timer/st,stm32-timer.txt
 create mode 100644 arch/arm/boot/dts/stm32f429-disco.dts
 create mode 100644 arch/arm/boot/dts/stm32f429.dtsi
 create mode 100644 arch/arm/configs/stm32_defconfig
 create mode 100644 arch/arm/mach-stm32/Makefile
 create mode 100644 arch/arm/mach-stm32/Makefile.boot
 create mode 100644 arch/arm/mach-stm32/board-dt.c
 create mode 100644 drivers/clocksource/armv7m_systick.c
 create mode 100644 drivers/clocksource/timer-stm32.c
 create mode 100644 drivers/reset/reset-stm32.c
 create mode 100644 drivers/tty/serial/stm32-usart.c
 create mode 100644 include/dt-bindings/mfd/stm32f4-rcc.h

-- 
1.9.1

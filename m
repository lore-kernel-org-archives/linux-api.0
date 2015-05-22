From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: [PATCH v9 0/5] Add support to STMicroelectronics STM32 family
Date: Fri, 22 May 2015 23:03:31 +0200
Message-ID: <1432328616-16964-1-git-send-email-mcoquelin.stm32@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, Daniel Thompson <daniel.thompson@linaro.org>, Kamil Lulko <rev13@wp.pl>, u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Thomas Gleixner <tglx@linutronix.de>, Jiri Slaby <jslaby@suse.cz>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

This ninth round counts less patches as some have already been applied,
and the reset driver will be part of another series because it will
introduce a generic reset driver to be used by several SoCs (sunxi, socfpga).
Main change in remaining patches is the rework of the STM32 clocksource 
Kconfig entry.

STM32 MCUs are Cortex-M CPU, used in various applications (consumer
electronics, industrial applications, hobbyists...).
Datasheets, user and programming manuals are publicly available on
STMicroelectronics website.

Changes since v8:
-----------------
 - Rework clocksource driver Kconfig entry.
 - Remove reset driver from the series.

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

Maxime Coquelin (5):
  dt-bindings: Document the STM32 timer bindings
  clockevents/drivers: Add STM32 Timer driver
  dt-bindings: Document the STM32 USART bindings
  serial: stm32-usart: Add STM32 USART Driver
  ARM: dts: Introduce STM32F429 MCU

 .../devicetree/bindings/serial/st,stm32-usart.txt  |  32 +
 .../devicetree/bindings/timer/st,stm32-timer.txt   |  22 +
 arch/arm/boot/dts/Makefile                         |   1 +
 arch/arm/boot/dts/stm32f429-disco.dts              |  71 ++
 arch/arm/boot/dts/stm32f429.dtsi                   | 214 ++++++
 drivers/clocksource/Kconfig                        |   5 +
 drivers/clocksource/Makefile                       |   1 +
 drivers/clocksource/timer-stm32.c                  | 184 +++++
 drivers/tty/serial/Kconfig                         |  17 +
 drivers/tty/serial/Makefile                        |   1 +
 drivers/tty/serial/stm32-usart.c                   | 739 +++++++++++++++++++++
 include/uapi/linux/serial_core.h                   |   3 +
 12 files changed, 1290 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/serial/st,stm32-usart.txt
 create mode 100644 Documentation/devicetree/bindings/timer/st,stm32-timer.txt
 create mode 100644 arch/arm/boot/dts/stm32f429-disco.dts
 create mode 100644 arch/arm/boot/dts/stm32f429.dtsi
 create mode 100644 drivers/clocksource/timer-stm32.c
 create mode 100644 drivers/tty/serial/stm32-usart.c

-- 
1.9.1

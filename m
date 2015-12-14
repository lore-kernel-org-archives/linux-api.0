From: Joshua Henderson <joshua.henderson@microchip.com>
Subject: [PATCH v2 00/14] Initial Microchip PIC32MZDA Support
Date: Mon, 14 Dec 2015 15:42:02 -0700
Message-ID: <1450133093-7053-1-git-send-email-joshua.henderson@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org, Joshua Henderson <joshua.henderson@microchip.com>, Andrei Pistirica <andrei.pistirica@microchip.com>, Andrew Bresticker <abrestic@chromium.org>, Andy Green <andy.green@linaro.org>, Ben Hutchings <ben@decadent.org.uk>, Chaotian Jing <chaotian.jing@mediatek.com>, Corneliu Doban <cdoban@broadcom.com>, Cristian Birsan <cristian.birsan@microchip.com>, devicetree@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>, Haojian Zhuang <haojian.zhuang@gmail.com>, Jean Delvare <jdelvare@suse.de>, Kevin Hao <haokexin@gmail.com>, linux-api@vger.kernel.org, linux-clk@vger.kernel.org, linux-gpio@vger.kernel.org, linux-mmc@vger.kernel.org, linux-serial@vger.kernel.org, Lokesh Vutla <lokeshvutla@ti.com>, "ludovic.desroches@atmel.com" <ludovic.desroches@atmel.com>, Luis de Bethencourt <luisbg@osg.samsung.com>, Paul
List-Id: linux-api@vger.kernel.org

This patch series adds support for the Microchip PIC32MZDA MIPS platform.
All drivers required to boot from a MMC uSD card are included. Clock,
external interrupt controller, serial, SDHCI, and pinctrl drivers are
included. This has been tested on a PIC32MZDA Starter Kit. A tree with
these changes is available at [0].

[0] https://github.com/joshua-henderson/linux/tree/pic32-upstream-v2

Changes since v1 (https://lkml.org/lkml/2015/11/20/848):

	+ Rename all DT compatible properties to be chip specific.
	+ Remove hardware interrupt priorities from interrupt controller DT
	  bindings.
	+ Remove all dependencies on include headers used by PIC32 DTS
	  files.
	+ Remove arch/mips/include/asm/mach-pic32/gpio.h
	+ Drop usage of the following, mostly non-standard, properties in
	  DT bindings:
		device_type
		piomode
		no-1-8-v
		uart-has-rtscts
		clock-frequency => assigned-clock-rate
	+ Remove PIC32 memory PLL support from DT.
	+ Replace empty 'ranges' with populated one for clock tree node.
	+ Rename all instances of "USART" to "UART".
	+ Remove 'interrupts' property from FSCM of PIC32 clock tree node.
	+ Add default REFCLK rate initialization required for SDHCI in DTS.
	+ Remove default frequency setup for REFOSC clocks in -clk DTS.
	+ Address missing static on local functions and other sparse
	  warnings in several drivers.
	+ Update pinctrl driver to address major binding and architectural
	  issues.
	+ Remove redundant probing 'pb7_clk' to find CPU clock.
	+ Remove unused PIC32 MPLL support.
	+ Remove support for initializing default parent/rate for REFOSC
	  clocks.
	+ Be consistent and use only "SDHCI" when refering to SD host
	  controller
	+ Remove unecessary PIC32 sdhci_ops min clock function.
	+ Make platform PIC32[_CLR|_SET|_INV] register macros safer.

Andrei Pistirica (4):
  DEVICETREE: Add bindings for PIC32 UART driver
  serial: pic32_uart: Add PIC32 UART driver
  DEVICETREE: Add bindings for PIC32 SDHCI host controller
  mmc: sdhci-pic32: Add PIC32 SDHCI host controller driver

Cristian Birsan (2):
  DEVICETREE: Add bindings for PIC32 interrupt controller
  irqchip: irq-pic32-evic: Add support for PIC32 interrupt controller

Joshua Henderson (6):
  DEVICETREE: Add bindings for PIC32/MZDA platforms
  MIPS: Add support for PIC32MZDA platform
  DEVICETREE: Add bindings for PIC32 pin control and GPIO
  pinctrl: pinctrl-pic32: Add PIC32 pin control driver
  MIPS: dts: Add initial DTS for the PIC32MZDA Starter Kit
  MIPS: pic32mzda: Add initial PIC32MZDA Starter Kit defconfig

Purna Chandra Mandal (2):
  DEVICETREE: Add PIC32 clock binding documentation
  clk: clk-pic32: Add PIC32 clock driver

 .../devicetree/bindings/clock/microchip,pic32.txt  |  256 +++
 .../bindings/gpio/microchip,pic32-gpio.txt         |   32 +
 .../interrupt-controller/microchip,pic32-evic.txt  |   58 +
 .../bindings/mips/pic32/microchip,pic32mzda.txt    |   33 +
 .../bindings/mmc/microchip,sdhci-pic32.txt         |   29 +
 .../bindings/pinctrl/microchip,pic32-pinctrl.txt   |   93 +
 .../bindings/serial/microchip,pic32-uart.txt       |   29 +
 arch/mips/Kbuild.platforms                         |    1 +
 arch/mips/Kconfig                                  |    9 +
 arch/mips/boot/dts/Makefile                        |    1 +
 arch/mips/boot/dts/pic32/Makefile                  |   12 +
 arch/mips/boot/dts/pic32/pic32mzda-clk.dtsi        |  235 ++
 arch/mips/boot/dts/pic32/pic32mzda.dtsi            |  275 +++
 arch/mips/boot/dts/pic32/pic32mzda_sk.dts          |  151 ++
 arch/mips/configs/pic32mzda_defconfig              |   88 +
 .../include/asm/mach-pic32/cpu-feature-overrides.h |   32 +
 arch/mips/include/asm/mach-pic32/irq.h             |   22 +
 arch/mips/include/asm/mach-pic32/pic32.h           |   44 +
 arch/mips/include/asm/mach-pic32/spaces.h          |   24 +
 arch/mips/pic32/Kconfig                            |   50 +
 arch/mips/pic32/Makefile                           |    6 +
 arch/mips/pic32/Platform                           |    7 +
 arch/mips/pic32/common/Makefile                    |    5 +
 arch/mips/pic32/common/irq.c                       |   21 +
 arch/mips/pic32/common/reset.c                     |   62 +
 arch/mips/pic32/pic32mzda/Makefile                 |    9 +
 arch/mips/pic32/pic32mzda/config.c                 |  126 ++
 arch/mips/pic32/pic32mzda/early_clk.c              |  106 +
 arch/mips/pic32/pic32mzda/early_console.c          |  171 ++
 arch/mips/pic32/pic32mzda/early_pin.c              |  275 +++
 arch/mips/pic32/pic32mzda/early_pin.h              |  241 ++
 arch/mips/pic32/pic32mzda/init.c                   |  156 ++
 arch/mips/pic32/pic32mzda/pic32mzda.h              |   29 +
 arch/mips/pic32/pic32mzda/time.c                   |   44 +
 drivers/clk/Kconfig                                |    3 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk-pic32.c                            | 1804 +++++++++++++++
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-pic32-evic.c                   |  321 +++
 drivers/mmc/host/Kconfig                           |   11 +
 drivers/mmc/host/Makefile                          |    1 +
 drivers/mmc/host/sdhci-pic32.c                     |  291 +++
 drivers/pinctrl/Kconfig                            |   17 +
 drivers/pinctrl/Makefile                           |    1 +
 drivers/pinctrl/pinctrl-pic32.c                    | 2339 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-pic32.h                    |  141 ++
 drivers/tty/serial/Kconfig                         |   21 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/pic32_uart.c                    |  927 ++++++++
 drivers/tty/serial/pic32_uart.h                    |  198 ++
 include/linux/irqchip/pic32-evic.h                 |   19 +
 include/linux/platform_data/sdhci-pic32.h          |   22 +
 include/uapi/linux/serial_core.h                   |    3 +
 53 files changed, 8854 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/microchip,pic32.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/microchip,pic32-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/microchip,pic32-evic.txt
 create mode 100644 Documentation/devicetree/bindings/mips/pic32/microchip,pic32mzda.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/microchip,sdhci-pic32.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/microchip,pic32-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/serial/microchip,pic32-uart.txt
 create mode 100644 arch/mips/boot/dts/pic32/Makefile
 create mode 100644 arch/mips/boot/dts/pic32/pic32mzda-clk.dtsi
 create mode 100644 arch/mips/boot/dts/pic32/pic32mzda.dtsi
 create mode 100644 arch/mips/boot/dts/pic32/pic32mzda_sk.dts
 create mode 100644 arch/mips/configs/pic32mzda_defconfig
 create mode 100644 arch/mips/include/asm/mach-pic32/cpu-feature-overrides.h
 create mode 100644 arch/mips/include/asm/mach-pic32/irq.h
 create mode 100644 arch/mips/include/asm/mach-pic32/pic32.h
 create mode 100644 arch/mips/include/asm/mach-pic32/spaces.h
 create mode 100644 arch/mips/pic32/Kconfig
 create mode 100644 arch/mips/pic32/Makefile
 create mode 100644 arch/mips/pic32/Platform
 create mode 100644 arch/mips/pic32/common/Makefile
 create mode 100644 arch/mips/pic32/common/irq.c
 create mode 100644 arch/mips/pic32/common/reset.c
 create mode 100644 arch/mips/pic32/pic32mzda/Makefile
 create mode 100644 arch/mips/pic32/pic32mzda/config.c
 create mode 100644 arch/mips/pic32/pic32mzda/early_clk.c
 create mode 100644 arch/mips/pic32/pic32mzda/early_console.c
 create mode 100644 arch/mips/pic32/pic32mzda/early_pin.c
 create mode 100644 arch/mips/pic32/pic32mzda/early_pin.h
 create mode 100644 arch/mips/pic32/pic32mzda/init.c
 create mode 100644 arch/mips/pic32/pic32mzda/pic32mzda.h
 create mode 100644 arch/mips/pic32/pic32mzda/time.c
 create mode 100644 drivers/clk/clk-pic32.c
 create mode 100644 drivers/irqchip/irq-pic32-evic.c
 create mode 100644 drivers/mmc/host/sdhci-pic32.c
 create mode 100644 drivers/pinctrl/pinctrl-pic32.c
 create mode 100644 drivers/pinctrl/pinctrl-pic32.h
 create mode 100644 drivers/tty/serial/pic32_uart.c
 create mode 100644 drivers/tty/serial/pic32_uart.h
 create mode 100644 include/linux/irqchip/pic32-evic.h
 create mode 100644 include/linux/platform_data/sdhci-pic32.h

--
1.7.9.5

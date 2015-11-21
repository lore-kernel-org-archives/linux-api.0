From: Joshua Henderson <joshua.henderson@microchip.com>
Subject: [PATCH 00/14] Initial Microchip PIC32MZDA Support
Date: Fri, 20 Nov 2015 17:17:12 -0700
Message-ID: <1448065205-15762-1-git-send-email-joshua.henderson@microchip.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-mips-bounce@linux-mips.org>
Sender: linux-mips-bounce@linux-mips.org
Errors-to: linux-mips-bounce@linux-mips.org
List-help: <mailto:ecartis@linux-mips.org?Subject=help>
List-unsubscribe: <mailto:ecartis@linux-mips.org?subject=unsubscribe%20linux-mips>
List-software: Ecartis version 1.0.0
List-subscribe: <mailto:ecartis@linux-mips.org?subject=subscribe%20linux-mips>
List-owner: <mailto:ralf@linux-mips.org>
List-post: <mailto:linux-mips@linux-mips.org>
List-archive: <http://www.linux-mips.org/archives/linux-mips/>
To: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, Joshua Henderson <joshua.henderson@microchip.com>, Alim Akhtar <alim.akhtar@samsung.com>, Andrei Pistirica <andrei.pistirica@microchip.com>, Andrew Bresticker <abrestic@chromium.org>, Andy Green <andy.green@linaro.org>, Ben Hutchings <ben@decadent.org.uk>, Chaotian Jing <chaotian.jing@mediatek.com>, Corneliu Doban <cdoban@broadcom.com>, Cristian Birsan <cristian.birsan@microchip.com>, devicetree@vger.kernel.org, Haojian Zhuang <haojian.zhuang@gmail.com>, Jean Delvare <jdelvare@suse.de>, Kevin Hao <haokexin@gmail.com>, linux-api@vger.kernel.org, linux-clk@vger.kernel.org, linux-gpio@vger.kernel.org, linux-mmc@vger.kernel.org, linux-serial@vger.kernel.org, Lokesh Vutla <lokeshvutla@ti.com>, ludovic.desroches@at
List-Id: linux-api@vger.kernel.org

This patch series adds support for the Microchip PIC32MZDA MIPS
platform. All drivers required to boot from MMC uSD card are
included. Clock and external interrupt controller drivers are
included. USART, console, and SDHCI peripheral drivers along with
the dependent pinctrl driver are included. This has been tested on
an applicable PIC32MZDA Starter Kit. A tree with these changes is
available at [0].

[0] https://github.com/joshua-henderson/linux/tree/pic32-upstream-v1

Andrei Pistirica (6):
  DEVICETREE: Add bindings for PIC32 pin control and GPIO
  pinctrl: Add PIC32 pin control driver
  DEVICETREE: Add bindings for PIC32 usart driver
  serial: pic32_uart: Add PIC32 uart driver
  mmc: sdhci-pic32: Add PIC32 SDHC host controller driver
  DEVICETREE: Add bindings for PIC32 SDHC host controller

Cristian Birsan (2):
  DEVICETREE: Add bindings for PIC32 interrupt controller
  irqchip: irq-pic32-evic: Add support for PIC32 interrupt controller

Joshua Henderson (4):
  DEVICETREE: Add bindings for PIC32/MZDA platforms
  MIPS: Add support for PIC32MZDA platform
  MIPS: dts: Add initial DTS for the PIC32MZDA Starter Kit
  MIPS: pic32mzda: Add initial PIC32MZDA Starter Kit defconfig

Purna Chandra Mandal (2):
  DEVICETREE: Add PIC32 clock binding documentation
  clk: clk-pic32: Add PIC32 clock driver

 .../devicetree/bindings/clock/microchip,pic32.txt  |  263 +++
 .../bindings/gpio/microchip,pic32-gpio.txt         |   33 +
 .../microchip,pic32mz-evic.txt                     |   65 +
 .../bindings/mips/pic32/microchip,pic32mzda.txt    |   33 +
 .../devicetree/bindings/mmc/sdhci-pic32.txt        |   24 +
 .../bindings/pinctrl/microchip,pic32-pinctrl.txt   |  100 +
 .../bindings/serial/microchip,pic32-usart.txt      |   29 +
 arch/mips/Kbuild.platforms                         |    1 +
 arch/mips/Kconfig                                  |    9 +
 arch/mips/boot/dts/Makefile                        |    1 +
 arch/mips/boot/dts/pic32/Makefile                  |   12 +
 arch/mips/boot/dts/pic32/pic32mzda-clk.dtsi        |  251 +++
 arch/mips/boot/dts/pic32/pic32mzda.dtsi            |  280 +++
 arch/mips/boot/dts/pic32/pic32mzda_sk.dts          |  150 ++
 arch/mips/configs/pic32mzda_defconfig              |   88 +
 .../include/asm/mach-pic32/cpu-feature-overrides.h |   32 +
 arch/mips/include/asm/mach-pic32/gpio.h            |   26 +
 arch/mips/include/asm/mach-pic32/irq.h             |   22 +
 arch/mips/include/asm/mach-pic32/pic32.h           |   44 +
 arch/mips/include/asm/mach-pic32/spaces.h          |   24 +
 arch/mips/pic32/Kconfig                            |   50 +
 arch/mips/pic32/Makefile                           |    6 +
 arch/mips/pic32/Platform                           |    7 +
 arch/mips/pic32/common/Makefile                    |    5 +
 arch/mips/pic32/common/irq.c                       |   20 +
 arch/mips/pic32/common/reset.c                     |   62 +
 arch/mips/pic32/pic32mzda/Makefile                 |    9 +
 arch/mips/pic32/pic32mzda/config.c                 |  148 ++
 arch/mips/pic32/pic32mzda/early_clk.c              |  106 +
 arch/mips/pic32/pic32mzda/early_console.c          |  171 ++
 arch/mips/pic32/pic32mzda/early_pin.c              |  275 +++
 arch/mips/pic32/pic32mzda/early_pin.h              |  241 +++
 arch/mips/pic32/pic32mzda/init.c                   |  156 ++
 arch/mips/pic32/pic32mzda/pic32mzda.h              |   30 +
 arch/mips/pic32/pic32mzda/time.c                   |   47 +
 drivers/clk/Kconfig                                |    3 +
 drivers/clk/Makefile                               |    1 +
 drivers/clk/clk-pic32.c                            | 1947 ++++++++++++++++++
 drivers/irqchip/Makefile                           |    1 +
 drivers/irqchip/irq-pic32-evic.c                   |  309 +++
 drivers/mmc/host/Kconfig                           |   11 +
 drivers/mmc/host/Makefile                          |    1 +
 drivers/mmc/host/sdhci-pic32.c                     |  354 ++++
 drivers/pinctrl/Kconfig                            |   17 +
 drivers/pinctrl/Makefile                           |    2 +
 drivers/pinctrl/pinctrl-pic32.c                    | 2127 ++++++++++++++++++++
 drivers/pinctrl/pinctrl-pic32.h                    |  158 ++
 drivers/pinctrl/pinctrl-pic32mzda.c                |  294 +++
 drivers/pinctrl/pinctrl-pic32mzda.h                |   40 +
 drivers/tty/serial/Kconfig                         |   21 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/pic32_uart.c                    |  930 +++++++++
 drivers/tty/serial/pic32_uart.h                    |  199 ++
 .../interrupt-controller/microchip,pic32mz-evic.h  |  238 +++
 include/dt-bindings/pinctrl/pic32mzda.h            |  404 ++++
 include/linux/irqchip/pic32-evic.h                 |   19 +
 include/linux/platform_data/sdhci-pic32.h          |   22 +
 include/uapi/linux/serial_core.h                   |    3 +
 58 files changed, 9922 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/microchip,pic32.txt
 create mode 100644 Documentation/devicetree/bindings/gpio/microchip,pic32-gpio.txt
 create mode 100644 Documentation/devicetree/bindings/interrupt-controller/microchip,pic32mz-evic.txt
 create mode 100644 Documentation/devicetree/bindings/mips/pic32/microchip,pic32mzda.txt
 create mode 100644 Documentation/devicetree/bindings/mmc/sdhci-pic32.txt
 create mode 100644 Documentation/devicetree/bindings/pinctrl/microchip,pic32-pinctrl.txt
 create mode 100644 Documentation/devicetree/bindings/serial/microchip,pic32-usart.txt
 create mode 100644 arch/mips/boot/dts/pic32/Makefile
 create mode 100644 arch/mips/boot/dts/pic32/pic32mzda-clk.dtsi
 create mode 100644 arch/mips/boot/dts/pic32/pic32mzda.dtsi
 create mode 100644 arch/mips/boot/dts/pic32/pic32mzda_sk.dts
 create mode 100644 arch/mips/configs/pic32mzda_defconfig
 create mode 100644 arch/mips/include/asm/mach-pic32/cpu-feature-overrides.h
 create mode 100644 arch/mips/include/asm/mach-pic32/gpio.h
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
 create mode 100644 drivers/pinctrl/pinctrl-pic32mzda.c
 create mode 100644 drivers/pinctrl/pinctrl-pic32mzda.h
 create mode 100644 drivers/tty/serial/pic32_uart.c
 create mode 100644 drivers/tty/serial/pic32_uart.h
 create mode 100644 include/dt-bindings/interrupt-controller/microchip,pic32mz-evic.h
 create mode 100644 include/dt-bindings/pinctrl/pic32mzda.h
 create mode 100644 include/linux/irqchip/pic32-evic.h
 create mode 100644 include/linux/platform_data/sdhci-pic32.h

--
1.7.9.5

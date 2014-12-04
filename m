From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Subject: [PATCH v4 0/5] Add Spreadtrum Sharkl64 Platform support
Date: Thu, 4 Dec 2014 19:34:15 +0800
Message-ID: <1417692860-18841-1-git-send-email-chunyan.zhang@spreadtrum.com>
References: <sc9836v4>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <sc9836v4>
Sender: linux-doc-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, mark.rutland@arm.com, arnd@arndb.de, gnomes@lxorguk.ukuu.org.uk, broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, will.deacon@arm.com, catalin.marinas@arm.com, jslaby@suse.cz, jason@lakedaemon.net, heiko@sntech.de, florian.vaussard@epfl.ch, andrew@lunn.ch, rrichter@cavium.com, hytszk@gmail.com, grant.likely@linaro.org, orsonzhai@gmail.com, geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com, zhang.lyra@gmail.com, wei.qiao@spreadtrum.com
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, sprdlinux@freelists.org, linux-doc@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, arm@kernel.org
List-Id: linux-api@vger.kernel.org

Spreadtrum is a rapid growing chip vendor providing smart phone total solutions.

Sharkl64 Platform is nominated as a SoC infrastructure that supports 4G/3G/2G
standards based on ARMv8 multiple core architecture.Now we have only one
SoC(SC9836) based on this Platform in developing.

This patchset adds Sharkl64 support in arm64 device tree and the serial driver
of SC9836-UART.

This patchset also has patches which address "sprd" prefix and DT compatible
strings for nodes which appear un-documented.

This version code was tesed both on Fast Mode and sc9836-fpga board.
We use the latest boot-wrapper-aarch64 as the bootloader.

Changes from v3:
* Addressed review comments:
	- Added the description of clock property for sc9836-uart
	- Revised the size of GICC to be 8KiB
	- Added another compatible string for psci-0.1
	- Removed the clock-frequency property of timer in DT
	- Removed ARCH_SHARKL64, just left ARCH_SPRD only
	- sprd_serial.c: Removed .owner of platform_driver.driver
	- sprd_serial.c: Removed all usages of unlikely
	- sprd_serial.c: Used the .port member of sprd_port instead of the cast
	- sprd_serial.c: Used dynamic allocation for major/minor device id
	- sprd_serial.c: Added a timeout and a cpu_relax for clearing rx/tx fifo
	- sprd_serial.c: clear CMSPAR in termios->c_cflag
	- sprd_serial.c: Set the resulting baud back into the termios
	- sprd_serial.c: Implemented a shared interrupt handler

Changes from v2:
* Addressed review comments:
	- Added a specific compitible string 'sc9836-uart' for the serial
	- Added a full serial driver
	- Added the property 'clock-frequency' for timer node in dtsi.
	- Replaceed the old macro prefix 'UART_' with 'SPRD_' in the 
	  Spreadtrum serial driver code.
* Revised the name of SoC and board from 'sharkl3' to 'sc9836'
* Used dual-license for DTS files
* Added a menuconfig 'ARCH_SPRD' in arch/arm64/Kconfig

Changes from v1:
* Addressed review comments:
        - Added "sprd" prefix to vendor-prefixes.txt
        - Created serial/sprd-serial.txt and remove the properties for serial-sprd
          from of-serial.txt to it.
        - Renamed of-serial.txt to 8250.txt according to Arnd's review comments
        - Splited and revised .dts for Sharkl64 Platform
        - Changed to PSCI method for cpu power management
        - Revised Kconfig Makefile to match the alphabetical ordering
        - Renamed serial-sprd-earlycon.c to serial-sprd.c

Chunyan Zhang (3):
  Documentation: DT: Renamed of-serial.txt to 8250.txt
  Documentation: DT: Add bindings for Spreadtrum SoC Platform
  tty/serial: Add Spreadtrum sc9836-uart driver support

Zhizhou Zhang (2):
  arm64: dts: Add support for Spreadtrum SC9836 SoC in dts and Makefile
  arm64: Add support for Spreadtrum's Sharkl64 Platform in Kconfig and
    defconfig

 Documentation/devicetree/bindings/arm/sprd.txt     |   11 +
 .../bindings/serial/{of-serial.txt => 8250.txt}    |    0
 .../devicetree/bindings/serial/sprd-uart.txt       |    9 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 arch/arm64/Kconfig                                 |    6 +
 arch/arm64/boot/dts/Makefile                       |    1 +
 arch/arm64/boot/dts/sprd-sc9836-openphone.dts      |   85 +++
 arch/arm64/boot/dts/sprd-sc9836.dtsi               |  102 +++
 arch/arm64/boot/dts/sprd-sharkl64.dtsi             |  105 +++
 arch/arm64/configs/defconfig                       |    1 +
 drivers/tty/serial/Kconfig                         |   18 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/sprd_serial.c                   |  761 ++++++++++++++++++++
 include/uapi/linux/serial_core.h                   |    3 +
 14 files changed, 1104 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/sprd.txt
 rename Documentation/devicetree/bindings/serial/{of-serial.txt => 8250.txt} (100%)
 create mode 100644 Documentation/devicetree/bindings/serial/sprd-uart.txt
 create mode 100644 arch/arm64/boot/dts/sprd-sc9836-openphone.dts
 create mode 100644 arch/arm64/boot/dts/sprd-sc9836.dtsi
 create mode 100644 arch/arm64/boot/dts/sprd-sharkl64.dtsi
 create mode 100644 drivers/tty/serial/sprd_serial.c

-- 
1.7.9.5


From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Subject: [PATCH v5 0/5] Add Spreadtrum Sharkl64 Platform support
Date: Fri, 16 Jan 2015 18:00:06 +0800
Message-ID: <1421402411-3479-1-git-send-email-chunyan.zhang@spreadtrum.com>
References: <sc9836-v5>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <sc9836-v5>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: gregkh@linuxfoundation.org, mark.rutland@arm.com, arnd@arndb.de, gnomes@lxorguk.ukuu.org.uk, broonie@kernel.org, robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, will.deacon@arm.com, catalin.marinas@arm.com, jslaby@suse.cz, jason@lakedaemon.net, heiko@sntech.de, florian.vaussard@epfl.ch, andrew@lunn.ch, rrichter@cavium.com, hytszk@gmail.com, grant.likely@linaro.org, antonynpavlov@gmail.com, Joel.Schopp@amd.com, Suravee.Suthikulpanit@amd.com, shawn.guo@linaro.org, lea.yan@linaro.org, jorge.ramirez-ortiz@linaro.org, lee.jones@linaro.org, orsonzhai@gmail.com, geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com, zhang.lyra@gmail.com, wei.qiao@spreadtrum.com
Cc: devicetree@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-serial@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Spreadtrum is a rapid growing chip vendor providing smart phone total solutions.

Sharkl64 Platform is nominated as a SoC infrastructure that supports 4G/3G/2G
standards based on ARMv8 multiple core architecture. Now we have only one
SoC(SC9836) based on this Platform in developing.

This patchset adds Sharkl64 support in arm64 device tree and adds the serial
driver of SC9836-UART.

This patchset also has patches which address "sprd" prefix and DT compatible
strings for nodes which appear un-documented.

This version code was tesed on SC9836 mobile phone.

Changes from v4:
* Addressed review comments from last version:
	- Remove compitible string "arm,psci-0.2"
	- Add the properties of psci v0.1
	- Remove the "clocks" container node
* Addressed review comments from Shawn Guo, Lea Yan, Jorge Ramirez-Ortiz:
	- Turn the 'clocks' property of uart into a required property
	- Use GIC macro instead of the value
	- Update the CPU mask to match the number of described CPUs
	- Use the more explicit compatible string "arm,gic-400" for GIC
	- sprd_serial.c: Add a cpu_relax() in the busy loop of sprd_putc
	- sprd_serial.c: Add calling uart_suspend_port and uart_resume_port in
	  the function sprd_suspend and sprd_resume respectively
	- sprd_serial.c: Use SIMPLE_DEV_PM_OPS to register sprd_suspend and
	  sprd_resume

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
	- sprd_serial.c: sed dynamic allocation for major/minor device id
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
 .../devicetree/bindings/serial/sprd-uart.txt       |    7 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 arch/arm64/Kconfig                                 |    5 +
 arch/arm64/boot/dts/Makefile                       |    1 +
 arch/arm64/boot/dts/sprd/Makefile                  |    5 +
 arch/arm64/boot/dts/sprd/sc9836-openphone.dts      |   49 ++
 arch/arm64/boot/dts/sprd/sc9836.dtsi               |   73 ++
 arch/arm64/boot/dts/sprd/sharkl64.dtsi             |   67 ++
 arch/arm64/configs/defconfig                       |    1 +
 drivers/tty/serial/Kconfig                         |   18 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/sprd_serial.c                   |  772 ++++++++++++++++++++
 include/uapi/linux/serial_core.h                   |    3 +
 15 files changed, 1014 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/sprd.txt
 rename Documentation/devicetree/bindings/serial/{of-serial.txt => 8250.txt} (100%)
 create mode 100644 Documentation/devicetree/bindings/serial/sprd-uart.txt
 create mode 100644 arch/arm64/boot/dts/sprd/Makefile
 create mode 100644 arch/arm64/boot/dts/sprd/sc9836-openphone.dts
 create mode 100644 arch/arm64/boot/dts/sprd/sc9836.dtsi
 create mode 100644 arch/arm64/boot/dts/sprd/sharkl64.dtsi
 create mode 100644 drivers/tty/serial/sprd_serial.c

-- 
1.7.9.5

From: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Subject: [PATCH v3 0/5] Add Spreadtrum Sharkl64 Platform support
Date: Tue, 25 Nov 2014 20:16:53 +0800
Message-ID: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
References: <Sharkl64-v3>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <Sharkl64-v3>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: grant.likely@linaro.org, robh+dt@kernel.org, catalin.marinas@arm.com, gregkh@linuxfoundation.org, ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org, broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com, pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com, will.deacon@arm.com, arnd@arndb.de, gnomes@lxorguk.ukuu.org.uk, corbet@lwn.net, jason@lakedaemon.net, broonie@kernel.org, heiko@sntech.de, shawn.guo@freescale.com, florian.vaussard@epfl.ch, andrew@lunn.ch, hytszk@gmail.com, orsonzhai@gmail.com, geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com, zhang.lyra@gmail.com, wei.qiao@spreadtrum.com
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org, sprdlinux@freelists.org, linux-arm-kernel@lists.infradead.org
List-Id: linux-api@vger.kernel.org

Spreadtrum is a rapid growing chip vendor providing smart phone total solutions.

Sharkl64 Platform is nominated as a SoC infrastructure that supports 4G/3G/2G
standards based on ARMv8 multiple core architecture.Now we have only one
SoC(SC9836) based on this Platform in developing.

This patchset adds Sharkl64 support in arm64 device tree and the serial driver
of SC9836-UART.

This patchset also has patches which address "sprd" prefix and DT compatible
strings for nodes which appear un-documented.

This version code was tesed on Fast Mode.
We use boot-wrapper-aarch64 as the bootloader.

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

 Documentation/devices.txt                          |    3 +
 Documentation/devicetree/bindings/arm/sprd.txt     |   11 +
 .../bindings/serial/{of-serial.txt => 8250.txt}    |    0
 .../devicetree/bindings/serial/sprd-uart.txt       |    6 +
 .../devicetree/bindings/vendor-prefixes.txt        |    1 +
 arch/arm64/Kconfig                                 |   17 +
 arch/arm64/boot/dts/Makefile                       |    1 +
 arch/arm64/boot/dts/sprd-sc9836-openphone.dts      |   85 +++
 arch/arm64/boot/dts/sprd-sc9836.dtsi               |  103 +++
 arch/arm64/boot/dts/sprd-sharkl64.dtsi             |  105 +++
 arch/arm64/configs/defconfig                       |    2 +
 drivers/tty/serial/Kconfig                         |   23 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/sprd_serial.c                   |  752 ++++++++++++++++++++
 include/uapi/linux/serial_core.h                   |    3 +
 15 files changed, 1113 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/arm/sprd.txt
 rename Documentation/devicetree/bindings/serial/{of-serial.txt => 8250.txt} (100%)
 create mode 100644 Documentation/devicetree/bindings/serial/sprd-uart.txt
 create mode 100644 arch/arm64/boot/dts/sprd-sc9836-openphone.dts
 create mode 100644 arch/arm64/boot/dts/sprd-sc9836.dtsi
 create mode 100644 arch/arm64/boot/dts/sprd-sharkl64.dtsi
 create mode 100644 drivers/tty/serial/sprd_serial.c

-- 
1.7.9.5

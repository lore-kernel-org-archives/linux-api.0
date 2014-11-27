From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 0/5] Add Spreadtrum Sharkl64 Platform support
Date: Thu, 27 Nov 2014 12:03:56 +0000
Message-ID: <20141127120356.GF857@leverpostej>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
Sender: linux-doc-owner@vger.kernel.org
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>, "robh+dt@kernel.org" <robh+dt@kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "jslaby@suse.cz" <jslaby@suse.cz>, "galak@codeaurora.org" <galak@codeaurora.org>, "broonie@linaro.org" <broonie@linaro.org>, "m-karicheri2@ti.com" <m-karicheri2@ti.com>, Pawel Moll <Pawel.Moll@arm.com>, "artagnon@gmail.com" <artagnon@gmail.com>, "rrichter@cavium.com" <rrichter@cavium.com>, Will Deacon <Will.Deacon@arm.com>, "arnd@arndb.de" <arnd@arndb.de>, "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, "corbet@lwn.net" <corbet@lwn.net>, "jason@lakedaemon.net" <jason@lakedaemon.net>, "broonie@kernel.org" <broonie@kernel.org>, "heiko@sntech.de" <heiko@sntech.de>, "shawn.guo@freescale.com" <shawn.g>
List-Id: linux-api@vger.kernel.org

Hi,

On Tue, Nov 25, 2014 at 12:16:53PM +0000, Chunyan Zhang wrote:
> Spreadtrum is a rapid growing chip vendor providing smart phone total solutions.
> 
> Sharkl64 Platform is nominated as a SoC infrastructure that supports 4G/3G/2G
> standards based on ARMv8 multiple core architecture.Now we have only one
> SoC(SC9836) based on this Platform in developing.
> 
> This patchset adds Sharkl64 support in arm64 device tree and the serial driver
> of SC9836-UART.
> 
> This patchset also has patches which address "sprd" prefix and DT compatible
> strings for nodes which appear un-documented.
> 
> This version code was tesed on Fast Mode.

This concerns me a bit because fast models are extremely lenient w.r.t.
the management of clocks and regulators. Are you sure you have
everything you need for your UART described?

> We use boot-wrapper-aarch64 as the bootloader.

Which version of boot-wrapper-aarch64 are you using?

Upstream does not implement PSCI 0.2, but its --enable-psci option will
inject PSCI 0.1 compatible properties, which leads me to suspect that
your DT is misleading. The boot wrapper should also program CNTFRQ_EL0
correctly regardless.

What do you intend to use on real hardware?

Thanks,
Mark.

> 
> Changes from v2:
> * Addressed review comments:
> 	- Added a specific compitible string 'sc9836-uart' for the serial
> 	- Added a full serial driver
> 	- Added the property 'clock-frequency' for timer node in dtsi.
> 	- Replaceed the old macro prefix 'UART_' with 'SPRD_' in the 
> 	  Spreadtrum serial driver code.
> * Revised the name of SoC and board from 'sharkl3' to 'sc9836'
> * Used dual-license for DTS files
> * Added a menuconfig 'ARCH_SPRD' in arch/arm64/Kconfig
> 
> Changes from v1:
> * Addressed review comments:
>         - Added "sprd" prefix to vendor-prefixes.txt
>         - Created serial/sprd-serial.txt and remove the properties for serial-sprd
>           from of-serial.txt to it.
>         - Renamed of-serial.txt to 8250.txt according to Arnd's review comments
>         - Splited and revised .dts for Sharkl64 Platform
>         - Changed to PSCI method for cpu power management
>         - Revised Kconfig Makefile to match the alphabetical ordering
>         - Renamed serial-sprd-earlycon.c to serial-sprd.c
> 
> Chunyan Zhang (3):
>   Documentation: DT: Renamed of-serial.txt to 8250.txt
>   Documentation: DT: Add bindings for Spreadtrum SoC Platform
>   tty/serial: Add Spreadtrum sc9836-uart driver support
> 
> Zhizhou Zhang (2):
>   arm64: dts: Add support for Spreadtrum SC9836 SoC in dts and Makefile
>   arm64: Add support for Spreadtrum's Sharkl64 Platform in Kconfig and
>     defconfig
> 
>  Documentation/devices.txt                          |    3 +
>  Documentation/devicetree/bindings/arm/sprd.txt     |   11 +
>  .../bindings/serial/{of-serial.txt => 8250.txt}    |    0
>  .../devicetree/bindings/serial/sprd-uart.txt       |    6 +
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  arch/arm64/Kconfig                                 |   17 +
>  arch/arm64/boot/dts/Makefile                       |    1 +
>  arch/arm64/boot/dts/sprd-sc9836-openphone.dts      |   85 +++
>  arch/arm64/boot/dts/sprd-sc9836.dtsi               |  103 +++
>  arch/arm64/boot/dts/sprd-sharkl64.dtsi             |  105 +++
>  arch/arm64/configs/defconfig                       |    2 +
>  drivers/tty/serial/Kconfig                         |   23 +
>  drivers/tty/serial/Makefile                        |    1 +
>  drivers/tty/serial/sprd_serial.c                   |  752 ++++++++++++++++++++
>  include/uapi/linux/serial_core.h                   |    3 +
>  15 files changed, 1113 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/arm/sprd.txt
>  rename Documentation/devicetree/bindings/serial/{of-serial.txt => 8250.txt} (100%)
>  create mode 100644 Documentation/devicetree/bindings/serial/sprd-uart.txt
>  create mode 100644 arch/arm64/boot/dts/sprd-sc9836-openphone.dts
>  create mode 100644 arch/arm64/boot/dts/sprd-sc9836.dtsi
>  create mode 100644 arch/arm64/boot/dts/sprd-sharkl64.dtsi
>  create mode 100644 drivers/tty/serial/sprd_serial.c
> 
> -- 
> 1.7.9.5
> 
> 

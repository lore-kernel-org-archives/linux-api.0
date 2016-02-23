From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 00/10] Support for Cortex-M Prototyping System
Date: Tue, 23 Feb 2016 14:34:18 +0000
Message-ID: <1456238068-25079-1-git-send-email-vladimir.murzin@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com
Cc: mark.rutland@arm.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, andy.shevchenko@gmail.com, gnomes@lxorguk.ukuu.org.uk, peter@hurleysoftware.com, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

This patch series provide the basic support for running ucLinux on V2M-MPS2
platform.

With these patches applied ucLinux can be run on both HW and FVP models
with Cortex-M3/M4/M7 configurations.

Board description:

http://infocenter.arm.com/help/topic/com.arm.doc.100112_0100_03_en/arm_versatile_express_cortex_m_prototyping_system_(v2m_mps2)_technical_reference_manual_100112_0100_03_en.pdf

Application notes (cover Cortex-M3/M4/M7):

http://infocenter.arm.com/help/topic/com.arm.doc.dai0385a/DAI0385A_cortex_m3_on_v2m_mps2.pdf
http://infocenter.arm.com/help/topic/com.arm.doc.dai0386a/DAI0386A_cortex_m4_on_v2m_mps2.pdf
http://infocenter.arm.com/help/topic/com.arm.doc.dai0399a/DAI0399A_cortex_m7_on_v2m_mps2.pdf
http://infocenter.arm.com/help/topic/com.arm.doc.dai0400a/DAI0400A_cortex_m7_on_v2m_mps2.pdf

Cortex-M System Design Kit (referenced as CMDK from documents above):

http://infocenter.arm.com/help/topic/com.arm.doc.ddi0479c/DDI0479C_cortex_m_system_design_kit_r1p0_trm.pdf

I'd be happy to hear any feedback/comments on this series!

Changelog:

  v3  -> v4:
      - rebased on 4.5-rc5
      - updated mps2-uart per Andy, Alan and Peter
      - dropped "zombie" EMBEDDED from defconfg per Arnd
      - moved mps2 under vexpress umbrella per Arnd
      - updated device-tree sources per Arnd
      - dropped low-level debug support, seems earlycon works well for that

  v2  -> v3:
      - rebased on 4.5-rc4
      - fixes for mps2-timer per Thomas
      - swicthed back to ttyMPS naming per Greg

  v1  -> v2:
      - rebased on 4.5-rc2
      - fixes for mps2-timer per Daniel and Rob (added Ack from Daniel)
      - fixes for mps2-uart per Greg and Andy

  RFC -> v1:
      - dropped RFC tag
      - rebased on 4.4-rc3
      - added Acks from Rob
      - updated mps2-timer per Daniel
      - fixed build failures reported by 0-DAY kernel test infrastructure

Thanks!

Vladimir Murzin (10):
  dt-bindings: document the MPS2 timer bindings
  clockevents/drivers: add MPS2 Timer driver
  dt-bindings: document the MPS2 UART bindings
  serial: mps2-uart: add MPS2 UART driver
  serial: mps2-uart: add support for early console
  ARM: vexpress/mps2: introduce MPS2 platform
  ARM: configs: add MPS2 defconfig
  ARM: dts: introduce MPS2 AN385/AN386
  ARM: dts: introduce MPS2 AN399/AN400
  MAINTAINERS: Update ARM Versatile Express platform entry

 .../devicetree/bindings/serial/arm,mps2-uart.txt   |   19 +
 .../devicetree/bindings/timer/arm,mps2-timer.txt   |   28 +
 MAINTAINERS                                        |    1 +
 arch/arm/Kconfig                                   |    8 +
 arch/arm/Makefile                                  |    1 +
 arch/arm/boot/dts/Makefile                         |    3 +
 arch/arm/boot/dts/mps2-an385.dts                   |   92 +++
 arch/arm/boot/dts/mps2-an399.dts                   |   92 +++
 arch/arm/boot/dts/mps2.dtsi                        |  242 ++++++++
 arch/arm/configs/mps2_defconfig                    |  109 ++++
 arch/arm/mach-vexpress/Makefile                    |    4 +-
 arch/arm/mach-vexpress/Makefile.boot               |    3 +
 arch/arm/mach-vexpress/v2m-mps2.c                  |   21 +
 drivers/clocksource/Kconfig                        |    6 +
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/mps2-timer.c                   |  275 +++++++++
 drivers/tty/serial/Kconfig                         |   13 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/mps2-uart.c                     |  614 ++++++++++++++++++++
 include/uapi/linux/serial_core.h                   |    3 +
 20 files changed, 1535 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/serial/arm,mps2-uart.txt
 create mode 100644 Documentation/devicetree/bindings/timer/arm,mps2-timer.txt
 create mode 100644 arch/arm/boot/dts/mps2-an385.dts
 create mode 100644 arch/arm/boot/dts/mps2-an399.dts
 create mode 100644 arch/arm/boot/dts/mps2.dtsi
 create mode 100644 arch/arm/configs/mps2_defconfig
 create mode 100644 arch/arm/mach-vexpress/Makefile.boot
 create mode 100644 arch/arm/mach-vexpress/v2m-mps2.c
 create mode 100644 drivers/clocksource/mps2-timer.c
 create mode 100644 drivers/tty/serial/mps2-uart.c

-- 
1.7.9.5

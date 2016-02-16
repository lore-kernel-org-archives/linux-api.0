From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v3 00/10] Support for Cortex-M Prototyping System
Date: Tue, 16 Feb 2016 10:08:05 +0000
Message-ID: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de
Cc: mark.rutland@arm.com, devicetree@vger.kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, andy.shevchenko@gmail.com, robh+dt@kernel.org, linux-serial@vger.kernel.org, galak@codeaurora.org, jslaby@suse.cz, linux-arm-kernel@lists.infradead.org
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
  ARM: mps2: introduce MPS2 platform
  ARM: mps2: add low-level debug support
  ARM: configs: add MPS2 defconfig
  ARM: dts: introduce MPS2 AN385/AN386
  ARM: dts: introduce MPS2 AN399/AN400

 .../devicetree/bindings/serial/arm,mps2-uart.txt   |   22 +
 .../devicetree/bindings/timer/arm,mps2-timer.txt   |   28 +
 arch/arm/Kconfig                                   |    8 +
 arch/arm/Kconfig.debug                             |   12 +-
 arch/arm/Makefile                                  |    1 +
 arch/arm/boot/dts/Makefile                         |    3 +
 arch/arm/boot/dts/mps2-an385.dts                   |   90 +++
 arch/arm/boot/dts/mps2-an399.dts                   |   92 +++
 arch/arm/boot/dts/mps2.dtsi                        |  227 ++++++++
 arch/arm/configs/mps2_defconfig                    |  112 ++++
 arch/arm/include/debug/mps2.S                      |   27 +
 arch/arm/mach-mps2/Makefile                        |    1 +
 arch/arm/mach-mps2/Makefile.boot                   |    3 +
 arch/arm/mach-mps2/dtmachine.c                     |   21 +
 drivers/clocksource/Kconfig                        |    6 +
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/mps2-timer.c                   |  275 +++++++++
 drivers/tty/serial/Kconfig                         |   13 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/mps2-uart.c                     |  614 ++++++++++++++++++++
 include/uapi/linux/serial_core.h                   |    3 +
 21 files changed, 1559 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/serial/arm,mps2-uart.txt
 create mode 100644 Documentation/devicetree/bindings/timer/arm,mps2-timer.txt
 create mode 100644 arch/arm/boot/dts/mps2-an385.dts
 create mode 100644 arch/arm/boot/dts/mps2-an399.dts
 create mode 100644 arch/arm/boot/dts/mps2.dtsi
 create mode 100644 arch/arm/configs/mps2_defconfig
 create mode 100644 arch/arm/include/debug/mps2.S
 create mode 100644 arch/arm/mach-mps2/Makefile
 create mode 100644 arch/arm/mach-mps2/Makefile.boot
 create mode 100644 arch/arm/mach-mps2/dtmachine.c
 create mode 100644 drivers/clocksource/mps2-timer.c
 create mode 100644 drivers/tty/serial/mps2-uart.c

-- 
1.7.9.5

From: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Subject: [RFC PATCH 00/10] Support for Cortex-M Prototyping System
Date: Wed, 25 Nov 2015 10:33:31 +0000
Message-ID: <1448447621-17900-1-git-send-email-vladimir.murzin@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arnd-r2nGTMty4D4@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Mark.Rutland-5wv7dgnIgG8@public.gmane.org, Pawel.Moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi,

This patch series provide the basic support for running ucLinux on V2M-MPS2
platform.

With these patches applied ucLinux can be run on both HW and FVP models
with Cortex-M3/M4/M7 configurations.

Board description:

http://infocenter.arm.com/help/topic/com.arm.doc.100112_0100_03_en/arm_vers=
atile_express_cortex_m_prototyping_system_(v2m_mps2)_technical_reference_ma=
nual_100112_0100_03_en.pdf

Application notes (cover Cortex-M3/M4/M7):

http://infocenter.arm.com/help/topic/com.arm.doc.dai0385a/DAI0385A_cortex_m=
3_on_v2m_mps2.pdf
http://infocenter.arm.com/help/topic/com.arm.doc.dai0386a/DAI0386A_cortex_m=
4_on_v2m_mps2.pdf
http://infocenter.arm.com/help/topic/com.arm.doc.dai0399a/DAI0399A_cortex_m=
7_on_v2m_mps2.pdf
http://infocenter.arm.com/help/topic/com.arm.doc.dai0400a/DAI0400A_cortex_m=
7_on_v2m_mps2.pdf

Cortex-M System Design Kit (referenced as CMDK from documents above):

http://infocenter.arm.com/help/topic/com.arm.doc.ddi0479c/DDI0479C_cortex_m=
_system_design_kit_r1p0_trm.pdf

I'd be happy to hear any feedback/comments on this series!

Remain questions:

 - Application notes 399/400 have PSRAM located at address different to wha=
t
   we have for AN385/AN386, so I'm wondering what is the best practice to h=
andle
   CONFIG_DRAM_BASE? Different defconfig or there is better place?

 - I'm not sure about naming of dts files: Application Notes (mps2-an*) vs =
Cortex-M (mps2-cm*);
   any preference?

P.S.

This series is against 4.4-rc1.

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
 arch/arm/boot/dts/mps2.dtsi                        |  227 +++++++
 arch/arm/configs/mps2_defconfig                    |  112 ++++
 arch/arm/include/debug/mps2.S                      |   27 +
 arch/arm/mach-mps2/Makefile                        |    1 +
 arch/arm/mach-mps2/Makefile.boot                   |    3 +
 arch/arm/mach-mps2/dtmachine.c                     |   21 +
 drivers/clocksource/Kconfig                        |    5 +
 drivers/clocksource/Makefile                       |    1 +
 drivers/clocksource/mps2-timer.c                   |  280 +++++++++
 drivers/tty/serial/Kconfig                         |   13 +
 drivers/tty/serial/Makefile                        |    1 +
 drivers/tty/serial/mps2-uart.c                     |  626 ++++++++++++++++=
++++
 include/uapi/linux/serial_core.h                   |    3 +
 21 files changed, 1575 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/serial/arm,mps2-uart.=
txt
 create mode 100644 Documentation/devicetree/bindings/timer/arm,mps2-timer.=
txt
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

--=20
1.7.9.5

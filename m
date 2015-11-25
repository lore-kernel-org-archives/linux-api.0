From: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Subject: [RFC PATCH 07/10] ARM: mps2: add low-level debug support
Date: Wed, 25 Nov 2015 10:33:38 +0000
Message-ID: <1448447621-17900-8-git-send-email-vladimir.murzin@arm.com>
References: <1448447621-17900-1-git-send-email-vladimir.murzin@arm.com>
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448447621-17900-1-git-send-email-vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: arnd-r2nGTMty4D4@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Mark.Rutland-5wv7dgnIgG8@public.gmane.org, Pawel.Moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Add low-level debug support for MPS2, so that earlyprintk can be enabled
for debugging early boot issues.

Signed-off-by: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
---
 arch/arm/Kconfig.debug        |   12 +++++++++++-
 arch/arm/include/debug/mps2.S |   27 +++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/include/debug/mps2.S

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 259c0ca..cfbf09a 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -479,6 +479,13 @@ choice
 =09=09  Say Y here if you want kernel low-level debugging support
 =09=09  on MMP UART3.
=20
+=09config DEBUG_MPS2_UART
+=09=09bool "Kernel low-level debugging message via MPS2 UART0"
+=09=09depends on ARCH_MPS2
+=09=09help
+=09=09  Say Y here if you want kernel low-level debugging support
+=09=09  on MPS2 based platforms.
+
 =09config DEBUG_QCOM_UARTDM
 =09=09bool "Kernel low-level debugging messages via QCOM UARTDM"
 =09=09depends on ARCH_QCOM
@@ -1350,6 +1357,7 @@ config DEBUG_LL_INCLUDE
 =09default "debug/zynq.S" if DEBUG_ZYNQ_UART0 || DEBUG_ZYNQ_UART1
 =09default "debug/bcm63xx.S" if DEBUG_UART_BCM63XX
 =09default "debug/digicolor.S" if DEBUG_DIGICOLOR_UA0
+=09default "debug/mps2.S" if DEBUG_MPS2_UART
 =09default "mach/debug-macro.S"
=20
 # Compatibility options for PL01x
@@ -1403,6 +1411,7 @@ config DEBUG_UART_PHYS
 =09default 0x20068000 if DEBUG_RK29_UART2 || DEBUG_RK3X_UART3
 =09default 0x20201000 if DEBUG_BCM2835
 =09default 0x3e000000 if DEBUG_BCM_KONA_UART
+=09default 0x40004000 if DEBUG_MPS2_UART
 =09default 0x4000e400 if DEBUG_LL_UART_EFM32
 =09default 0x40081000 if DEBUG_LPC18XX_UART0
 =09default 0x40090000 if ARCH_LPC32XX
@@ -1476,7 +1485,8 @@ config DEBUG_UART_PHYS
 =09=09DEBUG_RMOBILE_SCIFA4 || DEBUG_S3C24XX_UART || \
 =09=09DEBUG_UART_BCM63XX || DEBUG_ASM9260_UART || \
 =09=09DEBUG_SIRFSOC_UART || DEBUG_DIGICOLOR_UA0 || \
-=09=09DEBUG_AT91_UART
+=09=09DEBUG_AT91_UART || \
+=09=09DEBUG_MPS2_UART
=20
 config DEBUG_UART_VIRT
 =09hex "Virtual base address of debug UART"
diff --git a/arch/arm/include/debug/mps2.S b/arch/arm/include/debug/mps2.S
new file mode 100644
index 0000000..0ced0ce
--- /dev/null
+++ b/arch/arm/include/debug/mps2.S
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2015 ARM Limited
+ *
+ * Author: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+=09.macro=09addruart, rp, tmp1, tmp2
+=09ldr=09\rp, =3DCONFIG_DEBUG_UART_PHYS
+=09.endm
+
+=09.macro=09senduart, rd, rx
+=09strb=09\rd, [\rx]=09=09@ Data Register
+=09.endm
+
+=09.macro=09busyuart, rd, rx
+1001:=09ldrb=09\rd, [\rx, #0x4]=09@ State Register
+=09tst=09\rd, #1=09=09=09@ busy
+=09bne=091001b=09=09=09@ wait until transmit done
+=09.endm
+
+=09.macro=09waituart,rd,rx
+=09.endm
--=20
1.7.9.5

From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v3 07/10] ARM: mps2: add low-level debug support
Date: Tue, 16 Feb 2016 10:08:12 +0000
Message-ID: <1455617295-23736-8-git-send-email-vladimir.murzin@arm.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de
Cc: mark.rutland@arm.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, andy.shevchenko@gmail.com, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Add low-level debug support for MPS2, so that earlyprintk can be enabled
for debugging early boot issues.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/Kconfig.debug        |   12 +++++++++++-
 arch/arm/include/debug/mps2.S |   27 +++++++++++++++++++++++++++
 2 files changed, 38 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/include/debug/mps2.S

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index c6b6175..fcd2e15 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -485,6 +485,13 @@ choice
 		  Say Y here if you want kernel low-level debugging support
 		  on MMP UART3.
 
+	config DEBUG_MPS2_UART
+		bool "Kernel low-level debugging message via MPS2 UART0"
+		depends on ARCH_MPS2
+		help
+		  Say Y here if you want kernel low-level debugging support
+		  on MPS2 based platforms.
+
 	config DEBUG_MVEBU_UART0
 		bool "Kernel low-level debugging messages via MVEBU UART0 (old bootloaders)"
 		depends on ARCH_MVEBU
@@ -1415,6 +1422,7 @@ config DEBUG_LL_INCLUDE
 	default "debug/zynq.S" if DEBUG_ZYNQ_UART0 || DEBUG_ZYNQ_UART1
 	default "debug/bcm63xx.S" if DEBUG_BCM63XX_UART
 	default "debug/digicolor.S" if DEBUG_DIGICOLOR_UA0
+	default "debug/mps2.S" if DEBUG_MPS2_UART
 	default "mach/debug-macro.S"
 
 # Compatibility options for PL01x
@@ -1463,6 +1471,7 @@ config DEBUG_UART_PHYS
 	default 0x20201000 if DEBUG_BCM2835
 	default 0x3f201000 if DEBUG_BCM2836
 	default 0x3e000000 if DEBUG_BCM_KONA_UART
+	default 0x40004000 if DEBUG_MPS2_UART
 	default 0x4000e400 if DEBUG_LL_UART_EFM32
 	default 0x40081000 if DEBUG_LPC18XX_UART0
 	default 0x40090000 if DEBUG_LPC32XX
@@ -1539,7 +1548,8 @@ config DEBUG_UART_PHYS
 		DEBUG_S3C64XX_UART || \
 		DEBUG_BCM63XX_UART || DEBUG_ASM9260_UART || \
 		DEBUG_SIRFSOC_UART || DEBUG_DIGICOLOR_UA0 || \
-		DEBUG_AT91_UART
+		DEBUG_AT91_UART || \
+		DEBUG_MPS2_UART
 
 config DEBUG_UART_VIRT
 	hex "Virtual base address of debug UART"
diff --git a/arch/arm/include/debug/mps2.S b/arch/arm/include/debug/mps2.S
new file mode 100644
index 0000000..0ced0ce
--- /dev/null
+++ b/arch/arm/include/debug/mps2.S
@@ -0,0 +1,27 @@
+/*
+ * Copyright (C) 2015 ARM Limited
+ *
+ * Author: Vladimir Murzin <vladimir.murzin@arm.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ */
+
+	.macro	addruart, rp, tmp1, tmp2
+	ldr	\rp, =CONFIG_DEBUG_UART_PHYS
+	.endm
+
+	.macro	senduart, rd, rx
+	strb	\rd, [\rx]		@ Data Register
+	.endm
+
+	.macro	busyuart, rd, rx
+1001:	ldrb	\rd, [\rx, #0x4]	@ State Register
+	tst	\rd, #1			@ busy
+	bne	1001b			@ wait until transmit done
+	.endm
+
+	.macro	waituart,rd,rx
+	.endm
-- 
1.7.9.5

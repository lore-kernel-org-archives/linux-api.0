From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v4 06/10] ARM: vexpress/mps2: introduce MPS2 platform
Date: Tue, 23 Feb 2016 14:34:24 +0000
Message-ID: <1456238068-25079-7-git-send-email-vladimir.murzin@arm.com>
References: <1456238068-25079-1-git-send-email-vladimir.murzin@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456238068-25079-1-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: arnd@arndb.de, linux@arm.linux.org.uk, gregkh@linuxfoundation.org, daniel.lezcano@linaro.org, tglx@linutronix.de, u.kleine-koenig@pengutronix.de, liviu.dudau@arm.com, sudeep.holla@arm.com, lorenzo.pieralisi@arm.com
Cc: mark.rutland@arm.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, jslaby@suse.cz, robh+dt@kernel.org, andy.shevchenko@gmail.com, gnomes@lxorguk.ukuu.org.uk, peter@hurleysoftware.com, devicetree@vger.kernel.org, linux-serial@vger.kernel.org, linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: linux-api@vger.kernel.org

The Cortex-M Prototyping System (or V2M-MPS2) is designed for
prototyping and evaluation Cortex-M family of processors including the
latest Cortex-M7

It comes with a range of useful peripherals including 8MB single cycle
SRAM, 16MB PSRAM, Ethernet, QSVGA touch screen panel, 4bit RGB VGA
connector, Audio, SPI and GPIO.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arch/arm/Kconfig                     |    8 ++++++++
 arch/arm/Makefile                    |    1 +
 arch/arm/mach-vexpress/Makefile      |    4 +++-
 arch/arm/mach-vexpress/Makefile.boot |    3 +++
 arch/arm/mach-vexpress/v2m-mps2.c    |   21 +++++++++++++++++++++
 5 files changed, 36 insertions(+), 1 deletion(-)
 create mode 100644 arch/arm/mach-vexpress/Makefile.boot
 create mode 100644 arch/arm/mach-vexpress/v2m-mps2.c

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 4f799e5..48fa6c4 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -883,6 +883,14 @@ config ARCH_STM32
 	help
 	  Support for STMicroelectronics STM32 processors.
 
+config ARCH_MPS2
+	bool "ARM MPS2 paltform"
+	depends on ARM_SINGLE_ARMV7M
+	select ARM_AMBA
+	select CLKSRC_MPS2
+	help
+	  Support for ARM MPS2 Cortex-M platform.
+
 # Definitions to make life easier
 config ARCH_ACORN
 	bool
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index fe25410..e08a211 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -182,6 +182,7 @@ machine-$(CONFIG_ARCH_LPC18XX)		+= lpc18xx
 machine-$(CONFIG_ARCH_LPC32XX)		+= lpc32xx
 machine-$(CONFIG_ARCH_MESON)		+= meson
 machine-$(CONFIG_ARCH_MMP)		+= mmp
+machine-$(CONFIG_ARCH_MPS2)		+= vexpress
 machine-$(CONFIG_ARCH_MOXART)		+= moxart
 machine-$(CONFIG_ARCH_MV78XX0)		+= mv78xx0
 machine-$(CONFIG_ARCH_MVEBU)		+= mvebu
diff --git a/arch/arm/mach-vexpress/Makefile b/arch/arm/mach-vexpress/Makefile
index f5c1006..a1d8ec9 100644
--- a/arch/arm/mach-vexpress/Makefile
+++ b/arch/arm/mach-vexpress/Makefile
@@ -4,7 +4,7 @@
 ccflags-$(CONFIG_ARCH_MULTIPLATFORM) := \
 	-I$(srctree)/arch/arm/plat-versatile/include
 
-obj-y					:= v2m.o
+obj-$(CONFIG_ARCH_VEXPRESS)		:= v2m.o
 obj-$(CONFIG_ARCH_VEXPRESS_DCSCB)	+= dcscb.o	dcscb_setup.o
 CFLAGS_dcscb.o				+= -march=armv7-a
 CFLAGS_REMOVE_dcscb.o			= -pg
@@ -15,3 +15,5 @@ CFLAGS_tc2_pm.o				+= -march=armv7-a
 CFLAGS_REMOVE_tc2_pm.o			= -pg
 obj-$(CONFIG_SMP)			+= platsmp.o
 obj-$(CONFIG_HOTPLUG_CPU)		+= hotplug.o
+
+obj-$(COFIG_ARCH_MPS2)			+= v2m-mps2.o
diff --git a/arch/arm/mach-vexpress/Makefile.boot b/arch/arm/mach-vexpress/Makefile.boot
new file mode 100644
index 0000000..eacfc3f
--- /dev/null
+++ b/arch/arm/mach-vexpress/Makefile.boot
@@ -0,0 +1,3 @@
+# Empty file waiting for deletion once Makefile.boot isn't needed any more.
+# Patch waits for application at
+# http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7889/1 .
diff --git a/arch/arm/mach-vexpress/v2m-mps2.c b/arch/arm/mach-vexpress/v2m-mps2.c
new file mode 100644
index 0000000..e7ad9c2
--- /dev/null
+++ b/arch/arm/mach-vexpress/v2m-mps2.c
@@ -0,0 +1,21 @@
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
+#include <asm/mach/arch.h>
+
+static const char *const mps2_compat[] __initconst = {
+	"arm,mps2",
+	NULL
+};
+
+DT_MACHINE_START(MPS2DT, "MPS2 (Device Tree Support)")
+	.dt_compat = mps2_compat,
+MACHINE_END
-- 
1.7.9.5

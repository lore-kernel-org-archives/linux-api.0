From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: [PATCH v8 12/16] ARM: Add STM32 family machine
Date: Sat,  9 May 2015 09:53:54 +0200
Message-ID: <1431158038-3813-13-git-send-email-mcoquelin.stm32@gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-gpio-owner@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, stefan@agner.ch, pmeerw@pmeerw.net, pebolle@tiscali.nl, peter@hurleysoftware.com, andy.shevchenko@gmail.com, cw00.choi@samsung.com, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, joe@perches.com, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, lee.jones@linaro.org, Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.cz>, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-gpio@vger.kernel.org, linux-serial@vger.kernel.org, linux-arch@vger.kerne
List-Id: linux-api@vger.kernel.org

STMicrolectronics's STM32 series is a family of Cortex-M
microcontrollers. It is used in various applications, and
proposes a wide range of peripherals.

Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
---
 Documentation/arm/stm32/overview.txt           | 32 ++++++++++++++++++++++++++
 Documentation/arm/stm32/stm32f429-overview.txt | 22 ++++++++++++++++++
 arch/arm/Kconfig                               | 18 +++++++++++++++
 arch/arm/Makefile                              |  1 +
 arch/arm/mach-stm32/Makefile                   |  1 +
 arch/arm/mach-stm32/Makefile.boot              |  3 +++
 arch/arm/mach-stm32/board-dt.c                 | 19 +++++++++++++++
 7 files changed, 96 insertions(+)
 create mode 100644 Documentation/arm/stm32/overview.txt
 create mode 100644 Documentation/arm/stm32/stm32f429-overview.txt
 create mode 100644 arch/arm/mach-stm32/Makefile
 create mode 100644 arch/arm/mach-stm32/Makefile.boot
 create mode 100644 arch/arm/mach-stm32/board-dt.c

diff --git a/Documentation/arm/stm32/overview.txt b/Documentation/arm/stm32/overview.txt
new file mode 100644
index 0000000..09aed55
--- /dev/null
+++ b/Documentation/arm/stm32/overview.txt
@@ -0,0 +1,32 @@
+			STM32 ARM Linux Overview
+			========================
+
+Introduction
+------------
+
+  The STMicroelectronics family of Cortex-M based MCUs are supported by the
+  'STM32' platform of ARM Linux. Currently only the STM32F429 is supported.
+
+
+Configuration
+-------------
+
+  A generic configuration is provided for STM32 family, and can be used as the
+  default by
+	make stm32_defconfig
+
+Layout
+------
+
+  All the files for multiple machine families are located in the platform code
+  contained in arch/arm/mach-stm32
+
+  There is a generic board board-dt.c in the mach folder which support
+  Flattened Device Tree, which means, it works with any compatible board with
+  Device Trees.
+
+
+Document Author
+---------------
+
+  Maxime Coquelin <mcoquelin.stm32@gmail.com>
diff --git a/Documentation/arm/stm32/stm32f429-overview.txt b/Documentation/arm/stm32/stm32f429-overview.txt
new file mode 100644
index 0000000..5206822
--- /dev/null
+++ b/Documentation/arm/stm32/stm32f429-overview.txt
@@ -0,0 +1,22 @@
+			STM32F429 Overview
+			==================
+
+  Introduction
+  ------------
+	The STM32F429 is a Cortex-M4 MCU aimed at various applications.
+	It features:
+	- ARM Cortex-M4 up to 180MHz with FPU
+	- 2MB internal Flash Memory
+	- External memory support through FMC controller (PSRAM, SDRAM, NOR, NAND)
+	- I2C, SPI, SAI, CAN, USB OTG, Ethernet controllers
+	- LCD controller & Camera interface
+	- Cryptographic processor
+
+  Resources
+  ---------
+	Datasheet and reference manual are publicly available on ST website:
+	- http://www.st.com/web/en/catalog/mmc/FM141/SC1169/SS1577/LN1806?ecmp=stm32f429-439_pron_pr-ces2014_nov2013
+
+  Document Author
+  ---------------
+	Maxime Coquelin <mcoquelin.stm32@gmail.com>
diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index 45df48b..21fe5c8 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -757,6 +757,24 @@ config ARCH_OMAP1
 	help
 	  Support for older TI OMAP1 (omap7xx, omap15xx or omap16xx)
 
+config ARCH_STM32
+	bool "STMicrolectronics STM32"
+	depends on !MMU
+	select ARCH_HAS_RESET_CONTROLLER
+	select ARM_NVIC
+	select ARMV7M_SYSTICK
+	select AUTO_ZRELADDR
+	select CLKSRC_OF
+	select COMMON_CLK
+	select CPU_V7M
+	select GENERIC_CLOCKEVENTS
+	select NO_IOPORT_MAP
+	select RESET_CONTROLLER
+	select SPARSE_IRQ
+	select USE_OF
+	help
+	  Support for STMicroelectronics STM32 processors.
+
 endchoice
 
 menu "Multiple platform selection"
diff --git a/arch/arm/Makefile b/arch/arm/Makefile
index 985227c..0fac562 100644
--- a/arch/arm/Makefile
+++ b/arch/arm/Makefile
@@ -196,6 +196,7 @@ machine-$(CONFIG_ARCH_SHMOBILE) 	+= shmobile
 machine-$(CONFIG_ARCH_SIRF)		+= prima2
 machine-$(CONFIG_ARCH_SOCFPGA)		+= socfpga
 machine-$(CONFIG_ARCH_STI)		+= sti
+machine-$(CONFIG_ARCH_STM32)		+= stm32
 machine-$(CONFIG_ARCH_SUNXI)		+= sunxi
 machine-$(CONFIG_ARCH_TEGRA)		+= tegra
 machine-$(CONFIG_ARCH_U300)		+= u300
diff --git a/arch/arm/mach-stm32/Makefile b/arch/arm/mach-stm32/Makefile
new file mode 100644
index 0000000..bd0b7b5
--- /dev/null
+++ b/arch/arm/mach-stm32/Makefile
@@ -0,0 +1 @@
+obj-y += board-dt.o
diff --git a/arch/arm/mach-stm32/Makefile.boot b/arch/arm/mach-stm32/Makefile.boot
new file mode 100644
index 0000000..eacfc3f
--- /dev/null
+++ b/arch/arm/mach-stm32/Makefile.boot
@@ -0,0 +1,3 @@
+# Empty file waiting for deletion once Makefile.boot isn't needed any more.
+# Patch waits for application at
+# http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7889/1 .
diff --git a/arch/arm/mach-stm32/board-dt.c b/arch/arm/mach-stm32/board-dt.c
new file mode 100644
index 0000000..f2ad772
--- /dev/null
+++ b/arch/arm/mach-stm32/board-dt.c
@@ -0,0 +1,19 @@
+/*
+ * Copyright (C) Maxime Coquelin 2015
+ * Author:  Maxime Coquelin <mcoquelin.stm32@gmail.com>
+ * License terms:  GNU General Public License (GPL), version 2
+ */
+
+#include <linux/kernel.h>
+#include <asm/v7m.h>
+#include <asm/mach/arch.h>
+
+static const char *const stm32_compat[] __initconst = {
+	"st,stm32f429",
+	NULL
+};
+
+DT_MACHINE_START(STM32DT, "STM32 (Device Tree Support)")
+	.dt_compat = stm32_compat,
+	.restart = armv7m_restart,
+MACHINE_END
-- 
1.9.1


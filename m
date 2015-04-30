From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v7 11/15] ARM: Add STM32 family machine
Date: Thu, 30 Apr 2015 18:20:40 +0200
Message-ID: <1430410844-16062-12-git-send-email-mcoquelin.stm32@gmail.com>
References: <1430410844-16062-1-git-send-email-mcoquelin.stm32@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430410844-16062-1-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, stefan-XLVq0VzYD2Y@public.gmane.org, pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org, pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org, peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Nikolay Borisov <Nikolay.Borisov-5wv7dgnIgG8@public.gmane.org>, Rusty Russell <rusty-8n+1lVoiYb80n/F98K4Iww@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Michal Marek <mmarek-AlSwsSmVLrQ@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-gpio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TZNg+MwTxZMZA@public.gmane.org
List-Id: linux-api@vger.kernel.org

STMicrolectronics's STM32 series is a family of Cortex-M
microcontrollers. It is used in various applications, and
proposes a wide range of peripherals.

Tested-by: Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
+  Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
+	Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
+ * Author:  Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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

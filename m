From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 02/18] ARM: ARMv7M: Enlarge vector table to 256 entries
Date: Fri, 20 Feb 2015 19:01:01 +0100
Message-ID: <1424455277-29983-3-git-send-email-mcoquelin.stm32__11499.794983729$1424455702$gmane$org@gmail.com>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424455277-29983-1-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Antti Palosaari <crope-X3B1VOXEql0@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will
List-Id: linux-api@vger.kernel.org

>From Cortex-M reference manuals, the nvic supports up to 240 interrupts.
So the number of entries in vectors table is up to 256.

This patch adds a new config flag to specify the number of external interrupts.
Some ifdeferies are added in order to respect the natural alignment without
wasting too much space on smaller systems.

Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 arch/arm/kernel/entry-v7m.S | 13 +++++++++----
 arch/arm/mm/Kconfig         | 15 +++++++++++++++
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/entry-v7m.S b/arch/arm/kernel/entry-v7m.S
index 8944f49..68cde36 100644
--- a/arch/arm/kernel/entry-v7m.S
+++ b/arch/arm/kernel/entry-v7m.S
@@ -117,9 +117,14 @@ ENTRY(__switch_to)
 ENDPROC(__switch_to)
 
 	.data
-	.align	8
+#if CONFIG_CPUV7M_NUM_IRQ <= 112
+	.align	9
+#else
+	.align	10
+#endif
+
 /*
- * Vector table (64 words => 256 bytes natural alignment)
+ * Vector table (Natural alignment need to be ensured)
  */
 ENTRY(vector_table)
 	.long	0			@ 0 - Reset stack pointer
@@ -138,6 +143,6 @@ ENTRY(vector_table)
 	.long	__invalid_entry		@ 13 - Reserved
 	.long	__pendsv_entry		@ 14 - PendSV
 	.long	__invalid_entry		@ 15 - SysTick
-	.rept	64 - 16
-	.long	__irq_entry		@ 16..64 - External Interrupts
+	.rept	CONFIG_CPUV7M_NUM_IRQ
+	.long	__irq_entry		@ External Interrupts
 	.endr
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index c43c714..27eb835 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -604,6 +604,21 @@ config CPU_USE_DOMAINS
 	  This option enables or disables the use of domain switching
 	  via the set_fs() function.
 
+config CPUV7M_NUM_IRQ
+	int "Number of external interrupts connected to the NVIC"
+	depends on CPU_V7M
+	default 90 if ARCH_STM32
+	default 38 if ARCH_EFM32
+	default 240
+	help
+	  This option indicates the number of interrupts connected to the NVIC.
+	  The value can be larger than the real number of interrupts supported
+	  by the system, but must not be lower.
+	  The default value is 240, corresponding to the maximum number of
+	  interrupts supported by the NVIC on Cortex-M family.
+
+	  If unsure, keep default value.
+
 #
 # CPU supports 36-bit I/O
 #
-- 
1.9.1

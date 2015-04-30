From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: [PATCH v7 02/15] ARM: ARMv7-M: Enlarge vector table up to 256 entries
Date: Thu, 30 Apr 2015 18:20:31 +0200
Message-ID: <1430410844-16062-3-git-send-email-mcoquelin.stm32@gmail.com>
References: <1430410844-16062-1-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1430410844-16062-1-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, stefan@agner.ch, pmeerw@pmeerw.net, pebolle@tiscali.nl, peter@hurleysoftware.com, andy.shevchenko@gmail.com, cw00.choi@samsung.com, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, joe@perches.com, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.cz>, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-gpio@vger.kernel.org, linux-serial@vger.kernel.org, linux-arch@vger.kerne
List-Id: linux-api@vger.kernel.org

=46rom Cortex-M reference manuals, the nvic supports up to 240 interrup=
ts.
So the number of entries in vectors table is up to 256.

This patch adds a new config flag to specify the number of external int=
errupts.
Some ifdeferies are added in order to respect the natural alignment wit=
hout
wasting too much space on smaller systems.

Acked-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
Acked-by: Stefan Agner <stefan@agner.ch>
Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
---
 arch/arm/kernel/entry-v7m.S | 13 +++++++++----
 arch/arm/mm/Kconfig         | 15 +++++++++++++++
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/entry-v7m.S b/arch/arm/kernel/entry-v7m.S
index 8944f49..b6c8bb9 100644
--- a/arch/arm/kernel/entry-v7m.S
+++ b/arch/arm/kernel/entry-v7m.S
@@ -117,9 +117,14 @@ ENTRY(__switch_to)
 ENDPROC(__switch_to)
=20
 	.data
-	.align	8
+#if CONFIG_CPU_V7M_NUM_IRQ <=3D 112
+	.align	9
+#else
+	.align	10
+#endif
+
 /*
- * Vector table (64 words =3D> 256 bytes natural alignment)
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
+	.rept	CONFIG_CPU_V7M_NUM_IRQ
+	.long	__irq_entry		@ External Interrupts
 	.endr
diff --git a/arch/arm/mm/Kconfig b/arch/arm/mm/Kconfig
index b4f92b9..6173aa3 100644
--- a/arch/arm/mm/Kconfig
+++ b/arch/arm/mm/Kconfig
@@ -604,6 +604,21 @@ config CPU_USE_DOMAINS
 	  This option enables or disables the use of domain switching
 	  via the set_fs() function.
=20
+config CPU_V7M_NUM_IRQ
+	int "Number of external interrupts connected to the NVIC"
+	depends on CPU_V7M
+	default 90 if ARCH_STM32
+	default 38 if ARCH_EFM32
+	default 240
+	help
+	  This option indicates the number of interrupts connected to the NVI=
C.
+	  The value can be larger than the real number of interrupts supporte=
d
+	  by the system, but must not be lower.
+	  The default value is 240, corresponding to the maximum number of
+	  interrupts supported by the NVIC on Cortex-M family.
+
+	  If unsure, keep default value.
+
 #
 # CPU supports 36-bit I/O
 #
--=20
1.9.1

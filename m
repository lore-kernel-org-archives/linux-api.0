From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: [PATCH v3  05/15] dt-bindings: Document the STM32 reset bindings
Date: Thu, 12 Mar 2015 22:55:51 +0100
Message-ID: <1426197361-19290-6-git-send-email-maxime.coquelin@st.com>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
Sender: linux-arch-owner@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, stefan@agner.ch, pmeerw@pmeerw.net, pebolle@tiscali.nl
Cc: Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.cz>, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kerne
List-Id: linux-api@vger.kernel.org

From: Maxime Coquelin <mcoquelin.stm32@gmail.com>

This adds documentation of device tree bindings for the
STM32 reset controller.

Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
---
 .../devicetree/bindings/reset/st,stm32-rcc.txt     | 102 +++++++++++++++++++++
 1 file changed, 102 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reset/st,stm32-rcc.txt

diff --git a/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt b/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
new file mode 100644
index 0000000..962f961
--- /dev/null
+++ b/Documentation/devicetree/bindings/reset/st,stm32-rcc.txt
@@ -0,0 +1,102 @@
+STMicroelectronics STM32 Peripheral Reset Controller
+====================================================
+
+The RCC IP is both a reset and a clock controller. This documentation only
+document the reset part.
+
+Please also refer to reset.txt in this directory for common reset
+controller binding usage.
+
+Required properties:
+- compatible: Should be "st,stm32-rcc"
+- reg: should be register base and length as documented in the
+  datasheet
+- #reset-cells: 1, see below
+
+example:
+
+rcc: reset@40023800 {
+	#reset-cells = <1>;
+	compatible = "st,stm32-rcc";
+	reg = <0x40023800 0x400>;
+};
+
+Specifying softreset control of devices
+=======================================
+
+Device nodes should specify the reset channel required in their "resets"
+property, containing a phandle to the reset device node and an index specifying
+which channel to use.
+
+example:
+
+	timer2 {
+		resets			= <&rcc 256>;
+	};
+
+List of indexes for STM32F429:
+ - gpioa: 128
+ - gpiob: 129
+ - gpioc: 130
+ - gpiod: 131
+ - gpioe: 132
+ - gpiof: 133
+ - gpiog: 134
+ - gpioh: 135
+ - gpioi: 136
+ - gpioj: 137
+ - gpiok: 138
+ - crc: 140
+ - dma1: 149
+ - dma2: 150
+ - dma2d: 151
+ - ethmac: 153
+ - otghs: 157
+ - dcmi: 160
+ - cryp: 164
+ - hash: 165
+ - rng: 166
+ - otgfs: 167
+ - fmc: 192
+ - tim2: 256
+ - tim3: 257
+ - tim4: 258
+ - tim5: 259
+ - tim6: 260
+ - tim7: 261
+ - tim12: 262
+ - tim13: 263
+ - tim14: 264
+ - wwdg: 267
+ - spi2: 270
+ - spi3: 271
+ - uart2: 273
+ - uart3: 274
+ - uart4: 275
+ - uart5: 276
+ - i2c1: 277
+ - i2c2: 278
+ - i2c3: 279
+ - can1: 281
+ - can2: 282
+ - pwr: 284
+ - dac: 285
+ - uart7: 286
+ - uart8: 287
+ - tim1: 288
+ - tim8: 289
+ - usart1: 292
+ - usart6: 293
+ - adc: 296
+ - sdio: 299
+ - spi1: 300
+ - spi4: 301
+ - syscfg: 302
+ - tim9: 304
+ - tim10: 305
+ - tim11: 306
+ - spi5: 308
+ - spi6: 309
+ - sai1: 310
+ - ltdc: 31
+
-- 
1.9.1

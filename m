From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: [PATCH v8 05/16] dt-bindings: mfd: Add STM32F4 RCC numeric constants into DT include file
Date: Sat,  9 May 2015 09:53:47 +0200
Message-ID: <1431158038-3813-6-git-send-email-mcoquelin.stm32@gmail.com>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-gpio-owner@vger.kernel.org
To: u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, stefan@agner.ch, pmeerw@pmeerw.net, pebolle@tiscali.nl, peter@hurleysoftware.com, andy.shevchenko@gmail.com, cw00.choi@samsung.com, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, joe@perches.com, Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>, lee.jones@linaro.org, Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.cz>, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-gpio@vger.kernel.org, linux-serial@vger.kernel.org, linux-arch@vger.kerne
List-Id: linux-api@vger.kernel.org

Ths patch lists STM32F4's RCC numeric constants.
It will be used by clock and reset drivers, and DT bindings.

Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
---
 include/dt-bindings/mfd/stm32f4-rcc.h | 92 +++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 include/dt-bindings/mfd/stm32f4-rcc.h

diff --git a/include/dt-bindings/mfd/stm32f4-rcc.h b/include/dt-bindings/mfd/stm32f4-rcc.h
new file mode 100644
index 0000000..2f7ab9c
--- /dev/null
+++ b/include/dt-bindings/mfd/stm32f4-rcc.h
@@ -0,0 +1,92 @@
+/*
+ * This header provides constants for the STM32F4 RCC IP
+ */
+
+#ifndef _DT_BINDINGS_MFD_STM32F4_RCC_H
+#define _DT_BINDINGS_MFD_STM32F4_RCC_H
+
+/* AHB1 */
+#define STM32F4_RCC_AHB1_GPIOA	0
+#define STM32F4_RCC_AHB1_GPIOB	1
+#define STM32F4_RCC_AHB1_GPIOC	2
+#define STM32F4_RCC_AHB1_GPIOD	3
+#define STM32F4_RCC_AHB1_GPIOE	4
+#define STM32F4_RCC_AHB1_GPIOF	5
+#define STM32F4_RCC_AHB1_GPIOG	6
+#define STM32F4_RCC_AHB1_GPIOH	7
+#define STM32F4_RCC_AHB1_GPIOI	8
+#define STM32F4_RCC_AHB1_GPIOJ	9
+#define STM32F4_RCC_AHB1_GPIOK	10
+#define STM32F4_RCC_AHB1_CRC	12
+#define STM32F4_RCC_AHB1_DMA1	21
+#define STM32F4_RCC_AHB1_DMA2	22
+#define STM32F4_RCC_AHB1_DMA2D	23
+#define STM32F4_RCC_AHB1_ETHMAC	25
+#define STM32F4_RCC_AHB1_OTGHS	29
+
+#define STM32F4_AHB1_RESET(bit) (STM32F4_RCC_AHB1_##bit + (0x10 * 8))
+
+/* AHB2 */
+#define STM32F4_RCC_AHB2_DCMI	0
+#define STM32F4_RCC_AHB2_CRYP	4
+#define STM32F4_RCC_AHB2_HASH	5
+#define STM32F4_RCC_AHB2_RNG	6
+#define STM32F4_RCC_AHB2_OTGFS	7
+
+#define STM32F4_AHB2_RESET(bit)	(STM32F4_RCC_AHB2_##bit + (0x14 * 8))
+
+/* AHB3 */
+#define STM32F4_RCC_AHB3_FMC	0
+
+#define STM32F4_AHB3_RESET(bit)	(STM32F4_RCC_AHB3_##bit + (0x18 * 8))
+
+/* APB1 */
+#define STM32F4_RCC_APB1_TIM2	0
+#define STM32F4_RCC_APB1_TIM3	1
+#define STM32F4_RCC_APB1_TIM4	2
+#define STM32F4_RCC_APB1_TIM5	3
+#define STM32F4_RCC_APB1_TIM6	4
+#define STM32F4_RCC_APB1_TIM7	5
+#define STM32F4_RCC_APB1_TIM12	6
+#define STM32F4_RCC_APB1_TIM13	7
+#define STM32F4_RCC_APB1_TIM14	8
+#define STM32F4_RCC_APB1_WWDG	11
+#define STM32F4_RCC_APB1_SPI2	14
+#define STM32F4_RCC_APB1_SPI3	15
+#define STM32F4_RCC_APB1_UART2	17
+#define STM32F4_RCC_APB1_UART3	18
+#define STM32F4_RCC_APB1_UART4	19
+#define STM32F4_RCC_APB1_UART5	20
+#define STM32F4_RCC_APB1_I2C1	21
+#define STM32F4_RCC_APB1_I2C2	22
+#define STM32F4_RCC_APB1_I2C3	23
+#define STM32F4_RCC_APB1_CAN1	25
+#define STM32F4_RCC_APB1_CAN2	26
+#define STM32F4_RCC_APB1_PWR	28
+#define STM32F4_RCC_APB1_DAC	29
+#define STM32F4_RCC_APB1_UART7	30
+#define STM32F4_RCC_APB1_UART8	31
+
+#define STM32F4_APB1_RESET(bit)	(STM32F4_RCC_APB1_##bit + (0x20 * 8))
+
+/* APB2 */
+#define STM32F4_RCC_APB2_TIM1	0
+#define STM32F4_RCC_APB2_TIM8	1
+#define STM32F4_RCC_APB2_USART1	4
+#define STM32F4_RCC_APB2_USART6	5
+#define STM32F4_RCC_APB2_ADC	8
+#define STM32F4_RCC_APB2_SDIO	11
+#define STM32F4_RCC_APB2_SPI1	12
+#define STM32F4_RCC_APB2_SPI4	13
+#define STM32F4_RCC_APB2_SYSCFG	14
+#define STM32F4_RCC_APB2_TIM9	16
+#define STM32F4_RCC_APB2_TIM10	17
+#define STM32F4_RCC_APB2_TIM11	18
+#define STM32F4_RCC_APB2_SPI5	20
+#define STM32F4_RCC_APB2_SPI6	21
+#define STM32F4_RCC_APB2_SAI1	22
+#define STM32F4_RCC_APB2_LTDC	26
+
+#define STM32F4_APB2_RESET(bit)	(STM32F4_RCC_APB2_##bit + (0x24 * 8))
+
+#endif /* _DT_BINDINGS_MFD_STM32F4_RCC_H */
-- 
1.9.1


From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 11/18] pinctrl: Add pinctrl driver for STM32 MCUs
Date: Tue, 10 Mar 2015 16:08:26 +0100
Message-ID: <2464742.YZIRrHto62@wuerfel>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
 <1424455277-29983-12-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1424455277-29983-12-git-send-email-mcoquelin.stm32@gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: Mark Rutland <mark.rutland@arm.com>, linux-doc@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, linux-api@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Kees Cook <keescook@chromium.org>, linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Daniel Lezcano <daniel.lezcano@linaro.org>, Antti Palosaari <crope@iki.fi>, geert@linux-m68k.org, linux-serial@vger.kernel.org, u.kleine-koenig@pengutronix.de, devicetree@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>, Pawel Moll <pawel.moll@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>, Rob Herring <robh+dt@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Michal
List-Id: linux-api@vger.kernel.org

On Friday 20 February 2015 19:01:10 Maxime Coquelin wrote:
> --- /dev/null
> +++ b/include/dt-bindings/pinctrl/pinctrl-stm32.h
> @@ -0,0 +1,43 @@
> +#ifndef _DT_BINDINGS_PINCTRL_STM32_H
> +#define _DT_BINDINGS_PINCTRL_STM32_H
> +
> +/* Modes */
> +#define IN             0
> +#define OUT            1
> +#define ALT            2
> +#define ANALOG         3

I think it's better to prefix all the names with a
string to identify what they are for, otherwise these
are way too generic.

> +/* Alternate functions */
> +#define ALT0           ((0 << 2) | ALT)
> +#define ALT1           ((1 << 2) | ALT)
> +#define ALT2           ((2 << 2) | ALT)
> +#define ALT3           ((3 << 2) | ALT)
> +#define ALT4           ((4 << 2) | ALT)
> +#define ALT5           ((5 << 2) | ALT)
> +#define ALT6           ((6 << 2) | ALT)
> +#define ALT7           ((7 << 2) | ALT)
> +#define ALT8           ((8 << 2) | ALT)
> +#define ALT9           ((9 << 2) | ALT)
> +#define ALT10          ((10 << 2) | ALT)
> +#define ALT11          ((11 << 2) | ALT)
> +#define ALT12          ((12 << 2) | ALT)
> +#define ALT13          ((13 << 2) | ALT)
> +#define ALT14          ((14 << 2) | ALT)
> +#define ALT15          ((15 << 2) | ALT)

You can have a single macro for these like

#define STM32_PIN_ALT(x) ((x << 2) | ALT)

> +/* Pull-Up/Down */
> +#define NO_PULL                0
> +#define PULL_UP                1
> +#define PULL_DOWN      2
> +
> +/* Type */
> +#define PUSH_PULL      (0 << 2)
> +#define OPEN_DRAIN     (1 << 2)
> +

These should probably not be stm32 specific at all, they sound
rather generic, so maybe put the definitions into a common file.



	Arnd

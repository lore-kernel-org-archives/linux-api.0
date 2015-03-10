From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 12/18] dt-bindings: Document the STM32 USART bindings
Date: Tue, 10 Mar 2015 16:08:59 +0100
Message-ID: <38153432.AWA0ogMaoK@wuerfel>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com> <1424455277-29983-13-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1424455277-29983-13-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>Rus
List-Id: linux-api@vger.kernel.org

On Friday 20 February 2015 19:01:11 Maxime Coquelin wrote:
> +
> +Example:
> +usart1: usart@40011000 {
> +       compatible = "st,stm32-usart";
> 

Please use generic node names everywhere. The standard name for a serial
port is "serial".

	Arnd

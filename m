From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH v2 04/18] clocksource: Add ARM System timer driver
Date: Fri, 20 Feb 2015 20:54:37 +0100
Message-ID: <20150220195437.GT19388@pengutronix.de>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
 <1424455277-29983-5-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424455277-29983-5-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rust
List-Id: linux-api@vger.kernel.org

Hello,

On Fri, Feb 20, 2015 at 07:01:03PM +0100, Maxime Coquelin wrote:
> This patch adds clocksource support for ARMv7-M's System timer,
> also known as SysTick.
>=20
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> ---
>  drivers/clocksource/Kconfig          |  7 ++++
>  drivers/clocksource/Makefile         |  1 +
>  drivers/clocksource/armv7m_systick.c | 78 ++++++++++++++++++++++++++=
++++++++++
>  3 files changed, 86 insertions(+)
>  create mode 100644 drivers/clocksource/armv7m_systick.c
>=20
> diff --git a/drivers/clocksource/Kconfig b/drivers/clocksource/Kconfi=
g
> index fc01ec2..fb6011e 100644
> --- a/drivers/clocksource/Kconfig
> +++ b/drivers/clocksource/Kconfig
> @@ -124,6 +124,13 @@ config CLKSRC_ARM_GLOBAL_TIMER_SCHED_CLOCK
>  	help
>  	 Use ARM global timer clock source as sched_clock
> =20
> +config ARMV7M_SYSTICK
> +	bool
I assume this symbol is enabled later in the series. Would it make sens=
e
to allow enabing the symbol for compile test coverage?

> +	select CLKSRC_OF if OF
What happens if ARMV7M_SYSTICK=3Dy but OF=3Dn? Doesn't the driver fail =
to
compile?

> +	select CLKSRC_MMIO
> +	help
> +	  This options enables support for the ARMv7M system timer unit
the right spelling is ARMv7-M.

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig        =
    |
Industrial Linux Solutions                 | http://www.pengutronix.de/=
  |

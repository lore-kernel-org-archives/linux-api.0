From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?=
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH v2 02/18] ARM: ARMv7M: Enlarge vector table to 256 entries
Date: Fri, 20 Feb 2015 20:47:56 +0100
Message-ID: <20150220194756.GS19388@pengutronix.de>
References: <1424455277-29983-1-git-send-email-mcoquelin.stm32@gmail.com>
 <1424455277-29983-3-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1424455277-29983-3-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rust
List-Id: linux-api@vger.kernel.org

On Fri, Feb 20, 2015 at 07:01:01PM +0100, Maxime Coquelin wrote:
> From Cortex-M reference manuals, the nvic supports up to 240 interrup=
ts.
> So the number of entries in vectors table is up to 256.
>=20
> This patch adds a new config flag to specify the number of external i=
nterrupts.
> Some ifdeferies are added in order to respect the natural alignment w=
ithout
> wasting too much space on smaller systems.
>=20
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> ---
>  arch/arm/kernel/entry-v7m.S | 13 +++++++++----
>  arch/arm/mm/Kconfig         | 15 +++++++++++++++
>  2 files changed, 24 insertions(+), 4 deletions(-)
>=20
> diff --git a/arch/arm/kernel/entry-v7m.S b/arch/arm/kernel/entry-v7m.=
S
> index 8944f49..68cde36 100644
> --- a/arch/arm/kernel/entry-v7m.S
> +++ b/arch/arm/kernel/entry-v7m.S
> @@ -117,9 +117,14 @@ ENTRY(__switch_to)
>  ENDPROC(__switch_to)
> =20
>  	.data
> -	.align	8
> +#if CONFIG_CPUV7M_NUM_IRQ <=3D 112
I would have called this CONFIG_CPU_V7M_NUM_IRQ to match the already
existing CPU_V7M symbol.

> +	.align	9
> +#else
> +	.align	10
> +#endif
> +

Other than that:
Acked-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Who do you target to apply this series?

Best regards
Uwe

--=20
Pengutronix e.K.                           | Uwe Kleine-K=F6nig        =
    |
Industrial Linux Solutions                 | http://www.pengutronix.de/=
  |

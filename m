From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Subject: Re: [PATCH 06/14] drivers: reset: Add STM32 reset driver
Date: Mon, 16 Feb 2015 00:59:18 +0100
Message-ID: <54E132D6.6010608@suse.de>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com> <1423763164-5606-7-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <1423763164-5606-7-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-gpio-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Philipp Zabel <p.zabel@pengutronix.de>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees
List-Id: linux-api@vger.kernel.org

Am 12.02.2015 um 18:45 schrieb Maxime Coquelin:
> The STM32 MCUs family IP can be reset by accessing some shared regist=
ers.
>=20
> The specificity is that some reset lines are used by the timers.
> At timer initialization time, the timer has to be reset, that's why
> we cannot use a regular driver.
>=20
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> ---
>  .../devicetree/bindings/reset/st,stm32-reset.txt   |  19 ++++
>  drivers/reset/Makefile                             |   1 +
>  drivers/reset/reset-stm32.c                        | 124 +++++++++++=
++++++++++
>  3 files changed, 144 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/reset/st,stm32-=
reset.txt
>  create mode 100644 drivers/reset/reset-stm32.c
>=20
> diff --git a/Documentation/devicetree/bindings/reset/st,stm32-reset.t=
xt b/Documentation/devicetree/bindings/reset/st,stm32-reset.txt
> new file mode 100644
> index 0000000..add1298
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/reset/st,stm32-reset.txt
> @@ -0,0 +1,19 @@
> +STMicroelectronics STM32 Peripheral Reset Controller
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +
> +Please also refer to reset.txt in this directory for common reset
> +controller binding usage.
> +
> +Required properties:
> +- compatible: Should be "st,stm32-reset"
> +- reg: should be register base and length as documented in the
> +  datasheet
> +- #reset-cells: 1, see below
> +
> +example:
> +
> +reset_ahb1: reset@40023810 {
> +	#reset-cells =3D <1>;
> +	compatible =3D "st,stm32-reset";
> +	reg =3D <0x40023810 0x4>;
> +};
[snip]

RM0090 has two different chapters on the RCC IP:
* Reset and clock control for STM32F42xxx and STM32F43xxx (RCC)
* Reset and clock control for STM32F405xx/07xx and STM32F415xx/17xx(RCC=
)

I therefore feel it is wrong to use "stm32-" here; instead I used
"st,stm32f429-rcc" (also relates to 12/14 discussion). This may apply t=
o
other identifiers, too.

Regards,
Andreas

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Felix Imend=F6rffer, Jane Smithard, Jennifer Guild, Dilip Upmanyu,
Graham Norton; HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-gpio" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

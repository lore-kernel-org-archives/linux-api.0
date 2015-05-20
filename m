From: =?windows-1252?Q?Andreas_F=E4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v8 07/16] drivers: reset: Add STM32 reset driver
Date: Thu, 21 May 2015 01:45:01 +0200
Message-ID: <555D1C7D.1060205@suse.de>
References: <1431158038-3813-1-git-send-email-mcoquelin.stm32@gmail.com> <1431158038-3813-8-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431158038-3813-8-git-send-email-mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, stefan-XLVq0VzYD2Y@public.gmane.org, pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org, pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org, peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>, lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Nikolay Borisov <Nikolay.Borisov-5wv7dgnIgG8@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Kamil Lulko <rev1>
List-Id: linux-api@vger.kernel.org

Am 09.05.2015 um 09:53 schrieb Maxime Coquelin:
> The STM32 MCUs family IPs can be reset by accessing some registers
> from the RCC block.
>=20
> The list of available reset lines is documented in the DT bindings.
>=20
> Tested-by: Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> Acked-by: Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/reset/Makefile      |   1 +
>  drivers/reset/reset-stm32.c | 124 ++++++++++++++++++++++++++++++++++=
++++++++++
>  2 files changed, 125 insertions(+)
>  create mode 100644 drivers/reset/reset-stm32.c
>=20
> diff --git a/drivers/reset/Makefile b/drivers/reset/Makefile
> index 157d421..aed12d1 100644
> --- a/drivers/reset/Makefile
> +++ b/drivers/reset/Makefile
> @@ -1,5 +1,6 @@
>  obj-$(CONFIG_RESET_CONTROLLER) +=3D core.o
>  obj-$(CONFIG_ARCH_SOCFPGA) +=3D reset-socfpga.o
>  obj-$(CONFIG_ARCH_BERLIN) +=3D reset-berlin.o
> +obj-$(CONFIG_ARCH_STM32) +=3D reset-stm32.o
>  obj-$(CONFIG_ARCH_SUNXI) +=3D reset-sunxi.o
>  obj-$(CONFIG_ARCH_STI) +=3D sti/
> diff --git a/drivers/reset/reset-stm32.c b/drivers/reset/reset-stm32.=
c
> new file mode 100644
> index 0000000..2c41858
> --- /dev/null
> +++ b/drivers/reset/reset-stm32.c
[...]
> +static const struct of_device_id stm32_reset_dt_ids[] =3D {
> +	 { .compatible =3D "st,stm32-rcc", },
> +	 { /* sentinel */ },
> +};
> +MODULE_DEVICE_TABLE(of, sstm32_reset_dt_ids);

Typo.

IIUC the timer depends on the reset controller, so it must be built in
anyway, and that's what's enforced in the Makefile above. Drop the line=
?

Regards,
Andreas

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Felix Imend=F6rffer, Jane Smithard, Dilip Upmanyu, Graham Norton; H=
RB
21284 (AG N=FCrnberg)

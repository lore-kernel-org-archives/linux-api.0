From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Subject: Re: [PATCH v6 10/15] serial: stm32-usart: Add STM32 USART Driver
Date: Tue, 07 Apr 2015 18:51:56 +0200
Message-ID: <55240B2C.3020102@suse.de>
References: <1428424234-28572-1-git-send-email-mcoquelin.stm32@gmail.com> <1428424234-28572-11-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428424234-28572-11-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>, u.kleine-koenig@pengutronix.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, stefan@agner.ch, pmeerw@pmeerw.net, pebolle@tiscali.nl, peter@hurleysoftware.com, andy.shevchenko@gmail.com, cw00.choi@samsung.com, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, joe@perches.com
Cc: Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.cz>, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-gpio@vger.kernel.org, linux-serial@vger.kernel.org, linux-arch@vger.kerne
List-Id: linux-api@vger.kernel.org

Am 07.04.2015 um 18:30 schrieb Maxime Coquelin:
> This drivers adds support to the STM32 USART controller, which is a
> standard serial driver.
>=20
> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
> Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> ---
>  drivers/tty/serial/Kconfig       |  17 +
>  drivers/tty/serial/Makefile      |   1 +
>  drivers/tty/serial/stm32-usart.c | 735 +++++++++++++++++++++++++++++=
++++++++++
>  include/uapi/linux/serial_core.h |   3 +
>  4 files changed, 756 insertions(+)
>  create mode 100644 drivers/tty/serial/stm32-usart.c
[...]
> diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/st=
m32-usart.c
> new file mode 100644
> index 0000000..4adc430
> --- /dev/null
> +++ b/drivers/tty/serial/stm32-usart.c
[...]
> +#define DRIVER_NAME "stm32-usart"
> +#define STM32_SERIAL_NAME "ttyS"

I'm surprised no one has complained about ttyS yet. Doesn't that need t=
o
be unique, such as ttySTM (efm32 uses ttyefm), to avoid clashes between
serial drivers? ttyS was exclusive to the 8250 driver, I thought.

Regards,
Andreas

--=20
SUSE Linux GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Felix Imend=F6rffer, Jane Smithard, Jennifer Guild, Dilip Upmanyu,
Graham Norton; HRB 21284 (AG N=FCrnberg)

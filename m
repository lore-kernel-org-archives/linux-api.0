From: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>
Subject: Re: [PATCH v6 10/15] serial: stm32-usart: Add STM32 USART Driver
Date: Thu, 9 Apr 2015 16:04:39 +0300
Message-ID: <552678E7.4040107@mentor.com>
References: <1428424234-28572-1-git-send-email-mcoquelin.stm32@gmail.com> <1428424234-28572-11-git-send-email-mcoquelin.stm32@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1428424234-28572-11-git-send-email-mcoquelin.stm32@gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>, u.kleine-koenig@pengutronix.de, afaerber@suse.de, geert@linux-m68k.org, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, stefan@agner.ch, pmeerw@pmeerw.net, pebolle@tiscali.nl, peter@hurleysoftware.com, andy.shevchenko@gmail.com, cw00.choi@samsung.com, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, joe@perches.com
Cc: Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, Michal Marek <mmarek@suse.cz>, linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linux-gpio@vger.kernel.org, linux-serial@vger.kernel.orglinux-a
List-Id: linux-api@vger.kernel.org

Hi Maxime,

On 07.04.2015 19:30, Maxime Coquelin wrote:
> This drivers adds support to the STM32 USART controller, which is a
> standard serial driver.
> 
> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
> Reviewed-by: Peter Hurley <peter@hurleysoftware.com>
> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
> ---
>  drivers/tty/serial/Kconfig       |  17 +
>  drivers/tty/serial/Makefile      |   1 +
>  drivers/tty/serial/stm32-usart.c | 735 +++++++++++++++++++++++++++++++++++++++
>  include/uapi/linux/serial_core.h |   3 +
>  4 files changed, 756 insertions(+)
>  create mode 100644 drivers/tty/serial/stm32-usart.c

[snip]

> +static void stm32_console_write(struct console *co, const char *s, unsigned cnt)
> +{
> +	struct uart_port *port = &stm32_ports[co->index].port;
> +	unsigned long flags;
> +	u32 old_cr1, new_cr1;
> +	int locked = 1;
> +
> +	if (oops_in_progress) {
> +		locked = spin_trylock_irqsave(&port->lock, flags);
> +	} else {
> +		locked = 1;

locked = 1 is done from the declaration.

Also do you want to add "if (port->sysrq) locked = 0;" check?

> +		spin_lock_irqsave(&port->lock, flags);
> +	}
> +

[snip]

Everything else is fine from point of view.

Reviewed-by: Vladimir Zapolskiy <vladimir_zapolskiy@mentor.com>

--
With best wishes,
Vladimir

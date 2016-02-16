From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v3 05/10] serial: mps2-uart: add support for early console
Date: Tue, 16 Feb 2016 12:36:09 +0200
Message-ID: <CAHp75VdugAq0WnzLHmd9CJHCjBOdBwPqCmC3ARSaVF5XMYGoMw@mail.gmail.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>
	<1455617295-23736-6-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1455617295-23736-6-git-send-email-vladimir.murzin@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>, ijc+devicetree <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Jiri Slaby <jslaby@suse.cz>, Rob Herring <robh+dt@kernel.org>, devicetree <devicetree@vger.kernel.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Feb 16, 2016 at 12:08 PM, Vladimir Murzin
<vladimir.murzin@arm.com> wrote:
> This adds support early console for MPS2 UART which can be enabled via
> earlycon=mps2,0x40004000


> --- a/drivers/tty/serial/mps2-uart.c
> +++ b/drivers/tty/serial/mps2-uart.c
> @@ -435,6 +435,36 @@ static struct console mps2_uart_console = {
>
>  #define MPS2_SERIAL_CONSOLE (&mps2_uart_console)
>
> +static void mps2_early_putchar(struct uart_port *port, int ch)
> +{
> +
> +       while (readb(port->membase + UARTn_STATE) & UARTn_STATE_TX_FULL)
> +               cpu_relax();

Infinite busy loop?

> +
> +       writeb((unsigned char)ch, port->membase + UARTn_DATA);
> +}
> +
> +
> +static void mps2_early_write(struct console *con, const char *s, unsigned n)
> +{
> +       struct earlycon_device *dev = con->data;
> +
> +       uart_console_write(&dev->port, s, n, mps2_early_putchar);
> +}
> +
> +static int __init mps2_early_console_setup(struct earlycon_device *device,
> +                                          const char *opt)
> +{
> +       if (!device->port.membase)
> +               return -ENODEV;
> +
> +       device->con->write = mps2_early_write;
> +
> +       return 0;
> +}
> +EARLYCON_DECLARE(mps2, mps2_early_console_setup);
> +OF_EARLYCON_DECLARE(mps2, "arm,mps2-uart", mps2_early_console_setup);

IIRC Peter Hurley mentioned you don't need to put both anymore, OF_
one is enough.

-- 
With Best Regards,
Andy Shevchenko

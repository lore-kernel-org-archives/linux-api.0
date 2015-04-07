From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v5 10/15] serial: stm32-usart: Add STM32 USART Driver
Date: Tue, 7 Apr 2015 18:05:47 +0200
Message-ID: <CALszF6AzxKhQYVyDki-pT2hWT0a2gtJaPp2HED7SB+yJSG5rOg@mail.gmail.com>
References: <1428080481-18591-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1428080481-18591-11-git-send-email-mcoquelin.stm32@gmail.com>
	<CAHp75VfRpwH3gw=EX816Bd8QnGSVzPg8+OWppqEKp2H_vCzRXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-gpio-owner@vger.kernel.org>
In-Reply-To: <CAHp75VfRpwH3gw=EX816Bd8QnGSVzPg8+OWppqEKp2H_vCzRXw@mail.gmail.com>
Sender: linux-gpio-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Peter Hurley <peter@hurleysoftware.com>, Chanwoo Choi <cw00.choi@samsung.com>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>
List-Id: linux-api@vger.kernel.org

2015-04-04 0:04 GMT+02:00 Andy Shevchenko <andy.shevchenko@gmail.com>:
> On Fri, Apr 3, 2015 at 8:01 PM, Maxime Coquelin
> <mcoquelin.stm32@gmail.com> wrote:
>> This drivers adds support to the STM32 USART controller, which is a
>> standard serial driver.
>>
>
> Few minor comments.
>
>> Tested-by: Chanwoo Choi <cw00.choi@samsung.com>
>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>> ---
>>  drivers/tty/serial/Kconfig       |  17 +
>>  drivers/tty/serial/Makefile      |   1 +
>>  drivers/tty/serial/stm32-usart.c | 736 +++++++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/serial_core.h |   3 +
>>  4 files changed, 757 insertions(+)
>>  create mode 100644 drivers/tty/serial/stm32-usart.c
>>

>> diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
>> new file mode 100644
>> index 0000000..61e0e19
>> --- /dev/null
>> +++ b/drivers/tty/serial/stm32-usart.c
>> @@ -0,0 +1,736 @@
...
>> +
>> +static unsigned int stm32_get_mctrl(struct uart_port *port)
>> +{
>> +       /* This routine is used to get signals of: DCD, DSR, RI, and CTS */
>> +       return TIOCM_CAR | TIOCM_DSR | TIOCM_CTS;
>> +}
>> +
>> +/* Transmit stop */
>> +static void stm32_stop_tx(struct uart_port *port)
>> +{
>> +       stm32_clr_bits(port, USART_CR1, USART_CR1_TXEIE);
>> +}
>> +
>> +
>
> Unneeded empty line.
Right, will be removed.

>
...
>> +
>> +static int stm32_startup(struct uart_port *port)
>> +{
>> +       const char *name = to_platform_device(port->dev)->name;
>> +       u32 val;
>> +
>> +       if (request_irq(port->irq, stm32_interrupt, IRQF_NO_SUSPEND,
>> +                               name, port)) {
>
> I think you have to propogate returned value, thus
> ret = request_irq();
> if (ret < 0)
>  return ret;
Exact, I will fix this.

>
...
>> +
>> +static const char *stm32_type(struct uart_port *port)
>> +{
>> +       return (port->type == PORT_STM32) ? DRIVER_NAME : NULL;
>> +}
>> +
>> +static void stm32_release_port(struct uart_port *port)
>> +{
>> +}
>
> Doesn't core handle NULL-functions? If it does, remove such from the driver.
No it does not.

>
>> +
>> +static int stm32_request_port(struct uart_port *port)
>> +{
>> +       return 0;
>> +}
>
> Ditto.
Ditto.

Thanks for the review,
Maxime

>
>
>
> --
> With Best Regards,
> Andy Shevchenko

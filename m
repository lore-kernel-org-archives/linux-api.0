From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [PATCH v3 05/10] serial: mps2-uart: add support for early console
Date: Tue, 16 Feb 2016 13:09:51 +0000
Message-ID: <56C31F9F.10000@arm.com>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com>	<1455617295-23736-6-git-send-email-vladimir.murzin@arm.com> <CAHp75VdugAq0WnzLHmd9CJHCjBOdBwPqCmC3ARSaVF5XMYGoMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75VdugAq0WnzLHmd9CJHCjBOdBwPqCmC3ARSaVF5XMYGoMw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <u.kleine-koenig@pengutronix.de>, Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>, ijc+devicetree <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Jiri Slaby <jslaby@suse.cz>, Rob Herring <robh+dt@kernel.org>, devicetree <devicetree@vger.kernel.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On 16/02/16 10:36, Andy Shevchenko wrote:
> On Tue, Feb 16, 2016 at 12:08 PM, Vladimir Murzin
> <vladimir.murzin@arm.com> wrote:
>> This adds support early console for MPS2 UART which can be enabled via
>> earlycon=mps2,0x40004000
> 
> 
>> --- a/drivers/tty/serial/mps2-uart.c
>> +++ b/drivers/tty/serial/mps2-uart.c
>> @@ -435,6 +435,36 @@ static struct console mps2_uart_console = {
>>
>>  #define MPS2_SERIAL_CONSOLE (&mps2_uart_console)
>>
>> +static void mps2_early_putchar(struct uart_port *port, int ch)
>> +{
>> +
>> +       while (readb(port->membase + UARTn_STATE) & UARTn_STATE_TX_FULL)
>> +               cpu_relax();
> 
> Infinite busy loop?

In case of broken hw, yes, but I'm quite unsure how we can help to fix
it. Do you have something in mind?

> 
>> +
>> +       writeb((unsigned char)ch, port->membase + UARTn_DATA);
>> +}
>> +
>> +
>> +static void mps2_early_write(struct console *con, const char *s, unsigned n)
>> +{
>> +       struct earlycon_device *dev = con->data;
>> +
>> +       uart_console_write(&dev->port, s, n, mps2_early_putchar);
>> +}
>> +
>> +static int __init mps2_early_console_setup(struct earlycon_device *device,
>> +                                          const char *opt)
>> +{
>> +       if (!device->port.membase)
>> +               return -ENODEV;
>> +
>> +       device->con->write = mps2_early_write;
>> +
>> +       return 0;
>> +}
>> +EARLYCON_DECLARE(mps2, mps2_early_console_setup);
>> +OF_EARLYCON_DECLARE(mps2, "arm,mps2-uart", mps2_early_console_setup);
> 
> IIRC Peter Hurley mentioned you don't need to put both anymore, OF_
> one is enough.
> 

I've just tried with OF_ only and seems it works fine. Thanks for
pointing at it!

Cheers
Vladimir

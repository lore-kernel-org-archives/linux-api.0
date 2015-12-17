From: Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: Re: [PATCH v1 04/10] serial: mps2-uart: add MPS2 UART driver
Date: Thu, 17 Dec 2015 15:15:12 +0200
Message-ID: <CAHp75Vd3eg5EQhx_36CKNO_N=2yVmsTyCx++6zTvAR2cbp-RYQ@mail.gmail.com>
References: <1449048790-25859-1-git-send-email-vladimir.murzin@arm.com>
	<1449048790-25859-5-git-send-email-vladimir.murzin@arm.com>
	<CAHp75Vd98TEQ7TiD==t=RgYOqSinWgnyRjg7V=oPXmEx0nedLQ@mail.gmail.com>
	<56700A45.3070109@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56700A45.3070109@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Vladimir Murzin <vladimir.murzin@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, Mark Rutland <Mark.Rutland@arm.com>, Pawel Moll <Pawel.Moll@arm.com>, ijc+devicetree <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Jiri Slaby <jslaby@suse.cz>, Rob Herring <robh+dt@kernel.org>, devicetree <devicetree@vger.kernel.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

On Tue, Dec 15, 2015 at 2:40 PM, Vladimir Murzin
<vladimir.murzin@arm.com> wrote:
> On 12/12/15 23:39, Andy Shevchenko wrote:
>> On Wed, Dec 2, 2015 at 11:33 AM, Vladimir Murzin
>> <vladimir.murzin@arm.com> wrote:
>>> This driver adds support to the UART controller found on ARM MPS2
>>> platform.
>>
>> Just few comments (have neither time not big desire to do full review).
>>
>
> Still better than nothing ;) I'm mostly agree on points you had, so I've
> just left some I'm doubt about...
>
>>> +
>>> +static void mps2_uart_enable_ms(struct uart_port *port)
>>> +{
>>> +}
>>> +
>>> +static void mps2_uart_break_ctl(struct uart_port *port, int ctl)
>>> +{
>>> +}
>>
>> Are those required to be present? If not, remove them until you have
>> alive code there.
>
> A quick grep shows that core calls mps2_uart_break_ctl()
> unconditionally, but, yes, it checks for presence of
> mps2_uart_enable_ms() before jumping there, so it is safe to remove latter.

OK.

>>> +static irqreturn_t mps2_uart_oerrirq(int irq, void *data)
>>> +{
>>> +       irqreturn_t handled = IRQ_NONE;
>>> +       struct uart_port *port = data;
>>> +       u8 irqflag = mps2_uart_read8(port, UARTn_INT);
>>> +
>>> +       spin_lock(&port->lock);
>>> +
>>> +       if (irqflag & UARTn_INT_RX_OVERRUN) {
>>> +               struct tty_port *tport = &port->state->port;
>>> +
>>> +               mps2_uart_write8(port, UARTn_INT_RX_OVERRUN, UARTn_INT);
>>> +               tty_insert_flip_char(tport, 0, TTY_OVERRUN);
>>> +               port->icount.overrun++;
>>> +               handled = IRQ_HANDLED;
>>> +       }
>>> +
>>> +       /* XXX: this shouldn't happen? */
>>
>> If shouldn't why it's there? Otherwise better to explain which
>> conditions may lead to this.
>>
>
> In practice I've never seen that happened and I think it never *should*
> happen since we check if there is room in TX buffer. However, I could be
> wrong here, so it is why that statement has question mark.

So, worth to have a proper comment then.

>>> +static int __init mps2_uart_init(void)
>>> +{
>>> +       int ret;
>>> +
>>> +       ret = uart_register_driver(&mps2_uart_driver);
>>> +       if (ret)
>>> +               return ret;
>>> +
>>> +       ret = platform_driver_register(&mps2_serial_driver);
>>> +       if (ret)
>>> +               uart_unregister_driver(&mps2_uart_driver);
>>> +
>>> +       pr_info("MPS2 UART driver initialized\n");
>>> +
>>> +       return ret;
>>> +}
>>> +module_init(mps2_uart_init);
>>> +
>>> +static void __exit mps2_uart_exit(void)
>>> +{
>>> +       platform_driver_unregister(&mps2_serial_driver);
>>> +       uart_unregister_driver(&mps2_uart_driver);
>>> +}
>>> +module_exit(mps2_uart_exit);
>>
>> module_platform_driver();
>> And move uart_*register calls to probe/remove.
>>
>
> With this move we'll get uart_*register for every device probed, no?

Don't see a problem, maybe someone else could share an authoritive opinion.
Some of the drivers do that, though most do in __init stage. So, see above.

-- 
With Best Regards,
Andy Shevchenko

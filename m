From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v3 10/15] serial: stm32-usart: Add STM32 USART Driver
Date: Thu, 26 Mar 2015 23:03:35 +0100
Message-ID: <CALszF6Ds5b9V35iuSzxnOYDL2sD3psYfYp3b+6a-2Atse6_w3Q@mail.gmail.com>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
	<1426197361-19290-11-git-send-email-maxime.coquelin@st.com>
	<5511ABAA.2010303@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <5511ABAA.2010303@hurleysoftware.com>
Sender: linux-arch-owner@vger.kernel.org
To: Peter Hurley <peter@hurleysoftware.com>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft>
List-Id: linux-api@vger.kernel.org

HI Peter

2015-03-24 19:23 GMT+01:00 Peter Hurley <peter@hurleysoftware.com>:
> Hi Maxime,
>
> On 03/12/2015 05:55 PM, Maxime Coquelin wrote:
>> From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>>
>> This drivers adds support to the STM32 USART controller, which is a
>> standard serial driver.
>
> Comments below.

Thanks for the review, please find my answsers below
>
>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>> ---
>>  drivers/tty/serial/Kconfig       |  17 +
>>  drivers/tty/serial/Makefile      |   1 +
>>  drivers/tty/serial/stm32-usart.c | 695 +++++++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/serial_core.h |   3 +
>>  4 files changed, 716 insertions(+)
>>  create mode 100644 drivers/tty/serial/stm32-usart.c
>>

...

>> +static unsigned int stm32_tx_empty(struct uart_port *port)
>> +{
>> +     return readl_relaxed(port->membase + USART_SR) & USART_SR_TXE;
>> +}
>> +
>> +static void stm32_set_mctrl(struct uart_port *port, unsigned int mctrl)
>> +{
>> +     /*
>> +      * This routine is used for seting signals of: DTR, DCD, CTS/RTS
>> +      * We use USART's hardware for CTS/RTS, so don't need any for that.
>
> If this means that you're enabling autoflow control, then you still need
> to respond to the state of TIOCM_RTS, so that both serial core and userspace
> can halt input flow.
>
> If the hardware doesn't support separate RTS enable/disable control,
> then you need to disable autoRTS when TIOCM_RTS is clear, and re-enable
> it when raised.
>
>
>> +      * Some boards have DTR and DCD implemented using PIO pins,
>> +      * code to do this should be hooked in here.
>> +      */
>> +}
>> +
>> +static unsigned int stm32_get_mctrl(struct uart_port *port)
>> +{
>> +     /*
>> +      * This routine is used for geting signals of: DTR, DCD, DSR, RI,
>> +      * and CTS/RTS
>> +      */
>> +     return TIOCM_CAR | TIOCM_DSR | TIOCM_CTS;
>> +}
>> +

...
>> +
>> +static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
>> +                         struct ktermios *old)
>> +{
>> +     unsigned int baud;
>> +     u32 usardiv, mantissa, fraction;
>> +     tcflag_t cflag;
>> +     u32 cr1, cr2, cr3;
>> +     unsigned long flags;
>> +
>> +     baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
>> +     cflag = termios->c_cflag;
>> +
>> +     spin_lock_irqsave(&port->lock, flags);
>> +
>> +     /* Stop serial port and reset value */
>> +     writel_relaxed(0, port->membase + USART_CR1);
>> +
>> +     cr1 = USART_CR1_TE | USART_CR1_RE | USART_CR1_UE | USART_CR1_RXNEIE;
>> +
>> +     if (cflag & CSTOPB)
>> +             cr2 = USART_CR2_STOP_2B;
>> +
>> +     if (cflag & PARENB) {
>> +             cr1 |= USART_CR1_PCE;
>> +             if ((cflag & CSIZE) == CS8)
>> +                     cr1 |= USART_CR1_M;
>> +     }
>> +
>> +     if (cflag & PARODD)
>> +             cr1 |= USART_CR1_PS;
>> +
>> +     if (cflag & CRTSCTS)
>> +             cr3 = USART_CR3_RTSE | USART_CR3_CTSE;
>
> If this means autoflow control, then you need to define
> throttle()/unthrottle() methods, otherwise the serial core won't
> be able to throttle the remote when input buffers are about
> to overflow.
>
> And you should only enable the autoCTS and let the serial
> core enable autoRTS through set_mctrl(TIOCM_RTS).
>
> Just let me know if you need more info about how to do this.

Ok, let's see if I have well understood.

USART_CR3_RTSE should be set/cleared in set_mctrl(), depending on
TIOCM_RTS  value.
The throttle callback should disable the rx interrupt, and the
unthrottle enable it.
For CTS, it should be enabled in set_termios() if CRTSCTS, as done here.

Am I right?
>
>> +
>> +     usardiv = (port->uartclk * 25) / (baud * 4);
>> +     mantissa = (usardiv / 100) << USART_BRR_DIV_M_SHIFT;
>> +     fraction = DIV_ROUND_CLOSEST((usardiv % 100) * 16, 100);
>> +     if (fraction & ~USART_BRR_DIV_F_MASK) {
>> +             fraction = 0;
>> +             mantissa += (1 << USART_BRR_DIV_M_SHIFT);
>> +     }
>> +
>> +     writel_relaxed(mantissa | fraction, port->membase + USART_BRR);
>> +
>> +     uart_update_timeout(port, cflag, baud);
>> +
>> +     port->read_status_mask = USART_SR_ORE;
>> +     if (termios->c_iflag & INPCK)
>> +             port->read_status_mask |= USART_SR_PE | USART_SR_FE;
>> +     if (termios->c_iflag & (IGNBRK | BRKINT | PARMRK))
>> +             port->read_status_mask |= USART_SR_LBD;
>> +
>> +     /* Characters to ignore */
>> +     port->ignore_status_mask = 0;
>> +     if (termios->c_iflag & IGNPAR)
>> +             port->ignore_status_mask = USART_SR_PE | USART_SR_FE;
>> +     if (termios->c_iflag & IGNBRK) {
>> +             port->ignore_status_mask |= USART_SR_LBD;
>> +             /*
>> +              * If we're ignoring parity and break indicators,
>> +              * ignore overruns too (for real raw support).
>> +              */
>> +             if (termios->c_iflag & IGNPAR)
>> +                     port->ignore_status_mask |= USART_SR_ORE;
>> +     }
>> +
>> +     /*
>> +      * Ignore all characters if CREAD is not set.
>> +      */
>> +     if ((termios->c_cflag & CREAD) == 0)
>> +             port->ignore_status_mask |= USART_SR_DUMMY_RX;
>> +
>> +     writel_relaxed(cr3, port->membase + USART_CR3);
>> +     writel_relaxed(cr2, port->membase + USART_CR2);
>> +     writel_relaxed(cr1, port->membase + USART_CR1);
>> +
>> +     spin_unlock_irqrestore(&port->lock, flags);
>> +}
>> +
...

>> +static void stm32_config_port(struct uart_port *port, int flags)
>> +{
>> +     if ((flags & UART_CONFIG_TYPE))
>
> Single parens.

Sure.

>
>> +             port->type = PORT_STM32;
>> +}
>> +
...

>> +
>> +static int stm32_init_port(struct stm32_port *stm32port,
>> +                       struct platform_device *pdev)
>> +{
>> +     struct uart_port *port = &stm32port->port;
>> +     struct resource *res;
>> +
>> +     port->iotype    = UPIO_MEM;
>> +     port->flags     = UPF_BOOT_AUTOCONF;
>> +     port->ops       = &stm32_uart_ops;
>> +     port->dev       = &pdev->dev;
>> +     port->irq       = platform_get_irq(pdev, 0);
>> +
>> +     res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> +     port->membase = devm_ioremap_resource(&pdev->dev, res);
>> +     if (IS_ERR(port->membase))
>> +             return PTR_ERR(port->membase);
>> +     port->mapbase = res->start;
>> +
>> +     spin_lock_init(&port->lock);
>> +
>> +     stm32port->clk = devm_clk_get(&pdev->dev, NULL);
>> +
>> +     if (WARN_ON(IS_ERR(stm32port->clk)))
>
> Do you really need a stack trace here? Could this be dev_err() instead?

No I don't, dev_err() will be enough.
>
>> +             return -EINVAL;
>> +
>> +     /* ensure that clk rate is correct by enabling the clk */
>> +     clk_prepare_enable(stm32port->clk);
>> +     stm32port->port.uartclk = clk_get_rate(stm32port->clk);
>> +     WARN_ON(stm32port->port.uartclk == 0);
>
> Or here?
Same here.

>
>> +     clk_disable_unprepare(stm32port->clk);
>> +
>> +     return 0;
>> +}
>> +
>> +static struct stm32_port *stm32_of_get_stm32_port(struct platform_device *pdev)
>> +{
>> +     struct device_node *np = pdev->dev.of_node;
>> +     int id;
>> +
>> +     if (!np)
>> +             return NULL;
>> +
>> +     id = of_alias_get_id(np, STM32_SERIAL_NAME);
>> +
>> +     if (id < 0)
>> +             id = 0;
>> +
>> +     if (WARN_ON(id >= STM32_MAX_PORTS))
>
> Or here?

I will return PTR_ERR(-EINVAL); instead.
>
>> +             return NULL;
>> +
>> +     stm32_ports[id].port.line = id;
>> +     return &stm32_ports[id];
>> +}
>> +
...

>> diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
>> index b212281..e22dee5 100644
>> --- a/include/uapi/linux/serial_core.h
>> +++ b/include/uapi/linux/serial_core.h
>> @@ -258,4 +258,7 @@
>>  /* Cris v10 / v32 SoC */
>>  #define PORT_CRIS    112
>>
>> +/* STM32 USART */
>> +#define PORT_STM32   110
>
> Already taken.
>
> You'll want to make sure v4 applies cleanly to Greg's tty-next branch.

Sure, I made a mistake during the rebase conflict resolution.

Thanks,
Maxime

>
> Regards,
> Peter Hurley
>
>> +
>>  #endif /* _UAPILINUX_SERIAL_CORE_H */
>>
>

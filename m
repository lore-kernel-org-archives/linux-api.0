From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v3 10/15] serial: stm32-usart: Add STM32 USART Driver
Date: Tue, 17 Mar 2015 18:32:24 +0100
Message-ID: <CALszF6BWuUYRh+3rWnSQLApkAHA5dQXw=6x6D_evRtb+5B_ukA@mail.gmail.com>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
	<1426197361-19290-11-git-send-email-maxime.coquelin@st.com>
	<CAHp75Vd7+oLiLLuyocYh95TebtocWrRho6xNjuSUt8fYGp8npg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAHp75Vd7+oLiLLuyocYh95TebtocWrRho6xNjuSUt8fYGp8npg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft>
List-Id: linux-api@vger.kernel.org

2015-03-13 15:19 GMT+01:00 Andy Shevchenko <andy.shevchenko@gmail.com>:
> On Thu, Mar 12, 2015 at 11:55 PM, Maxime Coquelin
> <mcoquelin.stm32@gmail.com> wrote:
>> From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>>
>> This drivers adds support to the STM32 USART controller, which is a
>> standard serial driver.
>
> My comment below.
>
>>
>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32@gmail.com>
>> ---
>>  drivers/tty/serial/Kconfig       |  17 +
>>  drivers/tty/serial/Makefile      |   1 +
>>  drivers/tty/serial/stm32-usart.c | 695 +++++++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/serial_core.h |   3 +
>>  4 files changed, 716 insertions(+)
>>  create mode 100644 drivers/tty/serial/stm32-usart.c
>>
>> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
>> index d2501f0..880cb4f 100644
>> --- a/drivers/tty/serial/Kconfig
>> +++ b/drivers/tty/serial/Kconfig
>> @@ -1611,6 +1611,23 @@ config SERIAL_SPRD_CONSOLE
>>           with "earlycon" on the kernel command line. The console is
>>           enabled when early_param is processed.
>>
>> +config SERIAL_STM32
>> +       tristate "STMicroelectronics STM32 serial port support"
>> +       select SERIAL_CORE
>> +       depends on ARM || COMPILE_TEST
>> +       help
>> +         This driver is for the on-chip Serial Controller on
>> +         STMicroelectronics STM32 MCUs.
>> +         USART supports Rx & Tx functionality.
>> +         It support all industry standard baud rates.
>> +
>> +         If unsure, say N.
>> +
>> +config SERIAL_STM32_CONSOLE
>> +       bool "Support for console on STM32"
>> +       depends on SERIAL_STM32=y
>> +       select SERIAL_CORE_CONSOLE
>> +
>>  endmenu
>>
>>  config SERIAL_MCTRL_GPIO
>> diff --git a/drivers/tty/serial/Makefile b/drivers/tty/serial/Makefile
>> index 599be4b..67c5023 100644
>> --- a/drivers/tty/serial/Makefile
>> +++ b/drivers/tty/serial/Makefile
>> @@ -95,6 +95,7 @@ obj-$(CONFIG_SERIAL_FSL_LPUART)       += fsl_lpuart.o
>>  obj-$(CONFIG_SERIAL_CONEXANT_DIGICOLOR)        += digicolor-usart.o
>>  obj-$(CONFIG_SERIAL_MEN_Z135)  += men_z135_uart.o
>>  obj-$(CONFIG_SERIAL_SPRD) += sprd_serial.o
>> +obj-$(CONFIG_SERIAL_STM32)     += stm32-usart.o
>>
>>  # GPIOLIB helpers for modem control lines
>>  obj-$(CONFIG_SERIAL_MCTRL_GPIO)        += serial_mctrl_gpio.o
>> diff --git a/drivers/tty/serial/stm32-usart.c b/drivers/tty/serial/stm32-usart.c
>> new file mode 100644
>> index 0000000..61bb065
>> --- /dev/null
>> +++ b/drivers/tty/serial/stm32-usart.c
>> @@ -0,0 +1,695 @@

<snip>

>> +
>> +static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
>> +                           struct ktermios *old)
>> +{
>> +       unsigned int baud;
>> +       u32 usardiv, mantissa, fraction;
>> +       tcflag_t cflag;
>> +       u32 cr1, cr2, cr3;
>> +       unsigned long flags;
>> +
>> +       baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
>> +       cflag = termios->c_cflag;
>> +
>> +       spin_lock_irqsave(&port->lock, flags);
>> +
>> +       /* Stop serial port and reset value */
>> +       writel_relaxed(0, port->membase + USART_CR1);
>> +
>> +       cr1 = USART_CR1_TE | USART_CR1_RE | USART_CR1_UE | USART_CR1_RXNEIE;
>> +
>> +       if (cflag & CSTOPB)
>> +               cr2 = USART_CR2_STOP_2B;
>> +
>> +       if (cflag & PARENB) {
>> +               cr1 |= USART_CR1_PCE;
>> +               if ((cflag & CSIZE) == CS8)
>> +                       cr1 |= USART_CR1_M;
>> +       }
>> +
>> +       if (cflag & PARODD)
>> +               cr1 |= USART_CR1_PS;
>> +
>> +       if (cflag & CRTSCTS)
>> +               cr3 = USART_CR3_RTSE | USART_CR3_CTSE;
>> +
>> +       usardiv = (port->uartclk * 25) / (baud * 4);
>> +       mantissa = (usardiv / 100) << USART_BRR_DIV_M_SHIFT;
>> +       fraction = DIV_ROUND_CLOSEST((usardiv % 100) * 16, 100);
>> +       if (fraction & ~USART_BRR_DIV_F_MASK) {
>> +               fraction = 0;
>> +               mantissa += (1 << USART_BRR_DIV_M_SHIFT);
>> +       }
>
> So, it's a fractional divider. right? Could it be then fractional
> divider clock in this first place (see
> drivers/clk/clk-fractional-divider.c)?
>

I'm not sure it makes sense to represent this baudrate divider within
the UART IP as a clock.
What would be the gain?

Kind regards,
Maxime

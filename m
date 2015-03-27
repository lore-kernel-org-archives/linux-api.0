From: Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH v3 10/15] serial: stm32-usart: Add STM32 USART Driver
Date: Fri, 27 Mar 2015 07:32:34 -0400
Message-ID: <55153FD2.7070304@hurleysoftware.com>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>	<1426197361-19290-11-git-send-email-maxime.coquelin@st.com>	<5511ABAA.2010303@hurleysoftware.com> <CALszF6Ds5b9V35iuSzxnOYDL2sD3psYfYp3b+6a-2Atse6_w3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALszF6Ds5b9V35iuSzxnOYDL2sD3psYfYp3b+6a-2Atse6_w3Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemlo>
List-Id: linux-api@vger.kernel.org

On 03/26/2015 06:03 PM, Maxime Coquelin wrote:
>>> +static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
>>> +                         struct ktermios *old)
>>> +{
>>> +     unsigned int baud;
>>> +     u32 usardiv, mantissa, fraction;
>>> +     tcflag_t cflag;
>>> +     u32 cr1, cr2, cr3;
>>> +     unsigned long flags;
>>> +
>>> +     baud = uart_get_baud_rate(port, termios, old, 0, port->uartclk / 16);
>>> +     cflag = termios->c_cflag;
>>> +
>>> +     spin_lock_irqsave(&port->lock, flags);
>>> +
>>> +     /* Stop serial port and reset value */
>>> +     writel_relaxed(0, port->membase + USART_CR1);
>>> +
>>> +     cr1 = USART_CR1_TE | USART_CR1_RE | USART_CR1_UE | USART_CR1_RXNEIE;
>>> +
>>> +     if (cflag & CSTOPB)
>>> +             cr2 = USART_CR2_STOP_2B;
>>> +
>>> +     if (cflag & PARENB) {
>>> +             cr1 |= USART_CR1_PCE;
>>> +             if ((cflag & CSIZE) == CS8)
>>> +                     cr1 |= USART_CR1_M;
>>> +     }
>>> +
>>> +     if (cflag & PARODD)
>>> +             cr1 |= USART_CR1_PS;
>>> +
>>> +     if (cflag & CRTSCTS)
>>> +             cr3 = USART_CR3_RTSE | USART_CR3_CTSE;
>>
>> If this means autoflow control, then you need to define
>> throttle()/unthrottle() methods, otherwise the serial core won't
>> be able to throttle the remote when input buffers are about
>> to overflow.
>>
>> And you should only enable the autoCTS and let the serial
>> core enable autoRTS through set_mctrl(TIOCM_RTS).
>>
>> Just let me know if you need more info about how to do this.
> 
> Ok, let's see if I have well understood.
> 
> USART_CR3_RTSE should be set/cleared in set_mctrl(), depending on
> TIOCM_RTS  value.
> The throttle callback should disable the rx interrupt, and the
> unthrottle enable it.
> For CTS, it should be enabled in set_termios() if CRTSCTS, as done here.
> 
> Am I right?

Yeah, basically. You also have to indicate to the serial core that you
require throttle/unthrottle handling in this mode by setting port->status.

Your set_termios() method would look like:

	port->status &= ~(UPSTAT_AUTOCTS | UPSTAT_AUTORTS);
	if (cflag & CRTSCTS) {
		port->status |= UPSTAT_AUTOCTS | UPSTAT_AUTORTS;
		cr3 = USART_CR3_CTSE;
	}

and your set_mctrl() method would look like:

	if ((mctrl & TIOCM_RTS) && (port->status & UPSTAT_AUTORTS))
		stm32_set_bits(port, USART_CR3, USART_CR3_RTSE);
	else
		stm32_clear_bits(port, USART_CR3, USART_CR3_RTSE);

The UPSTAT_AUTOCTS doesn't really do anything right now but please
use it anyway to indicate this driver has that functionality.

Regards,
Peter Hurley

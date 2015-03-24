From: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v3 10/15] serial: stm32-usart: Add STM32 USART Driver
Date: Tue, 24 Mar 2015 18:21:34 +0100
Message-ID: <CALszF6Dg7t9+F9NG+xREPQeaAj7T6D1GuGabkr8EvOAAdtg7yA@mail.gmail.com>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
	<1426197361-19290-11-git-send-email-maxime.coquelin@st.com>
	<CAHp75Vd7+oLiLLuyocYh95TebtocWrRho6xNjuSUt8fYGp8npg@mail.gmail.com>
	<CALszF6BWuUYRh+3rWnSQLApkAHA5dQXw=6x6D_evRtb+5B_ukA@mail.gmail.com>
	<CAHp75Vdf6=z1d5+eYJ+QGTko9kkZf-oPfoWaf8FRoTdqcdWxjw@mail.gmail.com>
	<CALszF6A5Zu7i0hxSLTS-nfOAXmd0__jLjB=fHxK93Ex5Vbi9LA@mail.gmail.com>
	<550AE41C.8070803@hurleysoftware.com>
	<CALszF6DX2pz_US6uqQwBjmZhfgjw5PP1UAy9H+c-_Kgkk_Z72w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALszF6DX2pz_US6uqQwBjmZhfgjw5PP1UAy9H+c-_Kgkk_Z72w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber@suse.de>, Geert Uytterhoeven <geert@linux-m68k.org>, Rob Herring <robh+dt@kernel.org>, Philipp Zabel <p.zabel@pengutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Arnd Bergmann <arnd@arndb.de>, Stefan Agner <stefan@agner.ch>, Peter Meerwald <pmeerw@pmeerw.net>, Paul Bolle <pebolle@tiscali.nl>, Jonathan Corbet <corbet@lwn.net>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-founda>
List-Id: linux-api@vger.kernel.org

Hi Peter,

2015-03-19 18:35 GMT+01:00 Maxime Coquelin <mcoquelin.stm32@gmail.com>:
> 2015-03-19 15:58 GMT+01:00 Peter Hurley <peter@hurleysoftware.com>:
>> On 03/19/2015 09:55 AM, Maxime Coquelin wrote:
>>>>>>> +static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
>>>>>>> +                           struct ktermios *old)
>> [...]
>>>>>>> +       usardiv = (port->uartclk * 25) / (baud * 4);
>>>>>>> +       mantissa = (usardiv / 100) << USART_BRR_DIV_M_SHIFT;
>>>>>>> +       fraction = DIV_ROUND_CLOSEST((usardiv % 100) * 16, 100);
>>>>>>> +       if (fraction & ~USART_BRR_DIV_F_MASK) {
>>>>>>> +               fraction = 0;
>>>>>>> +               mantissa += (1 << USART_BRR_DIV_M_SHIFT);
>>>>>>> +       }
>> [...]
>>> Really, I would prefer keeping this fractional divider as it is
>>> implemented today.
>>
>> You have to admit that's basically an unintelligible mess;
>> how would anyone ever be able to refactor and replace that with a
>> common divider implementation?
>>
>> At the very least, please comment on the formula and format.
>
> Ok, I will refactor the implementation, and comment it.

The implementation was indeed a mess.
I found some time to refactor the code, and also added support for 8
times oversampling (16 by default).
It will allow to achieve higher speeds, with the side effect of being
less tolerant to clock deviations.

What do you think about the code below?


    usartdiv = DIV_ROUND_CLOSEST(port->uartclk, baud);

    /*
     * The USART supports 16 or 8 times oversampling.
     * By default we prefer 16 times oversampling, so that the receiver
     * has a better tolerance to clock deviations.
     * 8 times oversampling is only used to achieve higher speeds.
     */
    if (usartdiv < 16) {
        oversampling = 8;
        stm32_set_bits(port, USART_CR1, USART_CR1_OVER8);
    } else {
        oversampling = 16;
        stm32_clr_bits(port, USART_CR1, USART_CR1_OVER8);
    }

    mantissa = (usartdiv / oversampling) << USART_BRR_DIV_M_SHIFT;
    fraction = usartdiv % oversampling;
    writel_relaxed(mantissa | fraction, port->membase + USART_BRR)

Thanks,
Maxime
>
> Regards,
> Maxime
>
>>
>> Regards,
>> Peter Hurley

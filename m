From: Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v3 10/15] serial: stm32-usart: Add STM32 USART Driver
Date: Tue, 24 Mar 2015 13:44:53 -0400
Message-ID: <5511A295.1060103@hurleysoftware.com>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>	<1426197361-19290-11-git-send-email-maxime.coquelin@st.com>	<CAHp75Vd7+oLiLLuyocYh95TebtocWrRho6xNjuSUt8fYGp8npg@mail.gmail.com>	<CALszF6BWuUYRh+3rWnSQLApkAHA5dQXw=6x6D_evRtb+5B_ukA@mail.gmail.com>	<CAHp75Vdf6=z1d5+eYJ+QGTko9kkZf-oPfoWaf8FRoTdqcdWxjw@mail.gmail.com>	<CALszF6A5Zu7i0hxSLTS-nfOAXmd0__jLjB=fHxK93Ex5Vbi9LA@mail.gmail.com>	<550AE41C.8070803@hurleysoftware.com>	<CALszF6DX2pz_US6uqQwBjmZhfgjw5PP1UAy9H+c-_Kgkk_Z72w@mail.gmail.com> <CALszF6Dg7t9+F9NG+xREPQeaAj7T6D1GuGabkr8EvOAAdtg7yA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALszF6Dg7t9+F9NG+xREPQeaAj7T6D1GuGabkr8EvOAAdtg7yA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?B?VXdlIEtsZWluZS0=?= =?UTF-8?B?S8O2bmln?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, =?UTF-8?B?QW5kcmVh?= =?UTF-8?B?cyBGw6RyYmVy?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Andr
List-Id: linux-api@vger.kernel.org

Hi Maxime,

On 03/24/2015 01:21 PM, Maxime Coquelin wrote:
> Hi Peter,
> 
> 2015-03-19 18:35 GMT+01:00 Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>:
>> 2015-03-19 15:58 GMT+01:00 Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>:
>>> On 03/19/2015 09:55 AM, Maxime Coquelin wrote:
>>>>>>>> +static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
>>>>>>>> +                           struct ktermios *old)
>>> [...]
>>>>>>>> +       usardiv = (port->uartclk * 25) / (baud * 4);
>>>>>>>> +       mantissa = (usardiv / 100) << USART_BRR_DIV_M_SHIFT;
>>>>>>>> +       fraction = DIV_ROUND_CLOSEST((usardiv % 100) * 16, 100);
>>>>>>>> +       if (fraction & ~USART_BRR_DIV_F_MASK) {
>>>>>>>> +               fraction = 0;
>>>>>>>> +               mantissa += (1 << USART_BRR_DIV_M_SHIFT);
>>>>>>>> +       }
>>> [...]
>>>> Really, I would prefer keeping this fractional divider as it is
>>>> implemented today.
>>>
>>> You have to admit that's basically an unintelligible mess;
>>> how would anyone ever be able to refactor and replace that with a
>>> common divider implementation?
>>>
>>> At the very least, please comment on the formula and format.
>>
>> Ok, I will refactor the implementation, and comment it.
> 
> The implementation was indeed a mess.
> I found some time to refactor the code, and also added support for 8
> times oversampling (16 by default).
> It will allow to achieve higher speeds, with the side effect of being
> less tolerant to clock deviations.
> 
> What do you think about the code below?
> 
> 
>     usartdiv = DIV_ROUND_CLOSEST(port->uartclk, baud);
> 
>     /*
>      * The USART supports 16 or 8 times oversampling.
>      * By default we prefer 16 times oversampling, so that the receiver
>      * has a better tolerance to clock deviations.
>      * 8 times oversampling is only used to achieve higher speeds.
>      */
>     if (usartdiv < 16) {
>         oversampling = 8;
>         stm32_set_bits(port, USART_CR1, USART_CR1_OVER8);
>     } else {
>         oversampling = 16;
>         stm32_clr_bits(port, USART_CR1, USART_CR1_OVER8);
>     }
> 
>     mantissa = (usartdiv / oversampling) << USART_BRR_DIV_M_SHIFT;
>     fraction = usartdiv % oversampling;
>     writel_relaxed(mantissa | fraction, port->membase + USART_BRR)

Thanks! Way better :)
Much more obvious this is a fixed-point divisor.

Regards,
Peter Hurley

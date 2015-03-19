From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 10/15] serial: stm32-usart: Add STM32 USART Driver
Date: Thu, 19 Mar 2015 18:35:30 +0100
Message-ID: <CALszF6DX2pz_US6uqQwBjmZhfgjw5PP1UAy9H+c-_Kgkk_Z72w@mail.gmail.com>
References: <1426197361-19290-1-git-send-email-maxime.coquelin@st.com>
	<1426197361-19290-11-git-send-email-maxime.coquelin@st.com>
	<CAHp75Vd7+oLiLLuyocYh95TebtocWrRho6xNjuSUt8fYGp8npg@mail.gmail.com>
	<CALszF6BWuUYRh+3rWnSQLApkAHA5dQXw=6x6D_evRtb+5B_ukA@mail.gmail.com>
	<CAHp75Vdf6=z1d5+eYJ+QGTko9kkZf-oPfoWaf8FRoTdqcdWxjw@mail.gmail.com>
	<CALszF6A5Zu7i0hxSLTS-nfOAXmd0__jLjB=fHxK93Ex5Vbi9LA@mail.gmail.com>
	<550AE41C.8070803@hurleysoftware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <550AE41C.8070803-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
Cc: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Andrew Morton <akpm@linux-founda>
List-Id: linux-api@vger.kernel.org

2015-03-19 15:58 GMT+01:00 Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>:
> On 03/19/2015 09:55 AM, Maxime Coquelin wrote:
>>>>>> +static void stm32_set_termios(struct uart_port *port, struct ktermios *termios,
>>>>>> +                           struct ktermios *old)
> [...]
>>>>>> +       usardiv = (port->uartclk * 25) / (baud * 4);
>>>>>> +       mantissa = (usardiv / 100) << USART_BRR_DIV_M_SHIFT;
>>>>>> +       fraction = DIV_ROUND_CLOSEST((usardiv % 100) * 16, 100);
>>>>>> +       if (fraction & ~USART_BRR_DIV_F_MASK) {
>>>>>> +               fraction = 0;
>>>>>> +               mantissa += (1 << USART_BRR_DIV_M_SHIFT);
>>>>>> +       }
> [...]
>> Really, I would prefer keeping this fractional divider as it is
>> implemented today.
>
> You have to admit that's basically an unintelligible mess;
> how would anyone ever be able to refactor and replace that with a
> common divider implementation?
>
> At the very least, please comment on the formula and format.

Ok, I will refactor the implementation, and comment it.

Regards,
Maxime

>
> Regards,
> Peter Hurley
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

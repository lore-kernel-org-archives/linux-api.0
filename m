From: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v6 10/15] serial: stm32-usart: Add STM32 USART Driver
Date: Tue, 28 Apr 2015 14:13:16 +0200
Message-ID: <CALszF6CTFgVd4D6Ftkf0jW+Hcp53jqrutOHOagDXT-0705aHHQ@mail.gmail.com>
References: <1428424234-28572-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1428424234-28572-11-git-send-email-mcoquelin.stm32@gmail.com>
	<552678E7.4040107@mentor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552678E7.4040107-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>, Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Vladimir,

Thanks for the review, and sorry for the late reply.

2015-04-09 15:04 GMT+02:00 Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>:
> Hi Maxime,
>
> On 07.04.2015 19:30, Maxime Coquelin wrote:
>> This drivers adds support to the STM32 USART controller, which is a
>> standard serial driver.
>>
>> Tested-by: Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
>> Reviewed-by: Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
>> Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>> ---
>>  drivers/tty/serial/Kconfig       |  17 +
>>  drivers/tty/serial/Makefile      |   1 +
>>  drivers/tty/serial/stm32-usart.c | 735 +++++++++++++++++++++++++++++++++++++++
>>  include/uapi/linux/serial_core.h |   3 +
>>  4 files changed, 756 insertions(+)
>>  create mode 100644 drivers/tty/serial/stm32-usart.c
>
> [snip]
>
>> +static void stm32_console_write(struct console *co, const char *s, unsigned cnt)
>> +{
>> +     struct uart_port *port = &stm32_ports[co->index].port;
>> +     unsigned long flags;
>> +     u32 old_cr1, new_cr1;
>> +     int locked = 1;
>> +
>> +     if (oops_in_progress) {
>> +             locked = spin_trylock_irqsave(&port->lock, flags);
>> +     } else {
>> +             locked = 1;    ID

>
> locked = 1 is done from the declaration.
Right, I will fix this in next version

>
> Also do you want to add "if (port->sysrq) locked = 0;" check?

Yes, that makes sense. It will be also in v7.
>
>> +             spin_lock_irqsave(&port->lock, flags);
>> +     }
>> +


>
> [snip]
>
> Everything else is fine from point of view.
>
> Reviewed-by: Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>

Regards,
Maxime
>
> --
> With best wishes,
> Vladimir

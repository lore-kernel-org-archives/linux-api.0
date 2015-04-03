From: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 08/15] clockevents/drivers: Add STM32 Timer driver
Date: Sat, 4 Apr 2015 01:14:04 +0300
Message-ID: <CAHp75Ve+2UUyPAM6ZnYLXaLNOaEA4DGnY6y=VCQxZpdo+cYBfw@mail.gmail.com>
References: <1428080481-18591-1-git-send-email-mcoquelin.stm32@gmail.com>
	<1428080481-18591-9-git-send-email-mcoquelin.stm32@gmail.com>
	<CAHp75VfPn_+sg_1iR_CdR2KuTyWcR+SKFsuHCbCkCKB0Oeqgfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAHp75VfPn_+sg_1iR_CdR2KuTyWcR+SKFsuHCbCkCKB0Oeqgfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, =?UTF-8?Q?Andreas_F=C3=A4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Philipp Zabel <p.zabel-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Stefan Agner <stefan-XLVq0VzYD2Y@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>, cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, Andrew
List-Id: linux-api@vger.kernel.org

On Sat, Apr 4, 2015 at 1:09 AM, Andy Shevchenko
<andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Fri, Apr 3, 2015 at 8:01 PM, Maxime Coquelin
> <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> STM32 MCUs feature 16 and 32 bits general purpose timers with prescalers.
>> The drivers detects whether the time is 16 or 32 bits, and applies a
>> 1024 prescaler value if it is 16 bits.

[]

>> +               pr_err("failed to get clock for clockevent (%d)\n", ret);
>
> Why not dev_err(); ?

Understood, because it's device tree with lack of something like of_err();

-- 
With Best Regards,
Andy Shevchenko

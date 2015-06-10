From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v9 4/5] serial: stm32-usart: Add STM32 USART Driver
Date: Wed, 10 Jun 2015 10:49:55 -0700
Message-ID: <20150610174955.GA6527@kroah.com>
References: <1432328616-16964-1-git-send-email-mcoquelin.stm32@gmail.com>
 <1432328616-16964-5-git-send-email-mcoquelin.stm32@gmail.com>
 <20150531215246.GA24174@kroah.com>
 <CALszF6B7_xOMvO9pRJJPNeR4JnOgAQAohSARDivzt2d1DQWP_Q@mail.gmail.com>
 <20150610154240.GC22214@kroah.com>
 <CALszF6AaS-i2MBF64mJKtY2h5Sb710Z50Mf8wHotUBysukfZbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALszF6AaS-i2MBF64mJKtY2h5Sb710Z50Mf8wHotUBysukfZbw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: khilman-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Daniel Lezcano <daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Daniel Thompson <daniel.thompson-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Kamil Lulko <rev13-5tc4TXWwyLM@public.gmane.org>, Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org>, Andreas =?iso-8859-1?Q?F=E4rber?= <afaerber-l3A5Bk7waGM@public.gmane.org>, Geert Uytterhoeven <geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial@vg>
List-Id: linux-api@vger.kernel.org

On Wed, Jun 10, 2015 at 06:18:37PM +0200, Maxime Coquelin wrote:
> 2015-06-10 17:42 GMT+02:00 Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>:
> > On Wed, Jun 10, 2015 at 01:33:22PM +0200, Maxime Coquelin wrote:
> >> 2015-05-31 23:52 GMT+02:00 Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>:
> >> > On Fri, May 22, 2015 at 11:03:35PM +0200, Maxime Coquelin wrote:
> >> >> This drivers adds support to the STM32 USART controller, which is a
> >> >> standard serial driver.
> >> >>
> >> >> Tested-by: Chanwoo Choi <cw00.choi-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
> >> >> Reviewed-by: Peter Hurley <peter-WaGBZJeGNqdsbIuE7sb01tBPR1lH4CV8@public.gmane.org>
> >> >> Reviewed-by: Vladimir Zapolskiy <vladimir_zapolskiy-nmGgyN9QBj3QT0dZR+AlfA@public.gmane.org>
> >> >> Reviewed-by: Andy Shevchenko <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> >> Signed-off-by: Maxime Coquelin <mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> >
> >> > Acked-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> >>
> >> Thanks Greg.
> >>
> >> Will you apply it to your tty tree for v4.2? Or it should go in
> >> someone else tree?
> >
> > It's not in my queue, I'm guessing it goes in through some other tree as
> > there are build dependancies here preventing me from taking it.
> 
> There should not be any build dependencies.
> I just tested it on my x86 machine with COMPILE_TEST on both v4.1-rc1
> and tty-next branch.
> In both case it compiles without warnings.

Ok, then feel free to resend it as a stand-alone patch please and I will
queue it up.

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

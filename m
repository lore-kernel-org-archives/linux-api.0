From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH V2 6/6] coresight-stm: adding driver for CoreSight STM component
Date: Fri, 05 Feb 2016 15:30:19 +0100
Message-ID: <1481791.6NqBhgWcKU@wuerfel>
References: <1454487337-30184-1-git-send-email-zhang.chunyan@linaro.org> <1454487337-30184-7-git-send-email-zhang.chunyan@linaro.org> <87h9hn5msz.fsf@ashishki-desk.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87h9hn5msz.fsf-qxRn5AmX6ZD9BXuAQUXR0fooFf0ArEBIu+b9c/7xato@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Alexander Shishkin <alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, mathieu.poirier-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, al.grant-5wv7dgnIgG8@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tor-l0cyMroinI0@public.gmane.org, broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mike.leach-5wv7dgnIgG8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Russell King <linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>, pratikp-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, nicolas.guion-qxv4g6HH51o@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Friday 05 February 2016 15:06:20 Alexander Shishkin wrote:
> Chunyan Zhang <zhang.chunyan-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> writes:
> 
> > +#ifndef CONFIG_64BIT
> > +static inline void __raw_writeq(u64 val, volatile void __iomem *addr)
> > +{
> > +     asm volatile("strd %1, %0"
> > +                  : "+Qo" (*(volatile u64 __force *)addr)
> > +                  : "r" (val));
> > +}
> 
> Is it really ok to do this for all !64bit arms, inside a driver, just
> like that? I'm not an expert, but I'm pretty sure there's more to it.

It's normally device dependent whether this works or not, on 32-bit
architectures, a 64-bit access to an I/O bus tends to get split into
two 32 bit accesses and the order might not be the as what was
intended.

We have functions in include/linux/io-64-nonatomic-hi-lo.h
and include/linux/io-64-nonatomic-lo-hi.h that are meant to
do this right. Maybe the driver can be changed to use whichever
one is correct for it.

	Arnd

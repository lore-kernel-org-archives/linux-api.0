From: Lyra Zhang <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 4/5] arm64: Add support for Spreadtrum's Sharkl64
 Platform in Kconfig and defconfig
Date: Wed, 26 Nov 2014 11:08:01 +0800
Message-ID: <CAAfSe-uDk-ih2tqU9a3UEzr=BZgU_=+XJm9=zWbE3J4HMOuiog@mail.gmail.com>
References: <1416917818-10506-5-git-send-email-chunyan.zhang@spreadtrum.com>
	<3490516.nCDXzA8J8x@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3490516.nCDXzA8J8x@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, "robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org" <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, "jslaby-AlSwsSmVLrQ@public.gmane.org" <jslaby-AlSwsSmVLrQ@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Mark Brown <broonie-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "m-karicheri2-l0cyMroinI0@public.gmane.org" <m-karicheri2-l0cyMroinI0@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ramkumar Ramachandra <artagnon-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org" <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org, shawn.guo-KZfg59tc24xl57MIdRCFDg@public.gmane.org, florian.vaussard-p8DiymsW2f8@public.gmane.org, andrew-g2DYL2Zd6BY@public.gmane.org, hytszk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Orson Zhai <orsonzhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, geng.ren@spreadtrum.
List-Id: linux-api@vger.kernel.org

2014-11-25 20:57 GMT+08:00 Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>:
>
> On Tuesday 25 November 2014 20:16:57 Chunyan Zhang wrote:
> >
> > +menuconfig ARCH_SPRD
> > +       bool "Spreadtrum SoC platform"
> > +       depends on ARM64
> > +       help
> > +         Support for Spreadtrum ARM based SoCs
> > +
> > +if ARCH_SPRD
> > +
> > +config ARCH_SHARKL64
> > +       bool "Sharkl64 SoC Platform"
> > +       help
> > +         Sharkl64 is a Spreadtrum's SoC Platform which is based
> > +         on ARM 64-bit processor core including
> > +           sc9836
> > +
> > +endif #ARCH_SPRD
> > +
>
> I don't think we need multiple levels here, it should be enough to
> have either ARCH_SPRD or ARCH_SHARKL64, because all device drivers
> are going to be optional anyway. Typically a Kconfig symbol covers
> all SoCs that are related, so if you Spreadtrum are doing both
> phone and server chips and these are designed independently, you
> would have two symbols, but if you only expect to see phone chips
> here that are all derived from the same product line, using ARCH_SPRD
> to refer to all of them should be enough.
>
>         Arnd


For now, we have only one platform(Sharkl64) based on ARM64 been
submitted, but we're intending to add support for more our platforms
based on ARM64 or ARM32 in the future. There are many common devices
on these platforms, such as serial. Our idea would be that if we had a
'menuconfig ARCH_SPRD' in the Kconfig, these common devices only need
to depend on ARCH_SPRD in the respective Kconfig, otherwise they may
depend on a few Kconfig symbols for every platforms which include
these common devices.

So, do you think whether we should define a menuconfig(ARCH_SPRD) in
the Kconfig for this case ?

Thanks!

Best regards,
Chunyan

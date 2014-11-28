From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC
 in dts and Makefile
Date: Fri, 28 Nov 2014 17:24:31 +0000
Message-ID: <20141128172431.GA32393@e104818-lin.cambridge.arm.com>
References: <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1416917818-10506-4-git-send-email-chunyan.zhang@spreadtrum.com>
 <20141127115042.GE857@leverpostej>
 <20141127121214.GF11511@e104818-lin.cambridge.arm.com>
 <20141127134309.GJ857@leverpostej>
 <20141128142913.GB5393@localhost>
 <20141128143532.GI25883@leverpostej>
 <20141128144412.GG7144@arm.com>
 <20141128150325.GC24370@e104818-lin.cambridge.arm.com>
 <20141128164047.GL25883@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141128164047.GL25883@leverpostej>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: "andrew-g2DYL2Zd6BY@public.gmane.org" <andrew-g2DYL2Zd6BY@public.gmane.org>, "heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org" <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Will Deacon <Will.Deacon-5wv7dgnIgG8@public.gmane.org>, Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, "jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, "lanqing.liu-lxIno14LUO0EEoCn2XhGlw@public.gmane.org" <lanqing.liu-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, "arnd-r2nGTMty4D4@public.gmane.org" <arnd-r2nGTMty4D4@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>, "zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "zhizhou.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org" <zhizhou.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, "geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org" <geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, "m-karicheri2-l0cyMroinI0@public.gmane.org" <m-karicheri2-l0cyMroinI0@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "orsonzhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <orsonzhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "florian.vaussard-p8DiymsW2f8@public.gmane.org" <florian.vaussard>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 28, 2014 at 04:40:47PM +0000, Mark Rutland wrote:
> [...]
> 
> > In the meantime I think we can be more tolerant:
> > 
> > diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> > index 2133f9d59d06..87f67a93fcc7 100644
> > --- a/drivers/clocksource/arm_arch_timer.c
> > +++ b/drivers/clocksource/arm_arch_timer.c
> > @@ -376,6 +376,8 @@ arch_timer_detect_rate(void __iomem *cntbase, struct device_node *np)
> >  			arch_timer_rate = readl_relaxed(cntbase + CNTFRQ);
> >  		else
> >  			arch_timer_rate = arch_timer_get_cntfrq();
> > +	} else if (IS_ENABLED(CONFIG_ARM64)) {
> > +		pr_warn("Architected timer frequency overridden by DT (broken firmware?)\n");
> >  	}
> 
> That looks good to me. On a related note, it looks like my documentation
> patch [1] from a while back fell by the wayside. Does anyone fancy
> picking that up to go with this?

I can put the two together (keeping you as author). Do we still need the
IS_ENABLED(CONFIG_ARM64) part here or we extend the warning to to arm32
as well?

-- 
Catalin
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

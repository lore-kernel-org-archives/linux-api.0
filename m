From: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v3 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC
 in dts and Makefile
Date: Fri, 28 Nov 2014 15:03:26 +0000
Message-ID: <20141128150325.GC24370@e104818-lin.cambridge.arm.com>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1416917818-10506-4-git-send-email-chunyan.zhang@spreadtrum.com>
 <20141127115042.GE857@leverpostej>
 <20141127121214.GF11511@e104818-lin.cambridge.arm.com>
 <20141127134309.GJ857@leverpostej>
 <20141128142913.GB5393@localhost>
 <20141128143532.GI25883@leverpostej>
 <20141128144412.GG7144@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20141128144412.GG7144-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Rutland <Mark.Rutland-5wv7dgnIgG8@public.gmane.org>, "andrew-g2DYL2Zd6BY@public.gmane.org" <andrew-g2DYL2Zd6BY@public.gmane.org>, "heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org" <heiko-4mtYJXux2i+zQB+pC5nmwQ@public.gmane.org>, "gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org" <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Chunyan Zhang <chunyan.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, "jslaby-AlSwsSmVLrQ@public.gmane.org" <jslaby-AlSwsSmVLrQ@public.gmane.org>, "jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org" <jason-NLaQJdtUoK4Be96aLqz0jA@public.gmane.org>, "lanqing.liu-lxIno14LUO0EEoCn2XhGlw@public.gmane.org" <lanqing.liu-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, Pawel Moll <Pawel.Moll-5wv7dgnIgG8@public.gmane.org>, "corbet-T1hC0tSOHrs@public.gmane.org" <corbet-T1hC0tSOHrs@public.gmane.org>, "zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <zhang.lyra-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "zhizhou.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org" <zhizhou.zhang-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, "geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org" <geng.ren-lxIno14LUO0EEoCn2XhGlw@public.gmane.org>, "m-karicheri2-l0cyMroinI0@public.gmane.org" <m-karicheri2-l0cyMroinI0@public.gmane.org>, "shawn.guo-KZfg59tc24xl57MIdRCFDg@public.gmane.org" <shawn.guo-KZfg59tc24xl57MIdRCFDg@public.gmane.org>, "linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "orsonzhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <orsonzhai-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "florian.vaussard-p8DiymsW2f8@public.gmane.org" <flori>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 28, 2014 at 02:44:12PM +0000, Will Deacon wrote:
> On Fri, Nov 28, 2014 at 02:35:32PM +0000, Mark Rutland wrote:
> > On Fri, Nov 28, 2014 at 02:29:13PM +0000, Catalin Marinas wrote:
> > > On Thu, Nov 27, 2014 at 01:43:09PM +0000, Mark Rutland wrote:
> > > > On Thu, Nov 27, 2014 at 12:12:15PM +0000, Catalin Marinas wrote:
> > > > > On Thu, Nov 27, 2014 at 11:50:43AM +0000, Mark Rutland wrote:
> > > > > > On Tue, Nov 25, 2014 at 12:16:56PM +0000, Chunyan Zhang wrote:
> > > > > > > +
> > > > > > > +       timer {
> > > > > > > +               compatible = "arm,armv8-timer";
> > > > > > > +               interrupts = <1 13 0xff01>,
> > > > > > > +                            <1 14 0xff01>,
> > > > > > > +                            <1 11 0xff01>,
> > > > > > > +                            <1 10 0xff01>;
> > > > > > > +               clock-frequency = <26000000>;
> > > > > > 
> > > > > > Please remove the clock-frequency property. Your FW should initialise
> > > > > > CNTFRQ_EL0 on all CPUs (certainly PSCI 0.2 requires that you do this).
> > > > > 
> > > > > Since this comes up regularly, I think we need a dev_warn() in the arch
> > > > > timer driver when CONFIG_ARM64.
> > > > 
> > > > I'll ack such a patch ;)
> > > 
> > > How rude would this be?
> > > 
> > > diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> > > index 2133f9d59d06..aaaf3433ccb9 100644
> > > --- a/drivers/clocksource/arm_arch_timer.c
> > > +++ b/drivers/clocksource/arm_arch_timer.c
> > > @@ -371,7 +371,8 @@ arch_timer_detect_rate(void __iomem *cntbase, struct device_node *np)
> > > 		return;
> > >  
> > > 	/* Try to determine the frequency from the device tree or CNTFRQ */
> > > -	if (of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
> > > +	if (IS_ENABLED(CONFIG_ARM64) ||
> > > +	    of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
> > > 		if (cntbase)
> > > 			arch_timer_rate = readl_relaxed(cntbase + CNTFRQ);
> > > 		else
> > >
> > 
> > Probably too rude, given it doesn't WARN() the user.
> 
> We override broken hardware ID registers all the time in device-tree without
> dumping stack. Why is this any different?

I'm not for dumping the stack, it's not relevant (just more noise).

> > We should be extremely loud if we see the clock-frequency property on an
> > arm64 system. Whether or not we should ignore the property is another
> > matter.
> 
> I don't really see the point in ignoring it. We will see broken hardware
> [1] and this is just preventing ourselves from working around it. I'd much
> rather have arch-timers with a "clock-frequence" property than have some
> other timer instead because the kernel driver is being stubborn.

I agree that sooner or later we'll need a workaround (we already did for
Juno). My point is that many consider such overriding behaviour to be
the default - i.e. don't bother writing any sane value in CNTFRQ in
firmware at boot because Linux can cope without. It gets worse when
companies develop their firmware long before starting to upstream kernel
patches, so too late to fix it.

> [1] A previous version of the Juno firmware, for example.

What about CONFIG_BROKEN_FIRMWARE, default off?

In the meantime I think we can be more tolerant:

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 2133f9d59d06..87f67a93fcc7 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -376,6 +376,8 @@ arch_timer_detect_rate(void __iomem *cntbase, struct device_node *np)
 			arch_timer_rate = readl_relaxed(cntbase + CNTFRQ);
 		else
 			arch_timer_rate = arch_timer_get_cntfrq();
+	} else if (IS_ENABLED(CONFIG_ARM64)) {
+		pr_warn("Architected timer frequency overridden by DT (broken firmware?)\n");
 	}
 
 	/* Check the timer frequency. */

From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC
 in dts and Makefile
Date: Fri, 28 Nov 2014 14:29:13 +0000
Message-ID: <20141128142913.GB5393@localhost>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1416917818-10506-4-git-send-email-chunyan.zhang@spreadtrum.com>
 <20141127115042.GE857@leverpostej>
 <20141127121214.GF11511@e104818-lin.cambridge.arm.com>
 <20141127134309.GJ857@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141127134309.GJ857@leverpostej>
Sender: linux-doc-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, "heiko@sntech.de" <heiko@sntech.de>, "broonie@linaro.org" <broonie@linaro.org>, Will Deacon <Will.Deacon@arm.com>, "andrew@lunn.ch" <andrew@lunn.ch>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Chunyan Zhang <chunyan.zhang@spreadtrum.com>, "artagnon@gmail.com" <artagnon@gmail.com>, "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>, "arnd@arndb.de" <arnd@arndb.de>, "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>, "corbet@lwn.net" <corbet@lwn.net>, "jslaby@suse.cz" <jslaby@suse.cz>, "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>, "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>, "m-karicheri2@ti.com" <m-karicheri2@ti.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, grant.li
List-Id: linux-api@vger.kernel.org

On Thu, Nov 27, 2014 at 01:43:09PM +0000, Mark Rutland wrote:
> On Thu, Nov 27, 2014 at 12:12:15PM +0000, Catalin Marinas wrote:
> > On Thu, Nov 27, 2014 at 11:50:43AM +0000, Mark Rutland wrote:
> > > On Tue, Nov 25, 2014 at 12:16:56PM +0000, Chunyan Zhang wrote:
> > > > +
> > > > +       timer {
> > > > +               compatible = "arm,armv8-timer";
> > > > +               interrupts = <1 13 0xff01>,
> > > > +                            <1 14 0xff01>,
> > > > +                            <1 11 0xff01>,
> > > > +                            <1 10 0xff01>;
> > > > +               clock-frequency = <26000000>;
> > > 
> > > Please remove the clock-frequency property. Your FW should initialise
> > > CNTFRQ_EL0 on all CPUs (certainly PSCI 0.2 requires that you do this).
> > 
> > Since this comes up regularly, I think we need a dev_warn() in the arch
> > timer driver when CONFIG_ARM64.
> 
> I'll ack such a patch ;)

How rude would this be?

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 2133f9d59d06..aaaf3433ccb9 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -371,7 +371,8 @@ arch_timer_detect_rate(void __iomem *cntbase, struct device_node *np)
		return;
 
	/* Try to determine the frequency from the device tree or CNTFRQ */
-	if (of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
+	if (IS_ENABLED(CONFIG_ARM64) ||
+	    of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
		if (cntbase)
			arch_timer_rate = readl_relaxed(cntbase + CNTFRQ);
		else

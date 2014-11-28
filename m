From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC
 in dts and Makefile
Date: Fri, 28 Nov 2014 14:35:32 +0000
Message-ID: <20141128143532.GI25883@leverpostej>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1416917818-10506-4-git-send-email-chunyan.zhang@spreadtrum.com>
 <20141127115042.GE857@leverpostej>
 <20141127121214.GF11511@e104818-lin.cambridge.arm.com>
 <20141127134309.GJ857@leverpostej>
 <20141128142913.GB5393@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20141128142913.GB5393@localhost>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "andrew@lunn.ch" <andrew@lunn.ch>, "heiko@sntech.de" <heiko@sntech.de>, "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, Chunyan Zhang <chunyan.zhang@spreadtrum.com>, Will Deacon <Will.Deacon@arm.com>, "jslaby@suse.cz" <jslaby@suse.cz>, "jason@lakedaemon.net" <jason@lakedaemon.net>, "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>, Pawel Moll <Pawel.Moll@arm.com>, "corbet@lwn.net" <corbet@lwn.net>, "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>, "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>, "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>, "m-karicheri2@ti.com" <m-karicheri2@ti.com>, "shawn.guo@freescale.com" <shawn.guo@freescale.com>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, "grant.likely@linaro.org" <grant.likely@linaro.org>, "orsonzhai@gmail.com" <orsonzhai@gmail.com>, "florian.vaussard@epfl.ch" <florian.va>
List-Id: linux-api@vger.kernel.org

On Fri, Nov 28, 2014 at 02:29:13PM +0000, Catalin Marinas wrote:
> On Thu, Nov 27, 2014 at 01:43:09PM +0000, Mark Rutland wrote:
> > On Thu, Nov 27, 2014 at 12:12:15PM +0000, Catalin Marinas wrote:
> > > On Thu, Nov 27, 2014 at 11:50:43AM +0000, Mark Rutland wrote:
> > > > On Tue, Nov 25, 2014 at 12:16:56PM +0000, Chunyan Zhang wrote:
> > > > > +
> > > > > +       timer {
> > > > > +               compatible = "arm,armv8-timer";
> > > > > +               interrupts = <1 13 0xff01>,
> > > > > +                            <1 14 0xff01>,
> > > > > +                            <1 11 0xff01>,
> > > > > +                            <1 10 0xff01>;
> > > > > +               clock-frequency = <26000000>;
> > > > 
> > > > Please remove the clock-frequency property. Your FW should initialise
> > > > CNTFRQ_EL0 on all CPUs (certainly PSCI 0.2 requires that you do this).
> > > 
> > > Since this comes up regularly, I think we need a dev_warn() in the arch
> > > timer driver when CONFIG_ARM64.
> > 
> > I'll ack such a patch ;)
> 
> How rude would this be?
> 
> diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
> index 2133f9d59d06..aaaf3433ccb9 100644
> --- a/drivers/clocksource/arm_arch_timer.c
> +++ b/drivers/clocksource/arm_arch_timer.c
> @@ -371,7 +371,8 @@ arch_timer_detect_rate(void __iomem *cntbase, struct device_node *np)
> 		return;
>  
> 	/* Try to determine the frequency from the device tree or CNTFRQ */
> -	if (of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
> +	if (IS_ENABLED(CONFIG_ARM64) ||
> +	    of_property_read_u32(np, "clock-frequency", &arch_timer_rate)) {
> 		if (cntbase)
> 			arch_timer_rate = readl_relaxed(cntbase + CNTFRQ);
> 		else
>

Probably too rude, given it doesn't WARN() the user.

We should be extremely loud if we see the clock-frequency property on an
arm64 system. Whether or not we should ignore the property is another
matter.

Mark.

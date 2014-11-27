From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v3 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC
 in dts and Makefile
Date: Thu, 27 Nov 2014 13:43:09 +0000
Message-ID: <20141127134309.GJ857@leverpostej>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1416917818-10506-4-git-send-email-chunyan.zhang@spreadtrum.com>
 <20141127115042.GE857@leverpostej>
 <20141127121214.GF11511@e104818-lin.cambridge.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20141127121214.GF11511@e104818-lin.cambridge.arm.com>
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
Cc: "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, "heiko@sntech.de" <heiko@sntech.de>, "broonie@linaro.org" <broonie@linaro.org>, Will Deacon <Will.Deacon@arm.com>, "andrew@lunn.ch" <andrew@lunn.ch>, "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>, Chunyan Zhang <chunyan.zhang@spreadtrum.com>, "artagnon@gmail.com" <artagnon@gmail.com>, "lanqing.liu@spreadtrum.com" <lanqing.liu@spreadtrum.com>, "arnd@arndb.de" <arnd@arndb.de>, "zhang.lyra@gmail.com" <zhang.lyra@gmail.com>, "corbet@lwn.net" <corbet@lwn.net>, "jslaby@suse.cz" <jslaby@suse.cz>, "zhizhou.zhang@spreadtrum.com" <zhizhou.zhang@spreadtrum.com>, "geng.ren@spreadtrum.com" <geng.ren@spreadtrum.com>, "m-karicheri2@ti.com" <m-karicheri2@ti.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>, grant.likely@l
List-Id: linux-api@vger.kernel.org

On Thu, Nov 27, 2014 at 12:12:15PM +0000, Catalin Marinas wrote:
> On Thu, Nov 27, 2014 at 11:50:43AM +0000, Mark Rutland wrote:
> > On Tue, Nov 25, 2014 at 12:16:56PM +0000, Chunyan Zhang wrote:
> > > +
> > > +       timer {
> > > +               compatible = "arm,armv8-timer";
> > > +               interrupts = <1 13 0xff01>,
> > > +                            <1 14 0xff01>,
> > > +                            <1 11 0xff01>,
> > > +                            <1 10 0xff01>;
> > > +               clock-frequency = <26000000>;
> > 
> > Please remove the clock-frequency property. Your FW should initialise
> > CNTFRQ_EL0 on all CPUs (certainly PSCI 0.2 requires that you do this).
> 
> Since this comes up regularly, I think we need a dev_warn() in the arch
> timer driver when CONFIG_ARM64.

I'll ack such a patch ;)

Mark.

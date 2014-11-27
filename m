From: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH v3 3/5] arm64: dts: Add support for Spreadtrum SC9836 SoC
 in dts and Makefile
Date: Thu, 27 Nov 2014 12:12:15 +0000
Message-ID: <20141127121214.GF11511@e104818-lin.cambridge.arm.com>
References: <Sharkl64-v3>
 <1416917818-10506-1-git-send-email-chunyan.zhang@spreadtrum.com>
 <1416917818-10506-4-git-send-email-chunyan.zhang@spreadtrum.com>
 <20141127115042.GE857@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141127115042.GE857@leverpostej>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: Chunyan Zhang <chunyan.zhang@spreadtrum.com>, "grant.likely@linaro.org" <grant.likely@linaro.org>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "jslaby@suse.cz" <jslaby@suse.cz>, "galak@codeaurora.org" <galak@codeaurora.org>, "broonie@linaro.org" <broonie@linaro.org>, "m-karicheri2@ti.com" <m-karicheri2@ti.com>, Pawel Moll <Pawel.Moll@arm.com>, "artagnon@gmail.com" <artagnon@gmail.com>, "rrichter@cavium.com" <rrichter@cavium.com>, Will Deacon <Will.Deacon@arm.com>, "arnd@arndb.de" <arnd@arndb.de>, "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, "corbet@lwn.net" <corbet@lwn.net>, "jason@lakedaemon.net" <jason@lakedaemon.net>, "broonie@kernel.org" <broonie@kernel.org>, "heiko@sntech.de" <heiko@sntech.de>, "shawn.guo@freescale.com" <shaw>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 27, 2014 at 11:50:43AM +0000, Mark Rutland wrote:
> On Tue, Nov 25, 2014 at 12:16:56PM +0000, Chunyan Zhang wrote:
> > +
> > +       timer {
> > +               compatible = "arm,armv8-timer";
> > +               interrupts = <1 13 0xff01>,
> > +                            <1 14 0xff01>,
> > +                            <1 11 0xff01>,
> > +                            <1 10 0xff01>;
> > +               clock-frequency = <26000000>;
> 
> Please remove the clock-frequency property. Your FW should initialise
> CNTFRQ_EL0 on all CPUs (certainly PSCI 0.2 requires that you do this).

Since this comes up regularly, I think we need a dev_warn() in the arch
timer driver when CONFIG_ARM64.

-- 
Catalin

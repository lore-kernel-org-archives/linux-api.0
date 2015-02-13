From: Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [PATCH 12/14] ARM: dts: Introduce STM32F429 MCU
Date: Fri, 13 Feb 2015 17:25:35 +0100
Message-ID: <1423844735.4182.52.camel@pengutronix.de>
References: <1423763164-5606-1-git-send-email-mcoquelin.stm32@gmail.com>
	 <1423763164-5606-13-git-send-email-mcoquelin.stm32@gmail.com>
	 <1423828078.4182.17.camel@pengutronix.de>
	 <CALszF6D+5mXajUWarwq8M4yL_Nc+x1Bmu4D7_HxDRy2kGRXNVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <CALszF6D+5mXajUWarwq8M4yL_Nc+x1Bmu4D7_HxDRy2kGRXNVQ@mail.gmail.com>
Sender: linux-doc-owner@vger.kernel.org
To: Maxime Coquelin <mcoquelin.stm32@gmail.com>
Cc: Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>, Ian Campbell <ijc+devicetree@hellion.org.uk>, Kumar Gala <galak@codeaurora.org>, Russell King <linux@arm.linux.org.uk>, Daniel Lezcano <daniel.lezcano@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Linus Walleij <linus.walleij@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, "David S. Miller" <davem@davemloft.net>, Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Joe Perches <joe@perches.com>, Antti Palosaari <crope@iki.fi>, Tejun Heo <tj@kernel.org>, Will Deacon <will.deacon@arm.com>, Nikolay Borisov <Nikolay.Borisov@arm.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, Michal
List-Id: linux-api@vger.kernel.org

Hi Maxime,

Am Freitag, den 13.02.2015, 16:59 +0100 schrieb Maxime Coquelin:
> Hi Philipp,
> 
> 2015-02-13 12:47 GMT+01:00 Philipp Zabel <p.zabel@pengutronix.de>:
> > Hi Maxime,
> >
> > Am Donnerstag, den 12.02.2015, 18:46 +0100 schrieb Maxime Coquelin:
> > [...]
> >> +     soc {
> >> +             reset_ahb1: reset@40023810 {
> >> +                     #reset-cells = <1>;
> >> +                     compatible = "st,stm32-reset";
> >> +                     reg = <0x40023810 0x4>;
> >> +             };
> >> +
> >> +             reset_ahb2: reset@40023814 {
> >> +                     #reset-cells = <1>;
> >> +                     compatible = "st,stm32-reset";
> >> +                     reg = <0x40023814 0x4>;
> >> +             };
> >> +
> >> +             reset_ahb3: reset@40023818 {
> >> +                     #reset-cells = <1>;
> >> +                     compatible = "st,stm32-reset";
> >> +                     reg = <0x40023818 0x4>;
> >> +             };
> >> +
> >> +             reset_apb1: reset@40023820 {
> >> +                     #reset-cells = <1>;
> >> +                     compatible = "st,stm32-reset";
> >> +                     reg = <0x40023820 0x4>;
> >> +             };
> >> +
> >> +             reset_apb2: reset@40023824 {
> >> +                     #reset-cells = <1>;
> >> +                     compatible = "st,stm32-reset";
> >> +                     reg = <0x40023824 0x4>;
> >> +             };
> >
> > These are mostly consecutive, single registers. I wonder if these are
> > part of the same IP block and thus should be grouped together into the
> > same reset controller node?
> 
> What I could to is to have two instances. One for AHB and one for APB domain.
> Doing this, I will have one instance per domain, and only consecutive registers.
> Is it fine for you?

Looking at
http://www.st.com/web/en/resource/technical/document/reference_manual/DM00031020.pdf
Table 34 (RCC register map and reset values), I'd say there is a single
"Reset and Clock Control" device at 0x40023800 - 0x40023884:

	soc {
		rcc: rcc@40023800 {
			#clock-cells = <1>;
			#reset-cells = <1>;
			compatible = "st,stm32-rcc";
			reg = <0x40023800 0x84>;
		};

		...

If you really want to describe the reset controller parts (offsets +0x10
to +0x24) in a separate node, I won't argue against it too long,
although this is a somewhat arbitrary decision.

In any case, the whole register at offset +0x1c is reserved, so there is
no reason to split the reset controller. It is ok to have unused ranges
as is already the case with reserved bits inside the used registers.

regards
Philipp


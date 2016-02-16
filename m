From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v3 06/10] ARM: mps2: introduce MPS2 platform
Date: Tue, 16 Feb 2016 15:39:12 +0100
Message-ID: <2949036.dUgqHWXoSe@wuerfel>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com> <29457600.xRDuy0uVjW@wuerfel> <56C333BF.1020108@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56C333BF.1020108-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Cc: linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 16 February 2016 14:35:43 Vladimir Murzin wrote:
> On 16/02/16 10:56, Arnd Bergmann wrote:
> > On Tuesday 16 February 2016 10:08:11 Vladimir Murzin wrote:
> >> The Cortex-M Prototyping System (or V2M-MPS2) is designed for
> >> prototyping and evaluation Cortex-M family of processors including the
> >> latest Cortex-M7
> >>
> >> It comes with a range of useful peripherals including 8MB single cycle
> >> SRAM, 16MB PSRAM, Ethernet, QSVGA touch screen panel, 4bit RGB VGA
> >> connector, Audio, SPI and GPIO.
> >>
> >> Signed-off-by: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
> >> ---
> >>  arch/arm/Kconfig                 |    8 ++++++++
> >>  arch/arm/Makefile                |    1 +
> >>  arch/arm/mach-mps2/Makefile      |    1 +
> >>  arch/arm/mach-mps2/Makefile.boot |    3 +++
> >>  arch/arm/mach-mps2/dtmachine.c   |   21 +++++++++++++++++++++
> >>
> > 
> > We are in the (slow) process of consolidating the ARM reference platforms
> > (versatile, integrator, realview, vexpress) into one place.
> > 
> 
> Thanks for information! Sometime ago I saw on a list you had some
> thoughts on consolidating M-class platforms since most of them follow
> quite the same pattern (I'm looking at efm32 and stm32). So, shouldn't
> this platform consider that way?
> 

Right, that would be another option. vf610 is in the same category as this
one I think, it's currently in mach-imx, and we can probably leave it there.

Unless someone is going to do the patch to consolidate the cortex-m
platforms, I'd stay with mach-vexpress here, but I don't have a strong
opinion.

	Arnd

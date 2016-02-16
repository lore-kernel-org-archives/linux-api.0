From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v3 06/10] ARM: mps2: introduce MPS2 platform
Date: Tue, 16 Feb 2016 11:56:08 +0100
Message-ID: <29457600.xRDuy0uVjW@wuerfel>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com> <1455617295-23736-7-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455617295-23736-7-git-send-email-vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Cc: linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, mark.rutland-5wv7dgnIgG8@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 16 February 2016 10:08:11 Vladimir Murzin wrote:
> The Cortex-M Prototyping System (or V2M-MPS2) is designed for
> prototyping and evaluation Cortex-M family of processors including the
> latest Cortex-M7
> 
> It comes with a range of useful peripherals including 8MB single cycle
> SRAM, 16MB PSRAM, Ethernet, QSVGA touch screen panel, 4bit RGB VGA
> connector, Audio, SPI and GPIO.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
> ---
>  arch/arm/Kconfig                 |    8 ++++++++
>  arch/arm/Makefile                |    1 +
>  arch/arm/mach-mps2/Makefile      |    1 +
>  arch/arm/mach-mps2/Makefile.boot |    3 +++
>  arch/arm/mach-mps2/dtmachine.c   |   21 +++++++++++++++++++++
> 

We are in the (slow) process of consolidating the ARM reference platforms
(versatile, integrator, realview, vexpress) into one place.

I'd suggest adding all this to the mach-vexpress directory rather than
a new directory, so we don't have another one to consolidate.

	Arnd
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

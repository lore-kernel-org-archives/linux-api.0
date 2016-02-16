From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v3 08/10] ARM: configs: add MPS2 defconfig
Date: Tue, 16 Feb 2016 16:08:34 +0100
Message-ID: <11778979.HbWgmZUCnF@wuerfel>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com> <2680417.bULLX3O66Y@wuerfel> <56C3378F.2010008@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56C3378F.2010008-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>, mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 16 February 2016 14:51:59 Vladimir Murzin wrote:
> > 
> > Why CONFIG_EMBEDDED? You probably mean CONFIG_EXPERT, but then what do
> > you need that for?
> 
> TBH, I have no special requirement for this option to be set and now,
> looking at Kconfig entry for this option, I think that I got it here
> because I stated configuration with allnoconfig.
> 
> OTOH, I don't see how harmful it can be since description says:
> 
>           This option should be enabled if compiling the kernel for
>           an embedded system so certain expert options are available
>           for configuration
> 
> yes, it selects CONFIG_EXPERT and that had side effect that, for
> example, CONFIG_NAMESPACE could be compiled out.
> 
> Have I missed something around it?

Just the history behind this symbol. We removed it a while ago in
favor if CONFIG_EXPERT, assuming that it makes it clearer that it's
not just for embedded systems, or for systems with small memory.

It's  basically a zombie symbol that nobody should use directly
(independent of what the documentation says...).

	Arnd

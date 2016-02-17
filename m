From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v3 09/10] ARM: dts: introduce MPS2 AN385/AN386
Date: Wed, 17 Feb 2016 17:58:09 +0100
Message-ID: <7272921.u1gphgWzUn@wuerfel>
References: <1455617295-23736-1-git-send-email-vladimir.murzin@arm.com> <56C349E6.2000002@arm.com> <56C4A46C.50506@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56C4A46C.50506-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Cc: mark.rutland-5wv7dgnIgG8@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, pawel.moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wednesday 17 February 2016 16:48:44 Vladimir Murzin wrote:
> On 16/02/16 16:10, Vladimir Murzin wrote:
> > On 16/02/16 11:01, Arnd Bergmann wrote:
> >> On Tuesday 16 February 2016 10:08:14 Vladimir Murzin wrote:
> >>> +
> >>> +       ethernet@40200000 {
> >>> +               compatible = "smsc,lan9220", "smsc,lan9115";
> >>> +               reg = <0x40200000 0x10000>;
> >>> +               interrupts = <13>;
> >>> +               interrupt-parent = <&nvic>;
> >>> +               smsc,irq-active-high;
> >>> +       };
> >>> +};
> >>> +
> >>>
> >>
> >> This node seems slightly misplaced. Is there some external bus interface
> >> that this is connected to? The address suggests that it should be somewhere
> >> below the /soc node, and you probably want to list the external bus
> >> interface with a "ranges" property that identifies the addresses visibile
> >> there, and put the external chip under there.
> >>
> > 
> > I might messed it up since the MAC/PHY connects to the same 16-bit
> > interface as the 16MB PSRAM external memory and both connected via AHB.
> > 
> > Not sure how it should be expressed, so some help form DT camp would be
> > appreciated.
> 
> Does following fixup address your point on where/how ethernet node
> should be placed?



> diff --git a/arch/arm/boot/dts/mps2-an385.dts b/arch/arm/boot/dts/an385.dts
> index 976f86d..50c8d24 100644
> --- a/arch/arm/boot/dts/mps2-an385.dts
> +++ b/arch/arm/boot/dts/mps2-an385.dts
> @@ -63,14 +63,10 @@
>  		device_type = "memory";
>  		reg = <0x21000000 0x1000000>;
>  	};
> +};
> 
> -	ethernet@40200000 {
> -		compatible = "smsc,lan9220", "smsc,lan9115";
> -		reg = <0x40200000 0x10000>;
> -		interrupts = <13>;
> -		interrupt-parent = <&nvic>;
> -		smsc,irq-active-high;
> -	};
> +&mb {
> +	ranges = <0 0x40200000 0x10000>;
>  };

How is the range being set here? The way I read this is:

"There is an external bus controller whose single CPU physical
address for MMIO is configurable. The chip always connects
a lan9220 device to it (as that is in the dtsi file) and
nothing else is possible, and the bootloader in this
version of the machine has configured the window to be
at address 0x40200000."

Is that what the hardware does?

I would have expected the opposite, with the external bus
interface being hardwired to one or more physical addresses
(more than one if you have multiple chip-selects), and
then allow to connect different devices, which are in the
.dts file, while the bus controller is defined in the
.dtsi file.

	Arnd

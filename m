From: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 01/10] dt-bindings: document the MPS2 timer bindings
Date: Wed, 25 Nov 2015 14:04:53 -0600
Message-ID: <20151125200441.GA30473@rob-hp-laptop>
References: <1448447621-17900-1-git-send-email-vladimir.murzin@arm.com>
 <1448447621-17900-2-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1448447621-17900-2-git-send-email-vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>
Cc: arnd-r2nGTMty4D4@public.gmane.org, linux-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, daniel.lezcano-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, u.kleine-koenig-bIcnvbaLZ9MEGnE8C9+IrQ@public.gmane.org, afaerber-l3A5Bk7waGM@public.gmane.org, mcoquelin.stm32-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Mark.Rutland-5wv7dgnIgG8@public.gmane.org, Pawel.Moll-5wv7dgnIgG8@public.gmane.org, ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org, galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org, jslaby-AlSwsSmVLrQ@public.gmane.org, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-serial-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed, Nov 25, 2015 at 10:33:32AM +0000, Vladimir Murzin wrote:
> This adds documentation of device tree bindings for the
> timers found on ARM MPS2 platform.
> 
> Signed-off-by: Vladimir Murzin <vladimir.murzin-5wv7dgnIgG8@public.gmane.org>

Acked-by: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

> ---
>  .../devicetree/bindings/timer/arm,mps2-timer.txt   |   28 ++++++++++++++++++++
>  1 file changed, 28 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/timer/arm,mps2-timer.txt
> 
> diff --git a/Documentation/devicetree/bindings/timer/arm,mps2-timer.txt b/Documentation/devicetree/bindings/timer/arm,mps2-timer.txt
> new file mode 100644
> index 0000000..48f84d7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/timer/arm,mps2-timer.txt
> @@ -0,0 +1,28 @@
> +ARM MPS2 timer
> +
> +The MPS2 platform has simple general-purpose 32 bits timers.
> +
> +Required properties:
> +- compatible	: Should be "arm,mps2-timer"
> +- reg		: Address and length of the register set
> +- interrupts	: Reference to the timer interrupt
> +
> +Required clocking property, have to be one of:
> +- clocks	   : The input clock of the timer
> +- clock-frequency : The rate in HZ in input of the ARM MPS2 timer
> +
> +Examples:
> +
> +timer1: mps2-timer@40000000 {
> +	compatible = "arm,mps2-timer";
> +	reg = <0x40000000 0x1000>;
> +	interrupts = <8>;
> +	clocks = <&sysclk>;
> +};
> +
> +timer2: mps2-timer@40001000 {
> +	compatible = "arm,mps2-timer";
> +	reg = <0x40001000 0x1000>;
> +	interrupts = <9>;
> +	clock-frequency = <25000000>;
> +};
> -- 
> 1.7.9.5
> 

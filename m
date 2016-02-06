From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v5 3/4] Documentation: afe4403: Add DT bindings for the
 AFE4403 heart monitor
Date: Sat, 6 Feb 2016 18:58:48 +0000
Message-ID: <56B64268.8090306@kernel.org>
References: <1454435446-20586-1-git-send-email-afd@ti.com>
 <1454435446-20586-4-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1454435446-20586-4-git-send-email-afd-l0cyMroinI0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>
Cc: devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 02/02/16 17:50, Andrew F. Davis wrote:
> Add the TI AFE4403 heart monitor DT bindings documentation.
> 
> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
Given this is near identical to the AFE4404 binding I'll assume the lack of
comment on that means this one is fine too ;)

Applied to the togreg branch of iio.git - initially pushed out as testing
for the autobuilders to ignore it.

Jonathan
> ---
>  .../devicetree/bindings/iio/health/afe4403.txt     | 34 ++++++++++++++++++++++
>  1 file changed, 34 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/health/afe4403.txt
> 
> diff --git a/Documentation/devicetree/bindings/iio/health/afe4403.txt b/Documentation/devicetree/bindings/iio/health/afe4403.txt
> new file mode 100644
> index 0000000..2fffd70
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/health/afe4403.txt
> @@ -0,0 +1,34 @@
> +Texas Instruments AFE4403 Heart rate and Pulse Oximeter
> +
> +Required properties:
> + - compatible		: Should be "ti,afe4403".
> + - reg			: SPI chip select address of device.
> + - tx-supply		: Regulator supply to transmitting LEDs.
> + - interrupt-parent	: Phandle to he parent interrupt controller.
> + - interrupts		: The interrupt line the device ADC_RDY pin is
> +			  connected to. For details refer to,
> +			  ../../interrupt-controller/interrupts.txt.
> +
> +Optional properties:
> + - reset-gpios		: GPIO used to reset the device.
> +			  For details refer to, ../../gpio/gpio.txt.
> +
> +For other required and optional properties of SPI slave nodes
> +please refer to ../../spi/spi-bus.txt.
> +
> +Example:
> +
> +&spi0 {
> +	heart_mon@0 {
> +		compatible = "ti,afe4403";
> +		reg = <0>;
> +		spi-max-frequency = <10000000>;
> +
> +		tx-supply = <&vbat>;
> +
> +		interrupt-parent = <&gpio1>;
> +		interrupts = <28 IRQ_TYPE_EDGE_RISING>;
> +
> +		reset-gpios = <&gpio1 16 GPIO_ACTIVE_LOW>;
> +	};
> +};
> 

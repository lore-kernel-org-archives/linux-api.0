From: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] Documentation: afe4404: Add DT bindings for the
 AFE4404 heart monitor
Date: Sat, 31 Oct 2015 13:44:15 -0500
Message-ID: <CAL_JsqJJjtAXzi-3Aeb6pwwSUUv0i9g0g43Fq60CeSmNEiYoaQ@mail.gmail.com>
References: <1446309089-21094-1-git-send-email-afd@ti.com> <1446309089-21094-2-git-send-email-afd@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446309089-21094-2-git-send-email-afd-l0cyMroinI0@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Andrew F. Davis" <afd-l0cyMroinI0@public.gmane.org>
Cc: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

gmail thinks this is spam BTW.

On Sat, Oct 31, 2015 at 11:31 AM, Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org> wrote:
> Add the TI afe4404 heart monitor DT bindings documentation.
> Create health directory created under iio.
>
> Signed-off-by: Andrew F. Davis <afd-l0cyMroinI0@public.gmane.org>
> ---
>  .../devicetree/bindings/iio/health/afe4404.txt     | 27 ++++++++++++++++++++++
>  1 file changed, 27 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/health/afe4404.txt
>
> diff --git a/Documentation/devicetree/bindings/iio/health/afe4404.txt b/Documentation/devicetree/bindings/iio/health/afe4404.txt
> new file mode 100644
> index 0000000..d377033
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/health/afe4404.txt
> @@ -0,0 +1,27 @@
> +* Texas Instruments AFE4404 Heart rate and Pulse Oximeter
> +
> +Required properties:
> + - compatible          : Should be "ti,afe4404".
> + - reg                 : I2C address of the device.
> + - led-supply          : Regulator supply to the device.

Is led correct name or copy-n-paste? The datasheet has tx_sup and
rx_sup for supplies.

> + - interrupt-parent    : Phandle to he parent interrupt controller.
> + - interrupts          : The interrupt line the device ADC_RDY pin is connected to.
> +
> +Optional properties:
> + - reset-gpios         : GPIO used to reset the device.
> +
> +Example:
> +
> +&i2c2 {
> +       heart_mon@58 {
> +               compatible = "ti,afe4404";
> +               reg = <0x58>;
> +
> +               led-supply = <&vbat>;
> +
> +               interrupt-parent = <&gpio1>;
> +               interrupts = <28 IRQ_TYPE_EDGE_RISING>;
> +
> +               reset-gpios = <&gpio1 16 GPIO_ACTIVE_LOW>;
> +       };
> +};
> --
> 1.9.1
>

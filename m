From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 4/8] iio: da9150: Add DT binding documentation for GPADC
Date: Sat, 27 Sep 2014 11:52:30 +0100
Message-ID: <542696EE.5000706@kernel.org>
References: <cover.1411396718.git.Adam.Thomson.Opensource@diasemi.com> <6697dbc9711c9c3551aede1b5e4f986caa0d1a44.1411396719.git.Adam.Thomson.Opensource@diasemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <6697dbc9711c9c3551aede1b5e4f986caa0d1a44.1411396719.git.Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, support.opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 23/09/14 11:53, Adam Thomson wrote:
> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
Acked-by: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  .../devicetree/bindings/iio/adc/da9150-gpadc.txt         | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt
> 
> diff --git a/Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt b/Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt
> new file mode 100644
> index 0000000..c07228d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/iio/adc/da9150-gpadc.txt
> @@ -0,0 +1,16 @@
> +Dialog Semiconductor DA9150 IIO GPADC bindings
> +
> +Required properties:
> +- compatible: "dlg,da9150-gpadc" for DA9150 IIO GPADC
> +- #io-channel-cells: Should be set to <1>
> +  (See Documentation/devicetree/bindings/iio/iio-bindings.txt for further info)
> +
> +For further information on GPADC channels, see device datasheet.
> +
> +
> +Example:
> +
> +	gpadc: da9150-gpadc {
> +		compatible = "dlg,da9150-gpadc";
> +		#io-channel-cells = <1>;
> +	};
> --
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

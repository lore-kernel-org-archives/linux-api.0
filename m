From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 8/8] iio: Add ABI documentation for input current readings
Date: Sat, 27 Sep 2014 11:23:03 +0100
Message-ID: <54269007.9000709@kernel.org>
References: <cover.1411396718.git.Adam.Thomson.Opensource@diasemi.com> <b578cdd53527bb71c271eefadd1ce1bac175b5a7.1411396719.git.Adam.Thomson.Opensource@diasemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <b578cdd53527bb71c271eefadd1ce1bac175b5a7.1411396719.git.Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, support.opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 23/09/14 11:53, Adam Thomson wrote:
> Add information on in_current related readings.
> 
> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
This crossed with a similar patch also adding some docs for current channels.
That just missed this cycle anyway so I'll probably just merge this in as
an extension of that patch when we are happy with the rest of the series.
That patch covers the raw attribute but doesn't add the other entries..
(in the togreg branch of iio.git)

Jonathan
> ---
>  Documentation/ABI/testing/sysfs-bus-iio | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index d760b02..37cd4d4 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -92,6 +92,18 @@ Description:
>  		is required is a consistent labeling.  Units after application
>  		of scale and offset are millivolts.
> 
> +What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_raw
> +What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_supply_raw
> +KernelVersion:	3.17
> +Contact:	linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> +Description:
> +		Raw (unscaled no bias removal etc.) current measurement from
> +		channel Y. In special cases where the channel does not
> +		correspond to externally available input one of the named
> +		versions may be used. The number must always be specified and
> +		unique to allow association with event codes. Units after
> +		application of scale and offset are milliamps.
> +
>  What:		/sys/bus/iio/devices/iio:deviceX/in_capacitanceY_raw
>  KernelVersion:	3.2
>  Contact:	linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> @@ -227,6 +239,8 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_accel_y_offset
>  What:		/sys/bus/iio/devices/iio:deviceX/in_accel_z_offset
>  What:		/sys/bus/iio/devices/iio:deviceX/in_voltageY_offset
>  What:		/sys/bus/iio/devices/iio:deviceX/in_voltage_offset
> +What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_offset
> +What:		/sys/bus/iio/devices/iio:deviceX/in_current_offset
>  What:		/sys/bus/iio/devices/iio:deviceX/in_tempY_offset
>  What:		/sys/bus/iio/devices/iio:deviceX/in_temp_offset
>  What:		/sys/bus/iio/devices/iio:deviceX/in_pressureY_offset
> @@ -249,8 +263,11 @@ Description:
>  		to the _raw output.
> 
>  What:		/sys/bus/iio/devices/iio:deviceX/in_voltageY_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_voltageY_supply_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_currentY_supply_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_voltage_scale
> +What:		/sys/bus/iio/devices/iio:deviceX/in_current_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/out_voltageY_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/out_altvoltageY_scale
>  What:		/sys/bus/iio/devices/iio:deviceX/in_accel_scale
> --
> 1.9.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 8/8] iio: Add ABI documentation for input current readings
Date: Fri, 12 Dec 2014 11:45:59 +0000
Message-ID: <548AD577.10508@kernel.org>
References: <cover.1416938054.git.Adam.Thomson.Opensource@diasemi.com> <9d3c3451c2cac6035277fb36ffead1a1f8af453e.1416938054.git.Adam.Thomson.Opensource@diasemi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9d3c3451c2cac6035277fb36ffead1a1f8af453e.1416938054.git.Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>, Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Samuel Ortiz <sameo-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sebastian Reichel <sre-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dmitry Eremin-Solenikov <dbaryshkov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-pm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, support.opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 25/11/14 18:25, Adam Thomson wrote:
> Add information on in_current related readings.
> 
> Signed-off-by: Adam Thomson <Adam.Thomson.Opensource-WBD+wuPFNBhBDgjK7y7TUQ@public.gmane.org>
This one stands on it's own to applied (with some fuzz and tiny
bit of rearranging) to the togreg branch of iio.git - initially pushed
out as testing for the autobuilders to play with it.

Thanks,

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

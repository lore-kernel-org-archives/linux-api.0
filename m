From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 1/1] iio: Add iio_mod_light_uva, iio_mod_light_uvb,
 and iio_mod_light_uvc.
Date: Sun, 07 Jun 2015 18:17:52 +0100
Message-ID: <55747CC0.1000803@kernel.org>
References: <1433468871-14351-1-git-send-email-ktsai@capellamicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433468871-14351-1-git-send-email-ktsai-GubuWUlQtMwciDkP5Hr2oA@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Kevin Tsai <ktsai-GubuWUlQtMwciDkP5Hr2oA@public.gmane.org>, Hartmut Knaack <knaack.h-Mmb7MZpHnFY@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Peter Meerwald <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, Irina Tirdea <irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haneen Mohammed <hamohammed.sa-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Darshana Padmadas <darshanapadmadas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roberta Dobrescu <roberta.dobrescu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlad Dogaru <vlad.dogaru-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Reyad Attiyat <reyad.attiyat-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Octavian Purdila <octavian.purdila-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Martin Fuzzey <mfuzzey-mB3Nsq4MPf1BDgjK7y7TUQ@public.gmane.org>, Srinivas Pandruvada <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 05/06/15 02:47, Kevin Tsai wrote:
> Add Ultraviolet(UV) support:
> UVA: 315 ~ 400 nm
> UVB: 280 ~ 315 nm
> UVC: 100 ~ 280 nm
> 
> /sys/bus/iio/devices/iio:deviceX/in_intensity_uva_input
> /sys/bus/iio/devices/iio:deviceX/in_intensity_uvb_input
> /sys/bus/iio/devices/iio:deviceX/in_intensity_uvc_input
> The SI unit is "uW/mm^2".
> 
> /sys/bus/iio/devices/iio:deviceX/in_intensity_uva_min_wavelength
> /sys/bus/iio/devices/iio:deviceX/in_intensity_uva_max_wavelength
> /sys/bus/iio/devices/iio:deviceX/in_intensity_uvb_min_wavelength
> /sys/bus/iio/devices/iio:deviceX/in_intensity_uvb_max_wavelength
> /sys/bus/iio/devices/iio:deviceX/in_intensity_uvc_min_wavelength
> /sys/bus/iio/devices/iio:deviceX/in_intensity_uvc_max_wavelength
I'd flip these around so 
in_intensity_uvc_wavelength_max etc

Fits better with existing forms in the ABI (I think) and also will
list them in a more useful order when the directory is sorted by name.

Otherwise, I'd like to let this sit for others who work with light
sensors to comment as ideally we'd extend this to visible wavelengths
as well.
> The SI unit is "nm".
> 
> Signed-off-by: Kevin Tsai <ktsai-GubuWUlQtMwciDkP5Hr2oA@public.gmane.org>

> ---
>  Documentation/ABI/testing/sysfs-bus-iio | 23 +++++++++++++++++++++++
>  drivers/iio/industrialio-core.c         |  3 +++
>  include/uapi/linux/iio/types.h          |  3 +++
>  tools/iio/iio_event_monitor.c           |  6 ++++++
>  4 files changed, 35 insertions(+)
> 
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> index bbed111..2960142 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -1463,3 +1463,26 @@ Description:
>  		measurements and return the average value as output data. Each
>  		value resulted from <type>[_name]_oversampling_ratio measurements
>  		is considered as one sample for <type>[_name]_sampling_frequency.
> +
> +What:		/sys/.../iio:deviceX/in_intensity_uva[_input|_raw]
> +What:		/sys/.../iio:deviceX/in_intensity_uvb[_input|_raw]
> +What:		/sys/.../iio:deviceX/in_intensity_uvc[_input|_raw]
We have carefully killed off wild cards in the actual What lines as they make
automated parsing of these files tricky.  So just list both options out longhand..
> +KernelVersion:	4.1.1
> +Description:
> +		uva is the ultraviolet wavelength from 315nm to 400nm.
> +		uvb is the ultraviolet wavelength from 280nm to 315nm.
> +		uvc is the ultraviolet wavelength from 100nm to 280nm.
> +		The SI unit is "uW/mm^2". Otherwise it should include _raw.
> +
> +What:		/sys/.../iio:deviceX/in_intensity_uva_min_wavelength
> +What:		/sys/.../iio:deviceX/in_intensity_uva_max_wavelength
> +What:		/sys/.../iio:deviceX/in_intensity_uvb_min_wavelength
> +What:		/sys/.../iio:deviceX/in_intensity_uvb_max_wavelength
> +What:		/sys/.../iio:deviceX/in_intensity_uvc_min_wavelength
> +What:		/sys/.../iio:deviceX/in_intensity_uvc_max_wavelength
> +KernelVersion:	4.1.1
> +Description:
> +		Sensor may not cover the whole uva/uvb/uvc channel. Add the
> +		min/max wavelength properties to descript sensor range.
describe
> +		The SI unit is "nm".
> +
> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> index 3524b0d..ecbdd1e 100644
> --- a/drivers/iio/industrialio-core.c
> +++ b/drivers/iio/industrialio-core.c
> @@ -89,6 +89,9 @@ static const char * const iio_modifier_names[] = {
>  	[IIO_MOD_LIGHT_RED] = "red",
>  	[IIO_MOD_LIGHT_GREEN] = "green",
>  	[IIO_MOD_LIGHT_BLUE] = "blue",
> +	[IIO_MOD_LIGHT_UVA] = "uva",
> +	[IIO_MOD_LIGHT_UVB] = "uvb",
> +	[IIO_MOD_LIGHT_UVC] = "uvc",
>  	[IIO_MOD_QUATERNION] = "quaternion",
>  	[IIO_MOD_TEMP_AMBIENT] = "ambient",
>  	[IIO_MOD_TEMP_OBJECT] = "object",
> diff --git a/include/uapi/linux/iio/types.h b/include/uapi/linux/iio/types.h
> index 2f8b117..5c99090 100644
> --- a/include/uapi/linux/iio/types.h
> +++ b/include/uapi/linux/iio/types.h
> @@ -72,6 +72,9 @@ enum iio_modifier {
>  	IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z,
>  	IIO_MOD_I,
>  	IIO_MOD_Q,
> +	IIO_MOD_LIGHT_UVA,
> +	IIO_MOD_LIGHT_UVB,
> +	IIO_MOD_LIGHT_UVC,
>  };
>  
>  enum iio_event_type {
> diff --git a/tools/iio/iio_event_monitor.c b/tools/iio/iio_event_monitor.c
> index 427c271..46dd27f 100644
> --- a/tools/iio/iio_event_monitor.c
> +++ b/tools/iio/iio_event_monitor.c
> @@ -88,6 +88,9 @@ static const char * const iio_modifier_names[] = {
>  	[IIO_MOD_LIGHT_RED] = "red",
>  	[IIO_MOD_LIGHT_GREEN] = "green",
>  	[IIO_MOD_LIGHT_BLUE] = "blue",
> +	[IIO_MOD_LIGHT_UVA] = "uva",
> +	[IIO_MOD_LIGHT_UVB] = "uvb",
> +	[IIO_MOD_LIGHT_UVC] = "uvc",
>  	[IIO_MOD_QUATERNION] = "quaternion",
>  	[IIO_MOD_TEMP_AMBIENT] = "ambient",
>  	[IIO_MOD_TEMP_OBJECT] = "object",
> @@ -156,6 +159,9 @@ static bool event_is_known(struct iio_event_data *event)
>  	case IIO_MOD_LIGHT_RED:
>  	case IIO_MOD_LIGHT_GREEN:
>  	case IIO_MOD_LIGHT_BLUE:
> +	case IIO_MOD_LIGHT_UVA:
> +	case IIO_MOD_LIGHT_UVB:
> +	case IIO_MOD_LIGHT_UVC:
>  	case IIO_MOD_QUATERNION:
>  	case IIO_MOD_TEMP_AMBIENT:
>  	case IIO_MOD_TEMP_OBJECT:
> 

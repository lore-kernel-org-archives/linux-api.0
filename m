From: Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>
Subject: Re: [RFC PATCH] iio: Export userspace IIO headers
Date: Mon, 09 Feb 2015 18:05:01 +0100
Message-ID: <54D8E8BD.3090904@metafoo.de>
References: <1423500586-26480-1-git-send-email-daniel.baluta@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423500586-26480-1-git-send-email-daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-iio-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, knaack.h-Mmb7MZpHnFY@public.gmane.org, pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org
Cc: irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roberta.dobrescu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 02/09/2015 05:49 PM, Daniel Baluta wrote:
> After UAPI header file split [1] all user-kernel interfaces were
> placed under include/uapi/.
>
> This patch moves IIO user specific API from:
> 	* include/linux/iio/events.h => include/uapi/linux/iio/events.h
> 	* include/linux/iio/types.h => include/uapi/linux/iio/types.h
>
> Now there is no need for nasty tricks to compile userspace programs
> (e.g iio_event_monitor). Just installing the kernel headers with
> make headers_install command does the job.
>
> [1] http://lwn.net/Articles/507794/

Thanks for taking care of this, this is something that should have done a 
while ago.

[...]
> index 580ed5b..146cda1 100644
> --- a/include/linux/iio/types.h
> +++ b/include/linux/iio/types.h
> @@ -10,97 +10,5 @@
>   #ifndef _IIO_TYPES_H_
>   #define _IIO_TYPES_H_
>
> -enum iio_chan_type {
> -	IIO_VOLTAGE,
> -	IIO_CURRENT,
> -	IIO_POWER,
> -	IIO_ACCEL,
> -	IIO_ANGL_VEL,
> -	IIO_MAGN,
> -	IIO_LIGHT,
> -	IIO_INTENSITY,
> -	IIO_PROXIMITY,
> -	IIO_TEMP,
> -	IIO_INCLI,
> -	IIO_ROT,
> -	IIO_ANGL,
> -	IIO_TIMESTAMP,
> -	IIO_CAPACITANCE,
> -	IIO_ALTVOLTAGE,
> -	IIO_CCT,
> -	IIO_PRESSURE,
> -	IIO_HUMIDITYRELATIVE,
> -	IIO_ACTIVITY,
> -	IIO_STEPS,
> -	IIO_ENERGY,
> -	IIO_DISTANCE,
> -	IIO_VELOCITY,
> -};
> -
> -enum iio_modifier {
> -	IIO_NO_MOD,
> -	IIO_MOD_X,
> -	IIO_MOD_Y,
> -	IIO_MOD_Z,
> -	IIO_MOD_X_AND_Y,
> -	IIO_MOD_X_AND_Z,
> -	IIO_MOD_Y_AND_Z,
> -	IIO_MOD_X_AND_Y_AND_Z,
> -	IIO_MOD_X_OR_Y,
> -	IIO_MOD_X_OR_Z,
> -	IIO_MOD_Y_OR_Z,
> -	IIO_MOD_X_OR_Y_OR_Z,
> -	IIO_MOD_LIGHT_BOTH,
> -	IIO_MOD_LIGHT_IR,
> -	IIO_MOD_ROOT_SUM_SQUARED_X_Y,
> -	IIO_MOD_SUM_SQUARED_X_Y_Z,
> -	IIO_MOD_LIGHT_CLEAR,
> -	IIO_MOD_LIGHT_RED,
> -	IIO_MOD_LIGHT_GREEN,
> -	IIO_MOD_LIGHT_BLUE,
> -	IIO_MOD_QUATERNION,
> -	IIO_MOD_TEMP_AMBIENT,
> -	IIO_MOD_TEMP_OBJECT,
> -	IIO_MOD_NORTH_MAGN,
> -	IIO_MOD_NORTH_TRUE,
> -	IIO_MOD_NORTH_MAGN_TILT_COMP,
> -	IIO_MOD_NORTH_TRUE_TILT_COMP,
> -	IIO_MOD_RUNNING,
> -	IIO_MOD_JOGGING,
> -	IIO_MOD_WALKING,
> -	IIO_MOD_STILL,
> -	IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z,
> -};
> -
> -enum iio_event_type {
> -	IIO_EV_TYPE_THRESH,
> -	IIO_EV_TYPE_MAG,
> -	IIO_EV_TYPE_ROC,
> -	IIO_EV_TYPE_THRESH_ADAPTIVE,
> -	IIO_EV_TYPE_MAG_ADAPTIVE,
> -	IIO_EV_TYPE_CHANGE,
> -};

I think everything in this file below is not part of the ABI and should not 
be exported to userspace.

> -
> -enum iio_event_info {
> -	IIO_EV_INFO_ENABLE,
> -	IIO_EV_INFO_VALUE,
> -	IIO_EV_INFO_HYSTERESIS,
> -	IIO_EV_INFO_PERIOD,
> -};
> -
> -enum iio_event_direction {
> -	IIO_EV_DIR_EITHER,
> -	IIO_EV_DIR_RISING,
> -	IIO_EV_DIR_FALLING,
> -	IIO_EV_DIR_NONE,
> -};
> -
> -#define IIO_VAL_INT 1
> -#define IIO_VAL_INT_PLUS_MICRO 2
> -#define IIO_VAL_INT_PLUS_NANO 3
> -#define IIO_VAL_INT_PLUS_MICRO_DB 4
> -#define IIO_VAL_INT_MULTIPLE 5
> -#define IIO_VAL_FRACTIONAL 10
> -#define IIO_VAL_FRACTIONAL_LOG2 11
> -
[...]

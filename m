From: Jonathan Cameron <jic23-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] iio: Export userspace IIO headers
Date: Sat, 14 Feb 2015 11:53:08 +0000
Message-ID: <54DF3724.8030301@kernel.org>
References: <1423586031-25199-1-git-send-email-daniel.baluta@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1423586031-25199-1-git-send-email-daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, knaack.h-Mmb7MZpHnFY@public.gmane.org, lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org, pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org
Cc: irina.tirdea-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, roberta.dobrescu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 10/02/15 16:33, Daniel Baluta wrote:
> After UAPI header file split [1] all user-kernel interfaces were
> placed under include/uapi/.
> 
> This patch moves IIO user specific API from:
> 	* include/linux/iio/events.h => include/uapi/linux/iio/events.h
> 	* include/linux/types.h => include/uapi/linux/types.h
> 
> Now there is no need for nasty tricks to compile userspace programs
> (e.g iio_event_monitor). Just installing the kernel headers with
> make headers_install command does the job.
> 
> [1] http://lwn.net/Articles/507794/
> 
> Signed-off-by: Daniel Baluta <daniel.baluta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Looks good to me. A bonus blank line and EOF that I've removed.

Applied to the togreg branch of iio.git

Thanks,

Jonathan
> ---
> Changes since v1:
> 	* keep enum iio_event_info and IIO_VAL_* constants in
> 	include/linux/iio/types.h since they aren't part of the
> 	ABI.
> 
>  include/linux/iio/events.h      | 30 +-------------
>  include/linux/iio/types.h       | 78 +----------------------------------
>  include/uapi/linux/Kbuild       |  1 +
>  include/uapi/linux/iio/Kbuild   |  3 ++
>  include/uapi/linux/iio/events.h | 43 +++++++++++++++++++
>  include/uapi/linux/iio/types.h  | 91 +++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 140 insertions(+), 106 deletions(-)
>  create mode 100644 include/uapi/linux/iio/Kbuild
>  create mode 100644 include/uapi/linux/iio/events.h
>  create mode 100644 include/uapi/linux/iio/types.h
> 
> diff --git a/include/linux/iio/events.h b/include/linux/iio/events.h
> index 03fa332..8ad87d1 100644
> --- a/include/linux/iio/events.h
> +++ b/include/linux/iio/events.h
> @@ -9,22 +9,8 @@
>  #ifndef _IIO_EVENTS_H_
>  #define _IIO_EVENTS_H_
>  
> -#include <linux/ioctl.h>
> -#include <linux/types.h>
>  #include <linux/iio/types.h>
> -
> -/**
> - * struct iio_event_data - The actual event being pushed to userspace
> - * @id:		event identifier
> - * @timestamp:	best estimate of time of event occurrence (often from
> - *		the interrupt handler)
> - */
> -struct iio_event_data {
> -	__u64	id;
> -	__s64	timestamp;
> -};
> -
> -#define IIO_GET_EVENT_FD_IOCTL _IOR('i', 0x90, int)
> +#include <uapi/linux/iio/events.h>
>  
>  /**
>   * IIO_EVENT_CODE() - create event identifier
> @@ -70,18 +56,4 @@ struct iio_event_data {
>  #define IIO_UNMOD_EVENT_CODE(chan_type, number, type, direction)	\
>  	IIO_EVENT_CODE(chan_type, 0, 0, direction, type, number, 0, 0)
>  
> -#define IIO_EVENT_CODE_EXTRACT_TYPE(mask) ((mask >> 56) & 0xFF)
> -
> -#define IIO_EVENT_CODE_EXTRACT_DIR(mask) ((mask >> 48) & 0x7F)
> -
> -#define IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(mask) ((mask >> 32) & 0xFF)
> -
> -/* Event code number extraction depends on which type of event we have.
> - * Perhaps review this function in the future*/
> -#define IIO_EVENT_CODE_EXTRACT_CHAN(mask) ((__s16)(mask & 0xFFFF))
> -#define IIO_EVENT_CODE_EXTRACT_CHAN2(mask) ((__s16)(((mask) >> 16) & 0xFFFF))
> -
> -#define IIO_EVENT_CODE_EXTRACT_MODIFIER(mask) ((mask >> 40) & 0xFF)
> -#define IIO_EVENT_CODE_EXTRACT_DIFF(mask) (((mask) >> 55) & 0x1)
> -
>  #endif
> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> index 580ed5b..942b6de 100644
> --- a/include/linux/iio/types.h
> +++ b/include/linux/iio/types.h
> @@ -10,76 +10,7 @@
>  #ifndef _IIO_TYPES_H_
>  #define _IIO_TYPES_H_
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
> +#include <uapi/linux/iio/types.h>
>  
>  enum iio_event_info {
>  	IIO_EV_INFO_ENABLE,
> @@ -88,13 +19,6 @@ enum iio_event_info {
>  	IIO_EV_INFO_PERIOD,
>  };
>  
> -enum iio_event_direction {
> -	IIO_EV_DIR_EITHER,
> -	IIO_EV_DIR_RISING,
> -	IIO_EV_DIR_FALLING,
> -	IIO_EV_DIR_NONE,
> -};
> -
>  #define IIO_VAL_INT 1
>  #define IIO_VAL_INT_PLUS_MICRO 2
>  #define IIO_VAL_INT_PLUS_NANO 3
> diff --git a/include/uapi/linux/Kbuild b/include/uapi/linux/Kbuild
> index 00b10002..5bfc5bd 100644
> --- a/include/uapi/linux/Kbuild
> +++ b/include/uapi/linux/Kbuild
> @@ -6,6 +6,7 @@ header-y += caif/
>  header-y += dvb/
>  header-y += hdlc/
>  header-y += hsi/
> +header-y += iio/
>  header-y += isdn/
>  header-y += mmc/
>  header-y += nfsd/
> diff --git a/include/uapi/linux/iio/Kbuild b/include/uapi/linux/iio/Kbuild
> new file mode 100644
> index 0000000..86f76d8
> --- /dev/null
> +++ b/include/uapi/linux/iio/Kbuild
> @@ -0,0 +1,3 @@
> +# UAPI Header export list
> +header-y += events.h
> +header-y += types.h
> diff --git a/include/uapi/linux/iio/events.h b/include/uapi/linux/iio/events.h
> new file mode 100644
> index 0000000..4b06477
> --- /dev/null
> +++ b/include/uapi/linux/iio/events.h
> @@ -0,0 +1,43 @@
> +/* The industrial I/O - event passing to userspace
> + *
> + * Copyright (c) 2008-2011 Jonathan Cameron
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +#ifndef _UAPI_IIO_EVENTS_H_
> +#define _UAPI_IIO_EVENTS_H_
> +
> +#include <linux/ioctl.h>
> +#include <linux/types.h>
> +
> +/**
> + * struct iio_event_data - The actual event being pushed to userspace
> + * @id:		event identifier
> + * @timestamp:	best estimate of time of event occurrence (often from
> + *		the interrupt handler)
> + */
> +struct iio_event_data {
> +	__u64	id;
> +	__s64	timestamp;
> +};
> +
> +#define IIO_GET_EVENT_FD_IOCTL _IOR('i', 0x90, int)
> +
> +#define IIO_EVENT_CODE_EXTRACT_TYPE(mask) ((mask >> 56) & 0xFF)
> +
> +#define IIO_EVENT_CODE_EXTRACT_DIR(mask) ((mask >> 48) & 0x7F)
> +
> +#define IIO_EVENT_CODE_EXTRACT_CHAN_TYPE(mask) ((mask >> 32) & 0xFF)
> +
> +/* Event code number extraction depends on which type of event we have.
> + * Perhaps review this function in the future*/
> +#define IIO_EVENT_CODE_EXTRACT_CHAN(mask) ((__s16)(mask & 0xFFFF))
> +#define IIO_EVENT_CODE_EXTRACT_CHAN2(mask) ((__s16)(((mask) >> 16) & 0xFFFF))
> +
> +#define IIO_EVENT_CODE_EXTRACT_MODIFIER(mask) ((mask >> 40) & 0xFF)
> +#define IIO_EVENT_CODE_EXTRACT_DIFF(mask) (((mask) >> 55) & 0x1)
> +
> +#endif /* _UAPI_IIO_EVENTS_H_ */
> +
> diff --git a/include/uapi/linux/iio/types.h b/include/uapi/linux/iio/types.h
> new file mode 100644
> index 0000000..56a1529
> --- /dev/null
> +++ b/include/uapi/linux/iio/types.h
> @@ -0,0 +1,91 @@
> +/* industrial I/O data types needed both in and out of kernel
> + *
> + * Copyright (c) 2008 Jonathan Cameron
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms of the GNU General Public License version 2 as published by
> + * the Free Software Foundation.
> + */
> +
> +#ifndef _UAPI_IIO_TYPES_H_
> +#define _UAPI_IIO_TYPES_H_
> +
> +enum iio_chan_type {
> +	IIO_VOLTAGE,
> +	IIO_CURRENT,
> +	IIO_POWER,
> +	IIO_ACCEL,
> +	IIO_ANGL_VEL,
> +	IIO_MAGN,
> +	IIO_LIGHT,
> +	IIO_INTENSITY,
> +	IIO_PROXIMITY,
> +	IIO_TEMP,
> +	IIO_INCLI,
> +	IIO_ROT,
> +	IIO_ANGL,
> +	IIO_TIMESTAMP,
> +	IIO_CAPACITANCE,
> +	IIO_ALTVOLTAGE,
> +	IIO_CCT,
> +	IIO_PRESSURE,
> +	IIO_HUMIDITYRELATIVE,
> +	IIO_ACTIVITY,
> +	IIO_STEPS,
> +	IIO_ENERGY,
> +	IIO_DISTANCE,
> +	IIO_VELOCITY,
> +};
> +
> +enum iio_modifier {
> +	IIO_NO_MOD,
> +	IIO_MOD_X,
> +	IIO_MOD_Y,
> +	IIO_MOD_Z,
> +	IIO_MOD_X_AND_Y,
> +	IIO_MOD_X_AND_Z,
> +	IIO_MOD_Y_AND_Z,
> +	IIO_MOD_X_AND_Y_AND_Z,
> +	IIO_MOD_X_OR_Y,
> +	IIO_MOD_X_OR_Z,
> +	IIO_MOD_Y_OR_Z,
> +	IIO_MOD_X_OR_Y_OR_Z,
> +	IIO_MOD_LIGHT_BOTH,
> +	IIO_MOD_LIGHT_IR,
> +	IIO_MOD_ROOT_SUM_SQUARED_X_Y,
> +	IIO_MOD_SUM_SQUARED_X_Y_Z,
> +	IIO_MOD_LIGHT_CLEAR,
> +	IIO_MOD_LIGHT_RED,
> +	IIO_MOD_LIGHT_GREEN,
> +	IIO_MOD_LIGHT_BLUE,
> +	IIO_MOD_QUATERNION,
> +	IIO_MOD_TEMP_AMBIENT,
> +	IIO_MOD_TEMP_OBJECT,
> +	IIO_MOD_NORTH_MAGN,
> +	IIO_MOD_NORTH_TRUE,
> +	IIO_MOD_NORTH_MAGN_TILT_COMP,
> +	IIO_MOD_NORTH_TRUE_TILT_COMP,
> +	IIO_MOD_RUNNING,
> +	IIO_MOD_JOGGING,
> +	IIO_MOD_WALKING,
> +	IIO_MOD_STILL,
> +	IIO_MOD_ROOT_SUM_SQUARED_X_Y_Z,
> +};
> +
> +enum iio_event_type {
> +	IIO_EV_TYPE_THRESH,
> +	IIO_EV_TYPE_MAG,
> +	IIO_EV_TYPE_ROC,
> +	IIO_EV_TYPE_THRESH_ADAPTIVE,
> +	IIO_EV_TYPE_MAG_ADAPTIVE,
> +	IIO_EV_TYPE_CHANGE,
> +};
> +
> +enum iio_event_direction {
> +	IIO_EV_DIR_EITHER,
> +	IIO_EV_DIR_RISING,
> +	IIO_EV_DIR_FALLING,
> +	IIO_EV_DIR_NONE,
> +};
> +
> +#endif /* _UAPI_IIO_TYPES_H_ */
> 

From: Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>
Subject: Re: [PATCHv2 1/9] media: Fix DVB representation at media controller API
Date: Sun, 11 Jan 2015 15:50:04 +0200
Message-ID: <2274549.Xm2J2SkQ3y@avalon>
References: <cover.1420294938.git.mchehab@osg.samsung.com> <ea1dd8e443b34e2047468866ec423d4334f54eba.1420294938.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ea1dd8e443b34e2047468866ec423d4334f54eba.1420294938.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Cc: Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Mauro,

Thank you for the patch.

On Saturday 03 January 2015 12:49:03 Mauro Carvalho Chehab wrote:
> The DVB devices are identified via a (major, minor) tuple,
> and not by a random id. Fix it, before we start using it.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index e00459185d20..de333cc8261b 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -97,7 +97,10 @@ struct media_entity {
>  			u32 device;
>  			u32 subdevice;
>  		} alsa;
> -		int dvb;
> +		struct {
> +			u32 major;
> +			u32 minor;
> +		} dvb;
> 
>  		/* Sub-device specifications */
>  		/* Nothing needed yet */
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index d847c760e8f0..7902e800f019 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -27,7 +27,7 @@
>  #include <linux/types.h>
>  #include <linux/version.h>
> 
> -#define MEDIA_API_VERSION	KERNEL_VERSION(0, 1, 0)
> +#define MEDIA_API_VERSION	KERNEL_VERSION(0, 1, 1)
> 
>  struct media_device_info {
>  	char driver[16];
> @@ -88,7 +88,10 @@ struct media_entity_desc {
>  			__u32 device;
>  			__u32 subdevice;
>  		} alsa;
> -		int dvb;
> +		struct {
> +			__u32 major;
> +			__u32 minor;
> +		} dvb;

Won't this break compilation of existing userspace code ? As DVB is not 
properly supported in MC at the moment we could consider that only mediactl 
will be affected, so it shouldn't be a big issue.

> 
>  		/* Sub-device specifications */
>  		/* Nothing needed yet */

-- 
Regards,

Laurent Pinchart

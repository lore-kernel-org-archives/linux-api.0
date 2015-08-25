From: Hans Verkuil <hverkuil@xs4all.nl>
Subject: Re: [PATCH v7 13/44] [media] uapi/media.h: Declare interface types
Date: Tue, 25 Aug 2015 08:46:29 +0200
Message-ID: <55DC0F45.7010108@xs4all.nl>
References: <cover.1440359643.git.mchehab@osg.samsung.com> <55df3b23389e68b19354011babf0da1d26d0a91a.1440359643.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-media-owner@vger.kernel.org>
In-Reply-To: <55df3b23389e68b19354011babf0da1d26d0a91a.1440359643.git.mchehab@osg.samsung.com>
Sender: linux-media-owner@vger.kernel.org
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>, Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On 08/23/2015 10:17 PM, Mauro Carvalho Chehab wrote:
> Declare the interface types that will be used by the new
> G_TOPOLOGY ioctl that will be defined latter on.
> 
> For now, we need those types, as they'll be used on the
> internal structs associated with the new media_interface
> graph object defined on the next patch.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 4e816be3de39..21c96cd7a6ae 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -167,6 +167,35 @@ struct media_links_enum {
>  	__u32 reserved[4];
>  };
>  
> +/* Interface type ranges */
> +
> +#define MEDIA_INTF_T_DVB_BASE	0x00000000
> +#define MEDIA_INTF_T_V4L_BASE	0x00000100
> +#define MEDIA_INTF_T_ALSA_BASE	0x00000200

I would avoid BASE 0 and start with 0x100 for DVB (so ALSA gets 0x300).

This ensures that type is never 0 which is often useful since it catches
cases where userspace just memsets to 0 and never fills in the type. Or
it can be used in the future as an ERROR or UNKNOWN type or something.

Since there is nothing that requires type to be 0 I would avoid it
altogether.

After making this small change:

Acked-by: Hans Verkuil <hans.verkuil@cisco.com>

Regards,

	Hans

> +
> +/* Interface types */
> +
> +#define MEDIA_INTF_T_DVB_FE    	(MEDIA_INTF_T_DVB_BASE)
> +#define MEDIA_INTF_T_DVB_DEMUX  (MEDIA_INTF_T_DVB_BASE + 1)
> +#define MEDIA_INTF_T_DVB_DVR    (MEDIA_INTF_T_DVB_BASE + 2)
> +#define MEDIA_INTF_T_DVB_CA     (MEDIA_INTF_T_DVB_BASE + 3)
> +#define MEDIA_INTF_T_DVB_NET    (MEDIA_INTF_T_DVB_BASE + 4)
> +
> +#define MEDIA_INTF_T_V4L_VIDEO  (MEDIA_INTF_T_V4L_BASE)
> +#define MEDIA_INTF_T_V4L_VBI    (MEDIA_INTF_T_V4L_BASE + 1)
> +#define MEDIA_INTF_T_V4L_RADIO  (MEDIA_INTF_T_V4L_BASE + 2)
> +#define MEDIA_INTF_T_V4L_SUBDEV (MEDIA_INTF_T_V4L_BASE + 3)
> +#define MEDIA_INTF_T_V4L_SWRADIO (MEDIA_INTF_T_V4L_BASE + 4)
> +
> +#define MEDIA_INTF_T_ALSA_PCM_CAPTURE   (MEDIA_INTF_T_ALSA_BASE)
> +#define MEDIA_INTF_T_ALSA_PCM_PLAYBACK  (MEDIA_INTF_T_ALSA_BASE + 1)
> +#define MEDIA_INTF_T_ALSA_CONTROL       (MEDIA_INTF_T_ALSA_BASE + 2)
> +#define MEDIA_INTF_T_ALSA_COMPRESS      (MEDIA_INTF_T_ALSA_BASE + 3)
> +#define MEDIA_INTF_T_ALSA_RAWMIDI       (MEDIA_INTF_T_ALSA_BASE + 4)
> +#define MEDIA_INTF_T_ALSA_HWDEP         (MEDIA_INTF_T_ALSA_BASE + 5)
> +
> +/* TBD: declare the structs needed for the new G_TOPOLOGY ioctl */
> +
>  #define MEDIA_IOC_DEVICE_INFO		_IOWR('|', 0x00, struct media_device_info)
>  #define MEDIA_IOC_ENUM_ENTITIES		_IOWR('|', 0x01, struct media_entity_desc)
>  #define MEDIA_IOC_ENUM_LINKS		_IOWR('|', 0x02, struct media_links_enum)
> 

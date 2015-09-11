From: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH 06/18] [media] media.h: create connector entities for
 hybrid TV devices
Date: Fri, 11 Sep 2015 17:19:13 +0200
Message-ID: <55F2F0F1.2070804@xs4all.nl>
References: <cover.1441559233.git.mchehab@osg.samsung.com> <9af2bbe9e63004f843e8478bc3d31cd03ea75d64.1441559233.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9af2bbe9e63004f843e8478bc3d31cd03ea75d64.1441559233.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 09/06/2015 07:30 PM, Mauro Carvalho Chehab wrote:
> Add entities to represent the connectors that exists inside a
> hybrid TV device.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> 
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index b17f6763aff4..69433405aec2 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -61,6 +61,7 @@ struct media_device_info {
>  #define MEDIA_ENT_T_DVB_BASE		0x00000000
>  #define MEDIA_ENT_T_V4L2_BASE		0x00010000
>  #define MEDIA_ENT_T_V4L2_SUBDEV_BASE	0x00020000
> +#define MEDIA_ENT_T_CONNECTOR_BASE	0x00030000
>  
>  /*
>   * V4L2 entities - Those are used for DMA (mmap/DMABUF) and
> @@ -105,6 +106,13 @@ struct media_device_info {
>  #define MEDIA_ENT_T_DVB_CA		(MEDIA_ENT_T_DVB_BASE + 4)
>  #define MEDIA_ENT_T_DVB_NET_DECAP	(MEDIA_ENT_T_DVB_BASE + 5)
>  
> +/* Connectors */
> +#define MEDIA_ENT_T_CONN_RF		(MEDIA_ENT_T_CONNECTOR_BASE)

Please start at BASE + 1.

With that change:

Acked-by: Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

> +#define MEDIA_ENT_T_CONN_SVIDEO		(MEDIA_ENT_T_CONNECTOR_BASE + 1)
> +#define MEDIA_ENT_T_CONN_COMPOSITE	(MEDIA_ENT_T_CONNECTOR_BASE + 2)
> +	/* For internal test signal generators and other debug connectors */
> +#define MEDIA_ENT_T_CONN_TEST		(MEDIA_ENT_T_CONNECTOR_BASE + 3)
> +
>  #ifndef __KERNEL__
>  /* Legacy symbols used to avoid userspace compilation breakages */
>  #define MEDIA_ENT_TYPE_SHIFT		16
> @@ -121,9 +129,9 @@ struct media_device_info {
>  #define MEDIA_ENT_T_DEVNODE_DVB		(MEDIA_ENT_T_DEVNODE + 4)
>  #endif
>  
> -/* Entity types */
> -
> +/* Entity flags */
>  #define MEDIA_ENT_FL_DEFAULT		(1 << 0)
> +#define MEDIA_ENT_FL_CONNECTOR		(1 << 1)
>  
>  struct media_entity_desc {
>  	__u32 id;
> 

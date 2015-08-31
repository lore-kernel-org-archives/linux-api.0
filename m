From: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH v8 38/55] [media] v4l2-subdev: use MEDIA_ENT_T_UNKNOWN
 for new subdevs
Date: Mon, 31 Aug 2015 13:43:16 +0200
Message-ID: <55E43DD4.1010303@xs4all.nl>
References: <cover.1440902901.git.mchehab@osg.samsung.com> <662a3bb2bfb02f820f4dafa0033af2cf16d273c5.1440902901.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <662a3bb2bfb02f820f4dafa0033af2cf16d273c5.1440902901.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Laurent Pinchart <laurent.pinchart-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, Sylwester Nawrocki <s.nawrocki-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>, Prabhakar Lad <prabhakar.csengg-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> Instead of abusing MEDIA_ENT_T_V4L2_SUBDEV, initialize
> new subdev entities as MEDIA_ENT_T_UNKNOWN.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

Acked-by: Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

> 
> diff --git a/drivers/media/media-device.c b/drivers/media/media-device.c
> index 659507bce63f..134fe7510195 100644
> --- a/drivers/media/media-device.c
> +++ b/drivers/media/media-device.c
> @@ -435,6 +435,12 @@ int __must_check media_device_register_entity(struct media_device *mdev,
>  {
>  	int i;
>  
> +	if (entity->type == MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN ||
> +	    entity->type == MEDIA_ENT_T_UNKNOWN)
> +		dev_warn(mdev->dev,
> +			 "Entity type for entity %s was not initialized!\n",
> +			 entity->name);
> +
>  	/* Warn if we apparently re-register an entity */
>  	WARN_ON(entity->graph_obj.mdev != NULL);
>  	entity->graph_obj.mdev = mdev;
> diff --git a/drivers/media/v4l2-core/v4l2-subdev.c b/drivers/media/v4l2-core/v4l2-subdev.c
> index 60da43772de9..b3bcc8253182 100644
> --- a/drivers/media/v4l2-core/v4l2-subdev.c
> +++ b/drivers/media/v4l2-core/v4l2-subdev.c
> @@ -584,7 +584,7 @@ void v4l2_subdev_init(struct v4l2_subdev *sd, const struct v4l2_subdev_ops *ops)
>  	sd->host_priv = NULL;
>  #if defined(CONFIG_MEDIA_CONTROLLER)
>  	sd->entity.name = sd->name;
> -	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV;
> +	sd->entity.type = MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN;
>  #endif
>  }
>  EXPORT_SYMBOL(v4l2_subdev_init);
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 3bbda409353f..44b84aae8b02 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -42,6 +42,14 @@ struct media_device_info {
>  
>  #define MEDIA_ENT_ID_FLAG_NEXT		(1 << 31)
>  
> +/* Used values for media_entity_desc::type */
> +
> +/*
> + * Initial value when an entity is created
> + * Drivers should change it to something useful
> + */
> +#define MEDIA_ENT_T_UNKNOWN	0x00000000
> +
>  /*
>   * Base numbers for entity types
>   *
> @@ -77,6 +85,15 @@ struct media_device_info {
>  #define MEDIA_ENT_T_V4L2_SWRADIO	(MEDIA_ENT_T_V4L2_BASE + 7)
>  
>  /* V4L2 Sub-device entities */
> +
> +	/*
> +	 * Subdevs are initialized with MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN,
> +	 * in order to preserve backward compatibility.
> +	 * Drivers should change to the proper subdev type before
> +	 * registering the entity.
> +	 */
> +#define MEDIA_ENT_T_V4L2_SUBDEV_UNKNOWN	MEDIA_ENT_T_V4L2_SUBDEV_BASE
> +
>  #define MEDIA_ENT_T_V4L2_SUBDEV_SENSOR	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 1)
>  #define MEDIA_ENT_T_V4L2_SUBDEV_FLASH	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 2)
>  #define MEDIA_ENT_T_V4L2_SUBDEV_LENS	(MEDIA_ENT_T_V4L2_SUBDEV_BASE + 3)
> 

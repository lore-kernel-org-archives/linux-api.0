From: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH v8 39/55] [media] media controller: get rid of entity
 subtype on Kernel
Date: Mon, 31 Aug 2015 13:44:07 +0200
Message-ID: <55E43E07.6010909@xs4all.nl>
References: <cover.1440902901.git.mchehab@osg.samsung.com> <8154aa42b993840dfde2d794e7e9e1f0c57c1e82.1440902901.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <8154aa42b993840dfde2d794e7e9e1f0c57c1e82.1440902901.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Mauro Carvalho Chehab <mchehab-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 08/30/2015 05:06 AM, Mauro Carvalho Chehab wrote:
> Don't use anymore the type/subtype entity data/macros
> inside the Kernel.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index b0cfbc0dffc7..756e1960fd7f 100644
> --- a/include/media/media-entity.h
> +++ b/include/media/media-entity.h
> @@ -185,16 +185,6 @@ struct media_intf_devnode {
>  	u32				minor;
>  };
>  
> -static inline u32 media_entity_type(struct media_entity *entity)
> -{
> -	return entity->type & MEDIA_ENT_TYPE_MASK;
> -}
> -
> -static inline u32 media_entity_subtype(struct media_entity *entity)
> -{
> -	return entity->type & MEDIA_ENT_SUBTYPE_MASK;
> -}
> -
>  static inline u32 media_entity_id(struct media_entity *entity)
>  {
>  	return entity->graph_obj.id;
> diff --git a/include/uapi/linux/media.h b/include/uapi/linux/media.h
> index 44b84aae8b02..cd486fc25f1e 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -42,10 +42,8 @@ struct media_device_info {
>  
>  #define MEDIA_ENT_ID_FLAG_NEXT		(1 << 31)
>  
> -/* Used values for media_entity_desc::type */
> -
>  /*
> - * Initial value when an entity is created
> + * Initial value to be used when a new entity is created

This change should be moved to patch 38.

>   * Drivers should change it to something useful
>   */
>  #define MEDIA_ENT_T_UNKNOWN	0x00000000
> 

Regards,

	Hans

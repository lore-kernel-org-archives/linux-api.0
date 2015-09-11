From: Hans Verkuil <hverkuil-qWit8jRvyhVmR6Xm/wNWPw@public.gmane.org>
Subject: Re: [PATCH v8 39/55] [media] media controller: get rid of entity
 subtype on Kernel
Date: Fri, 11 Sep 2015 15:08:13 +0200
Message-ID: <55F2D23D.6030900@xs4all.nl>
References: <ec40936d7349f390dd8b73b90fa0e0708de596a9.1441540862.git.mchehab@osg.samsung.com> <728826957177ee11793b6b28b4e61e94b2d3068c.1441540862.git.mchehab@osg.samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <728826957177ee11793b6b28b4e61e94b2d3068c.1441540862.git.mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>, Linux Media Mailing List <linux-media-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 09/06/2015 02:02 PM, Mauro Carvalho Chehab wrote:
> Don't use anymore the type/subtype entity data/macros
> inside the Kernel.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab-JPH+aEBZ4P+UEJcrhfAQsw@public.gmane.org>

Acked-by: Hans Verkuil <hans.verkuil-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>

> 
> diff --git a/include/media/media-entity.h b/include/media/media-entity.h
> index 220864319d21..7320cdc45833 100644
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
> index 3d6210095336..f90147cb9b57 100644
> --- a/include/uapi/linux/media.h
> +++ b/include/uapi/linux/media.h
> @@ -42,8 +42,6 @@ struct media_device_info {
>  
>  #define MEDIA_ENT_ID_FLAG_NEXT		(1 << 31)
>  
> -/* Used values for media_entity_desc::type */
> -
>  /*
>   * Initial value to be used when a new entity is created
>   * Drivers should change it to something useful
> 

From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [PATCH v4 11/79] savage_drm.h: include <drm/drm.h>
Date: Thu, 15 Oct 2015 08:44:05 +0200
Message-ID: <20151015064405.GQ26718@phenom.ffwll.local>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-12-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444888618-4506-12-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 15, 2015 at 07:55:49AM +0200, Mikko Rapeli wrote:
> Fixes compiler error:
> 
> drm/savage_drm.h:50:24: error: array type has incomplete element type
>   struct drm_tex_region texList[SAVAGE_NR_TEX_HEAPS][SAVAGE_NR_TEX_REGIONS +
> 
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>

Queued for -next, thanks for the patch.
-Daniel

> ---
>  include/uapi/drm/savage_drm.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/uapi/drm/savage_drm.h b/include/uapi/drm/savage_drm.h
> index 818d49b..9dc9dc1 100644
> --- a/include/uapi/drm/savage_drm.h
> +++ b/include/uapi/drm/savage_drm.h
> @@ -26,6 +26,8 @@
>  #ifndef __SAVAGE_DRM_H__
>  #define __SAVAGE_DRM_H__
>  
> +#include <drm/drm.h>
> +
>  #ifndef __SAVAGE_SAREA_DEFINES__
>  #define __SAVAGE_SAREA_DEFINES__
>  
> -- 
> 2.5.0
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

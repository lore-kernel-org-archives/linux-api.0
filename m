From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [PATCH v4 13/79] drm/i810_drm.h: include drm/drm.h
Date: Thu, 15 Oct 2015 09:44:17 +0200
Message-ID: <20151015074417.GT26718@phenom.ffwll.local>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
 <1444888618-4506-14-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444888618-4506-14-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 15, 2015 at 07:55:51AM +0200, Mikko Rapeli wrote:
> Fixes userspace compilation error:
> 
> error: array type has incomplete element type
> struct drm_clip_rect boxes[I810_NR_SAREA_CLIPRECTS];
> 
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>

Applied to drm-misc, thanks.
-Daniel

> ---
>  include/uapi/drm/i810_drm.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/uapi/drm/i810_drm.h b/include/uapi/drm/i810_drm.h
> index 7a10bb6..34736ef 100644
> --- a/include/uapi/drm/i810_drm.h
> +++ b/include/uapi/drm/i810_drm.h
> @@ -1,6 +1,8 @@
>  #ifndef _I810_DRM_H_
>  #define _I810_DRM_H_
>  
> +#include <drm/drm.h>
> +
>  /* WARNING: These defines must be the same as what the Xserver uses.
>   * if you change them, you must change the defines in the Xserver.
>   */
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

From: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 10/98] via_drm.h: hide struct via_file_private in userspace
Date: Wed, 3 Jun 2015 17:50:22 +0100
Message-ID: <CACvgo52HDRuaQ+1qXg6O9ikhwNFSRCgopv6aAbujywOG+msmYQ@mail.gmail.com>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
	<1433000370-19509-11-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433000370-19509-11-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ML dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

Hi Mikko,

On 30 May 2015 at 16:38, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wrote:
> Fixes compiler error since list_head is not exported to userspace headers.
>
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> ---
>  include/uapi/drm/via_drm.h | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/include/uapi/drm/via_drm.h b/include/uapi/drm/via_drm.h
> index 791531e..34ce658 100644
> --- a/include/uapi/drm/via_drm.h
> +++ b/include/uapi/drm/via_drm.h
> @@ -272,8 +272,10 @@ typedef struct drm_via_dmablit {
>         drm_via_blitsync_t sync;
>  } drm_via_dmablit_t;
>
> +#ifdef __KERNEL__
>  struct via_file_private {
>         struct list_head obj_list;
>  };
> +#endif
>
We might want to follow the example of other drivers (i915) and move
it to drivers/gpu/drm/via_drv.h, There are two users of this struct
(via_drv.c and via_mm.c), and each one explicitly includes the header.
How does that sound ?

Same suggestion goes for the equivalent sis patch.

Cheers
Emil

From: Alex Deucher <alexdeucher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 04/79] drm_mode.h: use __u32 and __u64 from linux/types.h
Date: Thu, 15 Oct 2015 09:32:10 -0400
Message-ID: <CADnq5_N5LK4Dy1okY7G6jPNB68PN2ijpwv=bt2bBC0FPGASoSQ@mail.gmail.com>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
	<1444888618-4506-5-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444888618-4506-5-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Maling list - DRI developers <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Oct 15, 2015 at 1:55 AM, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wro=
te:
> Fixes userspace compilation error:
>
> drm/drm_mode.h:472:2: error: unknown type name =E2=80=98uint32_t=E2=80=
=99
>
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>

NACK on all these type conversions.  This has not been a problem for
years and years and the result looks terrible.

Alex

> ---
>  include/uapi/drm/drm_mode.h | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.=
h
> index 359107a..0ed8d9d 100644
> --- a/include/uapi/drm/drm_mode.h
> +++ b/include/uapi/drm/drm_mode.h
> @@ -508,14 +508,14 @@ struct drm_mode_crtc_page_flip {
>
>  /* create a dumb scanout buffer */
>  struct drm_mode_create_dumb {
> -       uint32_t height;
> -       uint32_t width;
> -       uint32_t bpp;
> -       uint32_t flags;
> +       __u32 height;
> +       __u32 width;
> +       __u32 bpp;
> +       __u32 flags;
>         /* handle, pitch, size will be returned */
> -       uint32_t handle;
> -       uint32_t pitch;
> -       uint64_t size;
> +       __u32 handle;
> +       __u32 pitch;
> +       __u64 size;
>  };
>
>  /* set up for mmap of a dumb scanout buffer */
> @@ -532,7 +532,7 @@ struct drm_mode_map_dumb {
>  };
>
>  struct drm_mode_destroy_dumb {
> -       uint32_t handle;
> +       __u32 handle;
>  };
>
>  /* page-flip flags are valid, plus: */
> --
> 2.5.0
>
> _______________________________________________
> dri-devel mailing list
> dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

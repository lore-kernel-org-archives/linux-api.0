From: Frans Klaver <fransklaver-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 04/98] drm_mode.h: use __u32 and __u64 from linux/types.h
Date: Sat, 30 May 2015 21:58:14 +0200
Message-ID: <20150530195814.GB15645@bugger.home>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-5-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433000370-19509-5-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, May 30, 2015 at 05:37:56PM +0200, Mikko Rapeli wrote:
> Fixes userspace compilation error:
>=20
> drm/drm_mode.h:472:2: error: unknown type name =E2=80=98uint32_t=E2=80=
=99

It's even more or less required by the coding style. Chapter 5
(typedefs) says:

 (e) Types safe for use in userspace.

     In certain structures which are visible to userspace, we cannot
     require C99 types and cannot use the 'u32' form above. Thus, we
     use __u32 and similar types in all structures which are shared
     with userspace.

So this is probably an improvement in any case.

Thanks,
=46rans

>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> ---
>  include/uapi/drm/drm_mode.h | 16 ++++++++--------
>  1 file changed, 8 insertions(+), 8 deletions(-)
>=20
> diff --git a/include/uapi/drm/drm_mode.h b/include/uapi/drm/drm_mode.=
h
> index dbeba94..03e4d75 100644
> --- a/include/uapi/drm/drm_mode.h
> +++ b/include/uapi/drm/drm_mode.h
> @@ -508,14 +508,14 @@ struct drm_mode_crtc_page_flip {
> =20
>  /* create a dumb scanout buffer */
>  struct drm_mode_create_dumb {
> -	uint32_t height;
> -	uint32_t width;
> -	uint32_t bpp;
> -	uint32_t flags;
> +	__u32 height;
> +	__u32 width;
> +	__u32 bpp;
> +	__u32 flags;
>  	/* handle, pitch, size will be returned */
> -	uint32_t handle;
> -	uint32_t pitch;
> -	uint64_t size;
> +	__u32 handle;
> +	__u32 pitch;
> +	__u64 size;
>  };
> =20
>  /* set up for mmap of a dumb scanout buffer */
> @@ -532,7 +532,7 @@ struct drm_mode_map_dumb {
>  };
> =20
>  struct drm_mode_destroy_dumb {
> -	uint32_t handle;
> +	__u32 handle;
>  };
> =20
>  /* page-flip flags are valid, plus: */
> --=20
> 2.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kerne=
l" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

From: Alex Deucher <alexdeucher-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 02/20] drm: Kbuild: add admgpu_drm.h to the installed headers
Date: Mon, 30 Nov 2015 18:57:40 -0500
Message-ID: <CADnq5_PYBaeZ+u2Vi-PX6efhAm1mphUnXJt+dnmQ8i-DPe1m8w@mail.gmail.com>
References: <1448892658-14256-1-git-send-email-gabriel@lse.epita.fr>
	<1448892658-14256-3-git-send-email-gabriel@lse.epita.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1448892658-14256-3-git-send-email-gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
Cc: David Airlie <airlied-cv59FeDIM0c@public.gmane.org>, "open list:DRM DRIVERS" <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 30, 2015 at 9:10 AM, Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org> wrote:
> Signed-off-by: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
> CC: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>

Acked-by: Alex Deucher <alexander.deucher-5C7GfCeVMHo@public.gmane.org>

>
> ---
>  include/uapi/drm/Kbuild | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/uapi/drm/Kbuild b/include/uapi/drm/Kbuild
> index 38d4370..159551f 100644
> --- a/include/uapi/drm/Kbuild
> +++ b/include/uapi/drm/Kbuild
> @@ -3,6 +3,7 @@ header-y += drm.h
>  header-y += drm_fourcc.h
>  header-y += drm_mode.h
>  header-y += drm_sarea.h
> +header-y += amdgpu_drm.h
>  header-y += exynos_drm.h
>  header-y += i810_drm.h
>  header-y += i915_drm.h
> --
> 2.6.2
>
> _______________________________________________
> dri-devel mailing list
> dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel

From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [PATCH v06 32/36] uapi drm/armada_drm.h: use __u32 and __u64
 instead of uint32_t and uint64_t
Date: Mon, 7 Aug 2017 11:47:34 +0200
Message-ID: <20170807094734.fenpw2eohku3djv7@phenom.ffwll.local>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-33-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170806164428.2273-33-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Russell King <linux-I+IVW8TIWO2tmTQ+vhA3Yw@public.gmane.org>, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Aug 06, 2017 at 06:44:23PM +0200, Mikko Rapeli wrote:
> These are defined in linux/types.h or drm/drm.h. Fixes
> user space compilation errors like:
> 
> drm/armada_drm.h:26:2: error: unknown type name ‘uint32_t’
>   uint32_t handle;
>   ^~~~~~~~
> 
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> Cc: Emil Velikov <emil.l.velikov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Cc: Gabriel Laskar <gabriel-tU7rkvAWjlwhT4uAktR2oQ@public.gmane.org>
> Cc: Russell King <rmk+kernel-lFZ/pmaqli7XmaaqVzeoHQ@public.gmane.org>
> Cc: Rob Clark <robdclark-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to drm-misc, thanks.
-Daniel

> ---
>  include/uapi/drm/armada_drm.h | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/include/uapi/drm/armada_drm.h b/include/uapi/drm/armada_drm.h
> index 72e326f9c7de..0cb932416cfe 100644
> --- a/include/uapi/drm/armada_drm.h
> +++ b/include/uapi/drm/armada_drm.h
> @@ -23,27 +23,27 @@ extern "C" {
>  	DRM_##dir(DRM_COMMAND_BASE + DRM_ARMADA_##name, struct drm_armada_##str)
>  
>  struct drm_armada_gem_create {
> -	uint32_t handle;
> -	uint32_t size;
> +	__u32 handle;
> +	__u32 size;
>  };
>  #define DRM_IOCTL_ARMADA_GEM_CREATE \
>  	ARMADA_IOCTL(IOWR, GEM_CREATE, gem_create)
>  
>  struct drm_armada_gem_mmap {
> -	uint32_t handle;
> -	uint32_t pad;
> -	uint64_t offset;
> -	uint64_t size;
> -	uint64_t addr;
> +	__u32 handle;
> +	__u32 pad;
> +	__u64 offset;
> +	__u64 size;
> +	__u64 addr;
>  };
>  #define DRM_IOCTL_ARMADA_GEM_MMAP \
>  	ARMADA_IOCTL(IOWR, GEM_MMAP, gem_mmap)
>  
>  struct drm_armada_gem_pwrite {
> -	uint64_t ptr;
> -	uint32_t handle;
> -	uint32_t offset;
> -	uint32_t size;
> +	__u64 ptr;
> +	__u32 handle;
> +	__u32 offset;
> +	__u32 size;
>  };
>  #define DRM_IOCTL_ARMADA_GEM_PWRITE \
>  	ARMADA_IOCTL(IOW, GEM_PWRITE, gem_pwrite)
> -- 
> 2.13.3
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

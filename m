From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v06 33/36] uapi linux/fsmap.h: use __kernel_size_t
 instead of size_t
Date: Mon, 7 Aug 2017 08:54:45 -0700
Message-ID: <20170807155445.GA4074@magnolia>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi>
 <20170806164428.2273-34-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170806164428.2273-34-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Sun, Aug 06, 2017 at 06:44:24PM +0200, Mikko Rapeli wrote:
> Fixes user space compilation error:
> 
> linux/fsmap.h:71:19: error: unknown type name ‘size_t’
>  static __inline__ size_t
>                    ^~~~~~
> 
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> Cc: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> ---
>  include/uapi/linux/fsmap.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/fsmap.h b/include/uapi/linux/fsmap.h
> index 7e8e5f0bd6d2..99600bbed6b6 100644
> --- a/include/uapi/linux/fsmap.h
> +++ b/include/uapi/linux/fsmap.h
> @@ -68,7 +68,7 @@ struct fsmap_head {
>  };
>  
>  /* Size of an fsmap_head with room for nr records. */
> -static inline size_t
> +static inline __kernel_size_t

This is a static inline helper to assist in malloc calls.  We don't pass
size_t to the kernel, so why is this necessary over, say,

#include <sys/types.h>

--D

>  fsmap_sizeof(
>  	unsigned int	nr)
>  {
> -- 
> 2.13.3
> 

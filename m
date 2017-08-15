From: Stefano Stabellini <sstabellini@kernel.org>
Subject: Re: [Xen-devel] [PATCH v06 26/36] uapi xen/privcmd.h: fix compilation
 in userspace
Date: Tue, 15 Aug 2017 15:58:07 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1708151545340.12143@sstabellini-ThinkPad-X260>
References: <20170806164428.2273-1-mikko.rapeli@iki.fi> <20170806164428.2273-27-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323329-564055531-1502837143=:12143"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170806164428.2273-27-mikko.rapeli@iki.fi>
Content-ID: <alpine.DEB.2.10.1708151557370.12143@sstabellini-ThinkPad-X260>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, Russell King <linux@armlinux.org.uk>, Paul Durrant <paul.durrant@citrix.com>, David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>
List-Id: linux-api@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-564055531-1502837143=:12143
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.10.1708151557371.12143@sstabellini-ThinkPad-X260>

On Sun, 6 Aug 2017, Mikko Rapeli wrote:
> xen/interface/xen.h is not exported from kernel headers so remove the
> dependency and provide needed defines for domid_t and xen_pfn_t if they
> are not already defined by some other e.g. Xen specific headers.
> 
> Suggested by Andrew Cooper <andrew.cooper3@citrix.com> on lkml message
> <5569F9C9.8000607@citrix.com>.
> 
> The ifdef for ARM is ugly but did not find better solutions for it.
> 
> Then use __kernel_size_t instead of size_t since that is available in
> uapi headers in user space.
> 
> Fixes userspace compilation errors:
> 
> xen/privcmd.h:38:31: fatal error: xen/interface/xen.h: No such file or directory
> xen/privcmd.h:92:2: error: unknown type name ‘size_t’
> 
> Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
> Cc: Paul Durrant <paul.durrant@citrix.com>
> Cc: David Vrabel <david.vrabel@citrix.com>
> Cc: Stefano Stabellini <sstabellini@kernel.org>
> Cc: Russell King <linux@armlinux.org.uk>

Reviewed-by: Stefano Stabellini <sstabellini@kernel.org>

> ---
>  include/uapi/xen/privcmd.h | 14 ++++++++++++--
>  1 file changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/include/uapi/xen/privcmd.h b/include/uapi/xen/privcmd.h
> index 63ee95c9dabb..565f3003741d 100644
> --- a/include/uapi/xen/privcmd.h
> +++ b/include/uapi/xen/privcmd.h
> @@ -35,7 +35,17 @@
>  
>  #include <linux/types.h>
>  #include <linux/compiler.h>
> -#include <xen/interface/xen.h>
> +
> +/* Defined by include/xen/interface/xen.h, but it is not part of Linux uapi */
> +#ifndef __XEN_PUBLIC_XEN_H__
> +typedef __u16 domid_t;
> +
> +#if (defined __ARMEL__ || defined __ARMEB__)
> +typedef __u64 xen_pfn_t;
> +#else
> +typedef unsigned long xen_pfn_t;
> +#endif /* (defined __ARMEL__ || defined __ARMEB__) */
> +#endif /* __XEN_PUBLIC_XEN_H__ */
>  
>  struct privcmd_hypercall {
>  	__u64 op;
> @@ -79,7 +89,7 @@ struct privcmd_mmapbatch_v2 {
>  
>  struct privcmd_dm_op_buf {
>  	void __user *uptr;
> -	size_t size;
> +	__kernel_size_t size;
>  };
>  
>  struct privcmd_dm_op {
> -- 
> 2.13.3
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> https://lists.xen.org/xen-devel
> 
--8323329-564055531-1502837143=:12143--

From: Mikko Rapeli <mikko.rapeli@iki.fi>
Subject: Re: [PATCH 98/98] HACK include/uapi/linux/errqueue.h: include time.h
 in userspace
Date: Tue, 6 Oct 2015 22:56:24 +0300
Message-ID: <20151006195624.GO6104@lakka.kapsi.fi>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-99-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1433000370-19509-99-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Willem de Bruijn <willemb@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

Hi,

On Sat, May 30, 2015 at 05:39:30PM +0200, Mikko Rapeli wrote:
> linux/time.h conflicts with userspace header time.h. Try to be compatible
> for kernel and userspace.

Any comments about this change? I assume the <linux/time.h> and <time.h>
incompatibility in userspace is a known thing and the resulting definitions
are compatible.

-Mikko

> Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
> ---
>  include/uapi/linux/errqueue.h | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/include/uapi/linux/errqueue.h b/include/uapi/linux/errqueue.h
> index 6b1cdc6..b310b2c 100644
> --- a/include/uapi/linux/errqueue.h
> +++ b/include/uapi/linux/errqueue.h
> @@ -2,7 +2,12 @@
>  #define _UAPI_LINUX_ERRQUEUE_H
>  
>  #include <linux/types.h>
> +
> +#ifdef __KERNEL__
>  #include <linux/time.h>
> +#else
> +#include <time.h>
> +#endif /* __KERNEL__ */
>  
>  struct sock_extended_err {
>  	__u32	ee_errno;	
> -- 
> 2.1.4
> 

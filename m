From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 67/98] include/uapi/linux/netfilter/ipset/ip_set_bitmap.h:
 include linux/netfilter/ipset/ip_set.h
Date: Sun, 31 May 2015 20:15:48 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1505312014550.2712@blackhole.kfki.hu>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi> <1433000370-19509-68-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1433000370-19509-68-git-send-email-mikko.rapeli@iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikko Rapeli <mikko.rapeli@iki.fi>
Cc: linux-kernel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>, Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org, coreteam@netfilter.org, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Sat, 30 May 2015, Mikko Rapeli wrote:

> Fixes userspace compilation error:
> 
> error: ?IPSET_ERR_TYPE_SPECIFIC? undeclared here (not in a function)
>   IPSET_ERR_BITMAP_RANGE = IPSET_ERR_TYPE_SPECIFIC,

What kind of userspace compilation generates the error message above? How 
can one reproduce it?

Best regards,
Jozsef
 
> Signed-off-by: Mikko Rapeli <mikko.rapeli@iki.fi>
> ---
>  include/uapi/linux/netfilter/ipset/ip_set_bitmap.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/include/uapi/linux/netfilter/ipset/ip_set_bitmap.h b/include/uapi/linux/netfilter/ipset/ip_set_bitmap.h
> index 6a2c038..fd5024d 100644
> --- a/include/uapi/linux/netfilter/ipset/ip_set_bitmap.h
> +++ b/include/uapi/linux/netfilter/ipset/ip_set_bitmap.h
> @@ -1,6 +1,8 @@
>  #ifndef _UAPI__IP_SET_BITMAP_H
>  #define _UAPI__IP_SET_BITMAP_H
>  
> +#include <linux/netfilter/ipset/ip_set.h>
> +
>  /* Bitmap type specific error codes */
>  enum {
>  	/* The element is out of the range of the set */
> -- 
> 2.1.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary

From: Greg KH <greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] include/uapi/linux/swab.h: define a silent macro to
 avoid sparse error
Date: Mon, 15 Jun 2015 16:06:33 -0700
Message-ID: <20150615230633.GA14978@kroah.com>
References: <1434320613-28700-1-git-send-email-bilel.dr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1434320613-28700-1-git-send-email-bilel.dr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bilel DRIRA <bilel.dr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sun, Jun 14, 2015 at 11:23:32PM +0100, Bilel DRIRA wrote:
> define a silent macro when _CHECKER_ is defined.
> This change fixes the following sparse errors:
> 
> include/uapi/linux/swab.h:60:16: error: undefined identifier '__builtin_bswap32'
> include/uapi/linux/swab.h:60:33: error: not a function <noident>
> include/uapi/linux/swab.h:71:16: error: undefined identifier '__builtin_bswap64'
> include/uapi/linux/swab.h:71:33: error: not a function <noident>
> include/uapi/linux/swab.h:60:33: error: not a function <noident>
> 
> Signed-off-by: Bilel DRIRA <bilel.dr-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>  include/uapi/linux/swab.h |   12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/include/uapi/linux/swab.h b/include/uapi/linux/swab.h
> index 0e011eb..c04de49 100644
> --- a/include/uapi/linux/swab.h
> +++ b/include/uapi/linux/swab.h
> @@ -5,6 +5,18 @@
>  #include <linux/compiler.h>
>  #include <asm/swab.h>
>  
> +#ifdef __CHECKER__
> +
> +#ifdef __HAVE_BUILTIN_BSWAP64__
> +#define __builtin_bswap64(val) (0)
> +#endif
> +
> +#ifdef __HAVE_BUILTIN_BSWAP32__
> +#define __builtin_bswap32(val) (0)
> +#endif
> +
> +#endif	/* __CHECKER__ */

Shouldn't the tool be fixed instead of papering over the issue with
random defines like this?

thanks,

greg k-h

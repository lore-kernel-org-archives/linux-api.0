From: Dmitry Torokhov <dmitry.torokhov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] Input: input.h: Fix EVIOCSFF macro inconsistency by
 using _IOW()
Date: Wed, 14 Oct 2015 17:25:19 -0700
Message-ID: <20151015002519.GC3673@dtor-ws>
References: <1442510796-3062-1-git-send-email-elias.vds@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1442510796-3062-1-git-send-email-elias.vds-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Elias Vanderstuyft <elias.vds-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-input-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Sep 17, 2015 at 07:26:36PM +0200, Elias Vanderstuyft wrote:
> Just like the EVIOCSABS(abs) macro, use the more compact
> _IOW(..., type) instead of _IOC(_IOC_WRITE, ..., sizeof(type))
> for the EVIOCSFF macro.
> 
> Signed-off-by: Elias Vanderstuyft <elias.vds-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied, thank you.

> ---
>  include/uapi/linux/input.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
> index 731417c..63915a7 100644
> --- a/include/uapi/linux/input.h
> +++ b/include/uapi/linux/input.h
> @@ -147,7 +147,7 @@ struct input_keymap_entry {
>  #define EVIOCGABS(abs)		_IOR('E', 0x40 + (abs), struct input_absinfo)	/* get abs value/limits */
>  #define EVIOCSABS(abs)		_IOW('E', 0xc0 + (abs), struct input_absinfo)	/* set abs value/limits */
>  
> -#define EVIOCSFF		_IOC(_IOC_WRITE, 'E', 0x80, sizeof(struct ff_effect))	/* send a force effect to a force feedback device */
> +#define EVIOCSFF		_IOW('E', 0x80, struct ff_effect)	/* send a force effect to a force feedback device */
>  #define EVIOCRMFF		_IOW('E', 0x81, int)			/* Erase a force effect */
>  #define EVIOCGEFFECTS		_IOR('E', 0x84, int)			/* Report number of effects playable at the same time */
>  
> -- 
> 1.9.3
> 

-- 
Dmitry

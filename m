From: Frans Klaver <fransklaver-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 45/79] linux/if.h linux/hdlc/ioctl.h: move IFNAMSIZ
 definition to hdlc/ioctl.h
Date: Thu, 15 Oct 2015 10:49:17 +0200
Message-ID: <CAH6sp9Pc48Qfux9K68rCRvfBUhEpxqM9k43Nn2vCpKh4Ewa+QQ@mail.gmail.com>
References: <1444888618-4506-1-git-send-email-mikko.rapeli@iki.fi>
	<1444888618-4506-46-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1444888618-4506-46-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-api <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi,

On Thu, Oct 15, 2015 at 7:56 AM, Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org> wrote:
> And include linux/hdlc/ioctl.h from linux/if.h.

That appears to have already been the case before this patch. You just
add a comment behind the include statement.


> diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
> index 9cf2394..0f98f0a 100644
> --- a/include/uapi/linux/if.h
> +++ b/include/uapi/linux/if.h
> @@ -22,10 +22,8 @@
>  #include <linux/types.h>               /* for "__kernel_caddr_t" et al */
>  #include <linux/socket.h>              /* for "struct sockaddr" et al  */
>  #include <linux/compiler.h>            /* for "__user" et al           */
> -
> -#define        IFNAMSIZ        16
> -#define        IFALIASZ        256
> -#include <linux/hdlc/ioctl.h>
> +#include <linux/hdlc/ioctl.h>           /* for IFNAMSIZ                 */
> +#define        IFALIASZ        256

Thanks,
Frans

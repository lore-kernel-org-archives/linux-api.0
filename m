From: Frans Klaver <fransklaver-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 49/98] Break dependency loop between linux/if.h and
 linux/hdlc/ioctl.h
Date: Sat, 30 May 2015 21:52:23 +0200
Message-ID: <20150530195223.GA15645@bugger.home>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-50-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433000370-19509-50-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, May 30, 2015 at 05:38:41PM +0200, Mikko Rapeli wrote:
> This isn't pretty but does the job. I assume including plain linux/hd=
lc/ioctl.h
> without linux/if.h is much more rare than the other way round, and th=
at
> these header file names are part of API, and that creating a new head=
er file
> just for IFNAMSIZ isn't a good idea either.
>=20
> Fixes userspace compiler error:
>=20
> error: =E2=80=98IFNAMSIZ=E2=80=99 undeclared here (not in a function)
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> ---
>  include/uapi/linux/hdlc/ioctl.h | 5 ++++-
>  include/uapi/linux/if.h         | 4 ++++
>  2 files changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/uapi/linux/hdlc/ioctl.h b/include/uapi/linux/hdl=
c/ioctl.h
> index 8bbee11..73982ec 100644
> --- a/include/uapi/linux/hdlc/ioctl.h
> +++ b/include/uapi/linux/hdlc/ioctl.h
> @@ -1,7 +1,10 @@
>  #ifndef __HDLC_IOCTL_H__
>  #define __HDLC_IOCTL_H__
> =20
> -#include <linux/if.h>
> +/* For breaking dependency loop between if.h and hdlc/ioctl.h */
> +#ifndef IFNAMSIZ
> +#define IFNAMSIZ        16
> +#endif
> =20
>  #define GENERIC_HDLC_VERSION 4	/* For synchronization with sethdlc u=
tility */
> =20
> diff --git a/include/uapi/linux/if.h b/include/uapi/linux/if.h
> index 9cf2394..e4b130a 100644
> --- a/include/uapi/linux/if.h
> +++ b/include/uapi/linux/if.h
> @@ -23,6 +23,10 @@
>  #include <linux/socket.h>		/* for "struct sockaddr" et al	*/
>  #include <linux/compiler.h>		/* for "__user" et al           */
> =20
> +/**
> + * IFNAMSIZ is also defined in linux/hdlc/ioctl.h if it does not exi=
sts
> + * to break dependency loop between linux/if.h and linux/hdlc/ioctl.=
h.
> + */
>  #define	IFNAMSIZ	16
>  #define	IFALIASZ	256
>  #include <linux/hdlc/ioctl.h>

This feels backwards to me. Wouldn't it be less funky to accept that
IFNAMSIZE isn't defined in if.h, but rather in hdlc/ioctl.h? If now
someone feels giddy and does

#include <linux/hdlc/ioctl.h>
#include <linux/if.h>

We have a new and unnecessary warning on our hands ;-)

Thanks,
=46rans

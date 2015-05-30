From: Frans Klaver <fransklaver-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 43/98] include/uapi/linux/hdlc/ioctl.h: include linux/if.h
Date: Sat, 30 May 2015 22:22:53 +0200
Message-ID: <20150530202253.GD15645@bugger.home>
References: <1433000370-19509-1-git-send-email-mikko.rapeli@iki.fi>
 <1433000370-19509-44-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1433000370-19509-44-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, May 30, 2015 at 05:38:35PM +0200, Mikko Rapeli wrote:
> Fixes userspace compiler error:
>=20
> error: =E2=80=98IFNAMSIZ=E2=80=99 undeclared here (not in a function)
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> ---
>  include/uapi/linux/hdlc/ioctl.h | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/include/uapi/linux/hdlc/ioctl.h b/include/uapi/linux/hdl=
c/ioctl.h
> index 04bc027..8bbee11 100644
> --- a/include/uapi/linux/hdlc/ioctl.h
> +++ b/include/uapi/linux/hdlc/ioctl.h
> @@ -1,6 +1,7 @@
>  #ifndef __HDLC_IOCTL_H__
>  #define __HDLC_IOCTL_H__
> =20
> +#include <linux/if.h>
> =20
>  #define GENERIC_HDLC_VERSION 4	/* For synchronization with sethdlc u=
tility */

What's the point of this one if you break this circular dependency in
patch 49? Are those in between related?

Thanks,
=46rans

From: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Subject: Re: [PATCH 20/45] sctp.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 08:11:27 -0500
Message-ID: <20150217131127.GB2729@neilslaptop.think-freely.org>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi>
 <1424127948-22484-21-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1424127948-22484-21-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlad Yasevich <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Feb 17, 2015 at 12:05:23AM +0100, Mikko Rapeli wrote:
> Fixes compilation error:
>=20
> linux/sctp.h:652:2: error: unknown type name =E2=80=98uint32_t=E2=80=99
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Acked-by: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

> ---
>  include/uapi/linux/sctp.h | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> index ce70fe6..9fd31cf 100644
> --- a/include/uapi/linux/sctp.h
> +++ b/include/uapi/linux/sctp.h
> @@ -53,7 +53,11 @@
>  #ifndef _UAPI_SCTP_H
>  #define _UAPI_SCTP_H
> =20
> +#ifdef __KERNEL__
>  #include <linux/types.h>
> +#else
> +#include <stdint.h>
> +#endif
>  #include <linux/socket.h>
> =20
>  typedef __s32 sctp_assoc_t;
> --=20
> 2.1.4
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-sctp"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

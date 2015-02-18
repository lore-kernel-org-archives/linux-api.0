From: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Xen-devel] [PATCH 25/45] gntalloc.h: include stdint.h in userspace
Date: Wed, 18 Feb 2015 11:53:22 +0000
Message-ID: <54E47D32.9040208@citrix.com>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi> <1424127948-22484-26-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424127948-22484-26-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: David Vrabel <david.vrabel-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xen-devel-GuqFBffKawtpuQazS67q72D2FQJk+8+b@public.gmane.org, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On 16/02/15 23:05, Mikko Rapeli wrote:
> Fixes compilation error:
>=20
> xen/gntalloc.h:22:2: error: unknown type name =E2=80=98uint16_t=E2=80=
=99
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> ---
>  include/uapi/xen/gntalloc.h | 6 ++++++
>  1 file changed, 6 insertions(+)
>=20
> diff --git a/include/uapi/xen/gntalloc.h b/include/uapi/xen/gntalloc.=
h
> index 76bd580..184df7e 100644
> --- a/include/uapi/xen/gntalloc.h
> +++ b/include/uapi/xen/gntalloc.h
> @@ -11,6 +11,12 @@
>  #ifndef __LINUX_PUBLIC_GNTALLOC_H__
>  #define __LINUX_PUBLIC_GNTALLOC_H__
> =20
> +#ifdef __KERNEL__
> +#include <linux/types.h>
> +#else
> +#include <stdint.h>
> +#endif

I think it would be preferrable to #include <linux/types.h> only and
switch to using the __u32 etc. types (as others have suggested).

David

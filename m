From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 33/45] include/uapi/asm-generic/signal.h: include stdlib.h in userspace
Date: Tue, 17 Feb 2015 10:44:48 +0100
Message-ID: <2372547.aJh8O9JSDy@wuerfel>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi> <1424127948-22484-34-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424127948-22484-34-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 17 February 2015 00:05:36 Mikko Rapeli wrote:
> Fixes compiler warning:
> error: unknown type name =E2=80=98size_t=E2=80=99
>=20
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
> ---
>  include/uapi/asm-generic/signal.h | 4 ++++
>  1 file changed, 4 insertions(+)
>=20
> diff --git a/include/uapi/asm-generic/signal.h b/include/uapi/asm-gen=
eric/signal.h
> index 9df61f1..8a341a2 100644
> --- a/include/uapi/asm-generic/signal.h
> +++ b/include/uapi/asm-generic/signal.h
> @@ -3,6 +3,10 @@
> =20
>  #include <linux/types.h>
> =20
> +#ifndef __KERNEL__
> +#include <stdlib.h>
> +#endif
> +

Hmm, maybe we should use __kernel_size_t instead?

	Arnd

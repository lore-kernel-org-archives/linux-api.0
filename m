From: Daniel Borkmann <daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org>
Subject: Re: [PATCH 20/45] sctp.h: include stdint.h in userspace
Date: Wed, 18 Feb 2015 16:48:04 +0100
Message-ID: <54E4B434.3030302@iogearbox.net>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi> <1424127948-22484-21-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424127948-22484-21-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vlad Yasevich <vyasevich-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, linux-sctp-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On 02/17/2015 12:05 AM, Mikko Rapeli wrote:
> Fixes compilation error:
>
> linux/sctp.h:652:2: error: unknown type name =E2=80=98uint32_t=E2=80=99
>
> Signed-off-by: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>

I have no idea where the rest of this series went (neither netdev, nor
lkml, nor linux-sctp) and what user space application making use of the
header you are trying to fix !?

> ---
>   include/uapi/linux/sctp.h | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/include/uapi/linux/sctp.h b/include/uapi/linux/sctp.h
> index ce70fe6..9fd31cf 100644
> --- a/include/uapi/linux/sctp.h
> +++ b/include/uapi/linux/sctp.h
> @@ -53,7 +53,11 @@
>   #ifndef _UAPI_SCTP_H
>   #define _UAPI_SCTP_H
>
> +#ifdef __KERNEL__
>   #include <linux/types.h>
> +#else
> +#include <stdint.h>
> +#endif
>   #include <linux/socket.h>

Looks ugly, but could also be resolved in user space.

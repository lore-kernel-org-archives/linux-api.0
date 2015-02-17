From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH 15/45] dm-log-userspace.h: include stdint.h in userspace
Date: Tue, 17 Feb 2015 10:08:56 +0100
Message-ID: <2309592.iOl8K3u7d8@wuerfel>
References: <1424127948-22484-1-git-send-email-mikko.rapeli@iki.fi> <1424127948-22484-16-git-send-email-mikko.rapeli@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1424127948-22484-16-git-send-email-mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mikko Rapeli <mikko.rapeli-X3B1VOXEql0@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alasdair Kergon <agk-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, dm-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tuesday 17 February 2015 00:05:18 Mikko Rapeli wrote:
> --- a/include/uapi/linux/dm-log-userspace.h
> +++ b/include/uapi/linux/dm-log-userspace.h
> @@ -7,6 +7,11 @@
>  #ifndef __DM_LOG_USERSPACE_H__
>  #define __DM_LOG_USERSPACE_H__
>  
> +#ifdef __KERNEL__
> +#include <linux/types.h>
> +#else
> +#include <stdint.h>
> +#endif
>  #include <linux/dm-ioctl.h> /* For DM_UUID_LEN */
> 

The normal way to do this in kernel headers is to use linux/types.h
but change the data structures to use __u64 instead of uint64_t
to avoid the build error.

It's possible that the maintainers of this code have a strong opinion
on this matter, but try doing that first.

	Arnd

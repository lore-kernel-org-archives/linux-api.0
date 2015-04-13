From: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 4/4] timerfd.2: Add ioctl method description
Date: Mon, 13 Apr 2015 21:56:20 +0200
Message-ID: <552C1F64.30202@gmail.com>
References: <20140715215451.499191426@openvz.org> <20140715215703.353177995@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140715215703.353177995-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hello Cyrill,

On 07/15/2014 11:54 PM, Cyrill Gorcunov wrote:
> ioctl(2)
> 	The following commands are supported: TFD_IOC_SET_TICKS to adjust
> 	the number of the timer expirations that have occurred.
> 	It take a pointer to nonzero 8-byte integer (uint64_t*) containing
> 	new number of expirations. Once the number is set any waiter on
> 	the timer is woken up. The only purpose of this command is to restore
> 	the expirations in a sake of checkpoint/restore procedure.
> 	It requires the kernel to be built with CONFIG_CHECKPOINT_RESTORE
> 	support.

Late... but, patch applied. Thank you.

Cheers,

Michael


> Signed-off-by: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> CC: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> CC: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> CC: Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> CC: Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> ---
>  man2/timerfd_create.2 |   14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> Index: man-pages/man2/timerfd_create.2
> ===================================================================
> --- man-pages.orig/man2/timerfd_create.2
> +++ man-pages/man2/timerfd_create.2
> @@ -260,6 +260,20 @@ multiplexing APIs:
>  and
>  .BR epoll (7).
>  .TP
> +.BR ioctl "(2)"
> +The following commands are supported:
> +.B TFD_IOC_SET_TICKS
> +to adjust the number of the timer expirations that have occurred.
> +It take a pointer to nonzero 8-byte integer
> +.RI ( uint64_t *)
> +containing the new number of expirations.
> +Once the number is set any waiter on the timer is woken up.
> +The only purpose of this command is to restore the expirations
> +in a sake of checkpoint/restore procedure.
> +It requires the kernel to be built with
> +.BR CONFIG_CHECKPOINT_RESTORE
> +support.
> +.TP
>  .BR close (2)
>  When the file descriptor is no longer required it should be closed.
>  When all file descriptors associated with the same timer object
> 
> 


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/

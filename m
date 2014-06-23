From: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [patch 0/4] timerfd c/r support, v4
Date: Mon, 23 Jun 2014 23:44:29 +0400
Message-ID: <20140623194429.GB23651@paralelels.com>
References: <20140623185431.396309193@openvz.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="koi8-r"
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140623185431.396309193-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Jun 23, 2014 at 10:54:31PM +0400, Cyrill Gorcunov wrote:
> Hi guys, here is an updated version of c/r support for timerfd files. The main change
> is in how @ticks are restored in patch 3 -- I switched to ioctl code, which is wrapped
> with CONFIG because I still think that while there is only one ioctl designated
> solely for c/r needs no need to build it all the time until explicitly requested.
> Please take a look once time permit. Comments are highly appreciated.
> Also note the last patch is for man-page git repo, not for kernel.
> 
> Thanks!

Acked-by: Andrew Vagin <avagin-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

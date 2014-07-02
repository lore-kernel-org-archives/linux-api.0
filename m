From: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [patch 3/4] timerfd: Implement timerfd_ioctl method to restore
 timerfd_ctx::ticks
Date: Wed, 2 Jul 2014 23:07:06 +0400
Message-ID: <20140702190706.GH12440@moon>
References: <20140623185431.396309193@openvz.org>
 <53B4382F.9030908@codeaurora.org>
 <20140702170416.GG12440@moon>
 <4188254.Av1Z2pQssC@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4188254.Av1Z2pQssC@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Linux ARM kernel mailing list <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Jul 02, 2014 at 09:01:02PM +0200, Arnd Bergmann wrote:
> > > 
> > > 64-bit get_user is currently unsupported on ARM, although it appears work is
> > > ongoing [1].
> > > 
> > > 1. https://lkml.org/lkml/2014/6/17/260
> > 
> > Thanks for info, Christopher! What arm camp is using then, copy-from-user?
> > 
> 
> copy_from_user should work on all architectures. I believe a 64-bit get_user
> is currently unsupported on most 32-bit architectures, x86-32 being a notable
> exception.

Thanks, I'll update.

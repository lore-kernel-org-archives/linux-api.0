From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [patch 0/4] timerfd c/r support, v4
Date: Tue, 15 Jul 2014 18:11:58 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1407151811050.24854@nanos>
References: <20140623185431.396309193@openvz.org> <20140630194354.GB2305@moon> <20140715135445.GJ23835@moon>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140715135445.GJ23835@moon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 15 Jul 2014, Cyrill Gorcunov wrote:

> On Mon, Jun 30, 2014 at 11:43:54PM +0400, Cyrill Gorcunov wrote:
> > On Mon, Jun 23, 2014 at 10:54:31PM +0400, Cyrill Gorcunov wrote:
> > >
> > > Hi guys, here is an updated version of c/r support for timerfd files. The main change
> > > is in how @ticks are restored in patch 3 -- I switched to ioctl code, which is wrapped
> > > with CONFIG because I still think that while there is only one ioctl designated
> > > solely for c/r needs no need to build it all the time until explicitly requested.
> > > Please take a look once time permit. Comments are highly appreciated.
> > > Also note the last patch is for man-page git repo, not for kernel.
> > 
> > Gentlemen, could you please point me if there something preventing the
> > series from being picked up? Or there some way to improve the series?
> 
> Dear sirs, ping?

Hmm, I was waiting for a V5, but it seems you just updated that single
patch according to the review. I'll pick it up

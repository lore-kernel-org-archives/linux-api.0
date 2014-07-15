From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [patch 0/4] timerfd c/r support, v4
Date: Tue, 15 Jul 2014 23:20:25 +0200 (CEST)
Message-ID: <alpine.DEB.2.10.1407152319590.24854@nanos>
References: <20140623185431.396309193@openvz.org> <20140630194354.GB2305@moon> <20140715135445.GJ23835@moon> <alpine.DEB.2.10.1407151811050.24854@nanos> <20140715162501.GK23835@moon> <alpine.DEB.2.10.1407152306430.24854@nanos> <20140715211413.GL23835@moon>
 <alpine.DEB.2.10.1407152315350.24854@nanos> <20140715211800.GM23835@moon>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140715211800.GM23835@moon>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Cyrill Gorcunov <gorcunov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrey Vagin <avagin-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
List-Id: linux-api@vger.kernel.org



On Wed, 16 Jul 2014, Cyrill Gorcunov wrote:

> On Tue, Jul 15, 2014 at 11:16:23PM +0200, Thomas Gleixner wrote:
> > > 
> > > Maybe it's because of new -rc? Letme check...
> > 
> > No, it's because its against an older version of your patches which
> > lack the #ifdef PROC_FS around the show function ....
> 
> Crap. Sorry. Thomas, I'm fetching -rc5 now, I suppose better will
> be if I rebase the whole series and resend. Sounds good?

No rebase necessary. 1&2 apply fine. It's home made wreckage :)
 

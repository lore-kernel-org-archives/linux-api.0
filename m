From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [take2] Inotify: nested attributes support.
Date: Wed, 26 Nov 2008 16:15:39 +0300
Message-ID: <20081126131539.GA10172@ioremap.net>
References: <20081125194234.GA24449@ioremap.net> <20081125162434.4feacbbf.akpm@linux-foundation.org> <20081126074239.GA17525@ioremap.net> <20081126001538.4b1c7c99.akpm@linux-foundation.org> <20081126082936.GB17525@ioremap.net> <492D4560.8000302@davidnewall.com> <20081126125113.GA8921@ioremap.net> <492D4927.8040204@davidnewall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <492D4927.8040204-KzQzY1MbaKjAHznzqCTclw@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Newall <davidn-KzQzY1MbaKjAHznzqCTclw@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pavel-AlSwsSmVLrQ@public.gmane.org, Eric Paris <eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 26, 2008 at 11:33:35PM +1030, David Newall (davidn-KzQzY1MbaKjAHznzqCTclw@public.gmane.org) wrote:
> > And as was shown it does not work for all cases and introduces unneded
> > performance overhead.
> 
> If the performance using a local loopback is insufficient, or even when
> using a UNIX domain socket, then it's going to be even worse for the
> actual network-connected clients.  And the cases were it doesn't work
> amount to poor system administration, which is a solvable problem.

Proposing to introduce additional overhead when it can be avoided is not
the best way to deal with the problem.
Another small detail, that it does not completely solve the problem.
 
> >> This change violates my first rule of programming: If there's two or
> >> more ways of solving a problem, pick one; don't pick them all.
> >
> > Then we should go back to caves, raw meat was so tasty...
> 
> Amusing, but irrelevant to programming.

Programming is so special, that new things which help having a progress
should not be developed there? Care to recall how to work with the punch
card? Following your logic inotify should be returned from the kernel,
since all applications which may do IO can be modified to first register
it in some special database and not checking IO at run-time. And we will
not care about others who did not do that.

Your 'rule' does not apply to the case, where is no way to solve the
problem completely using existing methods.

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 11:40:06 -0400
Message-ID: <20140515114006.52a4e07d@gandalf.local.home>
References: <537346E5.4050407@gmail.com>
	<CF98E3EF.90564%dvhart@linux.intel.com>
	<20140515152834.GA6926@rei.Home>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140515152834.GA6926-HSzIOc4LzcM@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: chrubis-AlSwsSmVLrQ@public.gmane.org
Cc: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, 15 May 2014 17:28:35 +0200
chrubis-AlSwsSmVLrQ@public.gmane.org wrote:

> Hi!
> > 
> > However, unless I'm sorely mistaken, the larger problem is that glibc
> > removed the futex() call entirely, so these man pages don't describe
> > something users even have access to anymore. I had to revert to calling
> > the syscalls directly in the futextest test suite because of this:
> > 
> > http://git.kernel.org/cgit/linux/kernel/git/dvhart/futextest.git/tree/inclu
> 
> So there actually exists some tests for futexes, I've been asked if we
> have these as a LTP[1] maintainer several times.
> 
> Are these tests executed regulary as a part of some automated framework?
> If not it would make sense to port them to LTP (looking at the code that
> would be quite easy task) and get them executed by several QA
> departments for free. What do you think?
> 
> [1] http://linux-test-project.github.io/
> 

I think Thomas may be working on one. If not, I'd be happy to start
writing one as well.

-- Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

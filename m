From: chrubis-AlSwsSmVLrQ@public.gmane.org
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 18:30:04 +0200
Message-ID: <20140515163004.GB7959@rei.Home>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <20140515152834.GA6926@rei.Home>
 <CF9A3521.90ECC%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9A3521.90ECC%dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi!
> I've used LTP in the past (quite a bit), and I felt there was some
> advantage to keeping futextest independent.

What advantages did you have in mind?

> Perhaps things have changed enough since then (~2009 era) that we
> should reconsider.

I've been working on LTP for a about three years now and we happen to do
quite a lot in that time. The most visible changes would be more proper
development practices (git, proper build system, code review, LKML
coding style, documentation, ...) and also huge number of fixes. Now we
are trying to catch up in coverage too.

> We can discuss the pros/cons there if you like.

I would love to :).

> I have agreed to move the performance related tests over to perf, and
> Davidlohr has added some other such tests to perf. Trinity now covers
> the planned fuzz testing for futexes (very well... Obviously) so that
> idea will be dropped, leaving pure functional tests in futextest.

Well LTP mostly consists of functional tests, so that would fit the
purpose very well.

-- 
Cyril Hrubis
chrubis-AlSwsSmVLrQ@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

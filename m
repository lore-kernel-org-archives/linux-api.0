From: chrubis-AlSwsSmVLrQ@public.gmane.org
Subject: Re: futex(2) man page update help request
Date: Thu, 15 May 2014 21:05:29 +0200
Message-ID: <20140515190529.GA8887@rei.Home>
References: <537346E5.4050407@gmail.com>
 <CF98E3EF.90564%dvhart@linux.intel.com>
 <20140515152834.GA6926@rei.Home>
 <CF9A3521.90ECC%dvhart@linux.intel.com>
 <20140515163004.GB7959@rei.Home>
 <CF9A3A75.90F40%dvhart@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9A3A75.90F40%dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Darren Hart <dvhart-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-X9Un+BFzKDI@public.gmane.org>, Jakub Jelinek <jakub-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Davidlohr Bueso <davidlohr.bueso-VXdhtT5mjnY@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Carlos O'Donell <carlos-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi!
> >> I've used LTP in the past (quite a bit), and I felt there was some
> >> advantage to keeping futextest independent.
> >
> >What advantages did you have in mind?
> 
> Not CVS was a big one at the time ;-)
> 
> OK, I don't mean to be disparaging here... But since you asked, back in
> '09 LTP had some test quality issues and I felt I could maintain futextest
> to a higher bar independently.

To be honest LTP was one of the messiest codebases I've seen and it was
hacked up by mostly clueless people (there were even tests with race
conditions that were carefully disabled in a way that was not easy to
see). It took me months to get to a state where it compiled fine on
major distributions.

Today we still have quite a bit of legacy code that needs to be cleaned
up, however that gets better every day.

And most of the testcases are pretty stable, etc. unfortunatelly LTP has
a bad reputation which is lot harder to fix than the code itself.

> >> Perhaps things have changed enough since then (~2009 era) that we
> >> should reconsider.
> >
> >I've been working on LTP for a about three years now and we happen to do
> >quite a lot in that time. The most visible changes would be more proper
> >development practices (git, proper build system, code review, LKML
> >coding style, documentation, ...) and also huge number of fixes. Now we
> >are trying to catch up in coverage too.
> >
> >> We can discuss the pros/cons there if you like.
> >
> >I would love to :).
> 
> Does LTP need to own the code, or can it incorporate existing projects and
> a sort of aggregator?

That is possible as well but not optimal. This approach would need a
wrapper script to convert the test exit values to be LTP compatible.

> How much LTP harness type code needs to be used?

Not much.

For this complexity of tests you would just need to call the tst_resm()
interface to report success/failure and, at the end of the test,
tst_exit() to return the stored overall test status.

And ideally call the standard option parsing code and call the test in
standard loop so that the test can take advantage of standard options as
number of iterations to run, etc.

Have a look at:

https://github.com/linux-test-project/ltp/wiki/Test-Writing-Guidelines

there is simple test example as well as description of the interfaces.

-- 
Cyril Hrubis
chrubis-AlSwsSmVLrQ@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

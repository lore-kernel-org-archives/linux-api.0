From: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event
 generation
Date: Tue, 4 Nov 2014 11:49:04 +0100 (CET)
Message-ID: <alpine.DEB.2.11.1411041111010.5308@nanos>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com> <CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA@mail.gmail.com> <CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com> <3430954.VNaFmamXmP@wuerfel>
 <20141104082728.GB4253@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20141104082728.GB4253-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pawel Moll <mail-g3xvULXeDMYS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, 4 Nov 2014, Richard Cochran wrote:

> On Tue, Nov 04, 2014 at 09:01:31AM +0100, Arnd Bergmann wrote:
> > On Monday 03 November 2014 17:11:53 John Stultz wrote:
> > > I've got some thoughts on what a possible interface that wouldn't be
> > > awful could look like, but I'm still hesitant because I don't really
> > > know if exposing this sort of data is actually a good idea long term.
> >  
> > I was also thinking (while working on an unrelated patch) we could use
> > a system call like
> > 
> > int clock_getoffset(clockid_t clkid, struct timespec *offs);

We might make *offs a timespec64 or u64 :)

> > that returns the current offset between CLOCK_REALTIME and the
> > requested timebase. It is of course racy, but so is every use
> > of CLOCK_REALTIME. We could also use a reference other than
> > CLOCK_REALTIME that might be more stable, but passing two arbitrary
> > clocks as input would make this much more complex to implement.
> 
> No, it is really easy to implement. Just drop the idea of "atomic". It
> really is not necessary or even possible.

If the two clocks have the same underlying hardware then you get an
'atomic' snapshot of their relationship. That's true for any
combination of CLOCK_REALTIME, CLOCK_MONOTONIC, CLOCK_BOOTTIME and
CLOCK_TAI. So we can and should expose these 'atomic' snapshots.

There is another reason why we want to support the notion of 'atomic'
snapshots: There exists hardware which gives you 'atomic' samples of
two different hardware clocks and there is more of that coming soon.

If that's not the case then you need two seperate readouts which of
course cannot provide any guarantee, but I agree that we could do
something like what you do in the PTP_SYS_OFFSET ioctl and let user
space analyze the samples. But that should be optional.

Thanks,

	tglx

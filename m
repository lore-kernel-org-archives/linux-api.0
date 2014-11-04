From: Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event
 generation
Date: Tue, 4 Nov 2014 09:24:53 +0100
Message-ID: <20141104082453.GA4253@localhost.localdomain>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
 <CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA@mail.gmail.com>
 <CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pawel Moll <mail-g3xvULXeDMYS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 03, 2014 at 05:11:53PM -0800, John Stultz wrote:
> On Mon, Nov 3, 2014 at 4:58 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> > If you're going to add double-stamped packets, can you also add a
> > syscall to read multiple clocks at once, atomically?  Or can you
> > otherwise add a non-perf mechanism to get at this data?

Does not need to be "atomic". In fact it cannot be atomic in the
general case. Some clocks are read over memory mapped registers, but
others are read over slow and sleepy buses like PCIe or MDIO.

> > Because the realtime to monotonic offset is really quite useful for
> > things like this, and it seems silly to make people actually open a
> > perf_event to get at it.
> 
> So this comes up periodically, but I don't think I've seen a interface
> proposal that was decent yet.

We have ioctl PTP_SYS_OFFSET that alternately reads a dynamic clock
and CLOCK_REALTIME a given number of times. This is done without locks
or any kind of "atomic" guarantees, and it works quite well in
practice. The user can pick the number of repetitions to deal with
noisy run time environments, and usually it is a simple matter of
picking the reading with the shortest duration. However, the user is
free to do statistics over the readings in any way he wants.

It would be nice (and people have requested) a syscall that takes two
clockid_t arguments but otherwise works like PTP_SYS_OFFSET.

We really will never have to support more than two clocks. The
application will pick one clock as the reference and then measure each
of the other clocks relative to it, one at a time. The performance
should be perfectly adequate, even better than reading three or more
at once (with the understanding that these are "software" time
stamps).

Thanks,
Richard

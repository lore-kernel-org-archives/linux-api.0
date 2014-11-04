From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event generation
Date: Tue, 4 Nov 2014 08:04:20 -0800
Message-ID: <CALAqxLWf9KVmSh2WHPi-RjERex2UvFXf2A3yuP44dLJ8ucbTBw@mail.gmail.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
	<CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA@mail.gmail.com>
	<CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com>
	<3430954.VNaFmamXmP@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3430954.VNaFmamXmP@wuerfel>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pawel Moll <mail-g3xvULXeDMYS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, Nov 4, 2014 at 12:01 AM, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org> wrote:
> On Monday 03 November 2014 17:11:53 John Stultz wrote:
>> I've got some thoughts on what a possible interface that wouldn't be
>> awful could look like, but I'm still hesitant because I don't really
>> know if exposing this sort of data is actually a good idea long term.
>
> I was also thinking (while working on an unrelated patch) we could use
> a system call like
>
> int clock_getoffset(clockid_t clkid, struct timespec *offs);
>
> that returns the current offset between CLOCK_REALTIME and the
> requested timebase. It is of course racy, but so is every use
> of CLOCK_REALTIME. We could also use a reference other than
> CLOCK_REALTIME that might be more stable, but passing two arbitrary
> clocks as input would make this much more complex to implement.

Yea, this is too racy for me, at least for it to be useful. You get an
offset, but you don't get any sense of what it was actually valid for.

I think to be at all useful, you'll have to return both a timestamp
for a given clockid, and an offset to the second clockid. That way you
can generate a valid point in time on two clocks (as best as possible,
given possible non-atomic reads of separately backed clockids).

But again, I'm not totally sure exposing this provides that much value
over userspace reading the two clocks itself (in ABA fashion) to sort
this out.

And I also don't see it as particularly related to this perf extension
that Pawel is doing (since we are trying to avoid making the perf
clock a directly accessible clockid).

thanks
-john

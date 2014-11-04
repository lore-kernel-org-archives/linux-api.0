From: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 0/3] perf: User/kernel time correlation and event generation
Date: Mon, 3 Nov 2014 17:11:53 -0800
Message-ID: <CALAqxLXfy5P0kg-W7hL+Jf1iYv758+-2cTdZwsY8kAns1nvEmg@mail.gmail.com>
References: <1415060918-19954-1-git-send-email-pawel.moll@arm.com>
	<CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALCETrXGoevmD_avz5sQfbbD624vpLW5=-8ovzTPT_5wzNFnVA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>
Cc: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pawel Moll <mail-g3xvULXeDMYS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 3, 2014 at 4:58 PM, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org> wrote:
> On Mon, Nov 3, 2014 at 4:28 PM, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org> wrote:
>> From: Pawel Moll <mail-g3xvULXeDMYS+FvcfC7Uqw@public.gmane.org>
>> Thomas suggested solution which gets down to my original proposal for
>> sched/monotonic clock correlation - an additional sample type so events
>> can be "double stamped" using different clock sources providing
>> synchronisation points for later time approximation. I've just extended
>> the implementation with configuration value to select the clock source.
>> If the first patch (making perf timestamps monotonic) gets accepted,
>> there will be no immediate need for this one, but I'd like to gain some
>> feedback anyway.
>>
>
> I have nothing intelligent to add to the potentional Thomas/Ingo
> showdown, but I do have a related thought. :)
>
> If you're going to add double-stamped packets, can you also add a
> syscall to read multiple clocks at once, atomically?  Or can you
> otherwise add a non-perf mechanism to get at this data?
>
> Because the realtime to monotonic offset is really quite useful for
> things like this, and it seems silly to make people actually open a
> perf_event to get at it.

So this comes up periodically, but I don't think I've seen a interface
proposal that was decent yet.

Also, if you want to read multiple clocks at once, do you stop at two,
or three, or... there's possibly quite a few.  Additionally some
clocks may not be possible to read atomically (perf/sched clock and
system time for example may be based on different underlying
clocksources). The general idea feels like its creeping towards some
"atomically expose all timekeeping state" mega-interface.

I've got some thoughts on what a possible interface that wouldn't be
awful could look like, but I'm still hesitant because I don't really
know if exposing this sort of data is actually a good idea long term.

thanks
-john

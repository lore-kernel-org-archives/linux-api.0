From: Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>
Subject: Re: [PATCH v4 3/3] perf: Sample additional clock value
Date: Wed, 21 Jan 2015 17:54:43 +0000
Message-ID: <1421862883.14076.99.camel@arm.com>
References: <1415292718-19785-1-git-send-email-pawel.moll@arm.com>
	 <1415292718-19785-4-git-send-email-pawel.moll@arm.com>
	 <20150105134514.GS30905@twins.programming.kicks-ass.net>
	 <1421860365.14076.91.camel@arm.com>
	 <CALAqxLV6ggCO81ntWuYuDjrqNeMePkZBpq92G9-iwMHm7ONuFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALAqxLV6ggCO81ntWuYuDjrqNeMePkZBpq92G9-iwMHm7ONuFg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Richard Cochran <richardcochran-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Masami Hiramatsu <masami.hiramatsu.pt-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Christopher Covington <cov-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Namhyung Kim <namhyung-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Tomeu Vizoso <tomeu-XCtybt49RKsYaV1qd6yewg@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, 2015-01-21 at 17:44 +0000, John Stultz wrote:
> That said, there is the dynamic posix clockids. I'm not sure if it
> would make sense, but even if we don't bump MAX_CLOCKS, might there
> be some case where someone wants to use a dynamic posix clock for the
> perf reference?

If I remember correctly, last time I tried to use dynamic posix clocks
in the perf context, one needed to open a ptp character device in order
to get a file descriptor, than translated into a clockid_t value -
correct me if I'm wrong. But here you get the fd from the
sys_perf_open() and clock_*() doesn't know anything about such
descriptor.

I was looking into a way of associating a random clock with a random fd,
so that perf could "attach" itself to the clock API at will, but it
turned out not to be trivial (I'd have to dig through old threads to
remember all the nasty details).

The good thing is that it looks like the immediate need for this was no
more, with perf using monotonic clock as the clock source. It will come
back when we get into hardware trace correlation, but one step at a
time...

Pawel

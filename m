From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Fri, 21 Nov 2008 17:37:02 +0300
Message-ID: <20081121143702.GA13931@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com> <20081117171508.GA564@ioremap.net> <cfd18e0f0811170923q6b72bd0fn9d319bbceb8fa6a@mail.gmail.com> <20081117175212.GA2224@ioremap.net> <20081120130902.GA1408@ucw.cz> <20081121140325.GA12384@ioremap.net> <517f3f820811210620o34307610hf926bbe3b3828e8c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <517f3f820811210620o34307610hf926bbe3b3828e8c-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Pavel Machek <pavel-AlSwsSmVLrQ@public.gmane.org>, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, John McCutchan <john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Michael.

On Fri, Nov 21, 2008 at 09:20:39AM -0500, Michael Kerrisk (mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org) wrote:
> I think the point is this.  You want to introduce a change that
> address the needs of a single application.  Many others see the
> change, which though it may be simple and quick to implement, as "an
> ugly hack" -- it messes up an otherwise rather well designed API.
> Should we make such a change?  I think not -- and others are echoing
> that sentiment.  Your argument that "we should do this because no-one
> else has proposed a better way" is not sufficient rationale for
> uglifying this API to serve the needs of a single app -- the argument
> will not fly, no matter how many times you repeat it.  (Your statement
> "Critics without suggestions is useless" does not hold: one very
> useful purpose of critics is to maintain the status quo of "good
> taste" in API design.)

That's the point, I proposed an idea, people just say no, without
discussion on how this should be implemented. This is a sign that
people do not really know how they want this to be implemented, if
they care at all, but want to show that some cenversation took place.

It does not. There may be infinite ways to satisfy taste of the
beautiful for lots of people, I already tried, so know this perfectly
well. And when I ask how others expect it to look like, I got _zero_
responses except that to put it into different field, when you proposed
new inotify interface.

No one proposed netlink-like attributes nesting, no one proposed new
fields, nothing. Because no one really cares about that. Only becuase of
this fact I'm still trying to say that existing inotify works ok and its
ugly extension is not a bad idea. Because no one needs new inotify, new
fileds and new interfaces.

> At this stage, I see three possibilities -- you maintain an
> out-of-mainline patch for the kernel, and distribute that with your
> app; you work out some other *userspace* solution to your problem; or
> someone comes up with inotify-ng, designed to address your needs and
> those of others (okay, we may not know what those other needs are yet,
> but the question is if we could come up with an inotify-ng design that
> can extensible in a sane way).  I know that none of these options will
> be what you are happy with, but all of them have more life than your
> proposal, IMO.

I'm happy with any solution, which solves the problem. I proposed one.
It was not accepted. So I asked how this should look like? No response.
I proposed some ideas (pid, start/offset of the io) - still no response
if it is good, bad, ugly or beautiful.

But instead people want to throw a stone, that something is ugly.

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

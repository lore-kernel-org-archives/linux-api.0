From: Pavel Machek <pavel-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Fri, 21 Nov 2008 15:57:09 +0100
Message-ID: <20081121145709.GC1554@ucw.cz>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com> <20081117171508.GA564@ioremap.net> <cfd18e0f0811170923q6b72bd0fn9d319bbceb8fa6a@mail.gmail.com> <20081117175212.GA2224@ioremap.net> <20081120130902.GA1408@ucw.cz> <20081121140325.GA12384@ioremap.net> <acdcfe7e0811210630s65404ef5pf2b94731c2a872e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <acdcfe7e0811210630s65404ef5pf2b94731c2a872e1-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>
Cc: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>, mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri 2008-11-21 09:30:38, Robert Love wrote:
> On Fri, Nov 21, 2008 at 9:03 AM, Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org> wrote:
> 
> > Critics without suggestions is useless. What did you try to say here?
> > You you believe it should be done in a different way, please tell us how
> > you see this should be implemented.
> 
> Pavel has the bedside manner of a T-Rex, but he is right.

Heh. Will attach T-Rex to next email.

> Your solution needs to be (a) generally applicable and useful, with an
> (b) elegant and clean API, which (c) does not break ABI or API.
> 
> Overloading the cookie field is not the way to go. Finding ways to
> extend the API through inotify_init might be--you will have even
> higher hurdles of "do we really need this" though.
> 
> John & I intentionally did not add the pid field when writing inotify
> for reasons of security and questionable need. It also stinks to have
> to add a pid field to the event structure if that field is seldom
> used.

...plus the permission check was quite strange. We don't normally try
to hide PIDs, and 'equal uid' is very non-standard test. can_ptrace()
is normally used for such stuff...

								Pavel

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Mon, 17 Nov 2008 20:15:08 +0300
Message-ID: <20081117171508.GA564@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Michael.

On Mon, Nov 17, 2008 at 11:59:11AM -0500, Michael Kerrisk (mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org) wrote:
> NAK.  If we are going to do this -- and I leave the security
> discussions to others more knowlegeable on that score than me -- then
> the API design should be better than this.  The current design is a
> hack.  Why exclude rename events?  Why re-use the cookie field?  The
> only answers I can guess at are that the current patch is less work to
> write.  IMO, there are (much) better design possibilities, using
> inotify1(), as I suggested earlier in this thread.

Cookie was created to store information used to somehow connect events to
each other. PID does that from another angle than rename. Extending
(rewriting userspace event processing part) events is a solution for the
new project, while existing patch (where all security concerns are
resolved) is a minimum functionality extension.

if I will spent a day and rewrite userspace report side to report new
events I'm pretty sure there will be people, who will start complaining
that again design does not match some theoretically perfect
expectations, and for the purpose of reporting origin's PID cookie
fields can be reused since right now it is unused.

Plus, if it is that hard to comment on patch which adds 14 (!) lines
including blank, which feedback we should expect on larger one? :)

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

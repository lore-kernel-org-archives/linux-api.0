From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Tue, 18 Nov 2008 14:19:37 +0100
Message-ID: <20081118131937.GC16944@lst.de>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Mon, Nov 17, 2008 at 11:59:11AM -0500, Michael Kerrisk wrote:
> NAK.  If we are going to do this -- and I leave the security
> discussions to others more knowlegeable on that score than me -- then
> the API design should be better than this.  The current design is a
> hack.  Why exclude rename events?  Why re-use the cookie field?  The
> only answers I can guess at are that the current patch is less work to
> write.  IMO, there are (much) better design possibilities, using
> inotify1(), as I suggested earlier in this thread.

Yes, this kind of thing should be enable using an flag to inotify1, and
be consistant even for rename.  Doing it as a flag to inotify1 also has
the advantage to be able to return an -EPERM when the feature is
requested but not allowed instead of letting applications that assume it
silently fail.

--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

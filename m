From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [1/1] Use pid in inotify events.
Date: Mon, 10 Nov 2008 18:20:43 +0300
Message-ID: <20081110152043.GB15796@ioremap.net>
References: <20081108114225.GA22674@ioremap.net> <cfd18e0f0811080625w5b285cc0p2410e8d187b025c7@mail.gmail.com> <20081108153545.GA3859@ioremap.net> <cfd18e0f0811080858k7f6cddadg962771ed0cb3bdb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <cfd18e0f0811080858k7f6cddadg962771ed0cb3bdb8-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, John McCutchan <ttb-/fF4VJJ1vBJctGpslLZhzA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Michael.

On Sat, Nov 08, 2008 at 11:58:30AM -0500, Michael Kerrisk (mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org) wrote:
> It's perhaps unfortunate that the structure wasn't padded out with a
> few additional fields "for future use".  But -- maybe it is not really
> true that we can't change things.  Two things to consider:
> 
> a) We now (since 2.6.27) have an inotify_init1() which has a flags argument.
> b) There are spare bits in the mask argument of inotify_add_watch()
> 
> We could use a flag in either of these to say that we want a different
> structure returned on read() from the inotify descriptor.  In the
> first case, this would be a global setting for all inotify events on
> that descriptor.  In the second, we could do it on a per-watch basis
> (I'm not so sure that that is a nice idea).  Since we are in any case
> extending the ABI, and new applications would need to be taught about
> the extension, it seems we could consider either of the alternative
> extensions I mentioned, which woul also allow the PID to be obtained
> for rename() events.  What do you think?

This may be a good idea for some serious ABI change. I think we could
extend it even more to include IO offset/size into events and attribute
changes.

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Fri, 21 Nov 2008 17:03:25 +0300
Message-ID: <20081121140325.GA12384@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com> <20081117171508.GA564@ioremap.net> <cfd18e0f0811170923q6b72bd0fn9d319bbceb8fa6a@mail.gmail.com> <20081117175212.GA2224@ioremap.net> <20081120130902.GA1408@ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20081120130902.GA1408-+ZI9xUNit7I@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Pavel Machek <pavel-AlSwsSmVLrQ@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thu, Nov 20, 2008 at 02:09:03PM +0100, Pavel Machek (pavel-AlSwsSmVLrQ@public.gmane.org) wrote:
> > > It is a minimum functionality extension that serves the needs of one
> > > or a few projects, while dirtying the design for all users.
> > 
> > Yes, this is a minimum functionality extension, which breaks nothing.
> > That's why it is a good idea, but I agree that there may be better than
> > just a good idea and implementation :)
> 
> Breaks nothing?!
> 
> Introducing ugly hack with broken permission check we have to maintain
> forever seems like way too much breakage for 14 lines.

Apparently you missed the patch itself.
Please check it first before making such statements.

> > And I actually answered, that this may be a good idea for the new
> > project. Although if things work right now no one will ever try to
> > change it. It does not work in my case, so I need to invent as simple
> > as possible way to fix it.
> 
> 'as simple diff as possible' is pretty bad criterium for kernel
> merges.

Critics without suggestions is useless. What did you try to say here?
You you believe it should be done in a different way, please tell us how
you see this should be implemented.

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

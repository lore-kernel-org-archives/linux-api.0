From: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Wed, 19 Nov 2008 17:05:01 +0300
Message-ID: <20081119140500.GA25968@ioremap.net>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com> <20081116232450.GA13547@ioremap.net> <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com> <20081118131937.GC16944@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20081118131937.GC16944-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
List-Id: linux-api@vger.kernel.org

Hi Christoph.

On Tue, Nov 18, 2008 at 02:19:37PM +0100, Christoph Hellwig (hch-jcswGhMUV9g@public.gmane.org) wrote:
> Yes, this kind of thing should be enable using an flag to inotify1, and
> be consistant even for rename.  Doing it as a flag to inotify1 also has
> the advantage to be able to return an -EPERM when the feature is
> requested but not allowed instead of letting applications that assume it
> silently fail.

So effectively you propose to have second generation of the inotify
which will have additional pid field, which will be unused by all but
the same uid events?

If you want to return -EPERM, than it will be _always_ returned for non
sysadmin capable user, which effectively makes it unusable.

-- 
	Evgeniy Polyakov
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

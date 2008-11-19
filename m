From: "Michael Kerrisk" <mtk.manpages-gM/Ye1E23mwN+BqQ9rBEUg@public.gmane.org>
Subject: Re: [take 3] Use pid in inotify events.
Date: Wed, 19 Nov 2008 09:43:41 -0500
Message-ID: <cfd18e0f0811190643j7769f768q53889bbc950ef251@mail.gmail.com>
References: <acdcfe7e0811081035l56eedf05x8b3b7ee2fc01eee6@mail.gmail.com>
	 <20081116232450.GA13547@ioremap.net>
	 <cfd18e0f0811170859w1d3f903ej1d5626f2d2bf4496@mail.gmail.com>
	 <20081118131937.GC16944@lst.de> <20081119140500.GA25968@ioremap.net>
	 <cfd18e0f0811190634g276b4a2dm5b3d5de25a5c9222@mail.gmail.com>
Reply-To: mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cfd18e0f0811190634g276b4a2dm5b3d5de25a5c9222-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Robert Love <rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org
List-Id: linux-api@vger.kernel.org

[RESENT, because LKML bounced some HTML that accidentally got put in the mail.]
[CC+=John McCutchan, this time with hopefully a live email address;
John, some context here: http://marc.info/?t=122633022400003&r=1&w=2 ]

Evgeniy,

On Wed, Nov 19, 2008 at 9:05 AM, Evgeniy Polyakov <zbr-i6C2adt8DTjR7s880joybQ@public.gmane.org> wrote:
>
> Hi Christoph.
>
> On Tue, Nov 18, 2008 at 02:19:37PM +0100, Christoph Hellwig (hch-jcswGhMUV9g@public.gmane.org) wrote:
> > Yes, this kind of thing should be enable using an flag to inotify1, and
> > be consistant even for rename.  Doing it as a flag to inotify1 also has
> > the advantage to be able to return an -EPERM when the feature is
> > requested but not allowed instead of letting applications that assume it
> > silently fail.
>
> So effectively you propose to have second generation of the inotify
> which will have additional pid field, which will be unused by all but
> the same uid events?

I suspect that Christoph wants the same thing as I do: some thinking
towards a future-proof design, rather than a quick hack to address the
needs of a single application.

> If you want to return -EPERM, than it will be _always_ returned for non
> sysadmin capable user, which effectively makes it unusable.

Again, appropriate flags in inotify_init1() could fix this -- e.g.,
only fill the field (and give an error if no perms) if a flag is set.

I think what is really needed at this point is some consideration of
what other extensions (if any) might be desired for inotify, and how
we might be best create a design that suits those and future needs.

Cheers,

Michael


--
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
--
To unsubscribe from this list: send the line "unsubscribe linux-api" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

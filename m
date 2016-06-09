From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ioctl_ficlonerange.2/ioctl_fideduperange.2: mention
 same-fs requirement
Date: Thu, 9 Jun 2016 10:34:47 -0700
Message-ID: <20160609173447.GA10371@birch.djwong.org>
References: <20160608164040.GB5740@birch.djwong.org>
 <f1f16a4c-046c-ea32-4171-a68f1044f85a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <f1f16a4c-046c-ea32-4171-a68f1044f85a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-man-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-man-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Thu, Jun 09, 2016 at 10:11:42AM +0200, Michael Kerrisk (man-pages) wrote:
> On 06/08/2016 06:40 PM, Darrick J. Wong wrote:
> > Mention that FICLONE, FICLONERANGE, and FIDEDUPERANGE all require both
> > files to reside on the same filesystem.
> 
> Thanks, Darrick. Applied.
> 
> I sees there's also some small problems with the page licenses in these
> two new pages: the markup "VERBATIM" is wrong. And you don't mention 
> the GPL version.
> 
> Can I suggest either changing the license to the real "verbatim" 
> license (https://www.kernel.org/doc/man-pages/licenses.html#verbatim),
> or to a GPL with version (see 
> https://www.kernel.org/doc/man-pages/licenses.html#gpl

Oops, that was a bad thinko on my part.  Will send a patch
changing it to GPLv2+ shortly.  A big thank you for pointing
this out!

--D

> 
> Cheers,
> 
> Michael
> 
> 
> > Signed-off-by: Darrick J. Wong <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> >  man2/ioctl_ficlonerange.2  |    1 +
> >  man2/ioctl_fideduperange.2 |    1 +
> >  2 files changed, 2 insertions(+)
> > 
> > diff --git a/man2/ioctl_ficlonerange.2 b/man2/ioctl_ficlonerange.2
> > index 0cb1567..c6e0762 100644
> > --- a/man2/ioctl_ficlonerange.2
> > +++ b/man2/ioctl_ficlonerange.2
> > @@ -36,6 +36,7 @@ file appear in the
> >  .I dest_fd
> >  file by sharing the underlying storage, which is faster than making a separate
> >  physical copy of the data.
> > +Both files must reside within the same filesystem.
> >  If a file write should occur to a shared region,
> >  the filesystem must ensure that the changes remain private to the file being
> >  written.
> > diff --git a/man2/ioctl_fideduperange.2 b/man2/ioctl_fideduperange.2
> > index c69f8c5..44a7765 100644
> > --- a/man2/ioctl_fideduperange.2
> > +++ b/man2/ioctl_fideduperange.2
> > @@ -34,6 +34,7 @@ file appear in the
> >  .B dest_fd
> >  file by sharing the underlying storage if the file data is identical
> >  ("deduplication").
> > +Both files must reside within the same filesystem.
> >  This reduces storage consumption by allowing the filesystem
> >  to store one shared copy of the data.
> >  If a file write should occur to a shared
> > 
> 
> 
> -- 
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/
--
To unsubscribe from this list: send the line "unsubscribe linux-man" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

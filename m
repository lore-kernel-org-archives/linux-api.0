From: "Darrick J. Wong" <darrick.wong-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: ioctl manpages?
Date: Tue, 15 Dec 2015 12:48:54 -0800
Message-ID: <20151215204854.GC10897@birch.djwong.org>
References: <20151215083358.GE10584@birch.djwong.org>
 <566FFF36.4060103@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <566FFF36.4060103-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Dec 15, 2015 at 12:53:26PM +0100, Michael Kerrisk (man-pages) wrote:
> Hello Darrick,
> 
> On 12/15/2015 09:33 AM, Darrick J. Wong wrote:
> > Hi,
> > 
> > Just out of curiosity, how does one submit manpages for specific
> > ioctls?  There's a manpage for ioctl() itself, but I can't find
> > anything for things like, say, FIEMAP or FICLONE or FICLONERANGE.
> > I guess they'd be section 2, right?
> 
> Yes. (And it sure would be nice to see some of those documented.
> Is this an offer? :-) )

Yep.  Given that we're hoisting clone, clone-range, and (hopefully) dedupe into
the VFS, it seems like a good time to document how they work.

> > Something like /usr/share/man/man2/ficlone.2.gz?  Or a separate
> > ioctl-ficlone.2.gz, just in case there's ever a ficlone syscall?
> 
> We already have ioctl_fat.2 and ioctl_list.2, so I'd say 
> ioctl_ficlone.2 and so on.

Aha, out of date manpages git repo. :(  So there are ioctl manpages after all!

Ok, horrifying troff spaghetti will follow soon.

--D

> 
> Cheers,
> 
> Michael
> 
> 
> 
> -- 
> Michael Kerrisk
> Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
> Linux/UNIX System Programming Training: http://man7.org/training/

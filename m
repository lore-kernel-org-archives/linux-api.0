From: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 1/4] statx: Add a system call to make enhanced file info
 available
Date: Sat, 19 Nov 2016 09:17:28 +1100
Message-ID: <20161118221728.GD31101@dastard>
References: <20161118212725.GA31101@dastard>
 <20161117234047.GE28177@dastard>
 <147938969703.13574.10295364502230379833.stgit@warthog.procyon.org.uk>
 <147938970382.13574.11581172952175034619.stgit@warthog.procyon.org.uk>
 <27040.1479464944@warthog.procyon.org.uk>
 <9903.1479505701@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <9903.1479505701-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Fri, Nov 18, 2016 at 09:48:21PM +0000, David Howells wrote:
> Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org> wrote:
> 
> > > Btw, can you point me at the manpage that defines the fsxattr struct and its
> > > flags?
> > 
> > man xfsctl is the original source. However, ....
> 
> 	warthog>man xfsctl
> 	No manual entry for xfsctl
> 
> This should be in the kernel manpages repo since it's kernel UAPI.

"original source" is where the API came from - that's
XFS_IOC_FSGETXATTR - and xfsctl from xfsprogs is where that was
documented. That page documents a bunch of other XFS specific
ioctls, too, so it is appropriately located.

Like I said, I thought patches had been sent to Michael to lift the
FS_IOC_FSGETXATTR documentation from this page into the official
linux man pages package. If not, that can be chased up separately,
but the XFS ioctl man page certainly does not belong there.

Cheers,

Dave.
-- 
Dave Chinner
david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org

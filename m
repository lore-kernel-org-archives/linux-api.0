From: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Subject: Re: Request for comments: reserving a value for O_SEARCH and O_EXEC
Date: Tue, 6 Aug 2013 10:36:10 -0400
Message-ID: <20130806143609.GV221@brightrain.aerifal.cx>
References: <20130805222544.GA19168@brightrain.aerifal.cx>
 <20130806055425.GA9280@lst.de>
 <20130806134254.GT221@brightrain.aerifal.cx>
 <20130806140321.GA4421@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130806140321.GA4421-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Aug 06, 2013 at 04:03:21PM +0200, Christoph Hellwig wrote:
> On Tue, Aug 06, 2013 at 09:42:54AM -0400, Rich Felker wrote:
> > > As told you earlier on linux-kernel just send a patch with your semantics
> > 
> > Apologies, I did not see the reply, and I'm still looking for it. I
> > should have put the request to CC me more prominently in the email...
> 
> Sorry, it actually was libc-alpha that I replied to.  I didn't notice
> you sent two slightly different messages instead of a having a cross-posted
> discussion, which would have been more useful.

I agree totally. That's why I cross-posted this new thread.

> > > to lkml.  We're not going to reserve a value for a namespace that is
> > > reserved for the kernel to implement something that should better
> > > be done in kernel space.
> > 
> > Did you mean "that should better be done in user space"?
> 
> No.  It should be done in kernelspace, just like all other O_ flags.

OK, I was just confused by your wording.

> > Whether O_SEARCH and O_EXEC are provided fully natively by the kernel
> > or handled by userspace, either way a reserved value in the open flags
> > must be set aside. Otherwise any value used by the userspace
> > implementation would risk conflicting with future kernel features
> > using the same bit(s).
> 
> No flag is going to get reserved without a proper (kernel-level)
> implementation.

This is frustrating because early on in the O_PATH discussions on LKML
when it was first added, there were requests for O_SEARCH and O_EXEC
semantics in the kernel, and these requests were rejected with the
response being roughly "you can do it in userspace using the more
general O_PATH approach". So we have two contradictory conditions:

- O_SEARCH/O_EXEC semantics won't be added in the kernel because you
  can do it in userspace with O_PATH.

- O_SEARCH/O_EXEC can't be added in userspace because they can't be
  assigned a value without having an implementation in kernelspace.

If there's a willingness to override/drop that previous decision
(which I believe Linus was in on, but I'd have to search for the old
threads again) then I can propose a patch. As far as I can tell, the
simplest implementation would be to follow the O_PATH code path but
include a check for this new mode and fail at the point of opening a
symlink where O_NOFOLLOW is processed. I am not sufficiently familiar
with this code to write the patch yet, but I can try to learn it. My
guess is that the patch would be less than 20 lines, half of it being
a change for the top-level O_PATH logic in openat that strips other
flags when O_PATH is present and half of it being 

If I do this, do you have a recommendation on the value to use? My
guess for the best choice would be O_PATH|3, so that O_PATH, O_SEARCH,
O_EXEC, O_RDONLY, O_WRONLY, and O_RDWR can all fall under O_ACCMODE
without adding more than one bit to O_ACCMODE. If we do it this way,
the patch should also make it so the extra bits (bits 0 and 1) set at
open time should be preserved when fcntl(F_GETFL) is called so that
the application correctly sees the access mode it requested.

Really, my preference would be if O_PATH could be changed to honor
O_NOFOLLOW just like other open types, and a new O_SYMLINK could be
added to open the link itself, but this would be an incompatible
change in the kernel API and I fully agree that would not be
appropriate.

Rich

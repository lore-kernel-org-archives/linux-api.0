From: Rich Felker <dalias-/miJ2pyFWUyWIDz0JBNUog@public.gmane.org>
Subject: Re: Request for comments: reserving a value for O_SEARCH and O_EXEC
Date: Tue, 6 Aug 2013 09:42:54 -0400
Message-ID: <20130806134254.GT221@brightrain.aerifal.cx>
References: <20130805222544.GA19168@brightrain.aerifal.cx>
 <20130806055425.GA9280@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130806055425.GA9280-jcswGhMUV9g@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Joseph S. Myers" <joseph-qD8j1LwMmJjtCj0u4l0SBw@public.gmane.org>, libc-alpha-9JcytcrH/bA+uJoB2kUjGw@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Tue, Aug 06, 2013 at 07:54:25AM +0200, Christoph Hellwig wrote:
> On Mon, Aug 05, 2013 at 06:25:44PM -0400, Rich Felker wrote:
> > Hi,
> > 
> > [I'm resending this to linux-api instead of linux-kernel on the advice
> > of Joseph Myers on libc-alpha. Please see the link to the libc-alpha
> > thread at the bottom of this message for discussion that has already
> > taken place.]
> 
> As told you earlier on linux-kernel just send a patch with your semantics

Apologies, I did not see the reply, and I'm still looking for it. I
should have put the request to CC me more prominently in the email...

> to lkml.  We're not going to reserve a value for a namespace that is
> reserved for the kernel to implement something that should better
> be done in kernel space.

Did you mean "that should better be done in user space"?

Whether O_SEARCH and O_EXEC are provided fully natively by the kernel
or handled by userspace, either way a reserved value in the open flags
must be set aside. Otherwise any value used by the userspace
implementation would risk conflicting with future kernel features
using the same bit(s).

I fully understand that the kernel folks may not want to put O_SEARCH
and O_EXEC specific semantics in the kernel when O_PATH can, with some
trivial additional code in userspace, provide what's needed already.
This is why, at this time, I'm requesting a reserved value and not
trying to push code into the kernel.

Rich

From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v7] scsi: ufs: add ioctl interface for query request
Date: Thu, 10 Mar 2016 20:19:32 +0100
Message-ID: <201603102019.32467.arnd@arndb.de>
References: <1457532699-11487-1-git-send-email-ygardi@codeaurora.org> <046fc2d00e51f331a6bbc00553cc1f9c.squirrel@us.codeaurora.org> <201603101818.33826.arnd@arndb.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201603101818.33826.arnd-r2nGTMty4D4@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org
Cc: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, james.bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-arm-msm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, santoshsy-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-scsi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dolev Raviv <draviv-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Gilad Broner <gbroner-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Vinayak Holikatti <vinholikatti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "James E.J. Bottomley" <jbottomley-wo1vFcy6AUs@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Michael Neuling <mikey-/owAOxkjmzZAfugRpC6u6w@public.gmane.org>, "Matthew R. Ochs" <mrochs-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Wen Xiong <wenxiong-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Subhash Jadavani <subhashj-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "open list:ABI/API" <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Thursday 10 March 2016, Arnd Bergmann wrote:
> On Wednesday 09 March 2016, ygardi-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org wrote:
> > Any userspace application can be a tool.
> > We already implemented and used a user space application, that sent
> > queries to the UFS devices in order to get information and descriptors.
> > Not only ioctl interface is a useful way to interact with the device,
> > we used it, and found it very helpful in varies cases.
> > hence, this patch.
> > This patch has been already addressed all comments of Arnd Bergman from 5
> > months ago, and now, re-uploaded again.
> 
> Do you have a pointer to that review? It's been a long while, so I
> have completely forgotten what issues I raised and how it got resolved.

I got your link in private message and read up on it again now.

To clarify: I commented on the formal API definition, and you indeed addressed
all my concerns, so this is now an ioctl command that follows our usual
calling conventions.

However, this is orthogonal to the question of whether it is a good idea
to have this interface implemented as an ioctl as asked by Greg, and who
is actually using it. 

I'm lacking the detailed subsystem knowledge to answer this, but
I note that other block drivers have similar passthrough interfaces.

Looking through what other drivers do, I've found a couple of patterns
now. n particular, most use the SG_IO ioctl to pass down commands
from user space into a device specific command queue. Have you looked
at that interface in the past to see if it would fit your use case?

There is also a 'bsg' API that some drivers implement, which I think
would be another alternative.

Could any of the SCSI experts comment on what they expect a driver
to use out of those three alternatives (if any): 

* private ioctl
* bsg
* sg_io

	Arnd

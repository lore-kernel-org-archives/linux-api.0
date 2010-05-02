From: Matt Helsley <matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v21 001/100] eclone (1/11): Factor out code to allocate
 pidmap page
Date: Sat, 1 May 2010 17:25:13 -0700
Message-ID: <20100502002513.GC31830@count0.beaverton.ibm.com>
References: <1272723382-19470-1-git-send-email-orenl@cs.columbia.edu>
 <1272723382-19470-2-git-send-email-orenl@cs.columbia.edu>
 <20100501.151022.190375136.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100501.151022.190375136.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: orenl-eQaUEPhvms7ENvBUuze7eA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, serue-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, matthltc-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, sukadev-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxppc-dev-mnsaURCQ41sdnm+yROfE0A@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Sat, May 01, 2010 at 03:10:22PM -0700, David Miller wrote:
> NO WAY, there is no way in the world you should post 100 patches
> at a time to any mailing list, especially those at vger.kernel.org
> that have thousands upon thousands of subscribers.

I am sorry we concluded that sending these 100 patches at once was a
good idea. I will try, again, to find ways to divide the
set up into more manageable pieces. Regardless of how that goes
the whole set will not be submitted to LKML/vger all at once in the
future.

If anyone would like to offer more specific constructive suggestions
on subdividing the patches I'd be happy to try them.

That said, for anyone who's curious, we faced a few dilemmas which
pointed us down the wrong path here.

http://lkml.org/lkml/2010/3/1/422

Specifically the last part is rather hard to misinterpret:

"I'd suggest waiting until very shortly after 2.6.34-rc1 then please
send all the patches onto the list and let's get to work."

(ok, it's not shortly after 2.6.34-rc1 -- we were asked to reorganize
the code and we did...)

But even if one decides to ignore the common sense interpretation of
Andrew's reply there was more:

Standard procedure is to post to LKML when pushing patches upstream.

We were asked to create a useful implementation of checkpoint/restart
yet when we tried to submit a digestable piece we were told that
submitting it by itself was pointless (eclone). The rest of the code
was even more checkpoint/restart-specific so the same logic seemed to
apply.

We have public git trees and used the containers@ mailing list to post
patches for review but rarely received outside feedback on patches
there. Not even requests to divide the set.

So clearly we needed to post to relevant external lists and
reviewers. We tried that earlier and received complaints that lists
hadn't been Cc'd on some of the patches (e.g. fsdevel). So clearly we
needed to expand the Cc list for v21.

We looked at dividing the set but it always came down to trimming
functionality -- this conflicted with the "useful implementation"
we were asked for.

In summary: We've been given a fair number of conflicting instructions
		and we failed to find the right balance in following them.

> Post only small, well contained, sets of patches at a time.  At most
> 10 or so in one go.

We've tried to keep the individual patches small and reviewable. That
has the opposite effect on patch count unfortunately.

>
> Do you realize how much mail traffic you generate by posting so many
> patches at one time, and how unlikely it is for anyone to actually
> sift through and review your patches after you've spammed them by
> posting so many at one time?
>
> A second infraction and I will have no choice but to block you at the
> SMTP level at vger.kernel.org so please do not do it again.

We will not post nearly this many at once again.

I'm thinking we'll just provide URLs to git trees or quilt series
if subdividing is impossible and/or anyone needs wider context than
the 10 or so we post at a time.

Sorry again,
	-Matt Helsley

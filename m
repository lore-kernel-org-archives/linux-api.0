From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] mmap.2: clarify MAP_LOCKED semantic
Date: Wed, 11 May 2016 13:32:29 +0200
Message-ID: <20160511113228.GJ16677@dhcp22.suse.cz>
References: <1431527892-2996-1-git-send-email-miso@dhcp22.suse.cz>
 <1431527892-2996-2-git-send-email-miso@dhcp22.suse.cz>
 <57331275.9000805@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57331275.9000805-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 11-05-16 13:07:33, Peter Zijlstra wrote:
> 
> 
> On 05/13/2015 04:38 PM, Michal Hocko wrote:
> > From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> > 
> > MAP_LOCKED had a subtly different semantic from mmap(2)+mlock(2) since
> > it has been introduced.
> > mlock(2) fails if the memory range cannot get populated to guarantee
> > that no future major faults will happen on the range. mmap(MAP_LOCKED) on
> > the other hand silently succeeds even if the range was populated only
> > partially.
> > 
> > Fixing this subtle difference in the kernel is rather awkward because
> > the memory population happens after mm locks have been dropped and so
> > the cleanup before returning failure (munlock) could operate on something
> > else than the originally mapped area.
> > 
> > E.g. speculative userspace page fault handler catching SEGV and doing
> > mmap(fault_addr, MAP_FIXED|MAP_LOCKED) might discard portion of a racing
> > mmap and lead to lost data. Although it is not clear whether such a
> > usage would be valid, mmap page doesn't explicitly describe requirements
> > for threaded applications so we cannot exclude this possibility.
> > 
> > This patch makes the semantic of MAP_LOCKED explicit and suggest using
> > mmap + mlock as the only way to guarantee no later major page faults.
> > 
> 
> URGH, this really blows chunks. It basically means MAP_LOCKED is pointless
> cruft and we might as well remove it.

Yeah, the usefulness of MAP_LOCKED is somehow reduced. Everybody who
wants the full semantic really have to use mlock(2).

> Why not fix it proper?

I have tried but it turned out to be a problem because we are dropping
mmap_sem after we initialized VMA and as Linus pointed out there
are multithreaded applications which are doing opportunistic memory
management[1]. So we would have to hold the mmap_sem for write during
the whole VMA setup + population and that doesn't seem to be worth
all the trouble when we are even not sure whether somebody relies on
MAP_LOCKED to have the hard mlock semantic.

---
[1] http://lkml.kernel.org/r/CA+55aFydkG-BgZzry5DrTzueVh9VvEcVJdLV8iOyUphQk=0vpw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
-- 
Michal Hocko
SUSE Labs

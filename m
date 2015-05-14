From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/2] mmap.2: clarify MAP_LOCKED semantic
Date: Thu, 14 May 2015 10:01:45 +0200
Message-ID: <20150514080145.GB6433@dhcp22.suse.cz>
References: <1431527892-2996-1-git-send-email-miso@dhcp22.suse.cz>
 <1431527892-2996-2-git-send-email-miso@dhcp22.suse.cz>
 <20150513144506.GD1227@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150513144506.GD1227-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 13-05-15 10:45:06, Eric B Munson wrote:
> On Wed, 13 May 2015, Michal Hocko wrote:
> 
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
> > Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> 
> Does the problem still happend when MAP_POPULATE | MAP_LOCKED is used
> (AFAICT MAP_POPULATE will cause the mmap to fail if all the pages cannot
> be made present).

No, there is no difference because MAP_POPULATE is implicit when
MAP_LOCKED is used and as pointed in the cover, we cannot fail after the
vma is created and locks dropped. The second patch tries to clarify that
MAP_POPULATE is just a best effort.

> Either way this is a good catch.
> 
> Acked-by: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
 
Thanks!


-- 
Michal Hocko
SUSE Labs

From: Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: introduce MADV_CLR_HUGEPAGE
Date: Tue, 30 May 2017 16:04:56 +0200
Message-ID: <20170530140456.GA8412@redhat.com>
References: <20170522142927.GG27382@rapoport-lnx>
 <a9e74c22-1a07-f49a-42b5-497fee85e9c9@suse.cz>
 <20170524075043.GB3063@rapoport-lnx>
 <c59a0893-d370-130b-5c33-d567a4621903@suse.cz>
 <20170524103947.GC3063@rapoport-lnx>
 <20170524111800.GD14733@dhcp22.suse.cz>
 <20170524142735.GF3063@rapoport-lnx>
 <20170530074408.GA7969@dhcp22.suse.cz>
 <20170530101921.GA25738@rapoport-lnx>
 <20170530103930.GB7969@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170530103930.GB7969-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Rapoport <rppt-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Pavel Emelyanov <xemul-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Tue, May 30, 2017 at 12:39:30PM +0200, Michal Hocko wrote:
> On Tue 30-05-17 13:19:22, Mike Rapoport wrote:
> > On Tue, May 30, 2017 at 09:44:08AM +0200, Michal Hocko wrote:
> > > On Wed 24-05-17 17:27:36, Mike Rapoport wrote:
> > > > On Wed, May 24, 2017 at 01:18:00PM +0200, Michal Hocko wrote:
> > > [...]
> > > > > Why cannot khugepaged simply skip over all VMAs which have userfault
> > > > > regions registered? This would sound like a less error prone approach to
> > > > > me.
> > > > 
> > > > khugepaged does skip over VMAs which have userfault. We could register the
> > > > regions with userfault before populating them to avoid collapses in the
> > > > transition period.
> > > 
> > > Why cannot you register only post-copy regions and "manually" copy the
> > > pre-copy parts?
> > 
> > We can register only post-copy regions, but this will cause VMA
> > fragmentation. Now we register the entire VMA with userfaultfd, no matter
> > how many pages were dirtied there since the pre-dump. If we register only
> > post-copy regions, we will split out the VMAs for those regions.
> 
> Is this really a problem, though?

It would eventually get -ENOMEM or at best create lots of unnecessary
vmas (at least UFFDIO_COPY would never risk to trigger -ENOMEM).

The only attractive alternative is to use UFFDIO_COPY for precopy too
after pre-registering the whole range in uffd (which would happen
later anyway to start postcopy).

> It would be good to measure that though. You are proposing a new user
> API and the THP api is quite convoluted already so there better be a
> very good reason to add a new API. So far I can only see that it would
> be more convinient to add another madvise command and that is rather
> insufficient justification IMHO. Also do you expect somebody else would
> use new madvise? What would be the usecase?

UFFDIO_COPY while not being a major slowdown for sure, it's likely
measurable at the microbenchmark level because it would add a
enter/exit kernel to every 4k memcpy. It's not hard to imagine that as
measurable. How that impacts the total precopy time I don't know, it
would need to be benchmarked to be sure. The main benefit of this
madvise is precisely to skip those enter/exit kernel that UFFDIO_COPY
would add. Even if the impact on the total precopy time wouldn't be
measurable (i.e. if it's network bound load), the madvise that allows
using memcpy after setting VM_NOHUGEPAGE, would free up some CPU
cycles in the destination that could be used by other processes.

About the proposed madvise, it just clear bits, but it doesn't change
at all how those bits are computed in THP code. So I don't see it as
convoluted.

If it would add new bits to be computed it would add to the
complexity. Just clearing the same bits that already exists without
altering how they're computed, doesn't move the needle in terms of
complexity. If it wasn't the case the "operational" part of the patch
wouldn't be just a one liner.

+               *vm_flags &= ~(VM_HUGEPAGE | VM_NOHUGEPAGE);

Thanks,
Andrea

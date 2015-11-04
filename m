From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 5/8] mm: move lazily freed pages to inactive list
Date: Wed, 4 Nov 2015 17:55:27 -0500
Message-ID: <20151104225527.GA25941@cmpxchg.org>
References: <1446188504-28023-1-git-send-email-minchan@kernel.org>
 <1446188504-28023-6-git-send-email-minchan@kernel.org>
 <20151104205504.GA9927@cmpxchg.org>
 <563A7D21.6040505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <563A7D21.6040505-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Wang, Yalin" <Yalin.Wang-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed, Nov 04, 2015 at 04:48:17PM -0500, Daniel Micay wrote:
> > Even if we're wrong about the aging of those MADV_FREE pages, their
> > contents are invalidated; they can be discarded freely, and restoring
> > them is a mere GFP_ZERO allocation. All other anonymous pages have to
> > be written to disk, and potentially be read back.
> > 
> > [ Arguably, MADV_FREE pages should even be reclaimed before inactive
> >   page cache. It's the same cost to discard both types of pages, but
> >   restoring page cache involves IO. ]
> 
> Keep in mind that this is memory the kernel wouldn't be getting back at
> all if the allocator wasn't going out of the way to purge it, and they
> aren't going to go out of their way to purge it if it means the kernel
> is going to steal the pages when there isn't actually memory pressure.

Well, obviously you'd still only reclaim them on memory pressure. I'm
only talking about where these pages should go on the LRU hierarchy.

> > It probably makes sense to stop thinking about them as anonymous pages
> > entirely at this point when it comes to aging. They're really not. The
> > LRU lists are split to differentiate access patterns and cost of page
> > stealing (and restoring). From that angle, MADV_FREE pages really have
> > nothing in common with in-use anonymous pages, and so they shouldn't
> > be on the same LRU list.
> > 
> > That would also fix the very unfortunate and unexpected consequence of
> > tying the lazy free optimization to the availability of swap space.
> > 
> > I would prefer to see this addressed before the code goes upstream.
> 
> I don't think it would be ideal for these potentially very hot pages to
> be dropped before very cold pages were swapped out. It's the kind of
> tuning that needs to be informed by lots of real world experience and
> lots of testing. It wouldn't impact the API.

What about them is hot? They contain garbage, you have to write to
them before you can use them. Granted, you might have to refetch
cachelines if you don't do cacheline-aligned populating writes, but
you can do a lot of them before it's more expensive than doing IO.

> Whether MADV_FREE is useful as an API vs. something like a pair of
> system calls for pinning and unpinning memory is what should be worried
> about right now. The internal implementation just needs to be correct
> and useful right now, not perfect. Simpler is probably better than it
> being more well tuned for an initial implementation too.

Yes, it wouldn't impact the API, but the dependency on swap is very
random from a user experience and severely limits the usefulness of
this. It should probably be addressed before this gets released. As
this involves getting the pages off the anon LRU, we need to figure
out where they should go instead.

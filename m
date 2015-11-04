From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 5/8] mm: move lazily freed pages to inactive list
Date: Wed, 4 Nov 2015 15:55:04 -0500
Message-ID: <20151104205504.GA9927@cmpxchg.org>
References: <1446188504-28023-1-git-send-email-minchan@kernel.org>
 <1446188504-28023-6-git-send-email-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1446188504-28023-6-git-send-email-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Wang, Yalin" <Yalin.Wang-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, Oct 30, 2015 at 04:01:41PM +0900, Minchan Kim wrote:
> MADV_FREE is a hint that it's okay to discard pages if there is memory
> pressure and we use reclaimers(ie, kswapd and direct reclaim) to free them
> so there is no value keeping them in the active anonymous LRU so this
> patch moves them to inactive LRU list's head.
> 
> This means that MADV_FREE-ed pages which were living on the inactive list
> are reclaimed first because they are more likely to be cold rather than
> recently active pages.
> 
> An arguable issue for the approach would be whether we should put the page
> to the head or tail of the inactive list.  I chose head because the kernel
> cannot make sure it's really cold or warm for every MADV_FREE usecase but
> at least we know it's not *hot*, so landing of inactive head would be a
> comprimise for various usecases.

Even if we're wrong about the aging of those MADV_FREE pages, their
contents are invalidated; they can be discarded freely, and restoring
them is a mere GFP_ZERO allocation. All other anonymous pages have to
be written to disk, and potentially be read back.

[ Arguably, MADV_FREE pages should even be reclaimed before inactive
  page cache. It's the same cost to discard both types of pages, but
  restoring page cache involves IO. ]

It probably makes sense to stop thinking about them as anonymous pages
entirely at this point when it comes to aging. They're really not. The
LRU lists are split to differentiate access patterns and cost of page
stealing (and restoring). From that angle, MADV_FREE pages really have
nothing in common with in-use anonymous pages, and so they shouldn't
be on the same LRU list.

That would also fix the very unfortunate and unexpected consequence of
tying the lazy free optimization to the availability of swap space.

I would prefer to see this addressed before the code goes upstream.

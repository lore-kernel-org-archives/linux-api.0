From: Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 5/8] mm: move lazily freed pages to inactive list
Date: Fri, 30 Oct 2015 10:22:12 -0700
Message-ID: <20151030172212.GB44946@kernel.org>
References: <1446188504-28023-1-git-send-email-minchan@kernel.org>
 <1446188504-28023-6-git-send-email-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1446188504-28023-6-git-send-email-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, "Wang, Yalin" <Yalin.Wang-/MT0OVThwyLZJqsBc5GL+g@public.gmane.org>
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
> 
> This fixes suboptimal behavior of MADV_FREE when pages living on the
> active list will sit there for a long time even under memory pressure
> while the inactive list is reclaimed heavily.  This basically breaks the
> whole purpose of using MADV_FREE to help the system to free memory which
> is might not be used.

My main concern is the policy how we should treat the FREE pages. Moving it to
inactive lru is definitionly a good start, I'm wondering if it's enough. The
MADV_FREE increases memory pressure and cause unnecessary reclaim because of
the lazy memory free. While MADV_FREE is intended to be a better replacement of
MADV_DONTNEED, MADV_DONTNEED doesn't have the memory pressure issue as it free
memory immediately. So I hope the MADV_FREE doesn't have impact on memory
pressure too. I'm thinking of adding an extra lru list and wartermark for this
to make sure FREE pages can be freed before system wide page reclaim. As you
said, this is arguable, but I hope we can discuss about this issue more.

Or do you want to push this first and address the policy issue later?

Thanks,
Shaohua

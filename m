From: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/8] MADV_FREE support
Date: Sat, 31 Oct 2015 21:51:15 -0700 (PDT)
Message-ID: <alpine.DEB.2.10.1510312142560.10406@chino.kir.corp.google.com>
References: <1446188504-28023-1-git-send-email-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1446188504-28023-1-git-send-email-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri, 30 Oct 2015, Minchan Kim wrote:

> MADV_FREE is on linux-next so long time. The reason was two, I think.
> 
> 1. MADV_FREE code on reclaim path was really mess.
> 
> 2. Andrew really want to see voice of userland people who want to use
>    the syscall.
> 
> A few month ago, Daniel Micay(jemalloc active contributor) requested me
> to make progress upstreaming but I was busy at that time so it took
> so long time for me to revist the code and finally, I clean it up the
> mess recently so it solves the #2 issue.
> 
> As well, Daniel and Jason(jemalloc maintainer) requested it to Andrew
> again recently and they said it would be great to have even though
> it has swap dependency now so Andrew decided he will do that for v4.4.
> 

First, thanks very much for refreshing the patchset and reposting after a 
series of changes have been periodically added to -mm, it makes it much 
easier.

For tcmalloc, we can do some things in the allocator itself to increase 
the amount of memory backed by thp.  Specifically, we can prefer to 
release Spans to pageblocks that are already not backed by thp so there is 
no additional split on each scavenge.  This is somewhat easy if all memory 
is organized into hugepage-aligned pageblocks in the allocator itself.  
Second, we can prefer to release Spans of longer length on each scavenge 
so we can delay scavenging for as long as possible in a hope we can find 
more pages to coalesce.  Third, we can discount refaulted released memory 
from the scavenging period.

That significantly improves the amount of memory backed by thp for 
tcmalloc.  The problem, however, is that tcmalloc uses MADV_DONTNEED to 
release memory to the system and MADV_FREE wouldn't help at all in a 
swapless environment.

To combat that, I've proposed a new MADV bit that simply caches the 
ranges freed by the allocator per vma and places them on both a per-vma 
and per-memcg list.  During reclaim, this list is iterated and ptes are 
freed after thp split period to the normal directed reclaim.  Without 
memory pressure, this backs 100% of the heap with thp with a relatively 
lightweight kernel change (the majority is vma manipulation on split) and 
a couple line change to tcmalloc.  When pulling memory from the returned 
freelists, the memory that we have MADV_DONTNEED'd, we need to use another 
MADV bit to remove it from this cache, so there is a second madvise(2) 
syscall involved but the freeing call is much less expensive since there 
is no pagetable walk without memory pressure or synchronous thp split.

I've been looking at MADV_FREE to see if there is common ground that could 
be shared, but perhaps it's just easier to ask what your proposed strategy 
is so that tcmalloc users, especially those in swapless environments, 
would benefit from any of your work?

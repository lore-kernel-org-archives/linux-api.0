From: David Rientjes <rientjes@google.com>
Subject: Re: [PATCH 0/8] MADV_FREE support
Date: Wed, 4 Nov 2015 12:19:19 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1511041209540.3769@chino.kir.corp.google.com>
References: <1446188504-28023-1-git-send-email-minchan@kernel.org> <alpine.DEB.2.10.1510312142560.10406@chino.kir.corp.google.com> <5635B159.8030307@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <5635B159.8030307@gmail.com>
Sender: owner-linux-mm@kvack.org
To: Daniel Micay <danielmicay@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Michael Kerrisk <mtk.manpages@gmail.com>, linux-api@vger.kernel.org, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, zhangyanfei@cn.fujitsu.com, Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>, KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, Jason Evans <je@fb.com>, "Kirill A. Shutemov" <kirill@shutemov.name>, Michal Hocko <mhocko@suse.cz>, yalin.wang2010@gmail.com, Shaohua Li <shli@kernel.org>
List-Id: linux-api@vger.kernel.org

On Sun, 1 Nov 2015, Daniel Micay wrote:

> It can definitely be improved to cooperate well with THP too. I've been
> following the progress, and most of the problems seem to have been with
> the THP and that's a very active area of development. Seems best to deal
> with that after a simple, working implementation lands.
> 
> The best aspect of MADV_FREE is that it completely avoids page faults
> when there's no memory pressure. Making use of the freed memory only
> triggers page faults if the pages had to be dropped because the system
> ran out of memory. It also avoids needing to zero the pages. The memory
> can also still be freed at any time if there's memory pressure again
> even if it's handed out as an allocation until it's actually touched.
> 
> The call to madvise still has significant overhead, but it's much
> cheaper than MADV_DONTNEED. Allocators will be able to lean on the
> kernel to make good decisions rather than implementing lazy freeing
> entirely on their own. It should improve performance *and* behavior
> under memory pressure since allocators can be more aggressive with it
> than MADV_DONTNEED.
> 
> A nice future improvement would be landing MADV_FREE_UNDO feature to
> allow an attempt to pin the pages in memory again. It would make this
> work very well for implementing caches that are dropped under memory
> pressure. Windows has this via MEM_RESET (essentially MADV_FREE) and
> MEM_RESET_UNDO. Android has it for ashmem too (pinning/unpinning). I
> think browser vendors would be very interested in it.
> 

This sounds similar to what I was proposing to prevent thp splits when 
there is no memory pressure.

MADV_SPLITTABLE marks ranges of memory as free and the underlying thp may 
be split if there is no memory pressure.  Under memory pressure, it acts 
identical to MADV_DONTNEED.  Without memory pressure, the range is 
enqueued on an lru for the memcg that the vma's mm owner belongs to 
(global for !CONFIG_MEMCG).  It is also linked on a per-vma list for the 
range.  Anytime the vma is manipulated, the MADV_SPLITTABLE ranges are 
also fixed up.

On subsequent memory pressure, the memcg hierarchy lru list is iterated 
(global for !CONFIG_MEMCG) and the MADV_SPLITTABLE ranges are actually 
zapped (including thp split if necessary) and the memory is really freed 
to the system.

MADV_UNSPLITTABLE marks ranges of memory that have already been freed 
through MADV_SPLITTABLE as being used again.  If there was no memory 
pressure and the MADV_SPLITTABLE was simply enqueued on the lru list, it 
is removed from that list after the range has been zeroed with the same 
user-facing semantics as MADV_DONTNEED.  Otherwise, nothing is done since 
the ptes are already zapped and we'll incur a refault.

The change to tcmalloc is simple: use MADV_SPLITTABLE instead of 
MADV_DONTNEED when freeing memory to the system and use MADV_UNSPLITTABLE 
when returning memory that has been already freed to the system.

This works well in experimentation when 100% of heap backed by thp with no 
memory pressure.  This is a type of lazy-free that prevents thp memory 
from being split without memory pressure.

I was wondering if this could become part of MADV_FREE behavior with the 
MADV_FREE_UNDO behavior as the equivalent to my MADV_UNSPLITTABLE.  If 
there is no ground to be shared, mine is just implemented seperately, but 
I'm trying to avoid additional system calls required for malloc 
implemenations.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

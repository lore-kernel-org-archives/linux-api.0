From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFCv2 1/6] mm: introduce MADV_COLD
Date: Fri, 31 May 2019 10:47:52 +0200
Message-ID: <20190531084752.GI6896@dhcp22.suse.cz>
References: <20190531064313.193437-1-minchan@kernel.org>
 <20190531064313.193437-2-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190531064313.193437-2-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, oleksandr@redhat.com, hdanton@sina.com
List-Id: linux-api@vger.kernel.org

On Fri 31-05-19 15:43:08, Minchan Kim wrote:
> When a process expects no accesses to a certain memory range, it could
> give a hint to kernel that the pages can be reclaimed when memory pressure
> happens but data should be preserved for future use.  This could reduce
> workingset eviction so it ends up increasing performance.
> 
> This patch introduces the new MADV_COLD hint to madvise(2) syscall.
> MADV_COLD can be used by a process to mark a memory range as not expected
> to be used in the near future. The hint can help kernel in deciding which
> pages to evict early during memory pressure.
> 
> Internally, it works via deactivating pages from active list to inactive's
> head if the page is private because inactive list could be full of
> used-once pages which are first candidate for the reclaiming and that's a
> reason why MADV_FREE move pages to head of inactive LRU list. Therefore,
> if the memory pressure happens, they will be reclaimed earlier than other
> active pages unless there is no access until the time.

[I am intentionally not looking at the implementation because below
points should be clear from the changelog - sorry about nagging ;)]

What kind of pages can be deactivated? Anonymous/File backed.
Private/shared? If shared, are there any restrictions?

Are there any restrictions on mappings? E.g. what would be an effect of
this operation on hugetlbfs mapping?

Also you are talking about inactive LRU but what kind of LRU is that? Is
it the anonymous LRU? If yes, don't we have the same problem as with the
early MADV_FREE implementation when enough page cache causes that
deactivated anonymous memory doesn't get reclaimed anytime soon. Or
worse never when there is no swap available?
-- 
Michal Hocko
SUSE Labs

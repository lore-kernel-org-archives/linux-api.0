From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFCv2 1/6] mm: introduce MADV_COLD
Date: Mon, 3 Jun 2019 09:16:07 +0200
Message-ID: <20190603071607.GB4531@dhcp22.suse.cz>
References: <20190531064313.193437-1-minchan@kernel.org>
 <20190531064313.193437-2-minchan@kernel.org>
 <20190531084752.GI6896@dhcp22.suse.cz>
 <20190531133904.GC195463@google.com>
 <20190531140332.GT6896@dhcp22.suse.cz>
 <20190531143407.GB216592@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190531143407.GB216592@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, oleksandr@redhat.com, hdanton@sina.com
List-Id: linux-api@vger.kernel.org

On Fri 31-05-19 23:34:07, Minchan Kim wrote:
> On Fri, May 31, 2019 at 04:03:32PM +0200, Michal Hocko wrote:
> > On Fri 31-05-19 22:39:04, Minchan Kim wrote:
> > > On Fri, May 31, 2019 at 10:47:52AM +0200, Michal Hocko wrote:
> > > > On Fri 31-05-19 15:43:08, Minchan Kim wrote:
> > > > > When a process expects no accesses to a certain memory range, it could
> > > > > give a hint to kernel that the pages can be reclaimed when memory pressure
> > > > > happens but data should be preserved for future use.  This could reduce
> > > > > workingset eviction so it ends up increasing performance.
> > > > > 
> > > > > This patch introduces the new MADV_COLD hint to madvise(2) syscall.
> > > > > MADV_COLD can be used by a process to mark a memory range as not expected
> > > > > to be used in the near future. The hint can help kernel in deciding which
> > > > > pages to evict early during memory pressure.
> > > > > 
> > > > > Internally, it works via deactivating pages from active list to inactive's
> > > > > head if the page is private because inactive list could be full of
> > > > > used-once pages which are first candidate for the reclaiming and that's a
> > > > > reason why MADV_FREE move pages to head of inactive LRU list. Therefore,
> > > > > if the memory pressure happens, they will be reclaimed earlier than other
> > > > > active pages unless there is no access until the time.
> > > > 
> > > > [I am intentionally not looking at the implementation because below
> > > > points should be clear from the changelog - sorry about nagging ;)]
> > > > 
> > > > What kind of pages can be deactivated? Anonymous/File backed.
> > > > Private/shared? If shared, are there any restrictions?
> > > 
> > > Both file and private pages could be deactived from each active LRU
> > > to each inactive LRU if the page has one map_count. In other words,
> > > 
> > >     if (page_mapcount(page) <= 1)
> > >         deactivate_page(page);
> > 
> > Why do we restrict to pages that are single mapped?
> 
> Because page table in one of process shared the page would have access bit
> so finally we couldn't reclaim the page. The more process it is shared,
> the more fail to reclaim.

So what? In other words why should it be restricted solely based on the
map count. I can see a reason to restrict based on the access
permissions because we do not want to simplify all sorts of side channel
attacks but memory reclaim is capable of reclaiming shared pages and so
far I haven't heard any sound argument why madvise should skip those.
Again if there are any reasons, then document them in the changelog.
 
[...]

> > Please document this, if this is really a desirable semantic because
> > then you have the same set of problems as we've had with the early
> > MADV_FREE implementation mentioned above.
> 
> IIRC, the problem of MADV_FREE was that we couldn't discard freeable
> pages because VM never scan anonymous LRU with swapless system.
> However, it's not the our case because we should reclaim them, not
> discarding.

Right. But there is still the page cache reclaim. Is it expected that
an explicitly cold memory doesn't get reclaimed because we have a
sufficient amount of page cache (a very common case) and we never age
anonymous memory because of that?

-- 
Michal Hocko
SUSE Labs

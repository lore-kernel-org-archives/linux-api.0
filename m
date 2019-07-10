From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v3 4/5] mm: introduce MADV_PAGEOUT
Date: Wed, 10 Jul 2019 19:48:09 +0900
Message-ID: <20190710104809.GA186559@google.com>
References: <20190627115405.255259-1-minchan@kernel.org>
 <20190627115405.255259-5-minchan@kernel.org>
 <20190709095518.GF26380@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190709095518.GF26380@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com, Dave Hansen <dave.hansen@intel.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Tue, Jul 09, 2019 at 11:55:19AM +0200, Michal Hocko wrote:
> On Thu 27-06-19 20:54:04, Minchan Kim wrote:
> > When a process expects no accesses to a certain memory range
> > for a long time, it could hint kernel that the pages can be
> > reclaimed instantly but data should be preserved for future use.
> > This could reduce workingset eviction so it ends up increasing
> > performance.
> > 
> > This patch introduces the new MADV_PAGEOUT hint to madvise(2)
> > syscall. MADV_PAGEOUT can be used by a process to mark a memory
> > range as not expected to be used for a long time so that kernel
> > reclaims *any LRU* pages instantly. The hint can help kernel in
> > deciding which pages to evict proactively.
> > 
> > - man-page material
> > 
> > MADV_PAGEOUT (since Linux x.x)
> > 
> > Do not expect access in the near future so pages in the specified
> > regions could be reclaimed instantly regardless of memory pressure.
> > Thus, access in the range after successful operation could cause
> > major page fault but never lose the up-to-date contents unlike
> > MADV_DONTNEED.
> 
> > It works for only private anonymous mappings and
> > non-anonymous mappings that belong to files that the calling process
> > could successfully open for writing; otherwise, it could be used for
> > sidechannel attack.
> 
> I would rephrase this way:
> "
> Pages belonging to a shared mapping are only processed if a write access
> is allowed for the calling process.
> "
> 
> I wouldn't really mention side channel attacks for a man page. You can
> mention can_do_mincore check and the side channel prevention in the
> changelog that is not aimed for the man page.

Agree. I will rephrase with one you suggested.
Thanks for the suggestion.

> 
> > MADV_PAGEOUT cannot be applied to locked pages, Huge TLB pages, or
> > VM_PFNMAP pages.
> > 
> > * v2
> >  * add comment about SWAP_CLUSTER_MAX - mhocko
> >  * add permission check to prevent sidechannel attack - mhocko
> >  * add man page stuff - dave
> > 
> > * v1
> >  * change pte to old and rely on the other's reference - hannes
> >  * remove page_mapcount to check shared page - mhocko
> > 
> > * RFC v2
> >  * make reclaim_pages simple via factoring out isolate logic - hannes
> > 
> > * RFCv1
> >  * rename from MADV_COLD to MADV_PAGEOUT - hannes
> >  * bail out if process is being killed - Hillf
> >  * fix reclaim_pages bugs - Hillf
> > 
> > Signed-off-by: Minchan Kim <minchan@kernel.org>
> > ---
> 
> 
> I am still not convinced about the SWAP_CLUSTER_MAX batching and the
> udnerlying OOM argument. Is one pmd worth of pages really an OOM risk?
> Sure you can have many invocations in parallel and that would add on
> but the same might happen with SWAP_CLUSTER_MAX. So I would just remove
> the batching for now and think of it only if we really see this being a
> problem for real. Unless you feel really strong about this, of course.

I don't have the number to support SWAP_CLUSTER_MAX batching for hinting
operations. However, I wanted to be consistent with other LRU batching
logic so that it could affect altogether if someone try to increase
SWAP_CLUSTER_MAX which is more efficienty for batching operation, later.
(AFAIK, someone tried it a few years ago but rollback soon, I couldn't
rebemeber what was the reason at that time, anyway).

> 
> Anyway the patch looks ok to me otherwise.
> 
> Acked-by: Michal Hocko <mhocko@suse.co>

Thanks!

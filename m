From: Minchan Kim <minchan@kernel.org>
Subject: Re: [RFC 3/7] mm: introduce MADV_COLD
Date: Tue, 21 May 2019 18:13:29 +0900
Message-ID: <20190521091329.GB219653@google.com>
References: <20190520035254.57579-1-minchan@kernel.org>
 <20190520035254.57579-4-minchan@kernel.org>
 <20190520082703.GX6836@dhcp22.suse.cz>
 <20190520230038.GD10039@google.com>
 <20190521060820.GB32329@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190521060820.GB32329@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

On Tue, May 21, 2019 at 08:08:20AM +0200, Michal Hocko wrote:
> On Tue 21-05-19 08:00:38, Minchan Kim wrote:
> > On Mon, May 20, 2019 at 10:27:03AM +0200, Michal Hocko wrote:
> > > [Cc linux-api]
> > > 
> > > On Mon 20-05-19 12:52:50, Minchan Kim wrote:
> > > > When a process expects no accesses to a certain memory range
> > > > for a long time, it could hint kernel that the pages can be
> > > > reclaimed instantly but data should be preserved for future use.
> > > > This could reduce workingset eviction so it ends up increasing
> > > > performance.
> > > > 
> > > > This patch introduces the new MADV_COLD hint to madvise(2)
> > > > syscall. MADV_COLD can be used by a process to mark a memory range
> > > > as not expected to be used for a long time. The hint can help
> > > > kernel in deciding which pages to evict proactively.
> > > 
> > > As mentioned in other email this looks like a non-destructive
> > > MADV_DONTNEED alternative.
> > > 
> > > > Internally, it works via reclaiming memory in process context
> > > > the syscall is called. If the page is dirty but backing storage
> > > > is not synchronous device, the written page will be rotate back
> > > > into LRU's tail once the write is done so they will reclaim easily
> > > > when memory pressure happens. If backing storage is
> > > > synchrnous device(e.g., zram), hte page will be reclaimed instantly.
> > > 
> > > Why do we special case async backing storage? Please always try to
> > > explain _why_ the decision is made.
> > 
> > I didn't make any decesion. ;-) That's how current reclaim works to
> > avoid latency of freeing page in interrupt context. I had a patchset
> > to resolve the concern a few years ago but got distracted.
> 
> Please articulate that in the changelog then. Or even do not go into
> implementation details and stick with - reuse the current reclaim
> implementation. If you call out some of the specific details you are
> risking people will start depending on them. The fact that this reuses
> the currect reclaim logic is enough from the review point of view
> because we know that there is no additional special casing to worry
> about.

I should have clarified. I will remove those lines in respin.

> -- 
> Michal Hocko
> SUSE Labs

From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC 1/7] mm: introduce MADV_COOL
Date: Mon, 20 May 2019 10:16:21 +0200
Message-ID: <20190520081621.GV6836@dhcp22.suse.cz>
References: <20190520035254.57579-1-minchan@kernel.org>
 <20190520035254.57579-2-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190520035254.57579-2-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, linux-api@vger.kernel.org
List-Id: linux-api@vger.kernel.org

[CC linux-api]

On Mon 20-05-19 12:52:48, Minchan Kim wrote:
> When a process expects no accesses to a certain memory range
> it could hint kernel that the pages can be reclaimed
> when memory pressure happens but data should be preserved
> for future use.  This could reduce workingset eviction so it
> ends up increasing performance.
> 
> This patch introduces the new MADV_COOL hint to madvise(2)
> syscall. MADV_COOL can be used by a process to mark a memory range
> as not expected to be used in the near future. The hint can help
> kernel in deciding which pages to evict early during memory
> pressure.

I do not want to start naming fight but MADV_COOL sounds a bit
misleading. Everybody thinks his pages are cool ;). Probably MADV_COLD
or MADV_DONTNEED_PRESERVE.

> Internally, it works via deactivating memory from active list to
> inactive's head so when the memory pressure happens, they will be
> reclaimed earlier than other active pages unless there is no
> access until the time.

Could you elaborate about the decision to move to the head rather than
tail? What should happen to inactive pages? Should we move them to the
tail? Your implementation seems to ignore those completely. Why?

What should happen for shared pages? In other words do we want to allow
less privileged process to control evicting of shared pages with a more
privileged one? E.g. think of all sorts of side channel attacks. Maybe
we want to do the same thing as for mincore where write access is
required.
-- 
Michal Hocko
SUSE Labs

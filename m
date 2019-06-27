From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH v3 1/5] mm: introduce MADV_COLD
Date: Fri, 28 Jun 2019 08:46:52 +0900
Message-ID: <20190627234652.GB33052@google.com>
References: <20190627115405.255259-1-minchan@kernel.org>
 <20190627115405.255259-2-minchan@kernel.org>
 <343599f9-3d99-b74f-1732-368e584fa5ef@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <343599f9-3d99-b74f-1732-368e584fa5ef@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On Thu, Jun 27, 2019 at 06:13:36AM -0700, Dave Hansen wrote:
> On 6/27/19 4:54 AM, Minchan Kim wrote:
> > This patch introduces the new MADV_COLD hint to madvise(2) syscall.
> > MADV_COLD can be used by a process to mark a memory range as not expected
> > to be used in the near future. The hint can help kernel in deciding which
> > pages to evict early during memory pressure.
> > 
> > It works for every LRU pages like MADV_[DONTNEED|FREE]. IOW, It moves
> > 
> > 	active file page -> inactive file LRU
> > 	active anon page -> inacdtive anon LRU
> 
> Is the LRU behavior part of the interface or the implementation?

It's a just implementation. What user should expect with this API is they just
informs to the kernel "this memory in the regions wouldn't access in the near
future" so how kernel will handle memory in there is up to the kernel.

> 
> I ask because we've got something in between tossing something down the
> LRU and swapping it: page migration.  Specifically, on a system with
> slower memory media (like persistent memory) we just migrate a page
> instead of discarding it at reclaim:
> 
> > https://lore.kernel.org/linux-mm/20190321200157.29678-4-keith.busch@intel.com/
> 
> So let's say I have a page I want to evict from DRAM to the next slower
> tier of memory.  Do I use MADV_COLD or MADV_PAGEOUT?  If the LRU
> behavior is part of the interface itself, then MADV_COLD doesn't work.

IMHO, if it's one of storage in the memory hierarchy, that shouldn't be transparent
for the user? What I meant is VM moves inactive pages to the persistent memory
before the reclaiming. IOW, VM would have one more level LRU or extened inactive
LRU to cover the persistent memory.

> 
> Do you think we'll need a third MADV_ flag for our automatic migration
> behavior?  MADV_REALLYCOLD?  MADV_MIGRATEOUT?

I believe it depends on how we abstract the persistent memory of cache hierarchy.
If we abstract it as diffrent storage with DRAM, manybe, that should be part of
other syscall like like move_pages. 
If we abstract it as part of DRAM, that should be part of additional LRU
or extended inactive LRU.

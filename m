From: Dave Hansen <dave.hansen@intel.com>
Subject: Re: [PATCH v3 1/5] mm: introduce MADV_COLD
Date: Thu, 27 Jun 2019 06:13:36 -0700
Message-ID: <343599f9-3d99-b74f-1732-368e584fa5ef@intel.com>
References: <20190627115405.255259-1-minchan@kernel.org>
 <20190627115405.255259-2-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190627115405.255259-2-minchan@kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Minchan Kim <minchan@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, oleksandr@redhat.com, hdanton@sina.com, lizeb@google.com, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>
List-Id: linux-api@vger.kernel.org

On 6/27/19 4:54 AM, Minchan Kim wrote:
> This patch introduces the new MADV_COLD hint to madvise(2) syscall.
> MADV_COLD can be used by a process to mark a memory range as not expected
> to be used in the near future. The hint can help kernel in deciding which
> pages to evict early during memory pressure.
> 
> It works for every LRU pages like MADV_[DONTNEED|FREE]. IOW, It moves
> 
> 	active file page -> inactive file LRU
> 	active anon page -> inacdtive anon LRU

Is the LRU behavior part of the interface or the implementation?

I ask because we've got something in between tossing something down the
LRU and swapping it: page migration.  Specifically, on a system with
slower memory media (like persistent memory) we just migrate a page
instead of discarding it at reclaim:

> https://lore.kernel.org/linux-mm/20190321200157.29678-4-keith.busch@intel.com/

So let's say I have a page I want to evict from DRAM to the next slower
tier of memory.  Do I use MADV_COLD or MADV_PAGEOUT?  If the LRU
behavior is part of the interface itself, then MADV_COLD doesn't work.

Do you think we'll need a third MADV_ flag for our automatic migration
behavior?  MADV_REALLYCOLD?  MADV_MIGRATEOUT?

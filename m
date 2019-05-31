From: Minchan Kim <minchan@kernel.org>
Subject: Re: [RFCv2 3/6] mm: introduce MADV_PAGEOUT
Date: Fri, 31 May 2019 22:44:47 +0900
Message-ID: <20190531134447.GD195463@google.com>
References: <20190531064313.193437-1-minchan@kernel.org>
 <20190531064313.193437-4-minchan@kernel.org>
 <20190531085044.GJ6896@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190531085044.GJ6896@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, linux-api@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Tim Murray <timmurray@google.com>, Joel Fernandes <joel@joelfernandes.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Colascione <dancol@google.com>, Shakeel Butt <shakeelb@google.com>, Sonny Rao <sonnyrao@google.com>, Brian Geffon <bgeffon@google.com>, jannh@google.com, oleg@redhat.com, christian@brauner.io, oleksandr@redhat.com, hdanton@sina.com
List-Id: linux-api@vger.kernel.org

On Fri, May 31, 2019 at 10:50:44AM +0200, Michal Hocko wrote:
> On Fri 31-05-19 15:43:10, Minchan Kim wrote:
> > When a process expects no accesses to a certain memory range
> > for a long time, it could hint kernel that the pages can be
> > reclaimed instantly but data should be preserved for future use.
> > This could reduce workingset eviction so it ends up increasing
> > performance.
> > 
> > This patch introduces the new MADV_PAGEOUT hint to madvise(2)
> > syscall. MADV_PAGEOUT can be used by a process to mark a memory
> > range as not expected to be used for a long time so that kernel
> > reclaims the memory instantly. The hint can help kernel in deciding
> > which pages to evict proactively.
> 
> Again, are there any restictions on what kind of memory can be paged out?
> Private/Shared, anonymous/file backed. Any restrictions on mapping type.
> Etc. Please make sure all that is in the changelog.

It's same with MADV_COLD. Yes, I will include all detail in the
description.

> 
> What are the failure modes? E.g. what if the swap is full, does the call
> fails or it silently ignores the error?

In such case, just ignore the swapout. It returns -EINVAL only if the
vma is one of (VM_LOCKED|VM_HUGETLB|VM_PFNMAP) at this moment.

> 
> Thanks!
> -- 
> Michal Hocko
> SUSE Labs

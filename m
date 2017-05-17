From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 0/6] cpuset/mempolicies related fixes and cleanups
Date: Wed, 17 May 2017 18:24:10 +0200
Message-ID: <20170517162409.GC20660@dhcp22.suse.cz>
References: <20170517081140.30654-1-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170517081140.30654-1-vbabka-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed 17-05-17 10:11:34, Vlastimil Babka wrote:
> Changes since RFC v1 [3]:
> 
> - Reworked patch 2 after discussion with Christoph Lameter.
> - Fix bug in patch 5 spotted by Hillf Danton.
> - Rebased to mmotm-2017-05-12-15-53
> 
> I would like to stress that this patchset aims to fix issues and cleanup the
> code *within the existing documented semantics*, i.e. patch 1 ignores mempolicy
> restrictions if the set of allowed nodes has no intersection with set of nodes
> allowed by cpuset. I believe discussing potential changes of the semantics can
> be better done once we have a baseline with no known bugs of the current
> semantics.
> 
> ===
> 
> I've recently summarized the cpuset/mempolicy issues in a LSF/MM proposal [1]
> and the discussion itself [2]. I've been trying to rewrite the handling as
> proposed, with the idea that changing semantics to make all mempolicies static
> wrt cpuset updates (and discarding the relative and default modes) can be tried
> on top, as there's a high risk of being rejected/reverted because somebody
> might still care about the removed modes.
> 
> However I haven't yet figured out how to properly:
> 
> 1) make mempolicies swappable instead of rebinding in place. I thought mbind()
> already works that way and uses refcounting to avoid use-after-free of the old
> policy by a parallel allocation, but turns out true refcounting is only done
> for shared (shmem) mempolicies, and the actual protection for mbind() comes
> from mmap_sem. Extending the refcounting means more overhead in allocator hot
> path.

But that overhead would be there only if any policy is in place, right?
Do you think it would be possible to use per cpu ref counting and thus
reduce the overhead? We use this trick in the css ref. counting in the
memcg and the overhead is not measurable. It would be certainly better
to use the same mechanism for shared and anon mappings whenever
possible.

> Also swapping whole mempolicies means that we have to allocate the new
> ones, which can fail, and reverting of the partially done work also means
> allocating (note that mbind() doesn't care and will just leave part of the
> range updated and part not updated when returning -ENOMEM...).

This is nasty but we already have to deal with half-the-way
initialization already so why cannot we use the same approach? I am
sorry if I am asking something trivial but I have already flushed all
details from memory so have to re-read it again.

> 2) make cpuset's task->mems_allowed also swappable (after converting it from
> nodemask to zonelist, which is the easy part) for mostly the same reasons.
> 
> The good news is that while trying to do the above, I've at least figured out
> how to hopefully close the remaining premature OOM's, and do a buch of cleanups
> on top, removing quite some of the code that was also supposed to prevent the
> cpuset update races, but doesn't work anymore nowadays. This should fix the
> most pressing concerns with this topic and give us a better baseline before
> either proceeding with the original proposal, or pushing a change of semantics
> that removes the problem 1) above. I'd be then fine with trying to change the
> semantic first and rewrite later.

the diffstat definitely looks promissing. I will have a look tomorrow
(unless something unexpected jums in again).

> Patchset is based on next-20170411 and has been tested with the LTP cpuset01
> stress test.
> 
> [1] https://lkml.kernel.org/r/4c44a589-5fd8-08d0-892c-e893bb525b71-AlSwsSmVLrQ@public.gmane.org
> [2] https://lwn.net/Articles/717797/
> [3] https://marc.info/?l=linux-mm&m=149191957922828&w=2
> 
> Vlastimil Babka (6):
>   mm, page_alloc: fix more premature OOM due to race with cpuset update
>   mm, mempolicy: stop adjusting current->il_next in
>     mpol_rebind_nodemask()
>   mm, page_alloc: pass preferred nid instead of zonelist to allocator
>   mm, mempolicy: simplify rebinding mempolicies when updating cpusets
>   mm, cpuset: always use seqlock when changing task's nodemask
>   mm, mempolicy: don't check cpuset seqlock where it doesn't matter
> 
>  include/linux/gfp.h            |  11 ++-
>  include/linux/mempolicy.h      |  12 ++-
>  include/linux/sched.h          |   2 +-
>  include/uapi/linux/mempolicy.h |   8 --
>  kernel/cgroup/cpuset.c         |  33 ++------
>  mm/hugetlb.c                   |  15 ++--
>  mm/memory_hotplug.c            |   6 +-
>  mm/mempolicy.c                 | 181 ++++++++++-------------------------------
>  mm/page_alloc.c                |  61 ++++++++++----
>  9 files changed, 118 insertions(+), 211 deletions(-)
> 
> -- 
> 2.12.2

-- 
Michal Hocko
SUSE Labs

From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 1/6] mm, page_alloc: fix more premature OOM due to
 race with cpuset update
Date: Fri, 19 May 2017 13:51:10 +0200
Message-ID: <20170519115110.GB29839@dhcp22.suse.cz>
References: <20170517081140.30654-1-vbabka@suse.cz>
 <20170517081140.30654-2-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170517081140.30654-2-vbabka-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed 17-05-17 10:11:35, Vlastimil Babka wrote:
> Commit e47483bca2cc ("mm, page_alloc: fix premature OOM when racing with cpuset
> mems update") has fixed known recent regressions found by LTP's cpuset01
> testcase. I have however found that by modifying the testcase to use per-vma
> mempolicies via bind(2) instead of per-task mempolicies via set_mempolicy(2),
> the premature OOM still happens and the issue is much older.
> 
> The root of the problem is that the cpuset's mems_allowed and mempolicy's
> nodemask can temporarily have no intersection, thus get_page_from_freelist()
> cannot find any usable zone. The current semantic for empty intersection is to
> ignore mempolicy's nodemask and honour cpuset restrictions. This is checked in
> node_zonelist(), but the racy update can happen after we already passed the
> check. Such races should be protected by the seqlock task->mems_allowed_seq,
> but it doesn't work here, because 1) mpol_rebind_mm() does not happen under
> seqlock for write, and doing so would lead to deadlock, as it takes mmap_sem
> for write, while the allocation can have mmap_sem for read when it's taking the
> seqlock for read. And 2) the seqlock cookie of callers of node_zonelist()
> (alloc_pages_vma() and alloc_pages_current()) is different than the one of
> __alloc_pages_slowpath(), so there's still a potential race window.
> 
> This patch fixes the issue by having __alloc_pages_slowpath() check for empty
> intersection of cpuset and ac->nodemask before OOM or allocation failure. If
> it's indeed empty, the nodemask is ignored and allocation retried, which mimics
> node_zonelist(). This works fine, because almost all callers of
> __alloc_pages_nodemask are obtaining the nodemask via node_zonelist(). The only
> exception is new_node_page() from hotplug, where the potential violation of
> nodemask isn't an issue, as there's already a fallback allocation attempt
> without any nodemask. If there's a future caller that needs to have its specific
> nodemask honoured over task's cpuset restrictions, we'll have to e.g. add a gfp
> flag for that.
> 
> Signed-off-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

Do we want this backported to the stable tree?

OK I do agree this makes some sense as a quick and easy to backport
workaround.

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org?

> ---
>  mm/page_alloc.c | 51 ++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 38 insertions(+), 13 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index beb2827fd5de..43aa767c3188 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -3661,6 +3661,39 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
>  	return false;
>  }
>  
> +static inline bool
> +check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
> +{
> +	/*
> +	 * It's possible that cpuset's mems_allowed and the nodemask from
> +	 * mempolicy don't intersect. This should be normally dealt with by
> +	 * policy_nodemask(), but it's possible to race with cpuset update in
> +	 * such a way the check therein was true, and then it became false
> +	 * before we got our cpuset_mems_cookie here.
> +	 * This assumes that for all allocations, ac->nodemask can come only
> +	 * from MPOL_BIND mempolicy (whose documented semantics is to be ignored
> +	 * when it does not intersect with the cpuset restrictions) or the
> +	 * caller can deal with a violated nodemask.
> +	 */
> +	if (cpusets_enabled() && ac->nodemask &&
> +			!cpuset_nodemask_valid_mems_allowed(ac->nodemask)) {
> +		ac->nodemask = NULL;
> +		return true;
> +	}
> +
> +	/*
> +	 * When updating a task's mems_allowed or mempolicy nodemask, it is
> +	 * possible to race with parallel threads in such a way that our
> +	 * allocation can fail while the mask is being updated. If we are about
> +	 * to fail, check if the cpuset changed during allocation and if so,
> +	 * retry.
> +	 */
> +	if (read_mems_allowed_retry(cpuset_mems_cookie))
> +		return true;
> +
> +	return false;
> +}
> +
>  static inline struct page *
>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  						struct alloc_context *ac)
> @@ -3856,11 +3889,9 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  				&compaction_retries))
>  		goto retry;
>  
> -	/*
> -	 * It's possible we raced with cpuset update so the OOM would be
> -	 * premature (see below the nopage: label for full explanation).
> -	 */
> -	if (read_mems_allowed_retry(cpuset_mems_cookie))
> +
> +	/* Deal with possible cpuset update races before we start OOM killing */
> +	if (check_retry_cpuset(cpuset_mems_cookie, ac))
>  		goto retry_cpuset;
>  
>  	/* Reclaim has failed us, start killing things */
> @@ -3879,14 +3910,8 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  	}
>  
>  nopage:
> -	/*
> -	 * When updating a task's mems_allowed or mempolicy nodemask, it is
> -	 * possible to race with parallel threads in such a way that our
> -	 * allocation can fail while the mask is being updated. If we are about
> -	 * to fail, check if the cpuset changed during allocation and if so,
> -	 * retry.
> -	 */
> -	if (read_mems_allowed_retry(cpuset_mems_cookie))
> +	/* Deal with possible cpuset update races before we fail */
> +	if (check_retry_cpuset(cpuset_mems_cookie, ac))
>  		goto retry_cpuset;
>  
>  	/*
> -- 
> 2.12.2

-- 
Michal Hocko
SUSE Labs

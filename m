From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 5/6] mm, cpuset: always use seqlock when changing
 task's nodemask
Date: Tue, 23 May 2017 09:15:21 +0200
Message-ID: <20170523071521.GH12813@dhcp22.suse.cz>
References: <20170517081140.30654-1-vbabka@suse.cz>
 <20170517081140.30654-6-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170517081140.30654-6-vbabka-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Anshuman Khandual <khandual-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Wed 17-05-17 10:11:39, Vlastimil Babka wrote:
> When updating task's mems_allowed and rebinding its mempolicy due to cpuset's
> mems being changed, we currently only take the seqlock for writing when either
> the task has a mempolicy, or the new mems has no intersection with the old
> mems. This should be enough to prevent a parallel allocation seeing no
> available nodes, but the optimization is IMHO unnecessary (cpuset updates
> should not be frequent), and we still potentially risk issues if the
> intersection of new and old nodes has limited amount of free/reclaimable
> memory. Let's just use the seqlock for all tasks.

Agreed

> Signed-off-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  kernel/cgroup/cpuset.c | 29 ++++++++---------------------
>  1 file changed, 8 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index dfd5b420452d..26a1c360a481 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1038,38 +1038,25 @@ static void cpuset_post_attach(void)
>   * @tsk: the task to change
>   * @newmems: new nodes that the task will be set
>   *
> - * In order to avoid seeing no nodes if the old and new nodes are disjoint,
> - * we structure updates as setting all new allowed nodes, then clearing newly
> - * disallowed ones.
> + * We use the mems_allowed_seq seqlock to safely update both tsk->mems_allowed
> + * and rebind an eventual tasks' mempolicy. If the task is allocating in
> + * parallel, it might temporarily see an empty intersection, which results in
> + * a seqlock check and retry before OOM or allocation failure.
>   */
>  static void cpuset_change_task_nodemask(struct task_struct *tsk,
>  					nodemask_t *newmems)
>  {
> -	bool need_loop;
> -
>  	task_lock(tsk);
> -	/*
> -	 * Determine if a loop is necessary if another thread is doing
> -	 * read_mems_allowed_begin().  If at least one node remains unchanged and
> -	 * tsk does not have a mempolicy, then an empty nodemask will not be
> -	 * possible when mems_allowed is larger than a word.
> -	 */
> -	need_loop = task_has_mempolicy(tsk) ||
> -			!nodes_intersects(*newmems, tsk->mems_allowed);
>  
> -	if (need_loop) {
> -		local_irq_disable();
> -		write_seqcount_begin(&tsk->mems_allowed_seq);
> -	}
> +	local_irq_disable();
> +	write_seqcount_begin(&tsk->mems_allowed_seq);
>  
>  	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
>  	mpol_rebind_task(tsk, newmems);
>  	tsk->mems_allowed = *newmems;
>  
> -	if (need_loop) {
> -		write_seqcount_end(&tsk->mems_allowed_seq);
> -		local_irq_enable();
> -	}
> +	write_seqcount_end(&tsk->mems_allowed_seq);
> +	local_irq_enable();
>  
>  	task_unlock(tsk);
>  }
> -- 
> 2.12.2

-- 
Michal Hocko
SUSE Labs

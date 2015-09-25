From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 2/4] mm, proc: account for shmem swap in
 /proc/pid/smaps
Date: Fri, 25 Sep 2015 14:57:30 +0200
Message-ID: <20150925125729.GI16497@dhcp22.suse.cz>
References: <1438779685-5227-1-git-send-email-vbabka@suse.cz>
 <1438779685-5227-3-git-send-email-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1438779685-5227-3-git-send-email-vbabka-AlSwsSmVLrQ@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jerome Marchand <jmarchan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Cyrill Gorcunov <gorcunov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-s390-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Schwidefsky <schwidefsky-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Heiko Carstens <heiko.carstens-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linux API <linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

[Sorry for a really long delay]

On Wed 05-08-15 15:01:23, Vlastimil Babka wrote:
> Currently, /proc/pid/smaps will always show "Swap: 0 kB" for shmem-backed
> mappings, even if the mapped portion does contain pages that were swapped out.
> This is because unlike private anonymous mappings, shmem does not change pte
> to swap entry, but pte_none when swapping the page out. In the smaps page
> walk, such page thus looks like it was never faulted in.
>
> This patch changes smaps_pte_entry() to determine the swap status for such
> pte_none entries for shmem mappings, similarly to how mincore_page() does it.
> Swapped out pages are thus accounted for.
> 
> The accounting is arguably still not as precise as for private anonymous
> mappings, since now we will count also pages that the process in question never
> accessed, but only another process populated them and then let them become
> swapped out.
>
> I believe it is still less confusing and subtle than not showing
> any swap usage by shmem mappings at all. Also, swapped out pages only becomee a
> performance issue for future accesses, and we cannot predict those for neither
> kind of mapping.

Yes I agree.

> Signed-off-by: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
[...]
> @@ -625,6 +626,41 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
>  	seq_putc(m, '\n');
>  }
>  
> +#if defined(CONFIG_SHMEM) && defined(CONFIG_SWAP)
> +static unsigned long smaps_shmem_swap(struct vm_area_struct *vma)
> +{
> +	struct inode *inode;
> +	unsigned long swapped;
> +	pgoff_t start, end;
> +
> +	if (!vma->vm_file)
> +		return 0;
> +
> +	inode = file_inode(vma->vm_file);

Why don't we need to take i_mutex here? What prevents from a parallel
truncate? I guess we do not care because radix_tree_for_each_slot would
cope with a truncated portion of the range, right?
It would deserve a comment I guess.

> +
> +	if (!shmem_mapping(inode->i_mapping))
> +		return 0;
> +
> +	swapped = shmem_swap_usage(inode);
> +
> +	if (swapped == 0)
> +		return 0;
> +
> +	if (vma->vm_end - vma->vm_start >= inode->i_size)
> +		return swapped;
> +
> +	start = linear_page_index(vma, vma->vm_start);
> +	end = linear_page_index(vma, vma->vm_end);
> +
> +	return shmem_partial_swap_usage(inode->i_mapping, start, end);
> +}
[...]
> +unsigned long shmem_partial_swap_usage(struct address_space *mapping,
> +						pgoff_t start, pgoff_t end)
> +{
> +	struct radix_tree_iter iter;
> +	void **slot;
> +	struct page *page;
> +	unsigned long swapped = 0;
> +
> +	rcu_read_lock();
> +
> +restart:
> +	radix_tree_for_each_slot(slot, &mapping->page_tree, &iter, start) {
> +		if (iter.index >= end)
> +			break;
> +
> +		page = radix_tree_deref_slot(slot);
> +
> +		/*
> +		 * This should only be possible to happen at index 0, so we
> +		 * don't need to reset the counter, nor do we risk infinite
> +		 * restarts.
> +		 */
> +		if (radix_tree_deref_retry(page))
> +			goto restart;
> +
> +		if (radix_tree_exceptional_entry(page))
> +			swapped++;
> +
> +		if (need_resched()) {
> +			cond_resched_rcu();
> +			start = iter.index + 1;
> +			goto restart;
> +		}
> +	}
> +
> +	rcu_read_unlock();
> +
> +	return swapped << PAGE_SHIFT;
> +}
> +#endif
> +
>  /*
>   * SysV IPC SHM_UNLOCK restore Unevictable pages to their evictable lists.
>   */
> -- 
> 2.4.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-api" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs

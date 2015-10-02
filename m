From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v4 2/4] mm, proc: account for shmem swap in
 /proc/pid/smaps
Date: Fri, 2 Oct 2015 17:20:24 +0200
Message-ID: <20151002152024.GD16302@dhcp22.suse.cz>
References: <1443792951-13944-1-git-send-email-vbabka@suse.cz>
 <1443792951-13944-3-git-send-email-vbabka@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <1443792951-13944-3-git-send-email-vbabka@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: linux-mm@kvack.org, Jerome Marchand <jmarchan@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Cyrill Gorcunov <gorcunov@openvz.org>, Randy Dunlap <rdunlap@infradead.org>, linux-s390@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>, Arnaldo Carvalho de Melo <acme@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Linux API <linux-api@vger.kernel.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
List-Id: linux-api@vger.kernel.org

On Fri 02-10-15 15:35:49, Vlastimil Babka wrote:
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
> swapped out. I believe it is still less confusing and subtle than not showing
> any swap usage by shmem mappings at all. Also, swapped out pages only becomee a
> performance issue for future accesses, and we cannot predict those for neither
> kind of mapping.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Acked-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Acked-by: Michal Hocko <mhocko@suse.com>

But I think comments explaining why i_mutex is not needed are
confusing and incomplete.
[...]
> +	/*
> +	 * Here we have to inspect individual pages in our mapped range to
> +	 * determine how much of them are swapped out. Thanks to RCU, we don't
> +	 * need i_mutex to protect against truncating or hole punching.
> +	 */
> +	start = linear_page_index(vma, vma->vm_start);
> +	end = linear_page_index(vma, vma->vm_end);
> +
> +	return shmem_partial_swap_usage(inode->i_mapping, start, end);
[...]
> +/*
> + * Determine (in bytes) how many pages within the given range are swapped out.
> + *
> + * Can be called without i_mutex or mapping->tree_lock thanks to RCU.
> + */
> +unsigned long shmem_partial_swap_usage(struct address_space *mapping,
> +						pgoff_t start, pgoff_t end)

AFAIU RCU only helps to prevent from accessing nodes which were freed
from the radix tree. The reason why we do not need to hold i_mutex is
that the radix tree iterator would break out of the loop if we entered
node which backed truncated range. At least this is my understanding, I
might be wrong here of course.
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

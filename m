From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 7/8] mm: clear PG_dirty to mark page freeable
Date: Fri, 30 Oct 2015 13:55:04 +0100
Message-ID: <20151030125504.GC23627@dhcp22.suse.cz>
References: <1446188504-28023-1-git-send-email-minchan@kernel.org>
 <1446188504-28023-8-git-send-email-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1446188504-28023-8-git-send-email-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri 30-10-15 16:01:43, Minchan Kim wrote:
> Basically, MADV_FREE relies on dirty bit in page table entry to decide
> whether VM allows to discard the page or not.  IOW, if page table entry
> includes marked dirty bit, VM shouldn't discard the page.
> 
> However, as a example, if swap-in by read fault happens, page table entry
> doesn't have dirty bit so MADV_FREE could discard the page wrongly.
> 
> For avoiding the problem, MADV_FREE did more checks with PageDirty
> and PageSwapCache. It worked out because swapped-in page lives on
> swap cache and since it is evicted from the swap cache, the page has
> PG_dirty flag. So both page flags check effectively prevent
> wrong discarding by MADV_FREE.
> 
> However, a problem in above logic is that swapped-in page has
> PG_dirty still after they are removed from swap cache so VM cannot
> consider the page as freeable any more even if madvise_free is
> called in future.
> 
> Look at below example for detail.
> 
>     ptr = malloc();
>     memset(ptr);
>     ..
>     ..
>     .. heavy memory pressure so all of pages are swapped out
>     ..
>     ..
>     var = *ptr; -> a page swapped-in and could be removed from
>                    swapcache. Then, page table doesn't mark
>                    dirty bit and page descriptor includes PG_dirty
>     ..
>     ..
>     madvise_free(ptr); -> It doesn't clear PG_dirty of the page.
>     ..
>     ..
>     ..
>     .. heavy memory pressure again.
>     .. In this time, VM cannot discard the page because the page
>     .. has *PG_dirty*
> 
> To solve the problem, this patch clears PG_dirty if only the page is owned
> exclusively by current process when madvise is called because PG_dirty
> represents ptes's dirtiness in several processes so we could clear it only
> if we own it exclusively.
> 
> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

> ---
>  mm/madvise.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 9ee9df8c768d..fc24104d6b3a 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -303,11 +303,19 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
>  		if (!page)
>  			continue;
>  
> -		if (PageSwapCache(page)) {
> +		if (PageSwapCache(page) || PageDirty(page)) {
>  			if (!trylock_page(page))
>  				continue;
> +			/*
> +			 * If page is shared with others, we couldn't clear
> +			 * PG_dirty of the page.
> +			 */
> +			if (page_count(page) != 1 + !!PageSwapCache(page)) {
> +				unlock_page(page);
> +				continue;
> +			}
>  
> -			if (!try_to_free_swap(page)) {
> +			if (PageSwapCache(page) && !try_to_free_swap(page)) {
>  				unlock_page(page);
>  				continue;
>  			}
> -- 
> 1.9.1

-- 
Michal Hocko
SUSE Labs

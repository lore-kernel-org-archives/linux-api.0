From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 6/8] mm: lru_deactivate_fn should clear PG_referenced
Date: Fri, 30 Oct 2015 13:47:11 +0100
Message-ID: <20151030124711.GB23627@dhcp22.suse.cz>
References: <1446188504-28023-1-git-send-email-minchan@kernel.org>
 <1446188504-28023-7-git-send-email-minchan@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1446188504-28023-7-git-send-email-minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Michael Kerrisk <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, zhangyanfei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Jason Evans <je-b10kYP2dOMg@public.gmane.org>, Daniel Micay <danielmicay-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, yalin.wang2010-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-api@vger.kernel.org

On Fri 30-10-15 16:01:42, Minchan Kim wrote:
> deactivate_page aims for accelerate for reclaiming through
> moving pages from active list to inactive list so we should
> clear PG_referenced for the goal.

I might be missing something but aren't we using PG_referenced only for
pagecache (and shmem) pages?

> 
> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Suggested-by: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Signed-off-by: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  mm/swap.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/swap.c b/mm/swap.c
> index d0eacc5f62a3..4a6aec976ab1 100644
> --- a/mm/swap.c
> +++ b/mm/swap.c
> @@ -810,6 +810,7 @@ static void lru_deactivate_fn(struct page *page, struct lruvec *lruvec,
>  
>  		del_page_from_lru_list(page, lruvec, lru + LRU_ACTIVE);
>  		ClearPageActive(page);
> +		ClearPageReferenced(page);
>  		add_page_to_lru_list(page, lruvec, lru);
>  
>  		__count_vm_event(PGDEACTIVATE);
> -- 
> 1.9.1

-- 
Michal Hocko
SUSE Labs

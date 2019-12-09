From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [v4 PATCH] mm: move_pages: return valid node id in status if the
 page is already on the target node
Date: Mon, 9 Dec 2019 16:21:31 +0100
Message-ID: <ef6467ec-a568-d5df-9427-716cb56869d2@suse.cz>
References: <1575584353-125392-1-git-send-email-yang.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1575584353-125392-1-git-send-email-yang.shi@linux.alibaba.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Yang Shi <yang.shi@linux.alibaba.com>, fabecassis@nvidia.com, jhubbard@nvidia.com, mhocko@suse.com, cl@linux.com, mgorman@techsingularity.net, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, Linux API <linux-api@vger.kernel.org>
List-Id: linux-api@vger.kernel.org

Boo, v4 and nobody suggested CCing linux-api yet?
Doing that and not trimming the reply, for reference.

On 12/5/19 11:19 PM, Yang Shi wrote:
> Felix Abecassis reports move_pages() would return random status if the
> pages are already on the target node by the below test program:
> 
> ---8<---
> 
> int main(void)
> {
> 	const long node_id = 1;
> 	const long page_size = sysconf(_SC_PAGESIZE);
> 	const int64_t num_pages = 8;
> 
> 	unsigned long nodemask =  1 << node_id;
> 	long ret = set_mempolicy(MPOL_BIND, &nodemask, sizeof(nodemask));
> 	if (ret < 0)
> 		return (EXIT_FAILURE);
> 
> 	void **pages = malloc(sizeof(void*) * num_pages);
> 	for (int i = 0; i < num_pages; ++i) {
> 		pages[i] = mmap(NULL, page_size, PROT_WRITE | PROT_READ,
> 				MAP_PRIVATE | MAP_POPULATE | MAP_ANONYMOUS,
> 				-1, 0);
> 		if (pages[i] == MAP_FAILED)
> 			return (EXIT_FAILURE);
> 	}
> 
> 	ret = set_mempolicy(MPOL_DEFAULT, NULL, 0);
> 	if (ret < 0)
> 		return (EXIT_FAILURE);
> 
> 	int *nodes = malloc(sizeof(int) * num_pages);
> 	int *status = malloc(sizeof(int) * num_pages);
> 	for (int i = 0; i < num_pages; ++i) {
> 		nodes[i] = node_id;
> 		status[i] = 0xd0; /* simulate garbage values */
> 	}
> 
> 	ret = move_pages(0, num_pages, pages, nodes, status, MPOL_MF_MOVE);
> 	printf("move_pages: %ld\n", ret);
> 	for (int i = 0; i < num_pages; ++i)
> 		printf("status[%d] = %d\n", i, status[i]);
> }
> ---8<---
> 
> Then running the program would return nonsense status values:
> $ ./move_pages_bug
> move_pages: 0
> status[0] = 208
> status[1] = 208
> status[2] = 208
> status[3] = 208
> status[4] = 208
> status[5] = 208
> status[6] = 208
> status[7] = 208
> 
> This is because the status is not set if the page is already on the
> target node, but move_pages() should return valid status as long as it
> succeeds.  The valid status may be errno or node id.
> 
> We can't simply initialize status array to zero since the pages may be
> not on node 0.  Fix it by updating status with node id which the page is
> already on.
> 
> Fixes: a49bd4d71637 ("mm, numa: rework do_pages_move")
> Reported-by: Felix Abecassis <fabecassis@nvidia.com>
> Tested-by: Felix Abecassis <fabecassis@nvidia.com>
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Reviewed-by: John Hubbard <jhubbard@nvidia.com>
> Acked-by: Christoph Lameter <cl@linux.com>
> Cc: Vlastimil Babka <vbabka@suse.cz>
> Cc: Mel Gorman <mgorman@techsingularity.net>
> Cc: <stable@vger.kernel.org> 4.17+
> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>

Reviewed-by: Vlastimil Babka <vbabka@suse.cz>

> ---
> v4: * Fixed the comments from Christopher and John and added their Acked-by
>       and Reviewed-by.
> v3: * Adopted the suggestion from Michal.
> v2: * Correted the return value when add_page_for_migration() returns 1.
> 
>  mm/migrate.c | 23 +++++++++++++++++------
>  1 file changed, 17 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index a8f87cb..6b44818f 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -1512,9 +1512,11 @@ static int do_move_pages_to_node(struct mm_struct *mm,
>  /*
>   * Resolves the given address to a struct page, isolates it from the LRU and
>   * puts it to the given pagelist.
> - * Returns -errno if the page cannot be found/isolated or 0 when it has been
> - * queued or the page doesn't need to be migrated because it is already on
> - * the target node
> + * Returns:
> + *     errno - if the page cannot be found/isolated
> + *     0 - when it doesn't have to be migrated because it is already on the
> + *         target node
> + *     1 - when it has been queued
>   */
>  static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>  		int node, struct list_head *pagelist, bool migrate_all)
> @@ -1553,7 +1555,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>  	if (PageHuge(page)) {
>  		if (PageHead(page)) {
>  			isolate_huge_page(page, pagelist);
> -			err = 0;
> +			err = 1;
>  		}
>  	} else {
>  		struct page *head;
> @@ -1563,7 +1565,7 @@ static int add_page_for_migration(struct mm_struct *mm, unsigned long addr,
>  		if (err)
>  			goto out_putpage;
>  
> -		err = 0;
> +		err = 1;
>  		list_add_tail(&head->lru, pagelist);
>  		mod_node_page_state(page_pgdat(head),
>  			NR_ISOLATED_ANON + page_is_file_cache(head),
> @@ -1640,8 +1642,17 @@ static int do_pages_move(struct mm_struct *mm, nodemask_t task_nodes,
>  		 */
>  		err = add_page_for_migration(mm, addr, current_node,
>  				&pagelist, flags & MPOL_MF_MOVE_ALL);
> -		if (!err)
> +
> +		if (!err) {
> +			/* The page is already on the target node */
> +			err = store_status(status, i, current_node, 1);
> +			if (err)
> +				goto out_flush;
>  			continue;
> +		} else if (err > 0) {
> +			/* The page is successfully queued for migration */
> +			continue;
> +		}
>  
>  		err = store_status(status, i, err, 1);
>  		if (err)
> 

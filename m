From: Christoph Lameter <cl@linux.com>
Subject: Re: [PATCH v2 3/6] mm, page_alloc: pass preferred nid instead of
 zonelist to allocator
Date: Wed, 17 May 2017 10:19:13 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1705171009340.8714@east.gentwo.org>
References: <20170517081140.30654-1-vbabka@suse.cz> <20170517081140.30654-4-vbabka@suse.cz>
Content-Type: text/plain; charset=US-ASCII
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20170517081140.30654-4-vbabka@suse.cz>
Sender: owner-linux-mm@kvack.org
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-api@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Mel Gorman <mgorman@techsingularity.net>, David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Dimitri Sivanich <sivanich@sgi.com>
List-Id: linux-api@vger.kernel.org

On Wed, 17 May 2017, Vlastimil Babka wrote:

>  struct page *
> -__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
> -		       struct zonelist *zonelist, nodemask_t *nodemask);
> +__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
> +							nodemask_t *nodemask);
>
>  static inline struct page *
> -__alloc_pages(gfp_t gfp_mask, unsigned int order,
> -		struct zonelist *zonelist)
> +__alloc_pages(gfp_t gfp_mask, unsigned int order, int preferred_nid)
>  {
> -	return __alloc_pages_nodemask(gfp_mask, order, zonelist, NULL);
> +	return __alloc_pages_nodemask(gfp_mask, order, preferred_nid, NULL);
>  }

Maybe use nid instead of preferred_nid like in __alloc_pages? Otherwise
there may be confusion with the MPOL_PREFER policy.

> @@ -1963,8 +1960,8 @@ alloc_pages_vma(gfp_t gfp, int order, struct vm_area_struct *vma,
>  {
>  	struct mempolicy *pol;
>  	struct page *page;
> +	int preferred_nid;
>  	unsigned int cpuset_mems_cookie;
> -	struct zonelist *zl;
>  	nodemask_t *nmask;

Same here.

> @@ -4012,8 +4012,8 @@ static inline void finalise_ac(gfp_t gfp_mask,
>   * This is the 'heart' of the zoned buddy allocator.
>   */
>  struct page *
> -__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order,
> -			struct zonelist *zonelist, nodemask_t *nodemask)
> +__alloc_pages_nodemask(gfp_t gfp_mask, unsigned int order, int preferred_nid,
> +							nodemask_t *nodemask)
>  {

and here

This looks clean to me. Still feel a bit uneasy about this since I do
remember that we had a reason to use zonelists instead of nodes back then
but cannot remember what that reason was....

CCing Dimitri at SGI. This may break a lot of legacy SGIapps. If you read
this Dimitri then please review this patchset and the discussions around
it.

Reviewed-by: Christoph Lameter <cl@linux.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>

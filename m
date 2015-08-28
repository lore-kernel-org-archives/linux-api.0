From: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v8 3/6] mm: Introduce VM_LOCKONFAULT
Date: Fri, 28 Aug 2015 16:18:30 +0200
Message-ID: <20150828141829.GD5301@dhcp22.suse.cz>
References: <1440613465-30393-1-git-send-email-emunson@akamai.com>
 <1440613465-30393-4-git-send-email-emunson@akamai.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1440613465-30393-4-git-send-email-emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-api@vger.kernel.org

On Wed 26-08-15 14:24:22, Eric B Munson wrote:
> The cost of faulting in all memory to be locked can be very high when
> working with large mappings.  If only portions of the mapping will be
> used this can incur a high penalty for locking.
> 
> For the example of a large file, this is the usage pattern for a large
> statical language model (probably applies to other statical or graphical
> models as well).  For the security example, any application transacting
> in data that cannot be swapped out (credit card data, medical records,
> etc).
> 
> This patch introduces the ability to request that pages are not
> pre-faulted, but are placed on the unevictable LRU when they are finally
> faulted in.  The VM_LOCKONFAULT flag will be used together with
> VM_LOCKED and has no effect when set without VM_LOCKED.  Setting the
> VM_LOCKONFAULT flag for a VMA will cause pages faulted into that VMA to
> be added to the unevictable LRU when they are faulted or if they are
> already present, but will not cause any missing pages to be faulted in.

OK, I can live with this. Thank you for removing the part which exports
the flag to the userspace.
 
> Exposing this new lock state means that we cannot overload the meaning
> of the FOLL_POPULATE flag any longer.  Prior to this patch it was used
> to mean that the VMA for a fault was locked.  This means we need the
> new FOLL_MLOCK flag to communicate the locked state of a VMA.
> FOLL_POPULATE will now only control if the VMA should be populated and
> in the case of VM_LOCKONFAULT, it will not be set.

I thinking that this part is really unnecessary. populate_vma_page_range
could have simply returned without calling gup for VM_LOCKONFAULT
vmas. You would save the pte walk and the currently mapped pages would
be still protected from the reclaim. The side effect would be that they
would litter the regular LRUs and mlock/unevictable counters wouldn't be
updated until those pages are encountered during the reclaim and culled
to unevictable list.

I would expect that mlock with this flag would be typically called
on mostly unpopulated mappings so the side effects would be barely
noticeable while the lack of pte walk would be really nice (especially
for the large mappings).

This would be a nice optimization and minor code reduction but I am not
going to insist on it. I will leave the decision to you.

> Signed-off-by: Eric B Munson <emunson-JqFfY2XvxFXQT0dZR+AlfA@public.gmane.org>
> Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> Cc: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
> Cc: Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>
> Cc: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

One note below:

> ---
> Changes from v7:
> *Drop entries in smaps and dri code to avoid exposing VM_LOCKONFAULT to
>  userspace.  VM_LOCKONFAULT is still exposed via mm/debug.c
> *Create VM_LOCKED_CLEAR_MASK to be used anywhere we want to clear all
>  flags relating to locked VMAs
> 
>  include/linux/mm.h |  5 +++++
>  kernel/fork.c      |  2 +-
>  mm/debug.c         |  1 +
>  mm/gup.c           | 10 ++++++++--
>  mm/huge_memory.c   |  2 +-
>  mm/hugetlb.c       |  4 ++--
>  mm/mlock.c         |  2 +-
>  mm/mmap.c          |  2 +-
>  mm/rmap.c          |  6 ++++--
>  9 files changed, 24 insertions(+), 10 deletions(-)
[...]
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 171b687..14ce002 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -744,7 +744,8 @@ static int page_referenced_one(struct page *page, struct vm_area_struct *vma,
>  
>  		if (vma->vm_flags & VM_LOCKED) {
>  			spin_unlock(ptl);
> -			pra->vm_flags |= VM_LOCKED;
> +			pra->vm_flags |=
> +				(vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));
>  			return SWAP_FAIL; /* To break the loop */
>  		}
>  
> @@ -765,7 +766,8 @@ static int page_referenced_one(struct page *page, struct vm_area_struct *vma,
>  
>  		if (vma->vm_flags & VM_LOCKED) {
>  			pte_unmap_unlock(pte, ptl);
> -			pra->vm_flags |= VM_LOCKED;
> +			pra->vm_flags |=
> +				(vma->vm_flags & (VM_LOCKED | VM_LOCKONFAULT));
>  			return SWAP_FAIL; /* To break the loop */
>  		}

Why do we need to export this? Neither of the consumers care and should
care. VM_LOCKONFAULT should never be set without VM_LOCKED which is the
only thing that we should care about.
-- 
Michal Hocko
SUSE Labs
